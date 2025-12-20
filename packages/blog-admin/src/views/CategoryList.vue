<template>
  <div>
    <div class="flex justify-between items-center mb-6">
      <h1 class="text-3xl font-normal text-sand-900 tracking-wide">分類管理</h1>
      <button
        @click="showAddModal = true"
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
        新增分類
      </button>
    </div>

    <!-- 分類列表 -->
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
              名稱
            </th>
            <th
              class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
            >
              Slug
            </th>
            <th
              class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
            >
              描述
            </th>
            <th
              class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
            >
              文章數
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
          <tr v-else-if="categories.length === 0">
            <td colspan="5" class="px-6 py-4 text-center text-gray-500">
              暫無分類
            </td>
          </tr>
          <tr
            v-else
            v-for="category in categories"
            :key="category.id"
            class="hover:bg-gray-50"
          >
            <td class="px-6 py-4 whitespace-nowrap">
              <div class="text-sm font-medium text-gray-900">
                {{ category.name }}
              </div>
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
              <div class="text-sm text-gray-500">{{ category.slug }}</div>
            </td>
            <td class="px-6 py-4">
              <div class="text-sm text-gray-500">
                {{ category.description || "-" }}
              </div>
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
              <div class="text-sm text-gray-900">
                {{ category.post_count || 0 }}
              </div>
            </td>
            <td
              class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium"
            >
              <button
                @click="editCategory(category)"
                class="text-sand-700 hover:text-sand-900 mr-4"
              >
                編輯
              </button>
              <button
                @click="deleteCategory(category.id)"
                class="text-red-600 hover:text-red-900"
              >
                刪除
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- 新增/編輯模態框 -->
    <div
      v-if="showAddModal || showEditModal"
      class="fixed z-10 inset-0 overflow-y-auto"
    >
      <div class="flex items-center justify-center min-h-screen px-4">
        <div
          class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"
          @click="closeModal"
        ></div>

        <div
          class="bg-white rounded-lg overflow-hidden shadow-xl transform transition-all max-w-lg w-full"
        >
          <form @submit.prevent="handleSubmit">
            <div class="p-6">
              <h3 class="text-lg font-medium text-gray-900 mb-4">
                {{ showEditModal ? "編輯分類" : "新增分類" }}
              </h3>

              <div class="space-y-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1"
                    >名稱 *</label
                  >
                  <input
                    v-model="form.name"
                    type="text"
                    required
                    class="w-full px-3 py-2 border border-sand-200 rounded-md focus:outline-none focus:ring-2 focus:ring-sand-400 focus:border-transparent transition-all duration-200"
                  />
                </div>

                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1"
                    >Slug</label
                  >
                  <input
                    v-model="form.slug"
                    type="text"
                    class="w-full px-3 py-2 border border-sand-200 rounded-md focus:outline-none focus:ring-2 focus:ring-sand-400 focus:border-transparent transition-all duration-200"
                    placeholder="自動生成（可自訂）"
                  />
                </div>

                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1"
                    >描述</label
                  >
                  <textarea
                    v-model="form.description"
                    rows="3"
                    class="w-full px-3 py-2 border border-sand-200 rounded-md focus:outline-none focus:ring-2 focus:ring-sand-400 focus:border-transparent transition-all duration-200"
                  ></textarea>
                </div>
              </div>
            </div>

            <div class="bg-gray-50 px-6 py-4 flex justify-end space-x-3">
              <button
                type="button"
                @click="closeModal"
                class="px-4 py-2 border border-sand-300 rounded-md text-sm font-normal text-gray-700 hover:bg-sand-50 transition-colors duration-200"
              >
                取消
              </button>
              <button
                type="submit"
                class="px-4 py-2 border border-transparent rounded-md text-sm font-normal text-white bg-sand-600 hover:bg-sand-700 transition-colors duration-200"
              >
                {{ showEditModal ? "更新" : "新增" }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { supabase } from "../lib/supabase";

const categories = ref([]);
const loading = ref(false);
const showAddModal = ref(false);
const showEditModal = ref(false);
const editingId = ref(null);

const form = ref({
  name: "",
  slug: "",
  description: "",
});

const loadCategories = async () => {
  loading.value = true;
  try {
    const { data, error } = await supabase
      .from("categories")
      .select("*, post_count:posts(count)")
      .order("name");

    if (error) throw error;

    categories.value = data.map((cat) => ({
      ...cat,
      post_count: cat.post_count?.[0]?.count || 0,
    }));
  } catch (error) {
    console.error("載入分類失敗:", error);
  } finally {
    loading.value = false;
  }
};

const generateSlug = (name) => {
  return name
    .toLowerCase()
    .replace(/[^\w\s-]/g, "")
    .replace(/\s+/g, "-");
};

const handleSubmit = async () => {
  try {
    const slug = form.value.slug || generateSlug(form.value.name);
    const categoryData = {
      name: form.value.name,
      slug,
      description: form.value.description,
    };

    if (showEditModal.value) {
      const { error } = await supabase
        .from("categories")
        .update(categoryData)
        .eq("id", editingId.value);

      if (error) throw error;
    } else {
      const { error } = await supabase
        .from("categories")
        .insert([categoryData]);

      if (error) throw error;
    }

    closeModal();
    await loadCategories();
  } catch (error) {
    console.error("儲存分類失敗:", error);
    alert("儲存分類失敗: " + error.message);
  }
};

const editCategory = (category) => {
  form.value = {
    name: category.name,
    slug: category.slug,
    description: category.description || "",
  };
  editingId.value = category.id;
  showEditModal.value = true;
};

const deleteCategory = async (id) => {
  if (!confirm("確定要刪除此分類嗎？")) return;

  try {
    const { error } = await supabase.from("categories").delete().eq("id", id);

    if (error) throw error;
    await loadCategories();
  } catch (error) {
    console.error("刪除分類失敗:", error);
    alert("刪除分類失敗，可能有文章關聯此分類");
  }
};

const closeModal = () => {
  showAddModal.value = false;
  showEditModal.value = false;
  editingId.value = null;
  form.value = {
    name: "",
    slug: "",
    description: "",
  };
};

onMounted(() => {
  loadCategories();
});
</script>
