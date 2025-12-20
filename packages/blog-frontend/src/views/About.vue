<template>
  <div class="max-w-3xl mx-auto">
    <h1 class="text-4xl font-serif font-bold text-secondary-800 mb-8">
      關於我
    </h1>

    <div class="card-minimal space-y-6">
      <section>
        <h2 class="text-2xl font-serif font-semibold text-secondary-800 mb-4">
          歡迎來到我的部落格
        </h2>
        <p class="text-secondary-700 leading-relaxed">
          這是一個記錄生活與學習的空間，在這裡我分享關於軟體開發、旅遊記錄、美食評論以及工作經驗的內容。
        </p>
      </section>

      <section>
        <h2 class="text-2xl font-serif font-semibold text-secondary-800 mb-4">
          部落格主題
        </h2>
        <ul class="space-y-3">
          <li class="flex items-start">
            <span class="text-primary-600 mr-2">•</span>
            <div>
              <strong class="text-secondary-800">軟體分享</strong>
              <p class="text-secondary-600 text-sm">
                分享實用的軟體工具、程式設計技巧與開發心得
              </p>
            </div>
          </li>
          <li class="flex items-start">
            <span class="text-primary-600 mr-2">•</span>
            <div>
              <strong class="text-secondary-800">旅遊記錄</strong>
              <p class="text-secondary-600 text-sm">
                記錄旅途中的風景、文化體驗與旅行故事
              </p>
            </div>
          </li>
          <li class="flex items-start">
            <span class="text-primary-600 mr-2">•</span>
            <div>
              <strong class="text-secondary-800">美食評論</strong>
              <p class="text-secondary-600 text-sm">
                探索各地美食，分享餐廳評價與料理心得
              </p>
            </div>
          </li>
          <li class="flex items-start">
            <span class="text-primary-600 mr-2">•</span>
            <div>
              <strong class="text-secondary-800">工作經驗</strong>
              <p class="text-secondary-600 text-sm">
                職場觀察、專案心得與職涯發展的思考
              </p>
            </div>
          </li>
        </ul>
      </section>

      <section>
        <h2 class="text-2xl font-serif font-semibold text-secondary-800 mb-4">
          技術堆疊
        </h2>
        <p class="text-secondary-700 leading-relaxed mb-3">
          本部落格採用現代化的技術堆疊打造：
        </p>
        <div class="grid grid-cols-2 gap-4">
          <div class="p-4 bg-primary-50 rounded-lg">
            <h3 class="font-semibold text-secondary-800 mb-2">前端</h3>
            <ul class="text-sm text-secondary-600 space-y-1">
              <li>Vue 3 + Vite</li>
              <li>Pinia (狀態管理)</li>
              <li>Tailwind CSS</li>
              <li>Vue Router</li>
            </ul>
          </div>
          <div class="p-4 bg-primary-50 rounded-lg">
            <h3 class="font-semibold text-secondary-800 mb-2">後端</h3>
            <ul class="text-sm text-secondary-600 space-y-1">
              <li>Supabase</li>
              <li>PostgreSQL</li>
              <li>Realtime</li>
              <li>Storage</li>
            </ul>
          </div>
        </div>
      </section>

      <section>
        <h2 class="text-2xl font-serif font-semibold text-secondary-800 mb-4">
          聯絡方式
        </h2>
        <p class="text-secondary-700 leading-relaxed">
          如有任何問題或合作機會，歡迎透過留言或 Email 與我聯繫。
        </p>
      </section>
    </div>
  </div>
</template>

<script setup>
// About page - static content
</script>
