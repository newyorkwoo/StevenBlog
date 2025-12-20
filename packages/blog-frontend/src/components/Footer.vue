<template>
  <footer class="bg-white border-t border-secondary-100 mt-12">
    <div class="container mx-auto px-4 py-8 max-w-6xl">
      <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
        <!-- About -->
        <div>
          <h3 class="text-lg font-serif font-semibold text-secondary-800 mb-4">
            關於我
          </h3>
          <p class="text-secondary-600 text-sm leading-relaxed">
            分享軟體開發、旅遊記錄、美食評論與工作經驗的個人部落格。
          </p>
        </div>

        <!-- Categories -->
        <div v-if="categories.length > 0">
          <h3 class="text-lg font-serif font-semibold text-secondary-800 mb-4">
            分類
          </h3>
          <ul class="space-y-2">
            <li v-for="category in categories" :key="category.id">
              <RouterLink
                :to="`/category/${category.slug}`"
                class="text-secondary-600 hover:text-primary-600 transition-colors text-sm"
              >
                {{ category.name }}
              </RouterLink>
            </li>
          </ul>
        </div>

        <!-- Links -->
        <div>
          <h3 class="text-lg font-serif font-semibold text-secondary-800 mb-4">
            連結
          </h3>
          <ul class="space-y-2">
            <li>
              <RouterLink
                to="/"
                class="text-secondary-600 hover:text-primary-600 transition-colors text-sm"
              >
                首頁
              </RouterLink>
            </li>
            <li>
              <RouterLink
                to="/about"
                class="text-secondary-600 hover:text-primary-600 transition-colors text-sm"
              >
                關於
              </RouterLink>
            </li>
          </ul>
        </div>
      </div>

      <div class="border-t border-secondary-100 mt-8 pt-8 text-center">
        <p class="text-secondary-500 text-sm">
          © {{ currentYear }} Steven's Blog. All rights reserved.
        </p>
      </div>
    </div>
  </footer>
</template>

<script setup>
import { computed } from "vue";
import { RouterLink } from "vue-router";
import { useCategoryStore } from "@/stores/category";
import { storeToRefs } from "pinia";

const categoryStore = useCategoryStore();
const { categories } = storeToRefs(categoryStore);

const currentYear = computed(() => new Date().getFullYear());
</script>
