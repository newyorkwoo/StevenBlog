<template>
  <div>
    <h1 class="text-3xl font-normal text-sand-900 mb-8 tracking-wide">
      儀表板
    </h1>

    <!-- 統計卡片 -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
      <div
        class="bg-white overflow-hidden rounded-lg"
        style="box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.05)"
      >
        <div class="p-5">
          <div class="flex items-center">
            <div class="flex-shrink-0">
              <svg
                class="h-6 w-6 text-gray-400"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                />
              </svg>
            </div>
            <div class="ml-5 w-0 flex-1">
              <dl>
                <dt class="text-sm font-medium text-gray-500 truncate">
                  文章總數
                </dt>
                <dd class="text-lg font-semibold text-gray-900">
                  {{ stats.totalPosts }}
                </dd>
              </dl>
            </div>
          </div>
        </div>
      </div>

      <div
        class="bg-white overflow-hidden rounded-lg"
        style="box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.05)"
      >
        <div class="p-5">
          <div class="flex items-center">
            <div class="flex-shrink-0">
              <svg
                class="h-6 w-6 text-gray-400"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z"
                />
              </svg>
            </div>
            <div class="ml-5 w-0 flex-1">
              <dl>
                <dt class="text-sm font-medium text-gray-500 truncate">
                  分類總數
                </dt>
                <dd class="text-lg font-semibold text-gray-900">
                  {{ stats.totalCategories }}
                </dd>
              </dl>
            </div>
          </div>
        </div>
      </div>

      <div class="bg-white overflow-hidden rounded-lg">
        <div class="p-5">
          <div class="flex items-center">
            <div class="flex-shrink-0">
              <svg
                class="h-6 w-6 text-gray-400"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"
                />
              </svg>
            </div>
            <div class="ml-5 w-0 flex-1">
              <dl>
                <dt class="text-sm font-medium text-gray-500 truncate">
                  留言總數
                </dt>
                <dd class="text-lg font-semibold text-gray-900">
                  {{ stats.totalComments }}
                </dd>
              </dl>
            </div>
          </div>
        </div>
      </div>

      <div class="bg-white overflow-hidden rounded-lg">
        <div class="p-5">
          <div class="flex items-center">
            <div class="flex-shrink-0">
              <svg
                class="h-6 w-6 text-gray-400"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
                />
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"
                />
              </svg>
            </div>
            <div class="ml-5 w-0 flex-1">
              <dl>
                <dt class="text-sm font-medium text-gray-500 truncate">
                  本月瀏覽
                </dt>
                <dd class="text-lg font-semibold text-gray-900">
                  {{ stats.monthlyViews }}
                </dd>
              </dl>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 最新文章 -->
    <div
      class="bg-white rounded-lg"
      style="box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.05)"
    >
      <div class="px-6 py-4 border-b border-sand-200">
        <h2 class="text-lg font-normal text-sand-900">最新文章</h2>
      </div>
      <div class="p-6">
        <div
          v-if="recentPosts.length === 0"
          class="text-gray-500 text-center py-4"
        >
          暫無文章
        </div>
        <div v-else class="space-y-4">
          <div
            v-for="post in recentPosts"
            :key="post.id"
            class="flex items-center justify-between py-3 border-b border-gray-100 last:border-0"
          >
            <div class="flex-1">
              <h3 class="text-sm font-medium text-gray-900">
                {{ post.title }}
              </h3>
              <p class="text-xs text-gray-500 mt-1">
                {{ formatDate(post.created_at) }}
              </p>
            </div>
            <span
              :class="[
                'px-2 py-1 text-xs rounded-full',
                post.status === 'published'
                  ? 'bg-green-100 text-green-800'
                  : 'bg-gray-100 text-gray-800',
              ]"
            >
              {{ post.status === "published" ? "已發布" : "草稿" }}
            </span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { supabase } from "../lib/supabase";

const stats = ref({
  totalPosts: 0,
  totalCategories: 0,
  totalComments: 0,
  monthlyViews: 0,
});

const recentPosts = ref([]);

const loadStats = async () => {
  try {
    // 獲取文章總數
    const { count: postCount } = await supabase
      .from("posts")
      .select("*", { count: "exact", head: true });
    stats.value.totalPosts = postCount || 0;

    // 獲取分類總數
    const { count: categoryCount } = await supabase
      .from("categories")
      .select("*", { count: "exact", head: true });
    stats.value.totalCategories = categoryCount || 0;

    // 獲取留言總數
    const { count: commentCount } = await supabase
      .from("comments")
      .select("*", { count: "exact", head: true });
    stats.value.totalComments = commentCount || 0;

    // 獲取最新文章
    const { data: posts } = await supabase
      .from("posts")
      .select("id, title, status, created_at")
      .order("created_at", { ascending: false })
      .limit(5);

    recentPosts.value = posts || [];
  } catch (error) {
    console.error("載入統計資料失敗:", error);
  }
};

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString("zh-TW", {
    year: "numeric",
    month: "long",
    day: "numeric",
  });
};

onMounted(() => {
  loadStats();
});
</script>
