<template>
  <div>
    <h1 class="text-3xl font-normal text-sand-900 mb-6 tracking-wide">
      留言管理
    </h1>

    <!-- 篩選 -->
    <div class="bg-white shadow rounded-lg p-4 mb-6">
      <select
        v-model="filterStatus"
        class="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
        @change="loadComments"
      >
        <option value="">所有狀態</option>
        <option value="approved">已審核</option>
        <option value="pending">待審核</option>
      </select>
    </div>

    <!-- 留言列表 -->
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
              作者
            </th>
            <th
              class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
            >
              內容
            </th>
            <th
              class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
            >
              文章
            </th>
            <th
              class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
            >
              日期
            </th>
            <th
              class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
            >
              狀態
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
            <td colspan="6" class="px-6 py-4 text-center text-gray-500">
              載入中...
            </td>
          </tr>
          <tr v-else-if="comments.length === 0">
            <td colspan="6" class="px-6 py-4 text-center text-gray-500">
              暫無留言
            </td>
          </tr>
          <tr
            v-else
            v-for="comment in comments"
            :key="comment.id"
            class="hover:bg-gray-50"
          >
            <td class="px-6 py-4 whitespace-nowrap">
              <div class="text-sm font-medium text-gray-900">
                {{ comment.author_name }}
              </div>
              <div class="text-sm text-gray-500">
                {{ comment.author_email }}
              </div>
            </td>
            <td class="px-6 py-4">
              <div class="text-sm text-gray-900">
                {{ truncate(comment.content, 100) }}
              </div>
            </td>
            <td class="px-6 py-4">
              <div class="text-sm text-gray-500">
                {{ comment.post?.title || "-" }}
              </div>
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
              {{ formatDate(comment.created_at) }}
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
              <span
                :class="[
                  'px-2 inline-flex text-xs leading-5 font-semibold rounded-full',
                  comment.status === 'approved'
                    ? 'bg-green-100 text-green-800'
                    : 'bg-yellow-100 text-yellow-800',
                ]"
              >
                {{ comment.status === "approved" ? "已審核" : "待審核" }}
              </span>
            </td>
            <td
              class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium"
            >
              <button
                v-if="comment.status === 'pending'"
                @click="approveComment(comment.id)"
                class="text-green-600 hover:text-green-900 mr-4"
              >
                審核
              </button>
              <button
                @click="deleteComment(comment.id)"
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

const comments = ref([]);
const loading = ref(false);
const filterStatus = ref("");

const loadComments = async () => {
  loading.value = true;
  try {
    let query = supabase
      .from("comments")
      .select(
        `
        *,
        post:posts(id, title)
      `
      )
      .order("created_at", { ascending: false });

    if (filterStatus.value) {
      query = query.eq("status", filterStatus.value);
    }

    const { data, error } = await query;

    if (error) throw error;
    comments.value = data || [];
  } catch (error) {
    console.error("載入留言失敗:", error);
  } finally {
    loading.value = false;
  }
};

const approveComment = async (id) => {
  try {
    const { error } = await supabase
      .from("comments")
      .update({ status: "approved" })
      .eq("id", id);

    if (error) throw error;
    await loadComments();
  } catch (error) {
    console.error("審核留言失敗:", error);
    alert("審核留言失敗");
  }
};

const deleteComment = async (id) => {
  if (!confirm("確定要刪除此留言嗎？")) return;

  try {
    const { error } = await supabase.from("comments").delete().eq("id", id);

    if (error) throw error;
    await loadComments();
  } catch (error) {
    console.error("刪除留言失敗:", error);
    alert("刪除留言失敗");
  }
};

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString("zh-TW", {
    year: "numeric",
    month: "long",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
};

const truncate = (text, length) => {
  return text.length > length ? text.substring(0, length) + "..." : text;
};

onMounted(() => {
  loadComments();
});
</script>
