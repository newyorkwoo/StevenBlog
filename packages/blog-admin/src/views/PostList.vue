<template>
  <div>
    <div class="flex justify-between items-center mb-6">
      <h1 class="text-3xl font-normal text-sand-900 tracking-wide">文章管理</h1>
      <router-link
        to="/posts/new"
        class="inline-flex items-center px-4 py-2 border border-transparent rounded-md text-sm font-normal text-white bg-sand-600 hover:bg-sand-700 transition-colors duration-200"
      >
        <svg
          class="h-5 w-5 mr-2"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M12 4v16m8-8H4"
          />
        </svg>
        新增文章
      </router-link>
    </div>

    <!-- 搜尋和篩選 -->
    <div
      class="bg-white rounded-lg p-4 mb-6"
      style="box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.05)"
    >
      <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <input
          v-model="searchQuery"
          type="text"
          placeholder="搜尋文章標題..."
          class="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
          @input="handleSearch"
        />
        <select
          v-model="filterStatus"
          class="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
          @change="loadPosts"
        >
          <option value="">所有狀態</option>
          <option value="published">已發布</option>
          <option value="draft">草稿</option>
        </select>
        <select
          v-model="filterCategory"
          class="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
          @change="loadPosts"
        >
          <option value="">所有分類</option>
          <option
            v-for="category in categories"
            :key="category.id"
            :value="category.id"
          >
            {{ category.name }}
          </option>
        </select>
      </div>
    </div>

    <!-- 文章列表 -->
    <div
      class="bg-white rounded-lg overflow-hidden"
      style="box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.05)"
    >
      <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-gray-50">
          <tr>
            <th
              class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
            >
              標題
            </th>
            <th
              class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
            >
              分類
            </th>
            <th
              class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
            >
              狀態
            </th>
            <th
              class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
            >
              發布日期
            </th>
            <th
              class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider"
            >
              操作
            </th>
          </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
          <tr v-if="loading">
            <td colspan="5" class="px-6 py-4 text-center text-gray-500">
              載入中...
            </td>
          </tr>
          <tr v-else-if="posts.length === 0">
            <td colspan="5" class="px-6 py-4 text-center text-gray-500">
              暫無文章
            </td>
          </tr>
          <tr
            v-else
            v-for="post in posts"
            :key="post.id"
            class="hover:bg-gray-50"
          >
            <td class="px-6 py-4">
              <div class="text-sm font-medium text-gray-900">
                {{ post.title }}
              </div>
              <div class="text-sm text-gray-500">
                {{ truncate(post.excerpt, 60) }}
              </div>
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
              <span class="text-sm text-gray-900">{{
                post.category?.name || "-"
              }}</span>
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
              <span
                :class="[
                  'px-2 inline-flex text-xs leading-5 font-semibold rounded-full',
                  post.status === 'published'
                    ? 'bg-green-100 text-green-800'
                    : 'bg-gray-100 text-gray-800',
                ]"
              >
                {{ post.status === "published" ? "已發布" : "草稿" }}
              </span>
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
              {{ formatDate(post.created_at) }}
            </td>
            <td
              class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium"
            >
              <router-link
                :to="`/posts/${post.id}/edit`"
                class="text-sand-700 hover:text-sand-900 mr-4"
              >
                編輯
              </router-link>
              <button
                @click="deletePost(post.id)"
                class="text-red-600 hover:text-red-900"
              >
                刪除
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { supabase } from "../lib/supabase";

const posts = ref([]);
const categories = ref([]);
const loading = ref(false);
const searchQuery = ref("");
const filterStatus = ref("");
const filterCategory = ref("");

const loadPosts = async () => {
  loading.value = true;
  try {
    let query = supabase
      .from("posts")
      .select(
        `
        *,
        category:categories(id, name)
      `
      )
      .order("created_at", { ascending: false });

    if (filterStatus.value) {
      query = query.eq("status", filterStatus.value);
    }

    if (filterCategory.value) {
      query = query.eq("category_id", filterCategory.value);
    }

    if (searchQuery.value) {
      query = query.ilike("title", `%${searchQuery.value}%`);
    }

    const { data, error } = await query;

    if (error) throw error;
    posts.value = data || [];
  } catch (error) {
    console.error("載入文章失敗:", error);
    alert("載入文章失敗");
  } finally {
    loading.value = false;
  }
};

const loadCategories = async () => {
  try {
    const { data, error } = await supabase
      .from("categories")
      .select("*")
      .order("name");

    if (error) throw error;
    categories.value = data || [];
  } catch (error) {
    console.error("載入分類失敗:", error);
  }
};

const deletePost = async (id) => {
  if (!confirm("確定要刪除這篇文章嗎？此操作無法復原。")) return;

  try {
    const { error } = await supabase.from("posts").delete().eq("id", id);

    if (error) throw error;

    await loadPosts();
  } catch (error) {
    console.error("刪除文章失敗:", error);
    alert("刪除文章失敗");
  }
};

const handleSearch = () => {
  loadPosts();
};

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString("zh-TW");
};

const truncate = (text, length) => {
  if (!text) return "";
  return text.length > length ? text.substring(0, length) + "..." : text;
};

onMounted(() => {
  loadPosts();
  loadCategories();
});
</script>
