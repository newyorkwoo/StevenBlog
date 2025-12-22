<template>
  <div class="min-h-screen bg-sand-50">
    <!-- 日式簡約導航列 -->
    <nav class="bg-white border-b border-sand-200">
      <div class="mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
          <div class="flex items-center space-x-8">
            <!-- Logo 區域 -->
            <div class="flex-shrink-0 flex items-center">
              <h1 class="text-xl font-medium text-sand-800 tracking-wide">
                後台管理
              </h1>
            </div>

            <!-- 導航連結 (桌面版) -->
            <div class="hidden sm:flex sm:space-x-1">
              <router-link
                to="/"
                class="inline-flex items-center px-4 py-2 text-sm font-normal transition-colors duration-200 rounded-md"
                :class="
                  $route.path === '/'
                    ? 'bg-sand-100 text-sand-900'
                    : 'text-gray-600 hover:text-sand-800 hover:bg-sand-50'
                "
              >
                儀表板
              </router-link>
              <router-link
                to="/posts"
                class="inline-flex items-center px-4 py-2 text-sm font-normal transition-colors duration-200 rounded-md"
                :class="
                  $route.path.startsWith('/posts')
                    ? 'bg-sand-100 text-sand-900'
                    : 'text-gray-600 hover:text-sand-800 hover:bg-sand-50'
                "
              >
                文章
              </router-link>
              <router-link
                to="/categories"
                class="inline-flex items-center px-4 py-2 text-sm font-normal transition-colors duration-200 rounded-md"
                :class="
                  $route.path === '/categories'
                    ? 'bg-sand-100 text-sand-900'
                    : 'text-gray-600 hover:text-sand-800 hover:bg-sand-50'
                "
              >
                分類
              </router-link>
              <router-link
                to="/comments"
                class="inline-flex items-center px-4 py-2 text-sm font-normal transition-colors duration-200 rounded-md"
                :class="
                  $route.path === '/comments'
                    ? 'bg-sand-100 text-sand-900'
                    : 'text-gray-600 hover:text-sand-800 hover:bg-sand-50'
                "
              >
                留言
              </router-link>
            </div>
          </div>

          <!-- 右側按鈕區域 -->
          <div class="flex items-center space-x-2">
            <!-- 使用者資訊 (桌面版) -->
            <div class="hidden sm:flex items-center space-x-4">
              <span class="text-sm text-gray-600">{{ userEmail }}</span>
              <button
                @click="handleLogout"
                class="inline-flex items-center px-4 py-2 text-sm font-normal text-gray-600 hover:text-sand-800 transition-colors duration-200"
              >
                登出
              </button>
            </div>

            <!-- 移動版選單按鈕 -->
            <button
              @click="mobileMenuOpen = !mobileMenuOpen"
              class="sm:hidden inline-flex items-center justify-center p-2 rounded-md text-gray-600 hover:text-sand-800 hover:bg-sand-50 transition-colors duration-200"
              aria-label="開啟選單"
            >
              <svg
                v-if="!mobileMenuOpen"
                class="h-6 w-6"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M4 6h16M4 12h16M4 18h16"
                />
              </svg>
              <svg
                v-else
                class="h-6 w-6"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
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
      </div>

      <!-- 移動版選單 -->
      <div v-if="mobileMenuOpen" class="sm:hidden border-t border-sand-200">
        <div class="px-2 pt-2 pb-3 space-y-1">
          <router-link
            to="/"
            @click="mobileMenuOpen = false"
            class="block px-3 py-2 rounded-md text-base font-normal transition-colors duration-200"
            :class="
              $route.path === '/'
                ? 'bg-sand-100 text-sand-900'
                : 'text-gray-600 hover:text-sand-800 hover:bg-sand-50'
            "
          >
            儀表板
          </router-link>
          <router-link
            to="/posts"
            @click="mobileMenuOpen = false"
            class="block px-3 py-2 rounded-md text-base font-normal transition-colors duration-200"
            :class="
              $route.path.startsWith('/posts')
                ? 'bg-sand-100 text-sand-900'
                : 'text-gray-600 hover:text-sand-800 hover:bg-sand-50'
            "
          >
            文章
          </router-link>
          <router-link
            to="/categories"
            @click="mobileMenuOpen = false"
            class="block px-3 py-2 rounded-md text-base font-normal transition-colors duration-200"
            :class="
              $route.path === '/categories'
                ? 'bg-sand-100 text-sand-900'
                : 'text-gray-600 hover:text-sand-800 hover:bg-sand-50'
            "
          >
            分類
          </router-link>
          <router-link
            to="/comments"
            @click="mobileMenuOpen = false"
            class="block px-3 py-2 rounded-md text-base font-normal transition-colors duration-200"
            :class="
              $route.path === '/comments'
                ? 'bg-sand-100 text-sand-900'
                : 'text-gray-600 hover:text-sand-800 hover:bg-sand-50'
            "
          >
            留言
          </router-link>
          <div class="border-t border-sand-200 my-2"></div>
          <div class="px-3 py-2 text-sm text-gray-600">{{ userEmail }}</div>
          <button
            @click="handleLogout"
            class="w-full text-left px-3 py-2 rounded-md text-base font-normal text-gray-600 hover:text-sand-800 hover:bg-sand-50 transition-colors duration-200"
          >
            登出
          </button>
        </div>
      </div>
    </nav>

    <!-- 主要內容區 -->
    <main class="py-8">
      <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <slot />
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import { supabase } from "../lib/supabase";

const router = useRouter();
const userEmail = ref("");
const mobileMenuOpen = ref(false);

const loadUser = async () => {
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (user) {
    userEmail.value = user.email;
  }
};

const handleLogout = async () => {
  await supabase.auth.signOut();
  router.push("/login");
};

onMounted(() => {
  loadUser();
});
</script>
