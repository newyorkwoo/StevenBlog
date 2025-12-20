# 🖼️ Supabase Storage 設定指南

## 問題：圖片上傳失敗

如果在後台上傳圖片時遇到失敗，請按照以下步驟設定 Supabase Storage。

## 📋 設定步驟

### 步驟 1: 建立 Storage Bucket

1. 登入 [Supabase Dashboard](https://supabase.com)
2. 選擇您的專案
3. 左側選單點選 **Storage**
4. 點擊 **Create a new bucket**
5. 填寫以下資訊：
   - **Name**: `post-images`
   - **Public bucket**: ✅ **勾選**（讓圖片可公開訪問）
   - **File size limit**: 5 MB（可選）
   - **Allowed MIME types**: `image/*`（可選）
6. 點擊 **Create bucket**

### 步驟 2: 設定 Storage 政策（重要！）

建立 bucket 後，需要設定存取權限：

#### 方法 A: 使用 UI 設定（推薦）

1. 在 Storage 頁面，找到 `post-images` bucket
2. 點擊 bucket 名稱旁的 **...** → **Policies**
3. 點擊 **New Policy**

**政策 1: 允許所有人讀取圖片**

- Policy name: `Public Access`
- Allowed operation: `SELECT`
- Target roles: `public`
- USING expression: 點擊 "Use the policy editor"
  ```sql
  bucket_id = 'post-images'
  ```

**政策 2: 允許認證使用者上傳圖片**

- Policy name: `Authenticated users can upload`
- Allowed operation: `INSERT`
- Target roles: `authenticated`
- WITH CHECK expression:
  ```sql
  bucket_id = 'post-images'
  ```

**政策 3: 允許認證使用者刪除圖片**

- Policy name: `Authenticated users can delete`
- Allowed operation: `DELETE`
- Target roles: `authenticated`
- USING expression:
  ```sql
  bucket_id = 'post-images'
  ```

#### 方法 B: 使用 SQL（進階）

在 SQL Editor 執行以下 SQL：

```sql
-- 允許所有人讀取圖片
CREATE POLICY "Public Access"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'post-images');

-- 允許認證使用者上傳圖片
CREATE POLICY "Authenticated users can upload"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'post-images');

-- 允許認證使用者更新圖片
CREATE POLICY "Authenticated users can update"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'post-images');

-- 允許認證使用者刪除圖片
CREATE POLICY "Authenticated users can delete"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'post-images');
```

### 步驟 3: 驗證設定

1. 返回後台管理系統：http://localhost:5173/posts/new
2. 嘗試上傳圖片
3. 如果成功，您會看到圖片預覽
4. 如果失敗，檢查瀏覽器的 Console（F12）查看詳細錯誤訊息

## 🔍 常見錯誤排除

### 錯誤 1: "Bucket not found"

**原因**: Storage bucket 'post-images' 不存在
**解決**: 按照步驟 1 建立 bucket

### 錯誤 2: "row-level security policy violation"

**原因**: 權限政策未正確設定
**解決**:

1. 檢查是否已建立上述 3 個政策
2. 確認政策的 Target roles 設定正確
3. 確認您已登入後台（需要 authenticated 身份）

### 錯誤 3: "Invalid API key"

**原因**: 環境變數配置錯誤
**解決**:

1. 檢查 `/packages/blog-admin/.env` 檔案
2. 確認 `VITE_SUPABASE_URL` 和 `VITE_SUPABASE_ANON_KEY` 正確
3. 重新啟動開發伺服器

### 錯誤 4: "File size exceeds limit"

**原因**: 圖片檔案超過 5MB
**解決**: 壓縮圖片後再上傳

## 📸 測試圖片

上傳測試圖片驗證功能：

1. 選擇一張小於 5MB 的圖片
2. 點擊「選擇檔案」
3. 看到預覽表示成功
4. 檔案會自動上傳到 Supabase Storage

## 🔗 相關連結

- [Supabase Storage 文檔](https://supabase.com/docs/guides/storage)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)
- [Storage Policies](https://supabase.com/docs/guides/storage/security/access-control)

## 💡 提示

- Storage bucket 名稱必須是 `post-images`（與程式碼一致）
- 確保 bucket 設定為 Public（公開）
- 圖片檔案會自動加上時間戳記作為檔名
- 上傳的圖片 URL 會自動填入表單的「封面圖片」欄位

## ✅ 完成檢查清單

- [ ] 已在 Supabase 建立 `post-images` bucket
- [ ] Bucket 設定為 Public
- [ ] 已建立 3 個 Storage 政策（SELECT, INSERT, DELETE）
- [ ] 環境變數正確設定
- [ ] 開發伺服器已重啟
- [ ] 已登入後台管理系統
- [ ] 測試上傳圖片成功

---

如果按照以上步驟設定後仍然失敗，請檢查瀏覽器 Console 的錯誤訊息，或參考 Supabase 的官方文檔。
