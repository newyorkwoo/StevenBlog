-- 為文章表添加多圖片支援
-- 執行日期: 2025-12-21

-- 添加 images 欄位來存儲多張圖片的 URL
ALTER TABLE public.posts
ADD COLUMN IF NOT EXISTS images JSONB DEFAULT '[]'::jsonb;

-- 添加索引以提高查詢效率
CREATE INDEX IF NOT EXISTS idx_posts_images ON public.posts USING gin(images);

-- 添加註釋
COMMENT ON COLUMN public.posts.images IS '文章圖片陣列，最多10張，存儲格式: [{"url": "...", "order": 1}, ...]';

-- 驗證
SELECT column_name, data_type, column_default
FROM information_schema.columns
WHERE table_name = 'posts' AND column_name = 'images';
