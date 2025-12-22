# 後台管理系統 Netlify 部署指南

## 📋 部署前準備清單

### 1. 確認檔案已存在

- ✅ `netlify.toml` 已在專案根目錄
- ✅ `packages/blog-admin/package.json` 包含正確的 build script
- ✅ Supabase 資料庫和 Storage 已設置完成

### 2. 環境變數準備

需要準備以下 Supabase 環境變數（從 Supabase Dashboard 取得）：

1. **VITE_SUPABASE_URL**

   - 位置：Supabase Dashboard > Settings > API > Project URL
   - 範例：`https://xxxxxxxxxxxxx.supabase.co`

2. **VITE_SUPABASE_ANON_KEY**
   - 位置：Supabase Dashboard > Settings > API > Project API keys > anon public
   - 範例：`eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`

## 🚀 Netlify 部署步驟

### 方法 1：透過 Netlify Dashboard（推薦）

#### Step 1: 推送代碼到 GitHub

```bash
cd /Users/steven/Documents/myproject/StevenBlog

# 如果還沒有 git repository
git init
git add .
git commit -m "準備部署後台到 Netlify"

# 推送到 GitHub
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/StevenBlog.git
git push -u origin main
```

#### Step 2: 在 Netlify 創建新站點

1. 前往 [Netlify Dashboard](https://app.netlify.com/)
2. 點擊 **"Add new site"** > **"Import an existing project"**
3. 選擇 **"Deploy with GitHub"**
4. 授權 Netlify 訪問你的 GitHub 帳號
5. 選擇 `StevenBlog` repository

#### Step 3: 配置構建設置

Netlify 會自動從 `netlify.toml` 讀取配置，確認以下設置：

```
Base directory: packages/blog-admin
Build command: npm run build
Publish directory: packages/blog-admin/dist
```

#### Step 4: 添加環境變數

在 **"Site configuration"** > **"Environment variables"** 中添加：

1. 點擊 **"Add a variable"**
2. 添加以下變數：

| Key                      | Value                       | 說明                     |
| ------------------------ | --------------------------- | ------------------------ |
| `VITE_SUPABASE_URL`      | `https://xxxxx.supabase.co` | 你的 Supabase 項目 URL   |
| `VITE_SUPABASE_ANON_KEY` | `eyJhbGc...`                | Supabase anon public key |

3. 點擊 **"Save"**

#### Step 5: 部署

1. 點擊 **"Deploy StevenBlog"**
2. 等待構建完成（通常需要 2-3 分鐘）
3. 構建成功後會顯示部署的 URL

### 方法 2：使用 Netlify CLI

```bash
# 1. 安裝 Netlify CLI
npm install -g netlify-cli

# 2. 登入 Netlify
netlify login

# 3. 初始化站點（在專案根目錄執行）
cd /Users/steven/Documents/myproject/StevenBlog
netlify init

# 4. 按照提示選擇：
#    - Create & configure a new site
#    - 選擇你的 team
#    - 設定 site name（例如：stevenblog-admin）
#    - Build command: npm run build
#    - Directory to deploy: packages/blog-admin/dist

# 5. 設定環境變數
netlify env:set VITE_SUPABASE_URL "https://xxxxx.supabase.co"
netlify env:set VITE_SUPABASE_ANON_KEY "eyJhbGc..."

# 6. 部署
netlify deploy --prod
```

## 🔧 netlify.toml 配置說明

目前的 `netlify.toml` 配置：

```toml
[build]
  base = "packages/blog-admin"        # 構建的基礎目錄
  command = "npm run build"           # 構建命令
  publish = "dist"                    # 發布目錄（相對於 base）

[[redirects]]
  from = "/*"                         # 所有路由
  to = "/index.html"                  # 重定向到 index.html
  status = 200                        # SPA 路由支持

[build.environment]
  NODE_VERSION = "18"                 # Node.js 版本
```

### 為什麼需要 redirects？

因為 Vue Router 使用 HTML5 History 模式，當用戶直接訪問 `/posts` 或刷新頁面時，Netlify 需要將所有路由重定向到 `index.html`，讓 Vue Router 處理路由。

## 📦 構建測試

在部署前，建議本地測試構建：

```bash
# 切換到後台目錄
cd packages/blog-admin

# 創建 .env.production 檔案（測試用）
cat > .env.production << EOF
VITE_SUPABASE_URL=https://xxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGc...
EOF

# 執行構建
npm run build

# 預覽構建結果
npm run preview

# 訪問 http://localhost:4173 測試
```

## 🌐 自訂域名（選用）

### 配置自訂域名

1. 在 Netlify Dashboard > **Domain management**
2. 點擊 **"Add custom domain"**
3. 輸入你的域名（例如：`admin.stevenblog.com`）
4. 按照提示在你的 DNS 提供商添加記錄：

#### 使用子域名（推薦）

```
Type: CNAME
Name: admin
Value: your-site-name.netlify.app
```

#### 使用根域名

```
Type: A
Name: @
Value: 75.2.60.5
```

5. 等待 DNS 傳播（可能需要幾分鐘到 24 小時）
6. Netlify 會自動配置 HTTPS（Let's Encrypt）

## 🔒 安全性設置

### 1. 啟用 HTTPS

Netlify 會自動為你的站點提供 HTTPS，確保在 **Domain management** 中啟用：

- ✅ Force HTTPS
- ✅ HTTPS certificate

### 2. 限制訪問（選用）

如果想限制只有特定人員能訪問後台：

**選項 A：使用 Netlify 密碼保護**

1. Site settings > Access control
2. 啟用 Password protection
3. 設定密碼

**選項 B：使用 Supabase Auth**
現有的登入系統已經提供認證保護

### 3. 環境變數安全

- ❌ 不要在代碼中硬編碼 Supabase 金鑰
- ✅ 使用環境變數
- ✅ 使用 `anon` key（公開金鑰）而非 `service_role` key

## 🔄 自動部署

### 配置自動部署

Netlify 會自動監控 GitHub repository：

1. **Push to main branch** → 自動部署到生產環境
2. **Pull Request** → 自動創建預覽部署

### 部署通知

在 **Site settings** > **Build & deploy** > **Deploy notifications** 中設置：

- Email notifications
- Slack notifications
- Webhook notifications

## 🐛 故障排除

### 1. 構建失敗

**檢查構建日誌：**

- Netlify Dashboard > Deploys > 點擊失敗的部署
- 查看詳細錯誤信息

**常見問題：**

```bash
# 問題：找不到 npm
解決：在 netlify.toml 中設定 NODE_VERSION

# 問題：依賴安裝失敗
解決：確保 package.json 和 package-lock.json 已提交

# 問題：構建超時
解決：檢查是否有大型依賴或循環依賴
```

### 2. 部署後白屏

**檢查：**

1. 瀏覽器控制台是否有錯誤
2. 環境變數是否正確設置
3. Supabase URL 和 Key 是否有效

**測試環境變數：**

```javascript
// 在瀏覽器控制台執行
console.log("SUPABASE_URL:", import.meta.env.VITE_SUPABASE_URL);
```

### 3. 路由 404 錯誤

**確認：**

- `netlify.toml` 中的 redirects 規則已配置
- Vue Router 使用正確的 base path

### 4. 圖片上傳失敗

**檢查：**

1. Supabase Storage bucket 是否創建
2. Storage 政策是否正確設置
3. CORS 設置（在 Supabase Dashboard）

```sql
-- 確認 Storage 政策
SELECT * FROM storage.policies WHERE bucket_id = 'post-images';
```

## 📊 監控和分析

### Netlify Analytics

在 **Analytics** 標籤中可以查看：

- 訪問量統計
- 帶寬使用
- 頁面載入時間
- 部署頻率

### 構建時間優化

如果構建時間過長：

```toml
# netlify.toml 添加快取配置
[build]
  base = "packages/blog-admin"
  command = "npm ci && npm run build"  # 使用 ci 代替 install
  publish = "dist"

[[plugins]]
  package = "@netlify/plugin-nextjs"  # 如果使用 Next.js
```

## 📝 部署檢查清單

完成部署後，請確認：

- [ ] 網站可以正常訪問
- [ ] 登入功能正常
- [ ] 可以新增/編輯/刪除文章
- [ ] 可以上傳圖片
- [ ] 可以管理分類和留言
- [ ] 移動端顯示正常
- [ ] HTTPS 已啟用
- [ ] 環境變數已正確設置
- [ ] 路由切換正常（刷新頁面不會 404）

## 🎉 部署完成

你的後台管理系統現已部署到 Netlify！

**部署 URL：** `https://your-site-name.netlify.app`

如有自訂域名：`https://admin.yourdomain.com`

### 後續維護

1. **更新代碼：** 只需 push 到 GitHub，Netlify 自動部署
2. **查看部署狀態：** Netlify Dashboard
3. **回滾版本：** Deploys > 選擇舊版本 > Publish deploy

## 🔗 相關資源

- [Netlify 文檔](https://docs.netlify.com/)
- [Vite 部署指南](https://vitejs.dev/guide/static-deploy.html)
- [Supabase 文檔](https://supabase.com/docs)
- [Vue Router 文檔](https://router.vuejs.org/)

---

需要協助？查看詳細的 [故障排除指南](#-故障排除) 或聯繫支援。
