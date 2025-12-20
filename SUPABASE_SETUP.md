# Supabase 設定指南

## 會員系統設定

### 1. 啟用 Email Authentication

在 Supabase Dashboard：

1. 前往 **Authentication** → **Providers**
2. 啟用 **Email** provider
3. 設定：
   - 啟用 "Confirm email"（需要 email 驗證）或停用（允許直接註冊）
   - 設定 Site URL: `http://localhost:3000`（開發環境）
   - 設定 Redirect URLs: `http://localhost:3000/*`

### 2. 更新 Comments 資料表結構

需要新增 `user_id` 欄位來關聯留言與用戶：

```sql
-- 新增 user_id 欄位
ALTER TABLE comments
ADD COLUMN user_id UUID REFERENCES auth.users(id);

-- 建立索引以提高查詢效能
CREATE INDEX idx_comments_user_id ON comments(user_id);
```

### 3. 設定 Row Level Security (RLS) 政策

#### Comments 表的 RLS 政策

```sql
-- 啟用 RLS
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;

-- 1. 所有人都可以讀取已審核的留言
CREATE POLICY "Everyone can read approved comments"
ON comments
FOR SELECT
USING (status = 'approved');

-- 2. 已登入用戶可以新增留言
CREATE POLICY "Authenticated users can insert comments"
ON comments
FOR INSERT
TO authenticated
WITH CHECK (
  auth.uid() = user_id
  AND status = 'pending'
);

-- 3. 用戶可以查看自己的待審核留言
CREATE POLICY "Users can read own pending comments"
ON comments
FOR SELECT
TO authenticated
USING (
  auth.uid() = user_id
  OR status = 'approved'
);

-- 4. 用戶可以刪除自己的留言（可選）
CREATE POLICY "Users can delete own comments"
ON comments
FOR DELETE
TO authenticated
USING (auth.uid() = user_id);
```

### 4. 用戶個人資料表（可選）

如果需要儲存額外的用戶資料（如顯示名稱、頭像等）：

```sql
-- 建立 profiles 表
CREATE TABLE profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  display_name TEXT,
  avatar_url TEXT,
  bio TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 啟用 RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- 所有人都可以讀取 profiles
CREATE POLICY "Profiles are viewable by everyone"
ON profiles
FOR SELECT
USING (true);

-- 用戶只能更新自己的 profile
CREATE POLICY "Users can update own profile"
ON profiles
FOR UPDATE
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- 用戶只能插入自己的 profile
CREATE POLICY "Users can insert own profile"
ON profiles
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = id);

-- 當新用戶註冊時自動建立 profile
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, display_name)
  VALUES (
    new.id,
    COALESCE(new.raw_user_meta_data->>'display_name', split_part(new.email, '@', 1))
  );
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 建立觸發器
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

## Email 模板設定（可選）

在 Supabase Dashboard:

1. 前往 **Authentication** → **Email Templates**
2. 自訂以下模板：
   - Confirm signup（確認註冊）
   - Invite user（邀請用戶）
   - Magic Link（魔法連結登入）
   - Change Email Address（更改 Email）
   - Reset Password（重設密碼）

## 測試會員功能

### 1. 註冊新用戶

- 前往 `http://localhost:3000/#/register`
- 填寫顯示名稱、Email 和密碼
- 送出表單

### 2. 登入

- 前往 `http://localhost:3000/#/login`
- 輸入 Email 和密碼
- 成功後會重定向到首頁

### 3. 查看個人資料

- 點擊右上角的用戶選單
- 選擇「個人資料」
- 可以更新顯示名稱

### 4. 測試留言功能

- 前往任一文章頁面
- 只有登入用戶才能看到留言表單
- 未登入用戶會看到登入/註冊按鈕
- 提交留言後，留言狀態為「pending」

### 5. 審核留言（後台管理）

- 前往後台管理介面 `http://localhost:5200`
- 可以新增留言審核功能來批准或拒絕留言

## 環境變數檢查

確認 `.env` 檔案包含：

```env
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

## 安全注意事項

1. **永遠不要** 將 `service_role_key` 暴露在前端程式碼中
2. 使用 RLS 政策來保護資料
3. 驗證所有用戶輸入
4. 定期檢查 Supabase Dashboard 的 logs
5. 在生產環境中啟用 email 驗證
6. 設定密碼強度要求
7. 限制註冊次數以防止濫用

## 常見問題

### Q: 用戶註冊後看不到確認 email？

A: 檢查 Supabase Dashboard → Authentication → Settings 中的 SMTP 設定

### Q: 留言提交後出現 401 錯誤？

A: 確認已正確設定 RLS 政策，並且用戶已登入

### Q: 如何取得當前登入用戶？

A: 使用 `supabase.auth.getUser()` 或監聽 `onAuthStateChange`

### Q: 如何登出？

A: 使用 `supabase.auth.signOut()`

## 進階功能（可選實作）

1. **社交登入**: Google, GitHub, Facebook 等
2. **多重身份驗證 (MFA)**: 增加帳號安全性
3. **密碼重設**: 讓用戶可以重設密碼
4. **Email 變更**: 讓用戶可以更改 Email
5. **帳號刪除**: 讓用戶可以刪除自己的帳號
6. **用戶角色**: 區分一般用戶和管理員
