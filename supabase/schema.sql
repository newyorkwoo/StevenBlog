-- Supabase 資料庫 Schema
-- 部落格系統完整資料表結構

-- =====================================================
-- 1. Categories Table (分類)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.categories (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(100) NOT NULL UNIQUE,
  description TEXT,
  "order" INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 建立索引
CREATE INDEX IF NOT EXISTS idx_categories_slug ON public.categories(slug);
CREATE INDEX IF NOT EXISTS idx_categories_order ON public.categories("order");

-- 插入預設分類
INSERT INTO public.categories (name, slug, description, "order") VALUES
  ('軟體分享', 'software', '分享實用的軟體工具、程式設計技巧與開發心得', 1),
  ('旅遊記錄', 'travel', '記錄旅途中的風景、文化體驗與旅行故事', 2),
  ('美食評論', 'food', '探索各地美食，分享餐廳評價與料理心得', 3),
  ('工作經驗', 'career', '職場觀察、專案心得與職涯發展的思考', 4)
ON CONFLICT (slug) DO NOTHING;

-- =====================================================
-- 2. Tags Table (標籤)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.tags (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  slug VARCHAR(50) NOT NULL UNIQUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 建立索引
CREATE INDEX IF NOT EXISTS idx_tags_slug ON public.tags(slug);

-- =====================================================
-- 3. Posts Table (文章)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.posts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  slug VARCHAR(255) NOT NULL UNIQUE,
  content TEXT NOT NULL,
  excerpt VARCHAR(500),
  cover_image TEXT,
  category_id UUID REFERENCES public.categories(id) ON DELETE SET NULL,
  status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'archived')),
  read_time INTEGER, -- 預估閱讀時間（分鐘）
  published_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 建立索引
CREATE INDEX IF NOT EXISTS idx_posts_slug ON public.posts(slug);
CREATE INDEX IF NOT EXISTS idx_posts_category ON public.posts(category_id);
CREATE INDEX IF NOT EXISTS idx_posts_status ON public.posts(status);
CREATE INDEX IF NOT EXISTS idx_posts_published_at ON public.posts(published_at DESC);
CREATE INDEX IF NOT EXISTS idx_posts_search ON public.posts USING gin(to_tsvector('english', title || ' ' || content));

-- =====================================================
-- 4. Post_Tags Table (文章標籤關聯)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.post_tags (
  post_id UUID REFERENCES public.posts(id) ON DELETE CASCADE,
  tag_id UUID REFERENCES public.tags(id) ON DELETE CASCADE,
  PRIMARY KEY (post_id, tag_id)
);

-- 建立索引
CREATE INDEX IF NOT EXISTS idx_post_tags_post ON public.post_tags(post_id);
CREATE INDEX IF NOT EXISTS idx_post_tags_tag ON public.post_tags(tag_id);

-- =====================================================
-- 5. Comments Table (留言)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.comments (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  post_id UUID REFERENCES public.posts(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  author VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'spam')),
  ip_address VARCHAR(45), -- IPv4 或 IPv6
  user_agent TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 建立索引
CREATE INDEX IF NOT EXISTS idx_comments_user ON public.comments(user_id);
CREATE INDEX IF NOT EXISTS idx_comments_post ON public.comments(post_id);
CREATE INDEX IF NOT EXISTS idx_comments_status ON public.comments(status);
CREATE INDEX IF NOT EXISTS idx_comments_created_at ON public.comments(created_at DESC);

-- =====================================================
-- 6. Users Table (使用者 - 僅後台管理員)
-- =====================================================
-- 注意：Supabase Auth 已有內建 auth.users，此表為擴充資訊
CREATE TABLE IF NOT EXISTS public.users (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  display_name VARCHAR(100),
  avatar_url TEXT,
  bio TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 7. Row Level Security (RLS) 政策
-- =====================================================

-- Categories: 所有人可讀，僅管理員可寫
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Categories are viewable by everyone"
ON public.categories FOR SELECT
USING (true);

CREATE POLICY "Only authenticated users can insert categories"
ON public.categories FOR INSERT
WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Only authenticated users can update categories"
ON public.categories FOR UPDATE
USING (auth.role() = 'authenticated');

-- Tags: 所有人可讀，僅管理員可寫
ALTER TABLE public.tags ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Tags are viewable by everyone"
ON public.tags FOR SELECT
USING (true);

CREATE POLICY "Only authenticated users can insert tags"
ON public.tags FOR INSERT
WITH CHECK (auth.role() = 'authenticated');

-- Posts: 已發布文章所有人可讀，草稿僅管理員可見
ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Published posts are viewable by everyone"
ON public.posts FOR SELECT
USING (status = 'published' OR auth.role() = 'authenticated');

CREATE POLICY "Only authenticated users can insert posts"
ON public.posts FOR INSERT
WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Only authenticated users can update posts"
ON public.posts FOR UPDATE
USING (auth.role() = 'authenticated');

CREATE POLICY "Only authenticated users can delete posts"
ON public.posts FOR DELETE
USING (auth.role() = 'authenticated');

-- Post_Tags: 與文章權限相同
ALTER TABLE public.post_tags ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Post tags are viewable by everyone"
ON public.post_tags FOR SELECT
USING (true);

CREATE POLICY "Only authenticated users can manage post tags"
ON public.post_tags FOR ALL
USING (auth.role() = 'authenticated');

-- Comments: 已審核留言所有人可讀，已登入用戶可寫入（待審核）
ALTER TABLE public.comments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Approved comments are viewable by everyone"
ON public.comments FOR SELECT
USING (status = 'approved' OR auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can insert comments"
ON public.comments FOR INSERT
TO authenticated
WITH CHECK (
  auth.uid() = user_id
  AND status = 'pending'
);

CREATE POLICY "Users can read own pending comments"
ON public.comments FOR SELECT
TO authenticated
USING (
  auth.uid() = user_id
  OR status = 'approved'
);

CREATE POLICY "Only authenticated users can update comments"
ON public.comments FOR UPDATE
USING (auth.role() = 'authenticated');

CREATE POLICY "Users can delete own comments"
ON public.comments FOR DELETE
TO authenticated
USING (auth.uid() = user_id OR auth.role() = 'authenticated');

-- Users: 僅管理員可讀寫
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users are viewable by authenticated users"
ON public.users FOR SELECT
USING (auth.role() = 'authenticated');

CREATE POLICY "Users can update their own profile"
ON public.users FOR UPDATE
USING (auth.uid() = id);

-- =====================================================
-- 8. Triggers for updated_at
-- =====================================================

-- 建立更新 updated_at 的函數
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 為各表建立 trigger
CREATE TRIGGER set_categories_updated_at
  BEFORE UPDATE ON public.categories
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_updated_at();

CREATE TRIGGER set_posts_updated_at
  BEFORE UPDATE ON public.posts
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_updated_at();

CREATE TRIGGER set_comments_updated_at
  BEFORE UPDATE ON public.comments
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_updated_at();

CREATE TRIGGER set_users_updated_at
  BEFORE UPDATE ON public.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_updated_at();

-- =====================================================
-- 9. Realtime Publication (啟用即時訂閱)
-- =====================================================

-- 啟用 Realtime for comments table
ALTER PUBLICATION supabase_realtime ADD TABLE public.comments;

-- =====================================================
-- 10. 建立視圖 (方便查詢)
-- =====================================================

-- 文章列表視圖（包含分類和標籤）
-- 使用 security_invoker = true 確保以查詢者權限執行 RLS
CREATE OR REPLACE VIEW public.posts_with_details
WITH (security_invoker = true)
AS
SELECT 
  p.*,
  c.name as category_name,
  c.slug as category_slug,
  COALESCE(
    json_agg(
      json_build_object(
        'id', t.id,
        'name', t.name,
        'slug', t.slug
      )
    ) FILTER (WHERE t.id IS NOT NULL),
    '[]'
  ) as tags
FROM public.posts p
LEFT JOIN public.categories c ON p.category_id = c.id
LEFT JOIN public.post_tags pt ON p.id = pt.post_id
LEFT JOIN public.tags t ON pt.tag_id = t.id
GROUP BY p.id, c.id;

-- =====================================================
-- 完成
-- =====================================================

COMMENT ON TABLE public.categories IS '文章分類表';
COMMENT ON TABLE public.tags IS '文章標籤表';
COMMENT ON TABLE public.posts IS '文章主表';
COMMENT ON TABLE public.post_tags IS '文章標籤關聯表';
COMMENT ON TABLE public.comments IS '留言表';
COMMENT ON TABLE public.users IS '使用者擴充資訊表';
