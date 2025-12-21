<template>
  <div>
    <div class="mb-6">
      <h1 class="text-3xl font-normal text-sand-900 tracking-wide">
        {{ isEditMode ? "編輯文章" : "新增文章" }}
      </h1>
    </div>

    <form @submit.prevent="handleSubmit" class="space-y-6">
      <!-- 標題 -->
      <div
        class="bg-white rounded-lg p-6"
        style="box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.05)"
      >
        <label for="title" class="block text-sm font-medium text-gray-700 mb-2">
          文章標題 *
        </label>
        <input
          id="title"
          v-model="form.title"
          type="text"
          required
          class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
          placeholder="輸入文章標題"
        />
      </div>

      <!-- 摘要 -->
      <div class="bg-white shadow rounded-lg p-6">
        <label
          for="excerpt"
          class="block text-sm font-medium text-gray-700 mb-2"
        >
          文章摘要
        </label>
        <textarea
          id="excerpt"
          v-model="form.excerpt"
          rows="3"
          class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
          placeholder="輸入文章摘要（選填）"
        ></textarea>
      </div>

      <!-- 內容 -->
      <div class="bg-white shadow rounded-lg p-6">
        <label
          for="content"
          class="block text-sm font-medium text-gray-700 mb-2"
        >
          文章內容 * (支援 Markdown)
        </label>
        <textarea
          id="content"
          v-model="form.content"
          rows="20"
          required
          class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 font-mono text-sm"
          placeholder="使用 Markdown 語法撰寫文章內容..."
        ></textarea>
        <p class="mt-2 text-sm text-gray-500">
          支援 Markdown 語法，如：**粗體**、*斜體*、[連結](URL)、# 標題等
        </p>
      </div>

      <!-- 分類和狀態 -->
      <div class="bg-white shadow rounded-lg p-6">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <label
              for="category"
              class="block text-sm font-medium text-gray-700 mb-2"
            >
              分類 *
            </label>
            <select
              id="category"
              v-model="form.category_id"
              required
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
            >
              <option value="">請選擇分類</option>
              <option
                v-for="category in categories"
                :key="category.id"
                :value="category.id"
              >
                {{ category.name }}
              </option>
            </select>
          </div>

          <div>
            <label
              for="status"
              class="block text-sm font-medium text-gray-700 mb-2"
            >
              狀態 *
            </label>
            <select
              id="status"
              v-model="form.status"
              required
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
            >
              <option value="draft">草稿</option>
              <option value="published">發布</option>
            </select>
          </div>
        </div>
      </div>

      <!-- 封面圖片 -->
      <div
        class="bg-white rounded-lg p-6"
        style="box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.05)"
      >
        <label class="block text-sm font-medium text-gray-700 mb-2">
          封面圖片
        </label>
        <div class="mt-1 flex items-center space-x-4">
          <input
            type="file"
            accept="image/*"
            @change="handleImageUpload"
            :disabled="uploading"
            class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:text-sm file:font-normal file:bg-sand-50 file:text-sand-700 hover:file:bg-sand-100 file:transition-colors file:duration-200 disabled:opacity-50 disabled:cursor-not-allowed"
          />
        </div>

        <!-- 上傳狀態 -->
        <div
          v-if="uploading"
          class="mt-4 flex items-center text-sm text-sand-700"
        >
          <svg
            class="animate-spin h-4 w-4 mr-2"
            fill="none"
            viewBox="0 0 24 24"
          >
            <circle
              class="opacity-25"
              cx="12"
              cy="12"
              r="10"
              stroke="currentColor"
              stroke-width="4"
            ></circle>
            <path
              class="opacity-75"
              fill="currentColor"
              d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
            ></path>
          </svg>
          上傳中，請稍候...
        </div>

        <!-- 圖片預覽 -->
        <div v-if="form.cover_image && !uploading" class="mt-4">
          <p class="text-sm text-gray-600 mb-2">預覽：</p>
          <div class="relative inline-block">
            <img
              :src="form.cover_image"
              alt="封面圖片預覽"
              class="max-h-48 w-auto rounded-lg border border-sand-200"
            />
            <button
              type="button"
              @click="form.cover_image = ''"
              class="absolute top-2 right-2 bg-red-500 text-white rounded-full p-1 hover:bg-red-600 transition-colors duration-200"
              title="移除圖片"
            >
              <svg
                class="h-4 w-4"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M6 18L18 6M6 6l12 12"
                />
              </svg>
            </button>
          </div>
        </div>

        <!-- 提示訊息 -->
        <p class="mt-2 text-xs text-gray-500">
          支援 JPG、PNG、GIF 格式，檔案大小不超過 5MB
        </p>
      </div>

      <!-- 文章圖片集 (最多10張) -->
      <div
        class="bg-white rounded-lg p-6"
        style="box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.05)"
      >
        <div class="flex items-center justify-between mb-4">
          <label class="block text-sm font-medium text-gray-700">
            文章圖片集 ({{ form.images.length }}/10)
          </label>
          <button
            v-if="form.images.length < 10"
            type="button"
            @click="triggerMultipleImageUpload"
            :disabled="uploadingImages"
            class="px-3 py-1.5 text-sm bg-blue-50 text-blue-700 rounded-md hover:bg-blue-100 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <span v-if="!uploadingImages">+ 添加圖片</span>
            <span v-else>上傳中...</span>
          </button>
        </div>

        <input
          ref="multipleImageInput"
          type="file"
          accept="image/*"
          multiple
          @change="handleMultipleImagesUpload"
          class="hidden"
        />

        <!-- Masonry Layout 圖片展示 -->
        <div v-if="form.images.length > 0" class="masonry-grid">
          <div
            v-for="(image, index) in form.images"
            :key="index"
            class="masonry-item group relative"
          >
            <img
              :src="image.url"
              :alt="`圖片 ${index + 1}`"
              class="w-full rounded-lg border border-gray-200 hover:border-blue-400 transition-colors"
              loading="lazy"
            />
            <!-- 圖片操作按鈕 -->
            <div
              class="absolute top-2 right-2 flex space-x-1 opacity-0 group-hover:opacity-100 transition-opacity"
            >
              <button
                type="button"
                @click="moveImageUp(index)"
                v-if="index > 0"
                class="bg-white text-gray-700 rounded-full p-1.5 shadow-md hover:bg-gray-100 transition-colors"
                title="上移"
              >
                <svg
                  class="h-4 w-4"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M5 15l7-7 7 7"
                  />
                </svg>
              </button>
              <button
                type="button"
                @click="moveImageDown(index)"
                v-if="index < form.images.length - 1"
                class="bg-white text-gray-700 rounded-full p-1.5 shadow-md hover:bg-gray-100 transition-colors"
                title="下移"
              >
                <svg
                  class="h-4 w-4"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M19 9l-7 7-7-7"
                  />
                </svg>
              </button>
              <button
                type="button"
                @click="removeImage(index)"
                class="bg-red-500 text-white rounded-full p-1.5 shadow-md hover:bg-red-600 transition-colors"
                title="刪除"
              >
                <svg
                  class="h-4 w-4"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M6 18L18 6M6 6l12 12"
                  />
                </svg>
              </button>
            </div>
            <!-- 圖片序號 -->
            <div
              class="absolute bottom-2 left-2 bg-black bg-opacity-60 text-white text-xs px-2 py-1 rounded"
            >
              {{ index + 1 }}
            </div>
          </div>
        </div>

        <!-- 空狀態 -->
        <div
          v-else
          class="text-center py-12 border-2 border-dashed border-gray-300 rounded-lg"
        >
          <svg
            class="mx-auto h-12 w-12 text-gray-400"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"
            />
          </svg>
          <p class="mt-2 text-sm text-gray-500">尚未添加圖片</p>
          <p class="text-xs text-gray-400 mt-1">點擊上方「添加圖片」按鈕上傳</p>
        </div>

        <!-- 提示訊息 -->
        <p class="mt-4 text-xs text-gray-500">
          • 最多可上傳 10 張圖片<br />
          • 支援 JPG、PNG、GIF 格式<br />
          • 每張圖片大小不超過 5MB<br />
          • 使用 Masonry 瀑布流布局展示
        </p>
      </div>

      <!-- Tags 暫時隱藏，待實作 post_tags 關聯表功能 -->
      <!-- <div class="bg-white shadow rounded-lg p-6">
        <label for="tags" class="block text-sm font-medium text-gray-700 mb-2">
          標籤
        </label>
        <input
          id="tags"
          v-model="tagsInput"
          type="text"
          class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
          placeholder="輸入標籤，用逗號分隔（例如：JavaScript, Vue.js, 教學）"
        />
      </div> -->

      <!-- 按鈕 -->
      <div class="flex justify-end space-x-4">
        <router-link
          to="/posts"
          class="px-4 py-2 border border-sand-300 rounded-md text-sm font-normal text-gray-700 hover:bg-sand-50 transition-colors duration-200"
        >
          取消
        </router-link>
        <button
          type="submit"
          :disabled="saving"
          class="px-4 py-2 border border-transparent rounded-md text-sm font-normal text-white bg-sand-600 hover:bg-sand-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors duration-200"
        >
          {{ saving ? "儲存中..." : isEditMode ? "更新文章" : "發布文章" }}
        </button>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { useRouter, useRoute } from "vue-router";
import { supabase } from "../lib/supabase";

const router = useRouter();
const route = useRoute();

const form = ref({
  title: "",
  excerpt: "",
  content: "",
  category_id: "",
  status: "draft",
  cover_image: "",
  images: [], // 新增：圖片集
  slug: "",
  published_at: null,
});

const tagsInput = ref("");
const categories = ref([]);
const saving = ref(false);
const uploading = ref(false);
const uploadingImages = ref(false); // 新增：多圖上傳狀態
const multipleImageInput = ref(null); // 新增：多圖上傳 input ref

const isEditMode = computed(() => !!route.params.id);

const loadPost = async () => {
  if (!isEditMode.value) return;

  try {
    const { data, error } = await supabase
      .from("posts")
      .select("*")
      .eq("id", route.params.id)
      .single();

    if (error) throw error;

    form.value = {
      title: data.title,
      excerpt: data.excerpt || "",
      content: data.content,
      category_id: data.category_id,
      status: data.status,
      cover_image: data.cover_image || "",
      images: data.images || [], // 新增：載入圖片集
      slug: data.slug,
      published_at: data.published_at,
    };

    tagsInput.value = data.tags ? data.tags.join(", ") : "";
  } catch (error) {
    console.error("載入文章失敗:", error);
    alert("載入文章失敗");
    router.push("/posts");
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

const generateSlug = (title) => {
  // 如果標題包含中文，使用時間戳 + 部分標題
  if (/[\u4e00-\u9fa5]/.test(title)) {
    const timestamp = Date.now();
    const safePart = title
      .substring(0, 10)
      .replace(/[^\u4e00-\u9fa5a-zA-Z0-9]/g, "-");
    return `post-${timestamp}-${safePart}`.toLowerCase();
  }

  // 英文標題的處理
  return title
    .toLowerCase()
    .replace(/[^\w\s-]/g, "")
    .replace(/\s+/g, "-")
    .replace(/-+/g, "-")
    .trim();
};

const handleImageUpload = async (event) => {
  const file = event.target.files[0];
  if (!file) return;

  // 檢查檔案類型
  if (!file.type.startsWith("image/")) {
    alert("請選擇圖片檔案");
    return;
  }

  // 檢查檔案大小（限制 5MB）
  if (file.size > 5 * 1024 * 1024) {
    alert("圖片大小不能超過 5MB");
    return;
  }

  uploading.value = true;
  try {
    const fileExt = file.name.split(".").pop();
    const fileName = `${Date.now()}.${fileExt}`;
    const filePath = `${fileName}`;

    console.log("開始上傳圖片:", filePath);

    const { error: uploadError } = await supabase.storage
      .from("post-images")
      .upload(filePath, file, {
        cacheControl: "3600",
        upsert: false,
      });

    if (uploadError) {
      console.error("上傳錯誤:", uploadError);
      throw uploadError;
    }

    const { data } = supabase.storage
      .from("post-images")
      .getPublicUrl(filePath);

    form.value.cover_image = data.publicUrl;
    console.log("圖片上傳成功:", data.publicUrl);
  } catch (error) {
    console.error("上傳圖片失敗:", error);

    // 提供更詳細的錯誤訊息
    let errorMessage = "上傳圖片失敗";
    if (error.message) {
      errorMessage += `: ${error.message}`;
    }

    // 檢查是否為權限問題
    if (error.message && error.message.includes("row-level security")) {
      errorMessage = "權限錯誤：請確認 Supabase Storage 的 bucket 權限設置正確";
    } else if (error.message && error.message.includes("not found")) {
      errorMessage =
        "Storage bucket 'post-images' 不存在，請先在 Supabase 建立此 bucket";
    }

    alert(errorMessage);
  } finally {
    uploading.value = false;
  }
};

// 新增：觸發多圖上傳
const triggerMultipleImageUpload = () => {
  if (multipleImageInput.value) {
    multipleImageInput.value.click();
  }
};

// 新增：處理多圖上傳
const handleMultipleImagesUpload = async (event) => {
  const files = Array.from(event.target.files);

  if (!files || files.length === 0) return;

  // 檢查上傳數量
  const remainingSlots = 10 - form.value.images.length;
  if (files.length > remainingSlots) {
    alert(`最多只能上傳 ${remainingSlots} 張圖片`);
    return;
  }

  uploadingImages.value = true;

  try {
    const uploadPromises = files.map(async (file) => {
      // 驗證檔案類型
      if (!file.type.startsWith("image/")) {
        throw new Error(`${file.name} 不是有效的圖片格式`);
      }

      // 驗證檔案大小 (5MB)
      const maxSize = 5 * 1024 * 1024;
      if (file.size > maxSize) {
        throw new Error(`${file.name} 超過 5MB 大小限制`);
      }

      // 生成唯一檔名
      const fileExt = file.name.split(".").pop();
      const fileName = `${Date.now()}-${Math.random()
        .toString(36)
        .substring(7)}.${fileExt}`;
      const filePath = `posts/${fileName}`;

      // 上傳到 Supabase Storage
      const { error: uploadError } = await supabase.storage
        .from("post-images")
        .upload(filePath, file, {
          cacheControl: "3600",
          upsert: false,
        });

      if (uploadError) throw uploadError;

      // 取得公開 URL
      const { data } = supabase.storage
        .from("post-images")
        .getPublicUrl(filePath);

      return {
        url: data.publicUrl,
        path: filePath,
        name: file.name,
      };
    });

    const uploadedImages = await Promise.all(uploadPromises);
    form.value.images.push(...uploadedImages);

    console.log("批次上傳成功:", uploadedImages.length, "張圖片");
  } catch (error) {
    console.error("上傳圖片失敗:", error);
    alert(error.message || "上傳圖片失敗，請重試");
  } finally {
    uploadingImages.value = false;
    // 重置 input
    if (event.target) {
      event.target.value = "";
    }
  }
};

// 新增：移除圖片
const removeImage = (index) => {
  if (confirm("確定要刪除這張圖片嗎？")) {
    form.value.images.splice(index, 1);
  }
};

// 新增：上移圖片
const moveImageUp = (index) => {
  if (index > 0) {
    const temp = form.value.images[index];
    form.value.images[index] = form.value.images[index - 1];
    form.value.images[index - 1] = temp;
  }
};

// 新增：下移圖片
const moveImageDown = (index) => {
  if (index < form.value.images.length - 1) {
    const temp = form.value.images[index];
    form.value.images[index] = form.value.images[index + 1];
    form.value.images[index + 1] = temp;
  }
};

const handleSubmit = async () => {
  saving.value = true;

  try {
    // 準備文章資料（不包含 tags）
    const postData = {
      title: form.value.title,
      excerpt: form.value.excerpt,
      content: form.value.content,
      category_id: form.value.category_id,
      status: form.value.status,
      cover_image: form.value.cover_image,
      images: form.value.images, // 新增：儲存圖片集
      slug: form.value.slug || generateSlug(form.value.title),
    };

    if (isEditMode.value) {
      // 更新現有文章 - 如果沒有 published_at，則設定為當前時間
      const updateData = {
        ...postData,
        published_at: form.value.published_at || new Date().toISOString(),
      };

      const { error } = await supabase
        .from("posts")
        .update(updateData)
        .eq("id", route.params.id);

      if (error) throw error;
      alert("文章更新成功");
    } else {
      // 新增文章 - 設定發布時間
      const newPostData = {
        ...postData,
        published_at: new Date().toISOString(),
      };

      const { error } = await supabase.from("posts").insert([newPostData]);

      if (error) throw error;
      alert("文章新增成功");
    }

    router.push("/posts");
  } catch (error) {
    console.error("儲存文章失敗:", error);
    alert("儲存文章失敗: " + error.message);
  } finally {
    saving.value = false;
  }
};

onMounted(() => {
  loadCategories();
  loadPost();
});
</script>
<style scoped>
/* Masonry 瀑布流布局 */
.masonry-grid {
  column-count: 3;
  column-gap: 1rem;
  margin-top: 1rem;
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
  position: relative;
}

.masonry-item img {
  display: block;
  width: 100%;
  height: auto;
}
</style>
