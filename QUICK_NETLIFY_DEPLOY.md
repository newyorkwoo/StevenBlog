# 🚀 快速部署到 Netlify

## 你的配置信息

✅ **GitHub Repository:** https://github.com/newyorkwoo/StevenBlog
✅ **代码已推送:** main 分支

### 环境变数

```
VITE_SUPABASE_URL=https://your-project-id.supabase.co
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

> ⚠️ 请从 Supabase Dashboard > Settings > API 获取实际值

---

## 📝 Netlify 部署步骤

### 1️⃣ 登入 Netlify

前往：https://app.netlify.com/

- 使用 GitHub 帐号登入

### 2️⃣ 创建新站点

1. 点击 **"Add new site"**
2. 选择 **"Import an existing project"**
3. 选择 **"Deploy with GitHub"**

### 3️⃣ 选择 Repository

1. 在 GitHub 仓库列表中找到 **newyorkwoo/StevenBlog**
2. 点击仓库名称

### 4️⃣ 配置构建设置

Netlify 会自动从 `netlify.toml` 读取配置，确认显示：

```
Base directory: packages/blog-admin
Build command: npm run build
Publish directory: packages/blog-admin/dist
```

**✅ 这些都是正确的，直接点击 "Advanced build settings"**

### 5️⃣ 添加环境变量

在 **"Advanced build settings"** 下，点击 **"New variable"**

添加第一个变量：

- **Key:** `VITE_SUPABASE_URL`
- **Value:** `（从 Supabase Dashboard 获取你的项目 URL）`

点击 **"New variable"** 再添加：

- **Key:** `VITE_SUPABASE_ANON_KEY`
- **Value:** `（从 Supabase Dashboard 获取你的 Anon Key）`

### 6️⃣ 开始部署

1. 点击 **"Deploy newyorkwoo/StevenBlog"**
2. 等待构建完成（约 2-3 分钟）
3. 构建成功后会显示部署的 URL

---

## 🎯 部署后的 URL

Netlify 会生成一个随机的 URL，例如：

```
https://random-name-xxxxx.netlify.app
```

你可以在 **Site settings > Domain management** 中：

1. 修改站点名称（例如：stevenblog-admin）
2. 或添加自定义域名

---

## ✅ 验证部署

部署完成后，访问你的 URL 并测试：

1. ✅ 打开网站是否正常显示
2. ✅ 登入功能是否正常
3. ✅ 可以新增/编辑文章
4. ✅ 可以上传图片
5. ✅ 移动端显示正常

---

## 🔧 如果遇到问题

### 构建失败

查看 **Deploys** 标签页中的构建日志，查找错误信息

### 白屏或空白页面

1. 打开浏览器开发者工具（F12）
2. 查看 Console 标签页是否有错误
3. 确认环境变量是否正确设置

### 登入失败

1. 确认 Supabase URL 和 Key 正确
2. 检查 Supabase 项目是否正常运行

---

## 📱 部署完成后

你的后台管理系统现在已经在线了！

### 下次更新

只需要：

```bash
git add .
git commit -m "更新说明"
git push
```

Netlify 会自动检测变更并重新部署。

### 自动部署设置

- ✅ Push to main → 自动部署
- ✅ Pull Request → 自动创建预览

---

## 🔗 有用的链接

- **Netlify Dashboard:** https://app.netlify.com/
- **你的 GitHub Repo:** https://github.com/newyorkwoo/StevenBlog
- **完整部署指南:** 查看 `NETLIFY_ADMIN_DEPLOYMENT.md`

---

需要帮助？查看完整的 [部署指南](NETLIFY_ADMIN_DEPLOYMENT.md) 或检查 [故障排除](NETLIFY_ADMIN_DEPLOYMENT.md#-故障排除) 部分。
