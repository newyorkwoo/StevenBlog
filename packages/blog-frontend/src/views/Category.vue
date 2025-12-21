<template>
  <div>
    <h1 class="text-4xl font-serif font-bold text-secondary-800 mb-8">
      {{ categoryName }}
    </h1>

    <div v-if="loading" class="flex justify-center py-12">
      <div
        class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"
      ></div>
    </div>

    <div
      v-else-if="posts.length > 0"
      class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8"
    >
      <article
        v-for="post in posts"
        :key="post.id"
        class="card-minimal group cursor-pointer"
        @click="router.push(`/post/${post.slug}`)"
      >
        <div
          v-if="post.cover_image"
          class="aspect-video mb-4 rounded-lg overflow-hidden bg-secondary-100"
        >
          <img
            :src="post.cover_image"
            :alt="post.title"
            class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
          />
        </div>

        <h2
          class="text-xl font-serif font-semibold text-secondary-800 mb-2 group-hover:text-primary-600 transition-colors"
        >
          {{ post.title }}
        </h2>

        <p class="text-secondary-600 text-sm mb-4 line-clamp-3">
          {{ post.excerpt || getExcerpt(post.content) }}
        </p>

        <div
          class="flex items-center justify-between text-xs text-secondary-500"
        >
          <span>{{ formatDate(post.published_at) }}</span>
          <span v-if="post.read_time">{{ post.read_time }} 分鐘閱讀</span>
        </div>
      </article>
    </div>

    <div v-else class="text-center py-12">
      <p class="text-secondary-500 text-lg">此分類尚無文章</p>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from "vue";
import { useRoute, useRouter } from "vue-router";
import { usePostStore } from "@/stores/post";
import { useCategoryStore } from "@/stores/category";
import { storeToRefs } from "pinia";

const route = useRoute();
const router = useRouter();
const postStore = usePostStore();
const categoryStore = useCategoryStore();
const { posts, loading } = storeToRefs(postStore);
const { categories } = storeToRefs(categoryStore);

const categoryName = computed(() => {
  const slug = route.params.slug;
  if (!slug) return "分類";
  const category = categories.value.find((c) => c.slug === slug);
  return category?.name || "分類";
});

const loadCategoryPosts = async () => {
  const slug = route.params.slug;
  if (!slug) {
    console.error("No category slug provided");
    return;
  }

  // 確保分類已載入
  if (categories.value.length === 0) {
    await categoryStore.fetchCategories();
  }

  const category = categories.value.find((c) => c.slug === slug);

  if (category) {
    console.log("Loading posts for category:", category.name, category.id);
    await postStore.fetchPosts(category.id, 100); // 增加限制以確保獲取更多文章
  } else {
    console.error("Category not found:", slug);
  }
};

onMounted(() => {
  loadCategoryPosts();
});

// 監聽路由變化，當切換分類時重新加載
watch(
  () => route.params.slug,
  (newSlug, oldSlug) => {
    if (newSlug && newSlug !== oldSlug) {
      loadCategoryPosts();
    }
  }
);

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
.line-clamp-3 {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
