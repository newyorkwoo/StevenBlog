<template>
  <div>
    <h1 class="text-4xl font-serif font-bold text-secondary-800 mb-4">
      搜尋結果
    </h1>
    <p class="text-secondary-600 mb-8">關鍵字：「{{ searchQuery }}」</p>

    <div v-if="loading" class="flex justify-center py-12">
      <div
        class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"
      ></div>
    </div>

    <div v-else-if="searchResults.length > 0">
      <p class="text-secondary-600 mb-6">
        找到 {{ searchResults.length }} 篇文章
      </p>

      <div class="space-y-6">
        <article
          v-for="post in searchResults"
          :key="post.id"
          class="card-minimal cursor-pointer hover:shadow-soft-lg transition-shadow"
          @click="router.push(`/post/${post.slug}`)"
        >
          <div class="flex gap-4">
            <div
              v-if="post.cover_image"
              class="w-32 h-32 flex-shrink-0 rounded-lg overflow-hidden bg-secondary-100"
            >
              <img
                :src="post.cover_image"
                :alt="post.title"
                class="w-full h-full object-cover"
              />
            </div>

            <div class="flex-1">
              <div v-if="post.categories" class="mb-2">
                <span
                  class="inline-block px-3 py-1 text-xs font-medium text-primary-700 bg-primary-100 rounded-full"
                >
                  {{ post.categories.name }}
                </span>
              </div>

              <h2
                class="text-xl font-serif font-semibold text-secondary-800 mb-2 hover:text-primary-600 transition-colors"
              >
                {{ post.title }}
              </h2>

              <p class="text-secondary-600 text-sm mb-2 line-clamp-2">
                {{ post.excerpt || getExcerpt(post.content) }}
              </p>

              <div class="text-xs text-secondary-500">
                {{ formatDate(post.published_at) }}
              </div>
            </div>
          </div>
        </article>
      </div>
    </div>

    <div v-else class="text-center py-12">
      <p class="text-secondary-500 text-lg">找不到相關文章</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from "vue";
import { useRoute, useRouter } from "vue-router";
import { usePostStore } from "@/stores/post";

const route = useRoute();
const router = useRouter();
const postStore = usePostStore();

const searchQuery = ref("");
const searchResults = ref([]);
const loading = ref(false);

onMounted(() => {
  searchQuery.value = route.query.q || "";
  performSearch();
});

watch(
  () => route.query.q,
  (newQuery) => {
    searchQuery.value = newQuery || "";
    performSearch();
  }
);

const performSearch = async () => {
  if (!searchQuery.value.trim()) {
    searchResults.value = [];
    return;
  }

  loading.value = true;
  try {
    searchResults.value = await postStore.searchPosts(searchQuery.value);
  } finally {
    loading.value = false;
  }
};

const getExcerpt = (content) => {
  if (!content) return "";
  const text = content.replace(/[#*`\[\]]/g, "").trim();
  return text.length > 150 ? text.substring(0, 150) + "..." : text;
};

const formatDate = (dateString) => {
  const date = new Date(dateString);
  return new Intl.DateTimeFormat("zh-TW", {
    year: "numeric",
    month: "long",
    day: "numeric",
  }).format(date);
};
</script>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
