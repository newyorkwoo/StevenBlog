<template>
  <div class="space-y-12">
    <!-- Hero Section -->
    <section class="text-center py-12">
      <h1
        class="text-4xl md:text-5xl font-serif font-bold text-secondary-800 mb-4"
      >
        歡迎來到我的部落格
      </h1>
      <p class="text-lg text-secondary-600 max-w-2xl mx-auto">
        分享軟體開發心得、旅遊記錄、美食探索與工作經驗
      </p>
    </section>

    <!-- Loading State -->
    <div v-if="loading" class="flex justify-center py-12">
      <div
        class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"
      ></div>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="text-center py-12">
      <p class="text-red-600">{{ error }}</p>
    </div>

    <!-- Posts Grid -->
    <div
      v-else-if="posts.length > 0"
      class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8"
    >
      <article
        v-for="post in posts"
        :key="post.id"
        class="card-minimal group"
        :class="{ 'cursor-pointer': post.slug }"
        @click="post.slug && router.push(`/post/${post.slug}`)"
      >
        <!-- Cover Image -->
        <div
          v-if="post.cover_image"
          class="aspect-video mb-4 rounded-lg overflow-hidden bg-secondary-100"
        >
          <img
            :src="post.cover_image"
            :alt="post.title"
            class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
            loading="lazy"
            decoding="async"
          />
        </div>

        <!-- Category Badge -->
        <div v-if="post.categories" class="mb-2">
          <span
            class="inline-block px-3 py-1 text-xs font-medium text-primary-700 bg-primary-100 rounded-full"
          >
            {{ post.categories.name }}
          </span>
        </div>

        <!-- Title -->
        <h2
          class="text-xl font-serif font-semibold text-secondary-800 mb-2 group-hover:text-primary-600 transition-colors"
        >
          {{ post.title }}
        </h2>

        <!-- Excerpt -->
        <p class="text-secondary-600 text-sm mb-4 line-clamp-3">
          {{ post.excerpt || getExcerpt(post.content) }}
        </p>

        <!-- Meta Info -->
        <div
          class="flex items-center justify-between text-xs text-secondary-500"
        >
          <span>{{ formatDate(post.published_at) }}</span>
          <span v-if="post.read_time">{{ post.read_time }} 分鐘閱讀</span>
        </div>

        <!-- Tags -->
        <div
          v-if="post.post_tags && post.post_tags.length > 0"
          class="mt-4 flex flex-wrap gap-2"
        >
          <span
            v-for="tag in post.post_tags.slice(0, 3)"
            :key="tag.tags.id"
            class="text-xs text-secondary-500 hover:text-primary-600 transition-colors"
          >
            #{{ tag.tags.name }}
          </span>
        </div>
      </article>
    </div>

    <!-- Empty State -->
    <div v-else class="text-center py-12">
      <p class="text-secondary-500 text-lg">目前還沒有文章</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import { usePostStore } from "@/stores/post";
import { storeToRefs } from "pinia";

const router = useRouter();
const postStore = usePostStore();
const { posts, loading, error } = storeToRefs(postStore);

onMounted(() => {
  postStore.fetchPosts();
});

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
