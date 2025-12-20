-- 新增測試文章資料

-- 軟體分享類別文章
INSERT INTO posts (title, slug, excerpt, content, category_id, status, featured_image, read_time, published_at)
VALUES 
(
  'Vue 3 Composition API 完全指南',
  'vue3-composition-api-guide',
  '深入了解 Vue 3 Composition API 的核心概念，從基礎到進階應用全面解析。',
  '# Vue 3 Composition API 完全指南

## 什麼是 Composition API？

Composition API 是 Vue 3 引入的全新 API 風格，提供了更靈活的邏輯組織方式。

## 基本用法

```javascript
import { ref, computed, onMounted } from ''vue''

export default {
  setup() {
    const count = ref(0)
    const double = computed(() => count.value * 2)
    
    onMounted(() => {
      console.log(''Component mounted!'')
    })
    
    return {
      count,
      double
    }
  }
}
```

## 優點

- 更好的類型推導
- 更靈活的邏輯複用
- 更小的打包體積
- 更好的 tree-shaking

## 結論

Composition API 為 Vue 3 帶來了革命性的改變，讓我們能寫出更優雅、可維護的代碼。',
  (SELECT id FROM categories WHERE slug = 'software'),
  'published',
  'https://images.unsplash.com/photo-1633356122544-f134324a6cee?w=800',
  8,
  NOW() - INTERVAL '2 days'
),
(
  '用 Supabase 打造即時應用',
  'build-realtime-app-with-supabase',
  'Supabase 提供了強大的即時功能，讓您輕鬆實現即時聊天、通知等功能。',
  '# 用 Supabase 打造即時應用

## Supabase Realtime 簡介

Supabase Realtime 基於 PostgreSQL 的 Logical Replication，讓您能監聽資料庫變更。

## 設定即時訂閱

```javascript
const channel = supabase
  .channel(''comments'')
  .on(''postgres_changes'', 
    { 
      event: ''INSERT'', 
      schema: ''public'', 
      table: ''comments'' 
    },
    (payload) => {
      console.log(''新評論：'', payload.new)
    }
  )
  .subscribe()
```

## 實際應用

- 即時聊天系統
- 協作編輯工具
- 即時通知
- 線上協作看板

讓您的應用變得更加生動！',
  (SELECT id FROM categories WHERE slug = 'software'),
  'published',
  'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=800',
  6,
  NOW() - INTERVAL '5 days'
);

-- 旅遊類別文章
INSERT INTO posts (title, slug, excerpt, content, category_id, status, featured_image, read_time, published_at)
VALUES 
(
  '京都賞楓攻略：最佳景點與時間',
  'kyoto-autumn-leaves-guide',
  '京都的秋天美不勝收，這裡整理了最佳賞楓景點和時間，讓您的旅程完美無憾。',
  '# 京都賞楓攻略：最佳景點與時間

## 最佳賞楓時間

京都的楓葉季通常在 11 月中旬到 12 月初達到高峰。

## 必訪景點

### 清水寺
- **時間**：11/18 - 12/3
- **門票**：400 日圓
- **特色**：夜間點燈，楓葉如火

### 嵐山
- **時間**：11/20 - 12/5  
- **交通**：JR 嵐山站
- **特色**：渡月橋與竹林小徑

### 東福寺
- **時間**：11/15 - 11/30
- **門票**：600 日圓
- **特色**：通天橋上俯瞰楓海

## 實用建議

1. 避開週末，平日人潮較少
2. 早上 8 點前或傍晚 4 點後較佳
3. 購買一日券節省交通費
4. 記得帶保溫瓶和小點心

祝您有個美好的賞楓之旅！🍁',
  (SELECT id FROM categories WHERE slug = 'travel'),
  'published',
  'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=800',
  5,
  NOW() - INTERVAL '7 days'
),
(
  '台東三日遊：放慢腳步的療癒之旅',
  'taitung-3-day-trip',
  '遠離城市喧囂，來台東感受大自然的擁抱，這是一場身心靈的療癒之旅。',
  '# 台東三日遊：放慢腳步的療癒之旅

## Day 1：海線之旅

### 三仙台
看著日出從海平面升起，感受大自然的壯闊。

### 加路蘭遊憩區
漂流木藝術裝置，絕美的拍照景點。

### 都歷海灘
人少景美，可以悠閒地漫步沙灘。

## Day 2：縱谷線

### 伯朗大道
騎著單車穿梭在金黃稻田間。

### 鹿野高台
體驗熱氣球或飛行傘，俯瞰花東縱谷。

### 池上飯包
品嚐最道地的池上便當。

## Day 3：市區巡禮

### 鐵花村
晚上的音樂市集很有氛圍。

### 台東森林公園
騎單車環湖，呼吸芬多精。

### 台東夜市
品嚐在地美食小吃。

台東，一個來了就不想離開的地方。🌊',
  (SELECT id FROM categories WHERE slug = 'travel'),
  'published',
  'https://images.unsplash.com/photo-1528127269322-539801943592?w=800',
  7,
  NOW() - INTERVAL '10 days'
);

-- 美食類別文章
INSERT INTO posts (title, slug, excerpt, content, category_id, status, featured_image, read_time, published_at)
VALUES 
(
  '東京必吃拉麵店 Top 5',
  'tokyo-best-ramen-shops',
  '從傳統豚骨到創新口味，這五家拉麵店絕對值得您排隊等候。',
  '# 東京必吃拉麵店 Top 5

## 1. 一蘭拉麵

**地點**：新宿、澀谷等多處
**特色**：個人座位設計，專注享受美味

經典豚骨湯頭濃郁，可自選濃度、油度、蔥量等，客製化程度很高。

## 2. 蔦（Tsuta）

**地點**：巢鴨
**特色**：米其林一星拉麵店

醬油拉麵清爽卻層次豐富，湯頭帶有松露香氣。

## 3. 麵屋武藏

**地點**：新宿、池袋
**特色**：濃厚魚介湯頭

使用大量魚乾和豬骨熬製，味道濃郁獨特。

## 4. AFURI

**地點**：惠比壽、原宿
**特色**：柚子鹽拉麵

清爽的雞湯搭配柚子香，完全不油膩。

## 5. 博多一雙

**地點**：六本木
**特色**：九州正統豚骨

湯頭濃郁滑順，配上極細麵條，完美搭配。

## 小提示

- 通常 11:30-13:00 和 18:00-20:00 人潮最多
- 部分店家只收現金
- 座位通常不多，建議避開用餐尖峰時段

祝您享受美味的拉麵之旅！🍜',
  (SELECT id FROM categories WHERE slug = 'food'),
  'published',
  'https://images.unsplash.com/photo-1557872943-16a5ac26437e?w=800',
  6,
  NOW() - INTERVAL '3 days'
),
(
  '手沖咖啡入門指南',
  'pour-over-coffee-guide',
  '想在家也能喝到咖啡廳等級的咖啡嗎？讓我們從器材到技巧，一步步學習手沖咖啡。',
  '# 手沖咖啡入門指南

## 必備器材

### 基本配備
- 手沖壺（建議細口壺）
- 濾杯（V60、Kalita 等）
- 濾紙
- 磨豆機
- 電子秤
- 溫度計

## 沖煮比例

**黃金比例**：1:15（咖啡粉：水）
- 例如：20g 咖啡粉配 300ml 水

## 沖煮步驟

### 1. 準備工作
- 研磨度：中等（類似細砂糖）
- 水溫：90-92°C

### 2. 悶蒸（Bloom）
- 用 2 倍咖啡粉重量的水
- 輕柔畫圈注水
- 悶蒸 30 秒

### 3. 主要注水
- 分 2-3 次注水
- 保持水位穩定
- 總時間約 2.5-3 分鐘

### 4. 享用
- 稍微放涼到 65-70°C
- 慢慢品嚐風味層次

## 常見問題

**Q：咖啡太苦怎麼辦？**
A：降低水溫或加快注水速度

**Q：味道太淡？**
A：增加咖啡粉量或延長萃取時間

**Q：豆子怎麼選？**
A：新手建議從淺中焙開始，風味較清爽

開始您的手沖之旅，每一杯都是獨一無二的體驗！☕',
  (SELECT id FROM categories WHERE slug = 'food'),
  'published',
  'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800',
  8,
  NOW() - INTERVAL '6 days'
);

-- 工作心得類別文章  
INSERT INTO posts (title, slug, excerpt, content, category_id, status, featured_image, read_time, published_at)
VALUES 
(
  '前端工程師的職涯規劃心得',
  'frontend-developer-career-path',
  '從菜鳥到資深，分享我這五年來的成長歷程與心得。',
  '# 前端工程師的職涯規劃心得

## 我的背景

2019 年開始自學前端，從 HTML/CSS 開始，一路走到現在。

## 職涯階段

### Junior（0-2 年）
- **重點**：扎實基礎
- 熟練 JavaScript、React/Vue
- 了解 Git 版本控制
- 學習與團隊協作

### Mid-level（2-4 年）
- **重點**：深度與廣度
- 效能優化
- 狀態管理架構
- CI/CD 部署流程
- 開始帶 Junior

### Senior（4+ 年）
- **重點**：技術領導
- 系統架構設計
- 技術選型決策
- 團隊文化建立
- 跨部門溝通

## 持續學習的重要性

### 每週投資時間
- 閱讀技術文章：3-5 小時
- Side Project：5-10 小時
- 線上課程：2-3 小時

### 推薦資源
- Frontend Masters
- Egghead.io
- CSS-Tricks
- Dev.to

## 軟實力同樣重要

- **溝通能力**：技術再強也要能表達
- **時間管理**：學會說不，專注重要的事
- **團隊合作**：一個人走得快，一群人走得遠

## 給新手的建議

1. 不要急著學太多框架
2. 先把 JavaScript 基礎打好
3. 多寫 side project
4. 參與開源專案
5. 經營技術部落格

## 未來展望

技術不斷演進，保持好奇心和學習熱情是最重要的。

記住：這是一場馬拉松，不是短跑。🏃',
  (SELECT id FROM categories WHERE slug = 'work'),
  'published',
  'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=800',
  10,
  NOW() - INTERVAL '1 day'
),
(
  '遠端工作兩年後的真實感受',
  'remote-work-2-years-experience',
  '疫情後開始遠端工作，兩年下來有了一些心得和體悟想分享給大家。',
  '# 遠端工作兩年後的真實感受

## 為什麼選擇遠端？

2022 年因為疫情開始遠端，後來發現這種模式很適合我。

## 優點

### 時間彈性
- 不用通勤，省下 2 小時
- 可以配合自己的生理時鐘
- 更容易照顧家人

### 環境舒適
- 自己的空間、設備
- 想喝什麼就喝什麼
- 可以放自己喜歡的音樂

### 成本降低
- 省下交通費
- 省下外食費
- 可以住在更便宜的地方

## 挑戰

### 自律問題
需要很強的自制力，容易分心。

**解決方法**：
- 設定工作區域
- 使用番茄鐘工作法
- 穿「工作服」營造儀式感

### 溝通成本
文字溝通容易產生誤解。

**解決方法**：
- 善用視訊會議
- 文字盡量清楚完整
- 定期 1-on-1

### 社交孤立
少了與同事的日常互動。

**解決方法**：
- 參加 co-working space
- 定期實體聚會
- 加入社群活動

## 工作環境設置

### 硬體
- 好的椅子（腰會感謝你）
- 大螢幕或雙螢幕
- 好的網路和備援
- 降噪耳機

### 軟體
- Slack / Discord：即時溝通
- Notion：文件協作
- Zoom：視訊會議
- GitHub：程式碼管理

## 工作與生活平衡

這是最大的挑戰，因為工作和生活的界線變模糊了。

### 我的做法
- 固定的上下班時間
- 下班後關閉工作通知
- 週末不看工作訊息
- 保持運動習慣

## 結論

遠端工作不是萬能的，但找到適合自己的節奏後，真的能提升生活品質。

重點是：自律、溝通、界線。

你準備好遠端工作了嗎？💻',
  (SELECT id FROM categories WHERE slug = 'work'),
  'published',
  'https://images.unsplash.com/photo-1588196749597-9ff075ee6b5b?w=800',
  9,
  NOW() - INTERVAL '4 days'
);

-- 新增一些標籤
INSERT INTO tags (name, slug) VALUES
('Vue.js', 'vuejs'),
('Supabase', 'supabase'),
('JavaScript', 'javascript'),
('旅遊攻略', 'travel-guide'),
('日本', 'japan'),
('台灣', 'taiwan'),
('拉麵', 'ramen'),
('咖啡', 'coffee'),
('職涯發展', 'career'),
('遠端工作', 'remote-work');

-- 將標籤關聯到文章
INSERT INTO post_tags (post_id, tag_id)
SELECT p.id, t.id FROM posts p, tags t
WHERE p.slug = 'vue3-composition-api-guide' AND t.slug IN ('vuejs', 'javascript');

INSERT INTO post_tags (post_id, tag_id)
SELECT p.id, t.id FROM posts p, tags t
WHERE p.slug = 'build-realtime-app-with-supabase' AND t.slug IN ('supabase', 'javascript');

INSERT INTO post_tags (post_id, tag_id)
SELECT p.id, t.id FROM posts p, tags t
WHERE p.slug = 'kyoto-autumn-leaves-guide' AND t.slug IN ('travel-guide', 'japan');

INSERT INTO post_tags (post_id, tag_id)
SELECT p.id, t.id FROM posts p, tags t
WHERE p.slug = 'taitung-3-day-trip' AND t.slug IN ('travel-guide', 'taiwan');

INSERT INTO post_tags (post_id, tag_id)
SELECT p.id, t.id FROM posts p, tags t
WHERE p.slug = 'tokyo-best-ramen-shops' AND t.slug IN ('ramen', 'japan');

INSERT INTO post_tags (post_id, tag_id)
SELECT p.id, t.id FROM posts p, tags t
WHERE p.slug = 'pour-over-coffee-guide' AND t.slug IN ('coffee');

INSERT INTO post_tags (post_id, tag_id)
SELECT p.id, t.id FROM posts p, tags t
WHERE p.slug = 'frontend-developer-career-path' AND t.slug IN ('career', 'javascript');

INSERT INTO post_tags (post_id, tag_id)
SELECT p.id, t.id FROM posts p, tags t
WHERE p.slug = 'remote-work-2-years-experience' AND t.slug IN ('career', 'remote-work');
