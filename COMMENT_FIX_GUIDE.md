# 🔧 留言功能修復指南

## 問題描述

提交留言時失敗，錯誤原因：資料庫的 `comments` 表缺少 `user_id` 欄位，導致前端無法正確插入留言資料。

## 問題原因

1. 前端代碼試圖插入 `user_id` 欄位
2. 資料庫 `comments` 表結構中沒有此欄位
3. RLS 政策不允許未經授權的插入操作

## 解決方案

### 方法 1: 使用 Supabase Dashboard（推薦）

1. **登入 Supabase Dashboard**

   - 前往 https://supabase.com
   - 選擇您的專案

2. **執行 SQL 腳本**

   - 點擊左側選單的 **SQL Editor**
   - 點擊 **New Query**
   - 複製並貼上 `supabase/migration-add-user-id.sql` 的內容
   - 點擊 **Run** 執行

3. **驗證設定**
   - 前往 **Table Editor** > **comments**
   - 確認 `user_id` 欄位已存在
   - 前往 **Authentication** > **Policies**
   - 確認新的政策已建立

### 方法 2: 使用 Supabase CLI

```bash
# 在專案根目錄執行
supabase db push --db-url "your-database-url"
```

## 詳細步驟（使用 Dashboard）

### 1. 添加 user_id 欄位

在 SQL Editor 執行：

```sql
-- 添加 user_id 欄位
ALTER TABLE public.comments
ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE;

-- 建立索引
CREATE INDEX IF NOT EXISTS idx_comments_user_id ON public.comments(user_id);
```

### 2. 更新 RLS 政策

```sql
-- 刪除舊政策
DROP POLICY IF EXISTS "Anyone can insert comments" ON public.comments;
DROP POLICY IF EXISTS "Only authenticated users can delete comments" ON public.comments;

-- 建立新政策：已登入用戶可以新增留言
CREATE POLICY "Authenticated users can insert comments"
ON public.comments FOR INSERT
TO authenticated
WITH CHECK (
  auth.uid() = user_id
  AND status = 'pending'
);

-- 建立新政策：用戶可以查看自己的待審核留言
CREATE POLICY "Users can read own pending comments"
ON public.comments FOR SELECT
TO authenticated
USING (
  auth.uid() = user_id
  OR status = 'approved'
);

-- 建立新政策：用戶可以刪除自己的留言
CREATE POLICY "Users can delete own comments"
ON public.comments FOR DELETE
TO authenticated
USING (auth.uid() = user_id OR auth.role() = 'authenticated');
```

## 驗證修復

1. **重新整理前台頁面**

   - http://localhost:3000/

2. **確認已登入**

   - 如果未登入，點擊右上角「登入」
   - 或註冊新帳號

3. **測試留言功能**

   - 前往任一文章頁面
   - 在留言區輸入內容
   - 點擊「提交留言」
   - 應該會看到「留言已提交，待審核後會顯示在頁面上！」訊息

4. **後台審核留言**
   - 前往 http://localhost:5200/
   - 登入後台
   - 進入留言管理
   - 將留言狀態改為 "approved"

## 常見問題

### Q: 執行 SQL 後仍然無法提交留言？

A: 請檢查：

1. 確認已登入（查看右上角是否有用戶名稱）
2. 清除瀏覽器緩存並重新整理
3. 開啟瀏覽器開發者工具（F12）查看 Console 錯誤訊息
4. 確認 Supabase 連接正常

### Q: 如何查看詳細錯誤訊息？

A:

1. 按 F12 開啟瀏覽器開發者工具
2. 切換到 Console 標籤
3. 嘗試提交留言
4. 查看紅色錯誤訊息

### Q: RLS 政策錯誤？

A: 確保：

1. 舊政策已完全刪除
2. 新政策名稱沒有衝突
3. 使用 `DROP POLICY IF EXISTS` 刪除舊政策後再建立新的

## 更新後的資料庫結構

```sql
CREATE TABLE public.comments (
  id UUID PRIMARY KEY,
  post_id UUID NOT NULL,           -- 文章 ID
  user_id UUID,                     -- ✨ 新增：用戶 ID
  author VARCHAR(100) NOT NULL,     -- 作者名稱
  email VARCHAR(255) NOT NULL,      -- 作者 Email
  content TEXT NOT NULL,            -- 留言內容
  status VARCHAR(20) DEFAULT 'pending',  -- 審核狀態
  ip_address VARCHAR(45),           -- IP 位址
  user_agent TEXT,                  -- User Agent
  created_at TIMESTAMPTZ,           -- 建立時間
  updated_at TIMESTAMPTZ            -- 更新時間
);
```

## 相關檔案

- 📄 `supabase/schema.sql` - 完整資料庫結構（已更新）
- 📄 `supabase/migration-add-user-id.sql` - 遷移腳本
- 📄 `packages/blog-frontend/src/components/CommentSection.vue` - 留言元件
- 📄 `packages/blog-frontend/src/stores/comment.js` - 留言 Store

## 後續步驟

修復完成後，您可以：

1. ✅ 在前台測試留言功能
2. ✅ 開發後台留言審核功能
3. ✅ 添加留言通知功能
4. ✅ 實作留言回覆功能（可選）

---

**修復完成後記得測試！** 🎉
