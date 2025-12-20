# Supabase 設定指南

## 1. 建立 Supabase 專案

1. 前往 [Supabase](https://supabase.com/) 並登入
2. 點選 "New Project"
3. 填寫專案資訊：
   - Name: steven-blog
   - Database Password: 設定一個強密碼（請記住）
   - Region: 選擇最近的區域（如 Singapore）
4. 點選 "Create new project"

## 2. 執行資料庫 Schema

1. 在 Supabase Dashboard 左側選單點選 "SQL Editor"
2. 點選 "New query"
3. 複製 `schema.sql` 的完整內容並貼上
4. 點選 "Run" 或按 `Cmd/Ctrl + Enter` 執行

執行完成後，您應該會看到以下資料表：

- `categories` (分類)
- `tags` (標籤)
- `posts` (文章)
- `post_tags` (文章標籤關聯)
- `comments` (留言)
- `users` (使用者擴充資訊)

## 3. 設定 Realtime

1. 在左側選單選擇 "Database" > "Replication"
2. 找到 `comments` 表
3. 確認 "Source" 欄位中的開關是啟用的（綠色）

## 4. 設定 Storage (圖片上傳)

1. 在左側選單選擇 "Storage"
2. 點選 "Create a new bucket"
3. 設定：
   - Name: `post-images`
   - Public bucket: ✓ (勾選，讓圖片可公開訪問)
4. 點選 "Create bucket"

### 設定 Storage 政策

在建立的 bucket 上點選 "Policies"，然後新增以下政策：

**允許所有人讀取圖片：**

```sql
CREATE POLICY "Public Access"
ON storage.objects FOR SELECT
USING (bucket_id = 'post-images');
```

**只允許認證使用者上傳圖片：**

```sql
CREATE POLICY "Authenticated users can upload"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'post-images'
  AND auth.role() = 'authenticated'
);
```

**只允許認證使用者刪除圖片：**

```sql
CREATE POLICY "Authenticated users can delete"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'post-images'
  AND auth.role() = 'authenticated'
);
```

## 5. 建立管理員帳號

1. 在左側選單選擇 "Authentication" > "Users"
2. 點選 "Add user" > "Create new user"
3. 輸入 Email 和 Password
4. 點選 "Create user"

這個帳號將用於登入後台管理系統。

## 6. 取得 API 金鑰

1. 在左側選單選擇 "Settings" > "API"
2. 找到以下資訊：
   - **Project URL**: 形如 `https://xxxxx.supabase.co`
   - **anon public**: 公開金鑰（前台使用）
   - **service_role**: 服務金鑰（僅後台使用，請勿公開）

## 7. 設定環境變數

### 前台 (blog-frontend)

建立 `/packages/blog-frontend/.env` 檔案：

```env
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your_anon_key_here
```

### 後台 (blog-admin)

建立 `/packages/blog-admin/.env` 檔案：

```env
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your_anon_key_here
```

## 8. 測試連接

啟動前台開發伺服器：

```bash
cd /Users/steven/StevenBlog
npm run dev:frontend
```

開啟瀏覽器前往 `http://localhost:5173`，如果沒有錯誤訊息，表示連接成功！

## 9. 新增測試文章（選用）

您可以在 SQL Editor 中執行以下 SQL 來新增測試文章：

```sql
-- 插入測試文章
INSERT INTO public.posts (
  title,
  slug,
  content,
  excerpt,
  category_id,
  status,
  read_time,
  published_at
) VALUES (
  '歡迎來到我的部落格',
  'welcome-to-my-blog',
  '# 歡迎\n\n這是第一篇測試文章。\n\n## 關於本站\n\n這是一個使用 Vue 3 + Supabase 打造的部落格系統。',
  '歡迎來到我的部落格，這是第一篇測試文章。',
  (SELECT id FROM public.categories WHERE slug = 'software' LIMIT 1),
  'published',
  3,
  NOW()
);
```

## 常見問題

### Q: RLS 政策導致無法讀取資料？

A: 確認：

1. 資料表的 `status` 欄位為 `'published'`
2. 已正確執行 RLS 政策 SQL
3. 在 Database > Tables 中檢查各表的 RLS 是否啟用

### Q: Realtime 不工作？

A: 確認：

1. 在 Database > Replication 中 `comments` 表已啟用
2. 程式碼中有正確呼叫 `subscribe()`
3. 檢查瀏覽器 Console 是否有錯誤訊息

### Q: 圖片無法上傳？

A: 確認：

1. Storage bucket 已建立且設為 public
2. Storage 政策已正確設定
3. 檢查檔案大小限制（預設 50MB）

## 下一步

完成 Supabase 設定後，您可以：

1. 啟動前台查看效果
2. 開發後台管理系統
3. 新增更多測試內容
4. 準備部署到 GitHub Pages
