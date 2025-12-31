# 🛡️ 安全性修復指南

## ⚠️ 已發現的安全問題

本專案先前存在嚴重的安全漏洞，已進行緊急修復。

### 問題清單

1. **敏感憑證暴露在版本控制中** ✅ 已修復
   - `.env` 文件包含真實的 Supabase 憑證
   - 已從文件中移除並添加安全警告
2. **Anon Key 格式異常** ⚠️ 需要您確認
   - 檢測到的 key 格式：`sb_publishable_*`
   - 正常的 Supabase Anon Key 應該是完整的 JWT token (很長的字串)
3. **RLS 政策不一致** ⚠️ 需要執行 SQL
   - `schema.sql` 和 `security-policies.sql` 定義不一致
   - 建議使用 `security-policies.sql` 的較嚴格版本

## 🚨 立即執行的步驟

### 步驟 1: 重新生成 Supabase Keys (必須)

由於舊的憑證已經暴露在 Git 歷史中，**必須重新生成**：

1. 登入 [Supabase Dashboard](https://supabase.com/dashboard)
2. 選擇您的專案
3. 前往 **Settings** > **API**
4. 在 "Project API keys" 區塊：
   - 找到 `anon` `public` key
   - 點擊旁邊的 **Regenerate** 按鈕
   - ⚠️ 警告：這會使舊的 key 立即失效
5. 複製新的 Key

### 步驟 2: 更新本地環境變量

更新以下兩個文件的憑證（使用新生成的 key）：

```bash
# blog-frontend
packages/blog-frontend/.env

# blog-admin
packages/blog-admin/.env
```

範例格式：

```env
VITE_SUPABASE_URL=https://your-project-id.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...（很長的字串）
```

### 步驟 3: 執行正確的 RLS 政策

在 Supabase SQL Editor 中執行：

```bash
# 登入 Supabase Dashboard
# 前往 SQL Editor
# 執行以下文件的內容：
```

**執行文件：** `supabase/security-policies.sql`

這個文件包含：

- ✅ 基於角色的管理員權限檢查 (`auth.jwt() -> 'user_metadata' ->> 'role'`)
- ✅ 嚴格的 Storage 存取控制
- ✅ 正確的留言權限管理

### 步驟 4: 設定管理員角色

確保您的管理員帳號有正確的 `user_metadata`：

```sql
-- 在 Supabase SQL Editor 執行
UPDATE auth.users
SET raw_user_meta_data = jsonb_set(
  COALESCE(raw_user_meta_data, '{}'::jsonb),
  '{role}',
  '"admin"'
)
WHERE email = 'your-admin-email@example.com';
```

### 步驟 5: 清理 Git 歷史 (選擇性但建議)

⚠️ **重要**：舊的憑證仍存在於 Git 歷史中

如果專案已經推送到 GitHub：

```bash
# 選項 A: 使用 BFG Repo-Cleaner (推薦)
brew install bfg
bfg --delete-files .env
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# 選項 B: 使用 git filter-branch
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch packages/*/.env" \
  --prune-empty --tag-name-filter cat -- --all

# 強制推送 (會重寫歷史記錄)
git push origin --force --all
git push origin --force --tags
```

⚠️ **警告**：這會重寫 Git 歷史，如果有其他協作者需要通知他們重新 clone

## ✅ 驗證安全性

完成上述步驟後，執行以下檢查：

### 1. 檢查 .env 是否被 Git 追蹤

```bash
# 應該顯示 .env 文件
git status --ignored | grep .env

# 如果 .env 仍被追蹤，執行：
git rm --cached packages/blog-frontend/.env
git rm --cached packages/blog-admin/.env
git commit -m "Remove .env files from tracking"
```

### 2. 測試 RLS 政策

```bash
# 使用瀏覽器開發者工具測試：
# 1. 未登入狀態 - 應該只能讀取已發布的文章
# 2. 登入普通用戶 - 不應該能新增/編輯文章
# 3. 登入管理員 - 應該能執行所有操作
```

### 3. 檢查 Supabase Dashboard

1. 前往 **Authentication** > **Policies**
2. 確認每個表都有啟用 RLS
3. 確認政策規則符合 `security-policies.sql`

## 📋 安全檢查清單

- [ ] 重新生成 Supabase Anon Key
- [ ] 更新本地 `.env` 文件
- [ ] 執行 `security-policies.sql`
- [ ] 設定管理員 `user_metadata.role`
- [ ] 從 Git 移除 `.env` 追蹤
- [ ] 測試 RLS 政策是否正常運作
- [ ] (選擇性) 清理 Git 歷史
- [ ] 通知團隊成員更新憑證

## 🔒 未來的安全最佳實踐

### 1. 環境變量管理

```bash
# 使用 .env.example 作為範本
cp packages/blog-frontend/.env.example packages/blog-frontend/.env
# 然後填入真實的值
```

### 2. 部署平台設定

**Netlify:**

- 在 Site settings > Environment variables 中設定
- 不要將真實憑證放在 `netlify.toml`

**Vercel:**

- 在 Project Settings > Environment Variables 中設定

### 3. 定期審查

- 每季度檢查 Supabase 的 Auth logs
- 監控異常的 API 使用量
- 定期更新依賴套件

### 4. 額外的安全層

考慮實施：

- Rate limiting (速率限制)
- IP whitelist for admin endpoints
- 2FA for admin accounts
- CAPTCHA for public forms

## 📞 需要幫助？

如果在執行過程中遇到問題：

1. 檢查 Supabase Dashboard 的 Logs
2. 使用瀏覽器開發者工具查看 API 錯誤
3. 參考 [Supabase 官方文檔](https://supabase.com/docs)

---

**最後更新：** 2025 年 12 月 31 日  
**狀態：** 🔴 需要立即執行步驟 1-4
