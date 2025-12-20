<template>
  <div
    class="min-h-screen flex items-center justify-center bg-sand-50 py-12 px-4 sm:px-6 lg:px-8"
  >
    <div class="max-w-md w-full">
      <!-- 標題區 -->
      <div class="text-center mb-12">
        <h2 class="text-3xl font-normal text-sand-900 tracking-wide">
          後台管理
        </h2>
        <p class="mt-3 text-sm text-gray-600">請登入您的管理員帳號</p>
      </div>

      <!-- 登入表單 -->
      <div
        class="bg-white rounded-lg p-8"
        style="box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.05)"
      >
        <form @submit.prevent="handleLogin" class="space-y-6">
          <div
            v-if="error"
            class="rounded-md bg-warm-50 border border-warm-200 p-4"
          >
            <p class="text-sm text-warm-800">{{ error }}</p>
          </div>

          <div class="space-y-5">
            <div>
              <label
                for="email"
                class="block text-sm font-normal text-gray-700 mb-2"
              >
                Email 地址
              </label>
              <input
                id="email"
                v-model="email"
                type="email"
                required
                class="appearance-none block w-full px-4 py-3 border border-sand-200 rounded-md text-gray-900 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-sand-400 focus:border-transparent transition-all duration-200"
                placeholder="your@email.com"
              />
            </div>

            <div>
              <label
                for="password"
                class="block text-sm font-normal text-gray-700 mb-2"
              >
                密碼
              </label>
              <input
                id="password"
                v-model="password"
                type="password"
                required
                class="appearance-none block w-full px-4 py-3 border border-sand-200 rounded-md text-gray-900 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-sand-400 focus:border-transparent transition-all duration-200"
                placeholder="••••••••"
              />
            </div>
          </div>

          <div class="pt-2">
            <button
              type="submit"
              :disabled="loading"
              class="w-full flex justify-center py-3 px-4 border border-transparent rounded-md text-sm font-normal text-white bg-sand-600 hover:bg-sand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-sand-500 disabled:opacity-50 disabled:cursor-not-allowed transition-colors duration-200"
            >
              {{ loading ? "登入中..." : "登入" }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";
import { supabase } from "../lib/supabase";

const router = useRouter();

const email = ref("");
const password = ref("");
const loading = ref(false);
const error = ref("");

const handleLogin = async () => {
  loading.value = true;
  error.value = "";

  try {
    const { data, error: loginError } = await supabase.auth.signInWithPassword({
      email: email.value,
      password: password.value,
    });

    if (loginError) throw loginError;

    router.push("/");
  } catch (err) {
    error.value = err.message;
  } finally {
    loading.value = false;
  }
};
</script>
