# 設定 Storage 政策指南

由於 `storage.objects` 是 Supabase 系統表，無法直接透過 SQL 修改其政策，需要在 Dashboard 中手動設定。

## 📋 步驟說明

### 1. 前往 Supabase Dashboard

1. 登入 [Supabase Dashboard](https://supabase.com/dashboard)
2. 選擇您的專案
3. 點擊左側選單的 **Storage**

### 2. 確保 post-images bucket 存在

- 如果已存在，直接進入下一步
- 如果不存在，點擊 **New bucket** 創建：
  - Name: `post-images`
  - Public bucket: **✅ 勾選**（允許公開讀取）

### 3. 設定 Policies

點擊 `post-images` bucket，然後點擊 **Policies** 標籤。

#### Policy 1: 允許所有人讀取圖片

點擊 **New Policy** > **For full customization**

```
Policy name: Anyone can read post images
Allowed operation: SELECT
Target roles: public
Policy definition - USING expression:
bucket_id = 'post-images'
```

點擊 **Review** > **Save policy**

---

#### Policy 2: 只有管理員可以上傳圖片

點擊 **New Policy** > **For full customization**

```
Policy name: Only admins can upload images
Allowed operation: INSERT
Target roles: authenticated
Policy definition - WITH CHECK expression:
bucket_id = 'post-images' AND (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
```

點擊 **Review** > **Save policy**

---

#### Policy 3: 只有管理員可以更新圖片

點擊 **New Policy** > **For full customization**

```
Policy name: Only admins can update images
Allowed operation: UPDATE
Target roles: authenticated
Policy definition - USING expression:
bucket_id = 'post-images' AND (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
```

點擊 **Review** > **Save policy**

---

#### Policy 4: 只有管理員可以刪除圖片

點擊 **New Policy** > **For full customization**

```
Policy name: Only admins can delete images
Allowed operation: DELETE
Target roles: authenticated
Policy definition - USING expression:
bucket_id = 'post-images' AND (auth.jwt() -> 'user_metadata' ->> 'role') = 'admin'
```

點擊 **Review** > **Save policy**

---

## ✅ 驗證設定

完成後，您應該看到 4 個政策：

1. ✅ Anyone can read post images (SELECT)
2. ✅ Only admins can upload images (INSERT)
3. ✅ Only admins can update images (UPDATE)
4. ✅ Only admins can delete images (DELETE)

## 🧪 測試

### 測試讀取權限（應該成功）

在瀏覽器 Console 中執行：

```javascript
const { data, error } = await supabase.storage.from("post-images").list();

console.log("Files:", data);
console.log("Error:", error);
```

### 測試上傳權限（未登入時應該失敗）

```javascript
const file = new File(["test"], "test.txt", { type: "text/plain" });

const { data, error } = await supabase.storage
  .from("post-images")
  .upload("test.txt", file);

console.log("Upload:", data);
console.log("Error:", error); // 應該顯示權限錯誤
```

### 測試管理員上傳（登入管理員後應該成功）

先確保您已經：

1. 執行了 `setup-admin-user.sql` 設定管理員角色
2. 使用管理員帳號登入

然後執行相同的上傳測試，應該會成功。

---

## ⚠️ 常見問題

### Q: 我看不到 Policies 標籤

A: 請確保您已經創建了 `post-images` bucket

### Q: 政策創建失敗

A: 檢查表達式語法是否正確，特別注意引號和括號

### Q: 管理員也無法上傳

A: 請確認：

1. 已執行 `setup-admin-user.sql` 設定角色
2. 使用正確的管理員帳號登入
3. 在瀏覽器 Console 檢查 JWT token：
   ```javascript
   const { data } = await supabase.auth.getSession();
   console.log(data.session.user.user_metadata.role);
   // 應該顯示 "admin"
   ```

---

**完成此步驟後，您的 Storage 安全設定就完成了！**
