# 🚀 使用 Netlify Dashboard 部署后台管理系统

由于 Netlify CLI 有个已知的 bug，我们使用更简单可靠的 Dashboard 方式部署。

## ✅ 你的配置信息

**GitHub Repository:** https://github.com/newyorkwoo/StevenBlog

**Supabase 环境变量:**

```
VITE_SUPABASE_URL=https://your-project-id.supabase.co
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

> ⚠️ 请从 Supabase Dashboard > Settings > API 获取实际值

---

## 📝 部署步骤（5 分钟完成）

### 第 1 步：打开 Netlify Dashboard

🔗 访问：https://app.netlify.com/

### 第 2 步：创建新站点

1. 点击右上角 **"Add new site"** 按钮
2. 选择 **"Import an existing project"**

### 第 3 步：连接 GitHub

1. 点击 **"Deploy with GitHub"**
2. 如果是第一次使用，授权 Netlify 访问你的 GitHub
3. 在仓库列表中找到 **newyorkwoo/StevenBlog**
4. 点击它

### 第 4 步：配置构建设置

Netlify 会自动从 `netlify.toml` 读取配置。确认显示如下：

```
Base directory: packages/blog-admin
Build command: npm run build
Publish directory: packages/blog-admin/dist
Branch to deploy: main
```

✅ **这些都是正确的，直接进行下一步**

### 第 5 步：添加环境变量

点击页面上的 **"Show advanced"** 或 **"Advanced build settings"**

然后点击 **"Add environment variable"** 或 **"New variable"**

**添加第一个变量：**

```
Variable: VITE_SUPABASE_URL
Value: （从 Supabase Dashboard 获取你的项目 URL）
```

**再次点击 "Add environment variable" 添加第二个：**

```
Variable: VITE_SUPABASE_ANON_KEY
Value: （从 Supabase Dashboard 获取你的 Anon Key）
```

⚠️ **重要：** 确保没有多余的空格，完全照抄上面的内容

### 第 6 步：部署

1. 点击页面底部的 **"Deploy newyorkwoo/StevenBlog"** 或 **"Deploy site"**
2. 等待构建完成（大约 2-3 分钟）
3. 你会看到构建日志在运行

### 第 7 步：获取 URL

构建成功后，你会看到：

- ✅ 绿色的 "Published" 状态
- 🌐 你的站点 URL（例如：`https://random-name-123456.netlify.app`）

点击这个 URL 就可以访问你的后台管理系统了！

---

## 🎨 自定义站点名称（可选）

默认的 URL 是随机生成的，你可以改成好记的名称：

1. 在站点 Dashboard 点击 **"Site configuration"**
2. 点击 **"Change site name"**
3. 输入你想要的名称（例如：`stevenblog-admin`）
4. 点击 **"Save"**

你的新 URL 就会变成：`https://stevenblog-admin.netlify.app`

---

## ✅ 验证部署

访问你的 Netlify URL，检查：

- [ ] 页面正常显示（不是白屏）
- [ ] 可以正常登录
- [ ] 可以查看文章列表
- [ ] 可以新增/编辑文章
- [ ] 可以上传图片
- [ ] 手机访问正常

---

## 🔄 自动部署

✅ **已配置完成！** 现在每次你推送代码到 GitHub：

```bash
git add .
git commit -m "更新内容"
git push
```

Netlify 会自动检测变更并重新部署！

### 查看部署历史

在 Netlify Dashboard > **Deploys** 标签页可以看到：

- 所有部署记录
- 每次部署的构建日志
- 可以回滚到任何历史版本

---

## 🛠️ 如果部署失败

### 1. 查看构建日志

在 Netlify Dashboard > **Deploys** > 点击失败的部署 > 查看详细日志

### 2. 常见问题

**问题：找不到依赖**

```bash
# 本地测试构建
cd packages/blog-admin
npm install
npm run build
```

**问题：环境变量未生效**

1. 检查变量名拼写是否正确
2. 确认没有多余空格
3. 重新部署：Deploys > Trigger deploy > Clear cache and deploy site

**问题：白屏**

1. 打开浏览器开发者工具（F12）
2. 查看 Console 标签的错误信息
3. 通常是环境变量或 Supabase 连接问题

### 3. 测试环境变量

部署后，在你的站点打开浏览器控制台（F12），运行：

```javascript
console.log("URL:", import.meta.env.VITE_SUPABASE_URL);
console.log("Key exists:", !!import.meta.env.VITE_SUPABASE_ANON_KEY);
```

如果显示正确，说明环境变量已生效。

---

## 📊 站点设置

### 启用 HTTPS（自动）

✅ Netlify 会自动为你的站点配置 HTTPS（Let's Encrypt）

### 设置密码保护（可选）

如果想限制访问：

1. Site configuration > Access control
2. 启用 Password protection
3. 设置密码

---

## 🎯 完成！

现在你的后台管理系统已经部署到 Netlify 了！

**你的站点：** `https://[你的站点名称].netlify.app`

享受自动部署的便利吧！每次 git push 都会自动更新线上版本。

---

## 📞 需要帮助？

如果遇到问题，告诉我：

1. Netlify 构建日志的错误信息
2. 浏览器控制台的错误（如果有）
3. 具体的问题描述

我会帮你解决！🚀
