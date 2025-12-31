-- ====================================
-- StevenBlog 安全政策設定（修正版）
-- 執行此腳本以確保資料安全
-- 執行前請先確認您已設定管理員的 user_metadata.role
-- ====================================

-- 首先，移除現有的自定義政策以避免衝突（僅針對 public schema）
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT schemaname, tablename, policyname 
              FROM pg_policies 
              WHERE schemaname = 'public') LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON %I.%I', 
                      r.policyname, r.schemaname, r.tablename);
    END LOOP;
END $$;

-- 1. 確保所有表格啟用 RLS（僅針對 public schema）
ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.post_tags ENABLE ROW LEVEL SECURITY;

-- 注意：storage.objects 的 RLS 由 Supabase 系統管理，我們只需創建政策

-- ====================================
-- 2. Posts 表格政策
-- ====================================

-- 所有人可以讀取已發布的文章
CREATE POLICY "Anyone can read published posts"
ON posts FOR SELECT
TO public
USING (status = 'published');

-- 認證用戶可以讀取所有文章（包括草稿）
CREATE POLICY "Authenticated users can read all posts"
ON posts FOR SELECT
TO authenticated
USING (true);

-- 只有管理員可以新增文章
CREATE POLICY "Only admins can insert posts"
ON posts FOR INSERT
TO authenticated
WITH CHECK (
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
);

-- 只有管理員可以更新文章
CREATE POLICY "Only admins can update posts"
ON posts FOR UPDATE
TO authenticated
USING (
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
);

-- 只有管理員可以刪除文章
CREATE POLICY "Only admins can delete posts"
ON posts FOR DELETE
TO authenticated
USING (
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
);

-- ====================================
-- 3. Categories 表格政策
-- ====================================

-- 所有人可以讀取分類
CREATE POLICY "Anyone can read categories"
ON categories FOR SELECT
TO public
USING (true);

-- 只有管理員可以新增分類
CREATE POLICY "Only admins can insert categories"
ON categories FOR INSERT
TO authenticated
WITH CHECK (
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
);

-- 只有管理員可以更新分類
CREATE POLICY "Only admins can update categories"
ON categories FOR UPDATE
TO authenticated
USING (
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
);

-- 只有管理員可以刪除分類
CREATE POLICY "Only admins can delete categories"
ON categories FOR DELETE
TO authenticated
USING (
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
);

-- ====================================
-- 4. Comments 表格政策
-- ====================================

-- 所有人可以讀取已批准的留言
CREATE POLICY "Anyone can read approved comments"
ON comments FOR SELECT
TO public
USING (status = 'approved');

-- 認證用戶可以讀取所有留言（管理用）
CREATE POLICY "Authenticated users can read all comments"
ON comments FOR SELECT
TO authenticated
USING (true);

-- 認證用戶可以新增留言（自己的）
CREATE POLICY "Authenticated users can insert own comments"
ON comments FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

-- 用戶只能更新自己的留言，或管理員可更新任何留言
CREATE POLICY "Users can update own comments or admins any"
ON comments FOR UPDATE
TO authenticated
USING (
  auth.uid() = user_id OR
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
);

-- 用戶可以刪除自己的留言，或管理員可以刪除任何留言
CREATE POLICY "Users can delete own comments or admins any"
ON comments FOR DELETE
TO authenticated
USING (
  auth.uid() = user_id OR
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
);

-- ====================================
-- 5. Tags 表格政策
-- ====================================

-- 所有人可以讀取標籤
CREATE POLICY "Anyone can read tags"
ON tags FOR SELECT
TO public
USING (true);

-- 只有管理員可以新增標籤
CREATE POLICY "Only admins can insert tags"
ON tags FOR INSERT
TO authenticated
WITH CHECK (
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
);

-- 只有管理員可以更新標籤
CREATE POLICY "Only admins can update tags"
ON tags FOR UPDATE
TO authenticated
USING (
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
);

-- 只有管理員可以刪除標籤
CREATE POLICY "Only admins can delete tags"
ON tags FOR DELETE
TO authenticated
USING (
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
);

-- ====================================
-- 6. Post_Tags 表格政策
-- ====================================

-- 所有人可以讀取文章標籤關聯
CREATE POLICY "Anyone can read post_tags"
ON post_tags FOR SELECT
TO public
USING (true);

-- 只有管理員可以新增文章標籤關聯
CREATE POLICY "Only admins can insert post_tags"
ON post_tags FOR INSERT
TO authenticated
WITH CHECK (
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
);

-- 只有管理員可以刪除文章標籤關聯
CREATE POLICY "Only admins can delete post_tags"
ON post_tags FOR DELETE
TO authenticated
USING (
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
);

-- ====================================
-- 7. Storage 政策（post-images bucket）
-- ====================================
-- 注意：Storage 政策需要在 Supabase Dashboard 中手動設定
-- 因為 storage.objects 是系統表，無法直接透過 SQL 創建政策
-- 請參考 STORAGE_POLICIES_SETUP.md 文件進行手動設定

-- 規則 1: 允許所有人讀取圖片
-- Policy name: Anyone can read post images
-- Allowed operation: SELECT
-- Target roles: public
-- USING expression: bucket_id = 'post-images'

-- 規則 2: 只有管理員可以上傳圖片
-- Policy name: Only admins can upload images  
-- Allowed operation: INSERT
-- Target roles: authenticated
-- WITH CHECK expression: 
--   bucket_id = 'post-images' AND
--   (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'

-- 規則 3: 只有管理員可以更新圖片
-- Policy name: Only admins can update images
-- Allowed operation: UPDATE
-- Target roles: authenticated
-- USING expression:
--   bucket_id = 'post-images' AND
--   (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'

-- 規則 4: 只有管理員可以刪除圖片
-- Policy name: Only admins can delete images
-- Allowed operation: DELETE
-- Target roles: authenticated
-- USING expression:
--   bucket_id = 'post-images' AND
--   (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'

-- ====================================
-- 8. 建立 post-images bucket（如果不存在）
-- ====================================

INSERT INTO storage.buckets (id, name, public)
VALUES ('post-images', 'post-images', true)
ON CONFLICT (id) DO UPDATE SET public = true;

-- ====================================
-- 完成！現在您的資料庫已受到完整保護
-- ====================================

-- 驗證政策是否正確設定
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    CASE 
        WHEN qual IS NOT NULL THEN 'Has USING clause'
        ELSE 'No USING clause'
    END as using_clause,
    CASE 
        WHEN with_check IS NOT NULL THEN 'Has CHECK clause'
        ELSE 'No CHECK clause'
    END as check_clause
FROM pg_policies
WHERE schemaname IN ('public', 'storage')
ORDER BY tablename, policyname;

-- 顯示統計信息
SELECT 
    tablename,
    COUNT(*) as policy_count
FROM pg_policies
WHERE schemaname IN ('public', 'storage')
GROUP BY tablename
ORDER BY tablename;
