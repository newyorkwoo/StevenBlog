<template>
  <div class="max-w-4xl mx-auto py-8 px-4 sm:px-6 lg:px-8">
    <div class="card-minimal">
      <div class="mb-8">
        <h1 class="text-3xl font-serif font-bold text-secondary-800">
          個人資料
        </h1>
        <p class="mt-2 text-sm text-secondary-600">管理您的帳號資訊和設定</p>
      </div>

      <div class="space-y-6">
        <!-- Email（不可編輯） -->
        <div>
          <label class="block text-sm font-medium text-secondary-700 mb-2">
            Email
          </label>
          <input
            type="email"
            disabled
            :value="authStore.user?.email"
            class="input-minimal bg-gray-50 cursor-not-allowed"
          />
          <p class="mt-1 text-xs text-secondary-500">Email 無法更改</p>
        </div>

        <!-- 顯示名稱 -->
        <div>
          <label
            for="displayName"
            class="block text-sm font-medium text-secondary-700 mb-2"
          >
            顯示名稱
          </label>
          <input
            id="displayName"
            v-model="formData.displayName"
            type="text"
            class="input-minimal"
            placeholder="您的顯示名稱"
          />
        </div>

        <!-- 註冊時間 -->
        <div>
          <label class="block text-sm font-medium text-secondary-700 mb-2">
            註冊時間
          </label>
          <input
            type="text"
            disabled
            :value="formatDate(authStore.user?.created_at)"
            class="input-minimal bg-gray-50 cursor-not-allowed"
          />
        </div>

        <!-- 成功訊息 -->
        <div v-if="successMessage" class="rounded-md bg-green-50 p-4">
          <p class="text-sm text-green-800">{{ successMessage }}</p>
        </div>

        <!-- 錯誤訊息 -->
        <div v-if="errorMessage" class="rounded-md bg-red-50 p-4">
          <p class="text-sm text-red-800">{{ errorMessage }}</p>
        </div>

        <!-- 按鈕 -->
        <div class="flex space-x-4">
          <button
            @click="handleUpdateProfile"
            :disabled="loading"
            class="btn-primary disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {{ loading ? "儲存中..." : "儲存變更" }}
          </button>

          <button
            @click="handleLogout"
            class="px-4 py-2 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50 transition-colors"
          >
            登出
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import { useAuthStore } from "@/stores/auth";

const router = useRouter();
const authStore = useAuthStore();

const formData = reactive({
  displayName: "",
});

const loading = ref(false);
const successMessage = ref("");
const errorMessage = ref("");

onMounted(() => {
  if (!authStore.isAuthenticated) {
    router.push("/login");
    return;
  }

  formData.displayName = authStore.user?.user_metadata?.display_name || "";
});

const handleUpdateProfile = async () => {
  loading.value = true;
  successMessage.value = "";
  errorMessage.value = "";

  const result = await authStore.updateProfile(formData.displayName);

  if (result.success) {
    successMessage.value = "個人資料已更新！";
    setTimeout(() => {
      successMessage.value = "";
    }, 3000);
  } else {
    errorMessage.value = result.error || "更新失敗，請稍後再試";
  }

  loading.value = false;
};

const handleLogout = async () => {
  await authStore.signOut();
  router.push("/");
};

const formatDate = (dateString) => {
  if (!dateString) return "";
  const date = new Date(dateString);
  return new Intl.DateTimeFormat("zh-TW", {
    year: "numeric",
    month: "long",
    day: "numeric",
  }).format(date);
};
</script>
