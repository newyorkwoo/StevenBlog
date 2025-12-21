# 🔧 分類功能故障排除指南

## 問題描述

在 GitHub Pages 部署的網站上，點擊分類選項後頁面沒有顯示文章。

## 可能的原因

### 1. 資料庫中沒有測試文章 ⭐ 最常見

**症狀**：

- 分類頁面顯示「此分類尚無文章」
- 瀏覽器 Console 沒有錯誤

**解決方案**：

#### 方法 A: 使用 Supabase Dashboard（推薦）

1. 登入 Supabase Dashboard：https://supabase.com
2. 選擇您的專案
3. 點擊左側的 **SQL Editor**
4. 複製並執行 `supabase/sample-posts.sql` 中的 SQL
5. 這會插入 8 篇測試文章到不同分類

#### 方法 B: 使用後台管理系統

1. 訪問後台：http://localhost:5200/
2. 登入管理員帳號
3. 進入「文章管理」
4. 新增文章，選擇分類
5. 發布文章（status = published）

### 2. 分類路由參數問題

**症狀**：

- Console 顯示 "No category slug provided"
- 或 "Category not found"

**解決方案**：
已在代碼中添加了錯誤處理和調試信息。

**檢查方式**：

1. 按 F12 開啟開發者工具
2. 切換到 Console 標籤
3. 點擊分類連結
4. 查看是否有錯誤訊息

### 3. 路由切換不刷新數據

**症狀**：

- 第一次點擊分類有效
- 切換到其他分類時不更新

**解決方案**：
已添加 `watch` 監聽路由變化，確保切換分類時重新加載數據。

### 4. Supabase 連接問題

**症狀**：

- Console 顯示 Supabase 相關錯誤
- 網絡請求失敗

**解決方案**：

1. 檢查 `.env` 檔案中的環境變數
2. 確認 Supabase URL 和 Anon Key 正確
3. 檢查 GitHub Secrets 是否正確設定

---

## 🔍 診斷步驟

### 步驟 1: 檢查分類是否存在

在 Supabase SQL Editor 執行：

```sql
SELECT * FROM categories ORDER BY "order";
```

應該會看到 4 個分類：

- 軟體分享 (software)
- 旅遊記錄 (travel)
- 美食評論 (food)
- 工作經驗 (career)

### 步驟 2: 檢查文章是否存在

```sql
SELECT
  p.title,
  c.name as category,
  p.status,
  p.published_at
FROM posts p
LEFT JOIN categories c ON p.category_id = c.id
WHERE p.status = 'published'
ORDER BY p.published_at DESC;
```

如果沒有結果，說明沒有已發布的文章。

### 步驟 3: 檢查 RLS 政策

確認 Posts 表的 RLS 政策允許讀取：

```sql
-- 查看現有政策
SELECT * FROM pg_policies WHERE tablename = 'posts';
```

應該有政策允許所有人讀取已發布的文章。

### 步驟 4: 測試本地環境

```bash
# 在本地測試
cd /Users/steven/Documents/myproject/StevenBlog/packages/blog-frontend
npm run dev

# 訪問 http://localhost:3000/
# 測試分類功能
```

### 步驟 5: 檢查瀏覽器 Console

1. 訪問網站
2. 按 F12 開啟開發者工具
3. 切換到 Console 標籤
4. 點擊分類
5. 查看以下信息：
   - "Loading posts for category: xxx"
   - 是否有錯誤訊息

---

## 📝 已修復的問題

### ✅ 添加路由監聽

現在當切換不同分類時，會自動重新加載文章：

```javascript
watch(
  () => route.params.slug,
  (newSlug, oldSlug) => {
    if (newSlug && newSlug !== oldSlug) {
      loadCategoryPosts();
    }
  }
);
```

### ✅ 增加錯誤處理

添加了詳細的 Console 日誌，方便調試：

```javascript
console.log("Loading posts for category:", category.name, category.id);
console.error("Category not found:", slug);
```

### ✅ 增加文章載入限制

從預設 10 篇增加到 100 篇：

```javascript
await postStore.fetchPosts(category.id, 100);
```

### ✅ 確保分類先載入

在獲取文章前，確保分類數據已載入：

```javascript
if (categories.value.length === 0) {
  await categoryStore.fetchCategories();
}
```

---

## 🚀 快速修復指令

### 本地測試完整流程

```bash
# 1. 確保服務器運行
cd /Users/steven/Documents/myproject/StevenBlog/packages/blog-frontend
npm run dev

# 2. 在新終端機檢查 Git 變更
cd /Users/steven/Documents/myproject/StevenBlog
git status

# 3. 提交變更
git add .
git commit -m "fix: 修復分類頁面功能，添加路由監聽和錯誤處理"

# 4. 推送到 GitHub 觸發部署
git push origin main
```

### 插入測試數據

在 Supabase SQL Editor 執行 `supabase/sample-posts.sql`，會插入：

- 2 篇軟體分享文章
- 2 篇旅遊記錄文章
- 2 篇美食評論文章
- 2 篇工作經驗文章

---

## 📊 預期結果

修復後的效果：

1. ✅ 點擊「分類」下拉選單
2. ✅ 選擇任一分類（如「軟體分享」）
3. ✅ 頁面跳轉到 `/#/category/software`
4. ✅ 顯示該分類下的所有文章
5. ✅ 切換到其他分類時正確更新內容
6. ✅ 如果分類沒有文章，顯示「此分類尚無文章」

---

## 🔗 相關文件

- [Category.vue](packages/blog-frontend/src/views/Category.vue) - 分類頁面元件
- [post.js](packages/blog-frontend/src/stores/post.js) - 文章 Store
- [category.js](packages/blog-frontend/src/stores/category.js) - 分類 Store
- [sample-posts.sql](supabase/sample-posts.sql) - 測試文章 SQL

---

## 💡 最終提醒

**最常見的原因是資料庫沒有文章！**

請確保：

1. ✅ Supabase 中有已發布的文章（status = 'published'）
2. ✅ 文章有設定 category_id
3. ✅ 文章有設定 published_at 時間

執行測試 SQL 快速驗證：

```sql
-- 快速檢查
SELECT
  c.name as category,
  COUNT(p.id) as post_count
FROM categories c
LEFT JOIN posts p ON c.id = p.category_id AND p.status = 'published'
GROUP BY c.id, c.name
ORDER BY c."order";
```

這會顯示每個分類有多少篇已發布的文章。
