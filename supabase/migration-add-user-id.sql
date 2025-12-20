-- 添加 user_id 欄位到 comments 表
-- 執行日期: 2025-12-21

-- 步驟 1: 添加 user_id 欄位
ALTER TABLE public.comments
ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE;

-- 步驟 2: 建立索引
CREATE INDEX IF NOT EXISTS idx_comments_user_id ON public.comments(user_id);

-- 步驟 3: 刪除舊的 RLS 政策
DROP POLICY IF EXISTS "Anyone can insert comments" ON public.comments;
DROP POLICY IF EXISTS "Only authenticated users can delete comments" ON public.comments;

-- 步驟 4: 建立新的 RLS 政策

-- 已登入用戶可以新增留言
CREATE POLICY "Authenticated users can insert comments"
ON public.comments FOR INSERT
TO authenticated
WITH CHECK (
  auth.uid() = user_id
  AND status = 'pending'
);

-- 用戶可以查看自己的待審核留言
CREATE POLICY "Users can read own pending comments"
ON public.comments FOR SELECT
TO authenticated
USING (
  auth.uid() = user_id
  OR status = 'approved'
);

-- 用戶可以刪除自己的留言
CREATE POLICY "Users can delete own comments"
ON public.comments FOR DELETE
TO authenticated
USING (auth.uid() = user_id OR auth.role() = 'authenticated');

-- 完成
