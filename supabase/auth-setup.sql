-- =====================================================
-- 會員系統設定 SQL
-- 執行此腳本來設定會員認證和留言功能
-- =====================================================

-- =====================================================
-- 1. 更新 Comments 表結構
-- =====================================================

-- 新增 user_id 欄位（關聯到 auth.users）
ALTER TABLE public.comments
ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL;

-- 建立索引以提高查詢效能
CREATE INDEX IF NOT EXISTS idx_comments_user_id ON public.comments(user_id);

-- 允許 author 和 email 欄位為可選（因為有 user_id 後這些可以從 auth.users 取得）
ALTER TABLE public.comments ALTER COLUMN author DROP NOT NULL;
ALTER TABLE public.comments ALTER COLUMN email DROP NOT NULL;

-- =====================================================
-- 2. 建立或更新 Profiles 表
-- =====================================================

-- 如果 users 表不存在，建立 profiles 表來儲存用戶資料
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  display_name TEXT,
  avatar_url TEXT,
  bio TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 建立索引
CREATE INDEX IF NOT EXISTS idx_profiles_display_name ON public.profiles(display_name);

-- =====================================================
-- 3. 更新 RLS 政策 - Comments
-- =====================================================

-- 先刪除舊的政策
DROP POLICY IF EXISTS "Approved comments are viewable by everyone" ON public.comments;
DROP POLICY IF EXISTS "Anyone can insert comments" ON public.comments;
DROP POLICY IF EXISTS "Only authenticated users can update comments" ON public.comments;
DROP POLICY IF EXISTS "Only authenticated users can delete comments" ON public.comments;

-- 1. 所有人都可以讀取已審核的留言
CREATE POLICY "Everyone can read approved comments"
ON public.comments
FOR SELECT
USING (status = 'approved');

-- 2. 已登入用戶可以新增留言（必須設定自己的 user_id）
CREATE POLICY "Authenticated users can insert comments"
ON public.comments
FOR INSERT
TO authenticated
WITH CHECK (
  auth.uid() = user_id
  AND status = 'pending'
);

-- 3. 用戶可以查看自己的待審核留言
CREATE POLICY "Users can read own pending comments"
ON public.comments
FOR SELECT
TO authenticated
USING (
  auth.uid() = user_id
  OR status = 'approved'
);

-- 4. 用戶可以刪除自己的留言
CREATE POLICY "Users can delete own comments"
ON public.comments
FOR DELETE
TO authenticated
USING (auth.uid() = user_id);

-- 5. 管理員可以更新所有留言（審核等）
CREATE POLICY "Authenticated users can update all comments"
ON public.comments
FOR UPDATE
TO authenticated
USING (true);

-- =====================================================
-- 4. 設定 Profiles 表的 RLS 政策
-- =====================================================

-- 啟用 RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 所有人都可以讀取 profiles
CREATE POLICY "Profiles are viewable by everyone"
ON public.profiles
FOR SELECT
USING (true);

-- 用戶只能插入自己的 profile
CREATE POLICY "Users can insert own profile"
ON public.profiles
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = id);

-- 用戶只能更新自己的 profile
CREATE POLICY "Users can update own profile"
ON public.profiles
FOR UPDATE
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- =====================================================
-- 5. 自動建立 Profile 的觸發器
-- =====================================================

-- 建立函數：當新用戶註冊時自動建立 profile
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, display_name)
  VALUES (
    new.id,
    COALESCE(
      new.raw_user_meta_data->>'display_name',
      split_part(new.email, '@', 1)
    )
  );
  RETURN new;
END;
$$ LANGUAGE plpgsql;

-- 刪除舊的觸發器（如果存在）
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- 建立觸發器
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- =====================================================
-- 6. 更新 updated_at 觸發器
-- =====================================================

-- 為 profiles 表建立 updated_at 觸發器
DROP TRIGGER IF EXISTS set_profiles_updated_at ON public.profiles;

CREATE TRIGGER set_profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_updated_at();

-- =====================================================
-- 7. 建立視圖：留言列表（包含用戶資訊）
-- =====================================================

CREATE OR REPLACE VIEW public.comments_with_user AS
SELECT 
  c.*,
  COALESCE(p.display_name, c.author, split_part(u.email, '@', 1)) as display_name,
  p.avatar_url
FROM public.comments c
LEFT JOIN auth.users u ON c.user_id = u.id
LEFT JOIN public.profiles p ON c.user_id = p.id;

-- =====================================================
-- 8. 啟用 Realtime for profiles
-- =====================================================

-- 啟用 Realtime 訂閱（如果 publication 不存在會自動建立）
ALTER PUBLICATION supabase_realtime ADD TABLE public.profiles;

-- =====================================================
-- 完成
-- =====================================================

-- 新增註解
COMMENT ON COLUMN public.comments.user_id IS '留言用戶 ID（關聯 auth.users）';
COMMENT ON TABLE public.profiles IS '用戶個人資料表';
COMMENT ON FUNCTION public.handle_new_user() IS '自動為新用戶建立 profile';
COMMENT ON VIEW public.comments_with_user IS '留言列表視圖（包含用戶資訊）';

-- 顯示完成訊息
DO $$
BEGIN
  RAISE NOTICE '✅ 會員系統設定完成！';
  RAISE NOTICE '📌 請記得在 Supabase Dashboard 啟用 Email Authentication';
  RAISE NOTICE '📌 設定 Site URL: http://localhost:3000';
  RAISE NOTICE '📌 設定 Redirect URLs: http://localhost:3000/*';
END $$;
