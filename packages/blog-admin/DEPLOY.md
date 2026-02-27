# 🚀 BlogAdmin 部署到 Netlify 指南

## ✅ 仓库信息

**GitHub Repository:** https://github.com/newyorkwoo/BlogAdmin

**Supabase 环境变量:**

```
VITE_SUPABASE_URL=https://your-project-id.supabase.co
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

> ⚠️ 请从 Supabase Dashboard > Settings > API 获取实际值

---

## 📝 Netlify 部署步骤

### 第 1 步：登入 Netlify

🔗 访问：https://app.netlify.com/

### 第 2 步：创建新站点

1. 点击 **"Add new site"**
2. 选择 **"Import an existing project"**
3. 选择 **"Deploy with GitHub"**

### 第 3 步：选择 BlogAdmin 仓库

找到并点击 **newyorkwoo/BlogAdmin**

### 第 4 步：配置构建设置

Netlify 会自动从 `netlify.toml` 读取，确认显示：

```
Build command: npm run build
Publish directory: dist
Branch to deploy: main
```

**✅ 这些都正确，直接点击底部的 "Deploy site" 按钮！**

### 第 5 步：部署后添加环境变量

⚠️ **重要：** 新版 Netlify 需要先部署，然后再添加环境变量

1. 等待初次部署完成（可能会失败，这是正常的）
2. 部署完成后，在站点 Dashboard 找到 **"Site configuration"** 或 **"Environment variables"**
3. 点击 **"Environment variables"** 标签页
4. 点击 **"Add a variable"** 或 **"Add environment variable"** 按钮

**添加变量 1:**

```
Key: VITE_SUPABASE_URL
Value: （从 Supabase Dashboard 获取你的项目 URL）
```

点击 **"Create variable"** 或 **"Save"**

**添加变量 2:**

```
Key: VITE_SUPABASE_ANON_KEY
Value: （从 Supabase Dashboard 获取你的 Anon Key）
```

点击 **"Create variable"** 或 **"Save"**

### 第 6 步：重新部署

添加环境变量后，需要重新部署：

1. 前往 **"Deploys"** 标签页
2. 点击 **"Trigger deploy"** 按钮
3. 选择 **"Deploy site"** 或 **"Clear cache and deploy site"**
4. 等待 2-3 分钟，完成后你会得到站点 URL！

---

## 🎨 自定义站点名称

在 **Site configuration** > **Change site name** 修改为：

- `stevenblog-admin`
- 或其他你喜欢的名称

---

## 🔄 自动部署

每次推送代码：

```bash
cd packages/blog-admin
git add .
git commit -m "更新说明"
git push
```

Netlify 会自动重新部署！

---

## ✅ 验证清单

- [ ] 页面正常显示
- [ ] 可以登录
- [ ] 可以管理文章
- [ ] 可以上传图片
- [ ] 手机访问正常

完成！🎉
