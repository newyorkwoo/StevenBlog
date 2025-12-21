-- 測試文章數據插入腳本
-- 用於測試分類功能

-- 首先確認分類已存在
SELECT * FROM categories ORDER BY "order";

-- 插入測試文章（請根據實際的 category_id 修改）
-- 注意：需要先從上面的查詢獲取實際的 category UUID

-- 範例：軟體分享分類的文章
INSERT INTO posts (title, slug, content, excerpt, category_id, status, published_at, read_time)
VALUES 
(
  'Vue 3 開發指南',
  'vue3-guide',
  '# Vue 3 開發指南

這是一篇關於 Vue 3 開發的完整指南。

## 安裝

```bash
npm create vue@latest
```

## 基本概念

Vue 3 使用 Composition API，讓代碼更易於組織和重用。',
  '這是一篇關於 Vue 3 開發的完整指南，包含安裝、基本概念和最佳實踐。',
  (SELECT id FROM categories WHERE slug = 'software' LIMIT 1),
  'published',
  NOW(),
  5
),
(
  'Tailwind CSS 實戰技巧',
  'tailwind-tips',
  '# Tailwind CSS 實戰技巧

分享一些實用的 Tailwind CSS 技巧。

## 響應式設計

使用 `md:` 前綴來設定中等螢幕以上的樣式。',
  '分享一些實用的 Tailwind CSS 技巧，讓你的開發更高效。',
  (SELECT id FROM categories WHERE slug = 'software' LIMIT 1),
  'published',
  NOW() - INTERVAL '1 day',
  3
);

-- 範例：旅遊記錄分類的文章
INSERT INTO posts (title, slug, content, excerpt, category_id, status, published_at, read_time)
VALUES 
(
  '東京三日遊記',
  'tokyo-trip',
  '# 東京三日遊記

這次東京之旅充滿了驚喜和美好的回憶。

## 第一天：淺草寺

早上抵達東京後，第一站來到了淺草寺。',
  '記錄我的東京三日遊，分享旅途中的美景和美食。',
  (SELECT id FROM categories WHERE slug = 'travel' LIMIT 1),
  'published',
  NOW() - INTERVAL '2 days',
  8
),
(
  '京都賞櫻攻略',
  'kyoto-sakura',
  '# 京都賞櫻攻略

分享京都最佳賞櫻地點和時間。

## 推薦景點

1. 哲學之道
2. 清水寺
3. 嵐山',
  '分享京都最佳賞櫻地點和時間，讓你不錯過最美的櫻花季。',
  (SELECT id FROM categories WHERE slug = 'travel' LIMIT 1),
  'published',
  NOW() - INTERVAL '3 days',
  6
);

-- 範例：美食評論分類的文章
INSERT INTO posts (title, slug, content, excerpt, category_id, status, published_at, read_time)
VALUES 
(
  '台北必吃美食推薦',
  'taipei-food',
  '# 台北必吃美食推薦

整理了台北最值得一試的美食清單。

## 1. 鼎泰豐小籠包

世界知名的小籠包，皮薄餡多。',
  '整理了台北最值得一試的美食清單，從小吃到餐廳都有。',
  (SELECT id FROM categories WHERE slug = 'food' LIMIT 1),
  'published',
  NOW() - INTERVAL '4 days',
  7
),
(
  '日本拉麵店探訪',
  'japan-ramen',
  '# 日本拉麵店探訪

分享我在日本吃過的各種拉麵店。

## 一蘭拉麵

24小時營業的人氣拉麵店。',
  '分享我在日本吃過的各種拉麵店，每家都有獨特風味。',
  (SELECT id FROM categories WHERE slug = 'food' LIMIT 1),
  'published',
  NOW() - INTERVAL '5 days',
  5
);

-- 範例：工作經驗分類的文章
INSERT INTO posts (title, slug, content, excerpt, category_id, status, published_at, read_time)
VALUES 
(
  '遠端工作心得分享',
  'remote-work-tips',
  '# 遠端工作心得分享

分享兩年遠端工作的經驗和技巧。

## 時間管理

設定固定的工作時間和休息時間很重要。',
  '分享兩年遠端工作的經驗和技巧，幫助你提升工作效率。',
  (SELECT id FROM categories WHERE slug = 'career' LIMIT 1),
  'published',
  NOW() - INTERVAL '6 days',
  10
),
(
  '前端工程師成長路線',
  'frontend-career-path',
  '# 前端工程師成長路線

從初學者到資深工程師的成長建議。

## 基礎階段

學好 HTML、CSS、JavaScript 基礎。',
  '從初學者到資深工程師的成長建議，規劃你的職涯發展。',
  (SELECT id FROM categories WHERE slug = 'career' LIMIT 1),
  'published',
  NOW() - INTERVAL '7 days',
  12
);

-- 驗證插入結果
SELECT 
  p.title,
  c.name as category,
  p.status,
  p.published_at
FROM posts p
LEFT JOIN categories c ON p.category_id = c.id
ORDER BY p.published_at DESC;
