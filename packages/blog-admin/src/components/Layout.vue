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

            <!-- 導航連結 -->
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

          <!-- 使用者資訊 -->
          <div class="flex items-center space-x-4">
            <span class="text-sm text-gray-600">{{ userEmail }}</span>
            <button
              @click="handleLogout"
              class="inline-flex items-center px-4 py-2 text-sm font-normal text-gray-600 hover:text-sand-800 transition-colors duration-200"
            >
              登出
            </button>
          </div>
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
