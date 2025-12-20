# 部署指南

## 前台部署到 GitHub Pages

### 1. 準備 GitHub Repository

```bash
cd /Users/steven/StevenBlog
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git push -u origin main
```

### 2. 設定 GitHub Secrets

在 GitHub repository 設定中新增以下 Secrets：

1. 前往 Settings > Secrets and variables > Actions
2. 點選 "New repository secret"
3. 新增：
   - `VITE_SUPABASE_URL`: 您的 Supabase Project URL
   - `VITE_SUPABASE_ANON_KEY`: 您的 Supabase Anon Key

### 3. 啟用 GitHub Pages

1. 前往 Settings > Pages
2. Source 選擇 "GitHub Actions"
3. 儲存

### 4. 更新 Vite 配置

如果您的 repository 名稱不是您的使用者名稱，需要更新 `packages/blog-frontend/vite.config.js`：

```javascript
export default defineConfig({
  // ...
  base: "/YOUR_REPO_NAME/", // 改為您的 repository 名稱
});
```

### 5. 推送並部署

```bash
git add .
git commit -m "Add deployment configuration"
git push
```

GitHub Actions 會自動建置並部署到 GitHub Pages。
完成後可透過 `https://YOUR_USERNAME.github.io/YOUR_REPO_NAME/` 訪問。

## 後台部署到 Vercel

### 1. 安裝 Vercel CLI（選用）

```bash
npm install -g vercel
```

### 2. 部署

#### 方式 A：使用 Vercel Dashboard（推薦）

1. 前往 [Vercel Dashboard](https://vercel.com/dashboard)
2. 點選 "Add New" > "Project"
3. 匯入您的 GitHub repository
4. 設定：
   - Framework Preset: Vite
   - Root Directory: `packages/blog-admin`
   - Build Command: `npm run build`
   - Output Directory: `dist`
5. 新增環境變數：
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
6. 點選 "Deploy"

#### 方式 B：使用 CLI

```bash
cd packages/blog-admin
vercel --prod
```

按照提示設定環境變數。

### 3. 設定自訂域名（選用）

在 Vercel Project Settings > Domains 中設定自訂域名。

## 後台部署到 Netlify

### 1. 建立 netlify.toml

在專案根目錄建立 `netlify.toml`：

```toml
[build]
  base = "packages/blog-admin"
  command = "npm run build"
  publish = "dist"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

### 2. 部署

1. 前往 [Netlify](https://app.netlify.com/)
2. 點選 "Add new site" > "Import an existing project"
3. 連接 GitHub repository
4. 設定會自動從 `netlify.toml` 讀取
5. 新增環境變數：
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
6. 點選 "Deploy site"

## 本地預覽建置結果

### 前台

```bash
cd packages/blog-frontend
npm run build
npm run preview
```

### 後台

```bash
cd packages/blog-admin
npm run build
npm run preview
```

## 故障排除

### GitHub Pages 404 錯誤

- 確認 `vite.config.js` 的 `base` 設定正確
- 使用 Hash Router (`createWebHashHistory`)

### Supabase 連接失敗

- 確認環境變數已正確設定
- 檢查 Supabase URL 和金鑰是否正確
- 確認 RLS 政策已啟用

### 建置失敗

- 檢查 Node.js 版本（需要 >= 18）
- 清除 node_modules 並重新安裝：
  ```bash
  rm -rf node_modules package-lock.json
  npm install
  ```

### CORS 錯誤

- 在 Supabase Dashboard > Settings > API > CORS
- 新增您的部署域名到允許清單

## 持續整合與部署

每次推送到 main 分支時，GitHub Actions 會自動：

1. 建置前台專案
2. 部署到 GitHub Pages

Vercel/Netlify 會自動：

1. 偵測 GitHub repository 的變更
2. 建置後台專案
3. 部署到正式環境

## 環境變數管理

建議使用不同的 Supabase 專案或 API Key 用於：

- 開發環境（本地）
- 測試環境（選用）
- 生產環境（GitHub Pages + Vercel）

這樣可以避免開發時影響正式環境的資料。
