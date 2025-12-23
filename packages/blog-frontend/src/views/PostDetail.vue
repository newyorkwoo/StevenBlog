<template>
  <div v-if="loading" class="flex justify-center py-12">
    <div
      class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"
    ></div>
  </div>

  <div v-else-if="error" class="text-center py-12">
    <p class="text-red-600">{{ error }}</p>
  </div>

  <article v-else-if="currentPost" class="max-w-4xl mx-auto">
    <!-- Back Button -->
    <button
      @click="router.back()"
      class="mb-6 text-secondary-600 hover:text-primary-600 transition-colors flex items-center"
    >
      <svg
        class="w-5 h-5 mr-1"
        fill="none"
        stroke="currentColor"
        viewBox="0 0 24 24"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d="M15 19l-7-7 7-7"
        />
      </svg>
      返回
    </button>

    <!-- Post Header -->
    <header class="mb-8">
      <!-- Category -->
      <div v-if="currentPost.categories" class="mb-4">
        <RouterLink
          :to="`/category/${currentPost.categories.slug}`"
          class="inline-block px-3 py-1 text-sm font-medium text-primary-700 bg-primary-100 rounded-full hover:bg-primary-200 transition-colors"
        >
          {{ currentPost.categories.name }}
        </RouterLink>
      </div>

      <!-- Title -->
      <h1
        class="text-4xl md:text-5xl font-serif font-bold text-secondary-800 mb-4"
      >
        {{ currentPost.title }}
      </h1>

      <!-- Meta Info -->
      <div class="flex flex-wrap items-center gap-4 text-secondary-500 text-sm">
        <span>{{ formatDate(currentPost.published_at) }}</span>
        <span v-if="currentPost.read_time"
          >{{ currentPost.read_time }} 分鐘閱讀</span
        >
      </div>

      <!-- Tags -->
      <div
        v-if="currentPost.post_tags && currentPost.post_tags.length > 0"
        class="mt-4 flex flex-wrap gap-2"
      >
        <span
          v-for="tag in currentPost.post_tags"
          :key="tag.tags.id"
          class="text-sm text-secondary-500"
        >
          #{{ tag.tags.name }}
        </span>
      </div>
    </header>

    <!-- All Images Gallery (Masonry Layout) - 封面圖片 + 文章圖片集 -->
    <div v-if="allImages.length > 0" class="mb-12">
      <div class="masonry-grid">
        <div
          v-for="(image, index) in allImages"
          :key="index"
          class="masonry-item cursor-pointer hover:opacity-90 transition-opacity"
          @click="openLightbox(index)"
        >
          <img
            :src="image.url"
            :alt="image.alt"
            class="w-full rounded-lg shadow-md"
            loading="lazy"
          />
        </div>
      </div>
    </div>

    <!-- Post Content -->
    <div class="prose prose-lg max-w-none mb-12" v-html="renderedContent"></div>

    <!-- Lightbox -->
    <div
      v-if="lightboxOpen"
      class="fixed inset-0 z-50 bg-black bg-opacity-90 flex items-center justify-center"
      @click="closeLightbox"
    >
      <button
        @click="closeLightbox"
        class="absolute top-4 right-4 text-white text-3xl hover:text-gray-300 z-60"
      >
        ×
      </button>
      <button
        v-if="currentImageIndex > 0"
        @click.stop="previousImage"
        class="absolute left-4 text-white text-4xl hover:text-gray-300"
      >
        ‹
      </button>
      <button
        v-if="currentImageIndex < allImages.length - 1"
        @click.stop="nextImage"
        class="absolute right-4 text-white text-4xl hover:text-gray-300"
      >
        ›
      </button>
      <img
        :src="allImages[currentImageIndex].url"
        :alt="allImages[currentImageIndex].alt"
        class="max-w-[90vw] max-h-[90vh] object-contain"
        @click.stop
      />
      <div class="absolute bottom-4 text-white text-sm">
        {{ currentImageIndex + 1 }} / {{ allImages.length }}
      </div>
    </div>

    <!-- Comments Section -->
    <CommentSection :postId="currentPost.id" />
  </article>

  <div v-else class="text-center py-12">
    <p class="text-secondary-500 text-lg">找不到文章</p>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from "vue";
import { useRoute, useRouter, RouterLink } from "vue-router";
import { usePostStore } from "@/stores/post";
import { storeToRefs } from "pinia";
import { marked } from "marked";
import DOMPurify from "dompurify";
import CommentSection from "@/components/CommentSection.vue";

// 配置 marked
marked.setOptions({
  gfm: true,
  breaks: true,
});

const route = useRoute();
const router = useRouter();
const postStore = usePostStore();
const { currentPost, loading, error } = storeToRefs(postStore);

// Lightbox 相关状态
const lightboxOpen = ref(false);
const currentImageIndex = ref(0);

// Markdown 渲染缓存
const markdownCache = new Map();

onMounted(async () => {
  await postStore.fetchPostBySlug(route.params.slug);
});

// 合併封面圖片和文章圖片集
const allImages = computed(() => {
  const images = [];

  // 如果有封面圖片，加入到陣列最前面
  if (currentPost.value?.cover_image) {
    images.push({
      url: currentPost.value.cover_image,
      alt: currentPost.value.title,
    });
  }

  // 加入文章圖片集
  if (currentPost.value?.images && Array.isArray(currentPost.value.images)) {
    currentPost.value.images.forEach((image, index) => {
      images.push({
        url: image.url,
        alt: image.name || `圖片 ${index + 1}`,
      });
    });
  }

  return images;
});

const renderedContent = computed(() => {
  if (!currentPost.value?.content) return "";

  const cacheKey = `${currentPost.value.id}-${currentPost.value.updated_at}`;

  if (markdownCache.has(cacheKey)) {
    return markdownCache.get(cacheKey);
  }

  const dirty = marked(currentPost.value.content);
  const clean = DOMPurify.sanitize(dirty);

  markdownCache.set(cacheKey, clean);

  // 限制缓存大小
  if (markdownCache.size > 10) {
    const firstKey = markdownCache.keys().next().value;
    markdownCache.delete(firstKey);
  }

  return clean;
});

const formatDate = (dateString) => {
  const date = new Date(dateString);
  return new Intl.DateTimeFormat("zh-TW", {
    year: "numeric",
    month: "long",
    day: "numeric",
  }).format(date);
};

// Lightbox 功能
const openLightbox = (index) => {
  currentImageIndex.value = index;
  lightboxOpen.value = true;
  document.body.style.overflow = "hidden"; // 防止背景滾動
};

const closeLightbox = () => {
  lightboxOpen.value = false;
  document.body.style.overflow = ""; // 恢復滾動
};

const nextImage = () => {
  if (currentImageIndex.value < allImages.value.length - 1) {
    currentImageIndex.value++;
  }
};

const previousImage = () => {
  if (currentImageIndex.value > 0) {
    currentImageIndex.value--;
  }
};

// 鍵盤快捷鍵
const handleKeydown = (event) => {
  if (!lightboxOpen.value) return;

  if (event.key === "Escape") {
    closeLightbox();
  } else if (event.key === "ArrowRight") {
    nextImage();
  } else if (event.key === "ArrowLeft") {
    previousImage();
  }
};

onMounted(() => {
  window.addEventListener("keydown", handleKeydown);
});

onUnmounted(() => {
  window.removeEventListener("keydown", handleKeydown);
  document.body.style.overflow = ""; // 清理
});
</script>

<style scoped>
/* Markdown 內容樣式 */
.prose {
  color: rgb(55 65 81);
  line-height: 1.75;
}

.prose h1,
.prose h2,
.prose h3,
.prose h4,
.prose h5,
.prose h6 {
  font-family: serif;
  font-weight: 600;
  color: rgb(31 41 55);
  margin-top: 2rem;
  margin-bottom: 1rem;
}

.prose h1 {
  font-size: 1.875rem;
}

.prose h2 {
  font-size: 1.5rem;
}

.prose h3 {
  font-size: 1.25rem;
}

.prose p {
  margin-bottom: 1rem;
}

.prose a {
  color: rgb(59 130 246);
  text-decoration: underline;
}

.prose a:hover {
  color: rgb(29 78 216);
}

.prose img {
  border-radius: 0.5rem;
  margin-top: 1.5rem;
  margin-bottom: 1.5rem;
  box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1);
}

.prose code {
  background-color: rgb(243 244 246);
  color: rgb(31 41 55);
  padding: 0.125rem 0.25rem;
  border-radius: 0.25rem;
  font-size: 0.875rem;
}

.prose pre {
  background-color: rgb(31 41 55);
  color: white;
  padding: 1rem;
  border-radius: 0.5rem;
  overflow-x: auto;
  margin-top: 1.5rem;
  margin-bottom: 1.5rem;
}

.prose pre code {
  background-color: transparent;
  color: white;
  padding: 0;
}

.prose blockquote {
  border-left: 4px solid rgb(59 130 246);
  padding-left: 1rem;
  font-style: italic;
  color: rgb(75 85 99);
  margin-top: 1.5rem;
  margin-bottom: 1.5rem;
}

.prose ul,
.prose ol {
  margin-top: 1rem;
  margin-bottom: 1rem;
  padding-left: 1.5rem;
}

.prose li {
  margin-bottom: 0.5rem;
}

.prose table {
  width: 100%;
  margin-top: 1.5rem;
  margin-bottom: 1.5rem;
  border-collapse: collapse;
}

.prose th,
.prose td {
  border: 1px solid rgb(229 231 235);
  padding: 0.5rem 1rem;
}

.prose th {
  background-color: rgb(249 250 251);
  font-weight: 600;
}

/* Masonry 瀑布流布局 */
.masonry-grid {
  column-count: 3;
  column-gap: 1rem;
}

@media (max-width: 1024px) {
  .masonry-grid {
    column-count: 2;
  }
}

@media (max-width: 640px) {
  .masonry-grid {
    column-count: 1;
  }
}

.masonry-item {
  break-inside: avoid;
  margin-bottom: 1rem;
}

.masonry-item img {
  display: block;
  width: 100%;
  height: auto;
}
</style>
