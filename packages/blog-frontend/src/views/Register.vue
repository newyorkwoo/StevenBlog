<template>
  <div
    class="min-h-screen flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8"
  >
    <div class="max-w-md w-full space-y-8">
      <div>
        <h2
          class="mt-6 text-center text-3xl font-serif font-bold text-secondary-800"
        >
          註冊新帳號
        </h2>
        <p class="mt-2 text-center text-sm text-secondary-600">
          已有帳號？
          <RouterLink
            to="/login"
            class="font-medium text-primary-600 hover:text-primary-500"
          >
            立即登入
          </RouterLink>
        </p>
      </div>

      <form class="mt-8 space-y-6" @submit.prevent="handleRegister">
        <div class="rounded-md shadow-sm space-y-4">
          <div>
            <label for="displayName" class="sr-only">顯示名稱</label>
            <input
              id="displayName"
              v-model="formData.displayName"
              type="text"
              required
              class="appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-primary-500 focus:border-primary-500 focus:z-10 sm:text-sm"
              placeholder="顯示名稱"
            />
          </div>
          <div>
            <label for="email" class="sr-only">Email</label>
            <input
              id="email"
              v-model="formData.email"
              type="email"
              required
              class="appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-primary-500 focus:border-primary-500 focus:z-10 sm:text-sm"
              placeholder="Email 地址"
            />
          </div>
          <div>
            <label for="password" class="sr-only">密碼</label>
            <input
              id="password"
              v-model="formData.password"
              type="password"
              required
              minlength="6"
              class="appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-primary-500 focus:border-primary-500 focus:z-10 sm:text-sm"
              placeholder="密碼（至少 6 個字元）"
            />
          </div>
          <div>
            <label for="confirmPassword" class="sr-only">確認密碼</label>
            <input
              id="confirmPassword"
              v-model="formData.confirmPassword"
              type="password"
              required
              class="appearance-none rounded-md relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-primary-500 focus:border-primary-500 focus:z-10 sm:text-sm"
              placeholder="確認密碼"
            />
          </div>
        </div>

        <div v-if="errorMessage" class="rounded-md bg-red-50 p-4">
          <div class="flex">
            <div class="ml-3">
              <h3 class="text-sm font-medium text-red-800">
                {{ errorMessage }}
              </h3>
            </div>
          </div>
        </div>

        <div v-if="successMessage" class="rounded-md bg-green-50 p-4">
          <div class="flex">
            <div class="ml-3">
              <h3 class="text-sm font-medium text-green-800">
                {{ successMessage }}
              </h3>
            </div>
          </div>
        </div>

        <div>
          <button
            type="submit"
            :disabled="loading"
            class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {{ loading ? "註冊中..." : "註冊" }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref } from "vue";
import { useRouter, RouterLink } from "vue-router";
import { useAuthStore } from "@/stores/auth";

const router = useRouter();
const authStore = useAuthStore();

const formData = reactive({
  displayName: "",
  email: "",
  password: "",
  confirmPassword: "",
});

const loading = ref(false);
const errorMessage = ref("");
const successMessage = ref("");

const handleRegister = async () => {
  loading.value = true;
  errorMessage.value = "";
  successMessage.value = "";

  // 驗證密碼
  if (formData.password !== formData.confirmPassword) {
    errorMessage.value = "密碼與確認密碼不符";
    loading.value = false;
    return;
  }

  if (formData.password.length < 6) {
    errorMessage.value = "密碼至少需要 6 個字元";
    loading.value = false;
    return;
  }

  const result = await authStore.signUp(
    formData.email,
    formData.password,
    formData.displayName
  );

  if (result.success) {
    successMessage.value = "註冊成功！請檢查您的 Email 以驗證帳號";
    setTimeout(() => {
      router.push("/login");
    }, 2000);
  } else {
    errorMessage.value = result.error || "註冊失敗，請稍後再試";
  }

  loading.value = false;
};
</script>
