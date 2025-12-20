# Supabase 設定步驟指南

## 🚀 快速設定（3 個步驟）

### 步驟 1: 執行 SQL 腳本

1. 開啟 Supabase Dashboard: https://supabase.com/dashboard
2. 選擇你的專案
3. 點擊左側選單的 **SQL Editor**
4. 點擊 **New query**
5. 複製 `supabase/auth-setup.sql` 的全部內容並貼上
6. 點擊 **Run** 執行腳本

✅ 這個腳本會自動完成：

- 更新 comments 表結構（新增 user_id）
- 建立 profiles 表
- 設定所有 RLS 政策
- 建立自動建立 profile 的觸發器
- 啟用 Realtime 訂閱

### 步驟 2: 啟用 Email Authentication

1. 在 Supabase Dashboard 點擊 **Authentication**
2. 點擊 **Providers** 標籤
3. 找到 **Email** provider
4. 確認已啟用（Enable Email provider 開關為開啟狀態）

#### 設定選項：

##### 開發環境設定（推薦）：

- **Confirm email**: ❌ 關閉（方便測試）
- **Secure email change**: ❌ 關閉（方便測試）
- **Site URL**: `http://localhost:3000`
- **Redirect URLs**:
  ```
  http://localhost:3000/*
  http://localhost:3000/**
  ```

##### 生產環境設定：

- **Confirm email**: ✅ 開啟（需要驗證 email）
- **Secure email change**: ✅ 開啟（更改 email 需驗證）
- **Site URL**: `https://你的網域.com`
- **Redirect URLs**:
  ```
  https://你的網域.com/*
  https://你的網域.com/**
  ```

### 步驟 3: 設定 URL Configuration

1. 在 Supabase Dashboard 點擊 **Authentication**
2. 點擊 **URL Configuration** 標籤
3. 設定以下內容：

```
Site URL: http://localhost:3000
Redirect URLs:
  http://localhost:3000/*
  http://localhost:3000/**
```

**生產環境記得改成你的實際網域！**

---

## ✅ 驗證設定

執行完上述步驟後，檢查以下項目：

### 1. 檢查資料表結構

在 SQL Editor 執行：

```sql
-- 檢查 comments 表是否有 user_id
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'comments' AND column_name = 'user_id';

-- 檢查 profiles 表是否存在
SELECT * FROM public.profiles LIMIT 1;
```

### 2. 檢查 RLS 政策

在 **Database** → **Tables** → **comments** → **Policies** 確認有以下政策：

- ✅ Everyone can read approved comments
- ✅ Authenticated users can insert comments
- ✅ Users can read own pending comments
- ✅ Users can delete own comments
- ✅ Authenticated users can update all comments

在 **profiles** 表確認有：

- ✅ Profiles are viewable by everyone
- ✅ Users can insert own profile
- ✅ Users can update own profile

### 3. 測試 Email Provider

1. 前往 **Authentication** → **Users**
2. 點擊 **Add user** → **Create new user**
3. 輸入測試 email 和密碼
4. 如果能成功建立，表示 Email provider 已正確啟用

---

## 🧪 測試會員功能

### 1. 啟動開發伺服器

```bash
cd packages/blog-frontend
pnpm dev
```

### 2. 測試註冊

1. 開啟瀏覽器前往 http://localhost:3000/#/register
2. 填寫：
   - 顯示名稱：測試用戶
   - Email: test@example.com
   - 密碼：test123（至少 6 個字元）
   - 確認密碼：test123
3. 點擊「註冊」
4. ✅ 應該看到成功訊息並自動跳轉到登入頁

### 3. 測試登入

1. 在登入頁輸入剛才註冊的 email 和密碼
2. 點擊「登入」
3. ✅ 應該跳轉到首頁並在右上角看到用戶選單

### 4. 檢查 Profile 是否自動建立

在 Supabase SQL Editor 執行：

```sql
SELECT * FROM public.profiles;
```

✅ 應該看到剛才註冊的用戶，display_name 是你輸入的「測試用戶」

### 5. 測試個人資料更新

1. 點擊右上角用戶選單 → 「個人資料」
2. 修改顯示名稱為「新名稱」
3. 點擊「更新個人資料」
4. ✅ 應該看到成功訊息

### 6. 測試留言功能

1. 前往任一文章頁面
2. ✅ 已登入時：應該看到留言表單（只有內容欄位）
3. ✅ 未登入時：應該看到「請登入後留言」的提示和登入按鈕
4. 輸入留言內容並提交
5. ✅ 應該看到「留言已提交，待審核後會顯示」的訊息

### 7. 在資料庫檢查留言

在 Supabase SQL Editor 執行：

```sql
SELECT
  c.id,
  c.content,
  c.status,
  c.user_id,
  p.display_name,
  c.created_at
FROM public.comments c
LEFT JOIN public.profiles p ON c.user_id = p.id
ORDER BY c.created_at DESC;
```

✅ 應該看到：

- `user_id` 有值（指向你的用戶）
- `status` 為 'pending'
- `display_name` 顯示你的顯示名稱

### 8. 測試登出

1. 點擊右上角用戶選單 → 「登出」
2. ✅ 應該跳轉到首頁
3. ✅ 右上角應該顯示「登入」和「註冊」按鈕
4. 前往文章頁面
5. ✅ 應該看到登入提示而非留言表單

---

## 📋 常見問題排解

### Q1: 執行 SQL 腳本時出現權限錯誤

**解決方法：**

- 確認你使用的是專案的 **service_role key**（在 Settings → API）
- 或者在 Supabase Dashboard 的 SQL Editor 中執行（已有完整權限）

### Q2: 註冊時出現 "User already registered" 錯誤

**原因：** Email 已被使用

**解決方法：**

1. 換一個 email 測試
2. 或在 **Authentication** → **Users** 中刪除舊用戶

### Q3: 留言提交時出現 401 錯誤

**可能原因：**

1. RLS 政策未正確設定
2. 用戶未登入或 token 已過期

**檢查方法：**

```sql
-- 檢查 comments 表的 RLS 政策
SELECT * FROM pg_policies WHERE tablename = 'comments';
```

### Q4: Profile 沒有自動建立

**檢查觸發器：**

```sql
-- 檢查觸發器是否存在
SELECT * FROM information_schema.triggers
WHERE trigger_name = 'on_auth_user_created';
```

**手動建立 profile：**

```sql
-- 取得用戶 ID
SELECT id, email FROM auth.users;

-- 手動插入 profile
INSERT INTO public.profiles (id, display_name)
VALUES ('用戶的UUID', '顯示名稱');
```

### Q5: 登入後馬上被登出

**可能原因：** Email 驗證設定問題

**解決方法：**

1. 前往 **Authentication** → **Providers** → **Email**
2. 關閉 "Confirm email" 選項（開發環境）

### Q6: 無法更新個人資料

**檢查 RLS 政策：**

```sql
-- 測試更新權限
SELECT * FROM public.profiles WHERE id = auth.uid();
```

如果回傳為空，表示 RLS 政策有問題，重新執行 auth-setup.sql

---

## 🔐 安全性檢查清單

在生產環境部署前，確認以下項目：

- [ ] ✅ 啟用 Email 驗證 (Confirm email)
- [ ] ✅ 設定正確的 Site URL（你的網域）
- [ ] ✅ 設定正確的 Redirect URLs
- [ ] ✅ 所有資料表都已啟用 RLS
- [ ] ✅ 測試未登入用戶無法新增留言
- [ ] ✅ 測試用戶只能刪除自己的留言
- [ ] ✅ 測試用戶只能更新自己的 profile
- [ ] ✅ 環境變數（VITE_SUPABASE_URL 和 ANON_KEY）已正確設定
- [ ] ❌ 絕對不要在前端暴露 SERVICE_ROLE_KEY

---

## 📞 需要幫助？

如果遇到問題：

1. 檢查 Supabase Dashboard 的 **Logs**（左側選單）
2. 檢查瀏覽器的 Console（F12）
3. 檢查 Network 標籤看 API 回應
4. 參考 Supabase 官方文檔：https://supabase.com/docs

---

## ✨ 設定完成後

恭喜！你的會員系統已經完全設定好了。現在你可以：

✅ 用戶可以註冊和登入
✅ 用戶可以管理個人資料
✅ 只有登入用戶可以留言
✅ 留言會關聯到用戶帳號
✅ 用戶可以刪除自己的留言
✅ 管理員可以審核所有留言

下一步可以考慮：

- 🎨 美化認證頁面
- 🔔 加入 email 通知
- 🌐 實作社交登入（Google、GitHub）
- 👤 加入用戶頭像上傳
- 🛡️ 實作管理員角色權限
