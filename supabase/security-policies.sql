-- ====================================
-- StevenBlog 安全政策設定
-- 執行此腳本以確保資料安全
-- ====================================

-- 1. 確保所有表格啟用 RLS
ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.post_tags ENABLE ROW LEVEL SECURITY;

-- 2. Posts 表格政策
-- 所有人可以讀取已發布的文章
DROP POLICY IF EXISTS "Anyone can read published posts" ON posts;
CREATE POLICY "Anyone can read published posts"
ON posts FOR SELECT
TO public
USING (status = 'published');

-- 只有認證用戶可以讀取草稿
DROP POLICY IF EXISTS "Authenticated users can read all posts" ON posts;
CREATE POLICY "Authenticated users can read all posts"
ON posts FOR SELECT
TO authenticated
USING (true);

-- 只有管理員可以新增文章
DROP POLICY IF EXISTS "Only admins can insert posts" ON posts;
CREATE POLICY "Only admins can insert posts"
ON posts FOR INSERT
TO authenticated
WITH CHECK (
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
);

-- 只有管理員可以更新文章
DROP POLICY IF EXISTS "Only admins can update posts" ON posts;
CREATE POLICY "Only admins can update posts"
ON posts FOR UPDATE
TO authenticated
USING (
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
);

-- 只有管理員可以刪除文章
DROP POLICY IF EXISTS "Only admins can delete posts" ON posts;
CREATE POLICY "Only admins can delete posts"
ON posts FOR DELETE
TO authenticated
USING (
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
);

-- 3. Categories 表格政策
-- 所有人可以讀取分類
DROP POLICY IF EXISTS "Anyone can read categories" ON categories;
CREATE POLICY "Anyone can read categories"
ON categories FOR SELECT
TO public
USING (true);

-- 只有管理員可以管理分類
DROP POLICY IF EXISTS "Only admins can manage categories" ON categories;
CREATE POLICY "Only admins can manage categories"
ON categories FOR ALL
TO authenticated
USING (
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
);

-- 4. Comments 表格政策
-- 所有人可以讀取留言
DROP POLICY IF EXISTS "Anyone can read comments" ON comments;
CREATE POLICY "Anyone can read comments"
ON comments FOR SELECT
TO public
USING (true);

-- 認證用戶可以新增留言
DROP POLICY IF EXISTS "Authenticated users can insert comments" ON comments;
CREATE POLICY "Authenticated users can insert comments"
ON comments FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

-- 用戶只能更新自己的留言
DROP POLICY IF EXISTS "Users can update own comments" ON comments;
CREATE POLICY "Users can update own comments"
ON comments FOR UPDATE
TO authenticated
USING (auth.uid() = user_id);

-- 用戶可以刪除自己的留言，或管理員可以刪除任何留言
DROP POLICY IF EXISTS "Users can delete own comments or admins can delete any" ON comments;
CREATE POLICY "Users can delete own comments or admins can delete any"
ON comments FOR DELETE
TO authenticated
USING (
  auth.uid() = user_id OR
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
);

-- 5. Tags 表格政策
-- 所有人可以讀取標籤
DROP POLICY IF EXISTS "Anyone can read tags" ON tags;
CREATE POLICY "Anyone can read tags"
ON tags FOR SELECT
TO public
USING (true);

-- 只有管理員可以管理標籤
DROP POLICY IF EXISTS "Only admins can manage tags" ON tags;
CREATE POLICY "Only admins can manage tags"
ON tags FOR ALL
TO authenticated
USING (
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
);

-- 6. Post_Tags 表格政策
-- 所有人可以讀取文章標籤關聯
DROP POLICY IF EXISTS "Anyone can read post_tags" ON post_tags;
CREATE POLICY "Anyone can read post_tags"
ON post_tags FOR SELECT
TO public
USING (true);

-- 只有管理員可以管理文章標籤關聯
DROP POLICY IF EXISTS "Only admins can manage post_tags" ON post_tags;
CREATE POLICY "Only admins can manage post_tags"
ON post_tags FOR ALL
TO authenticated
USING (
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
);

-- 7. Storage 政策（post-images bucket）
-- 允許所有人讀取圖片
DROP POLICY IF EXISTS "Anyone can read post images" ON storage.objects;
CREATE POLICY "Anyone can read post images"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'post-images');

-- 只有管理員可以上傳圖片
DROP POLICY IF EXISTS "Only admins can upload images" ON storage.objects;
CREATE POLICY "Only admins can upload images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'post-images' AND
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
);

-- 只有管理員可以更新圖片
DROP POLICY IF EXISTS "Only admins can update images" ON storage.objects;
CREATE POLICY "Only admins can update images"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'post-images' AND
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
);

-- 只有管理員可以刪除圖片
DROP POLICY IF EXISTS "Only admins can delete images" ON storage.objects;
CREATE POLICY "Only admins can delete images"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'post-images' AND
  (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
);

-- ====================================
-- 完成！現在您的資料庫已受到完整保護
-- ====================================

-- 驗證政策是否正確設定
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;
