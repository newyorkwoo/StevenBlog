# 🚀 GitHub Pages 部署指南

## 當前狀態

✅ **Git 倉庫已連接**

- Repository: `https://github.com/newyorkwoo/StevenBlog.git`
- 分支: `main`

✅ **已完成配置**

- [x] GitHub Actions workflow 已設定
- [x] Vite 配置已設定 base path
- [x] Supabase 環境變數已在本地配置

## 📋 部署前檢查清單

### 1. 確認本地變更已提交

```bash
cd /Users/steven/Documents/myproject/StevenBlog

# 查看狀態
git status

# 如果有未提交的變更
git add .
git commit -m "準備部署到 GitHub Pages"
git push origin main
```

### 2. 設定 GitHub Repository Secrets

這是**最重要**的步驟！需要將 Supabase 金鑰設定為 GitHub Secrets。

#### 步驟 A: 前往 GitHub Repository Settings

1. 打開瀏覽器，前往：

   ```
   https://github.com/newyorkwoo/StevenBlog/settings/secrets/actions
   ```

2. 或手動導航：
   - 前往 https://github.com/newyorkwoo/StevenBlog
   - 點擊 **Settings** 標籤
   - 左側選單點擊 **Secrets and variables** > **Actions**

#### 步驟 B: 新增 Secrets

點擊 **New repository secret** 按鈕，逐一新增以下兩個 secrets：

**Secret 1: VITE_SUPABASE_URL**

- Name: `VITE_SUPABASE_URL`
- Value: `（从 Supabase Dashboard 获取你的项目 URL）`
- 點擊 **Add secret**

**Secret 2: VITE_SUPABASE_ANON_KEY**

- Name: `VITE_SUPABASE_ANON_KEY`
- Value: `（从 Supabase Dashboard 获取你的 Anon Key）`
- 點擊 **Add secret**

#### 步驟 C: 驗證 Secrets 已新增

確認在 Secrets 列表中看到：

- ✅ VITE_SUPABASE_URL
- ✅ VITE_SUPABASE_ANON_KEY

### 3. 啟用 GitHub Pages

#### 步驟 A: 前往 Pages 設定

1. 前往：

   ```
   https://github.com/newyorkwoo/StevenBlog/settings/pages
   ```

2. 或手動導航：
   - Settings > 左側選單 **Pages**

#### 步驟 B: 設定 Source

- **Source**: 選擇 `GitHub Actions`
- 點擊 **Save**（如果需要）

### 4. 觸發部署

有兩種方式觸發部署：

#### 方式 A: 推送代碼（推薦）

```bash
cd /Users/steven/Documents/myproject/StevenBlog

# 確保有最新的變更
git add .
git commit -m "feat: 更新部署配置"
git push origin main
```

#### 方式 B: 手動觸發

1. 前往 Actions 頁面：

   ```
   https://github.com/newyorkwoo/StevenBlog/actions
   ```

2. 點擊左側的 **Deploy to GitHub Pages** workflow

3. 點擊右上角的 **Run workflow** 按鈕

4. 選擇 `main` 分支，點擊 **Run workflow**

### 5. 監控部署狀態

1. 前往 Actions 頁面查看部署進度：

   ```
   https://github.com/newyorkwoo/StevenBlog/actions
   ```

2. 點擊最新的 workflow run

3. 查看部署進度：
   - ✅ **build** job - 建置前台
   - ✅ **deploy** job - 部署到 GitHub Pages

4. 等待兩個 job 都顯示綠色勾勾 ✅

### 6. 訪問已部署的網站

部署完成後，您的部落格將可以通過以下網址訪問：

```
https://newyorkwoo.github.io/StevenBlog/
```

## 🔧 故障排除

### 問題 1: Actions 執行失敗

**可能原因**：Secrets 未設定或設定錯誤

**解決方案**：

1. 檢查 Secrets 是否已正確設定
2. 確認 Secret 名稱完全一致（區分大小寫）
3. 重新運行 workflow

### 問題 2: 404 錯誤

**可能原因**：base path 配置問題

**解決方案**：
確認 `packages/blog-frontend/vite.config.js` 中的 base 設定：

```javascript
base: process.env.NODE_ENV === "production" ? "/StevenBlog/" : "/",
```

### 問題 3: 白屏或無法載入

**可能原因**：

1. Supabase 連接失敗
2. 環境變數未正確傳遞

**解決方案**：

1. 檢查瀏覽器 Console (F12) 查看錯誤
2. 確認 GitHub Secrets 已正確設定
3. 重新部署

### 問題 4: 部署成功但功能異常

**可能原因**：Supabase CORS 設定

**解決方案**：
在 Supabase Dashboard 設定允許的網域：

1. 前往 Supabase Dashboard
2. Settings > API
3. 在 **URL Configuration** 中添加：
   - `https://newyorkwoo.github.io`
4. 儲存變更

## 📝 快速命令參考

```bash
# 查看 Git 狀態
git status

# 提交變更
git add .
git commit -m "更新內容"
git push origin main

# 查看遠端 URL
git remote -v

# 查看最近的 commits
git log --oneline -5
```

## 🎯 後續步驟

部署完成後：

1. ✅ 測試所有頁面功能
2. ✅ 測試會員註冊/登入
3. ✅ 測試留言功能（需先修復 user_id 問題）
4. ✅ 在 Supabase 新增測試文章
5. ✅ 設定自訂域名（可選）

## 🌐 重要 URLs

- **前台網站**: https://newyorkwoo.github.io/StevenBlog/
- **GitHub Repository**: https://github.com/newyorkwoo/StevenBlog
- **Actions**: https://github.com/newyorkwoo/StevenBlog/actions
- **Settings**: https://github.com/newyorkwoo/StevenBlog/settings

## 📱 自訂域名（進階）

如果您有自己的域名，可以設定 Custom Domain：

1. 前往 GitHub Pages 設定
2. 在 **Custom domain** 輸入您的域名
3. 在您的 DNS 提供商設定 CNAME 記錄
4. 等待 DNS 生效（通常 5-30 分鐘）

---

**準備好了嗎？執行以下命令開始部署！** 🚀

```bash
cd /Users/steven/Documents/myproject/StevenBlog
git add .
git commit -m "準備部署"
git push origin main
```
