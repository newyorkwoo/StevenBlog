<template>
  <header class="bg-white shadow-soft sticky top-0 z-50">
    <nav class="container mx-auto px-4 py-4 max-w-6xl">
      <div class="flex items-center justify-between">
        <!-- Logo -->
        <RouterLink
          to="/"
          class="text-2xl font-serif font-semibold text-primary-700 hover:text-primary-800 transition-colors"
        >
          Steven's Blog
        </RouterLink>

        <!-- Desktop Navigation -->
        <div class="hidden md:flex items-center space-x-8">
          <RouterLink
            to="/"
            class="text-secondary-700 hover:text-primary-600 transition-colors font-medium"
            active-class="text-primary-600"
          >
            首頁
          </RouterLink>

          <div class="relative group" v-if="categories.length > 0">
            <button
              class="text-secondary-700 hover:text-primary-600 transition-colors font-medium flex items-center"
            >
              分類
              <svg
                class="w-4 h-4 ml-1"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M19 9l-7 7-7-7"
                />
              </svg>
            </button>
            <div
              class="absolute left-0 mt-2 w-48 bg-white rounded-lg shadow-soft-lg opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200"
            >
              <RouterLink
                v-for="category in categories"
                :key="category.id"
                :to="`/category/${category.slug}`"
                class="block px-4 py-2 text-secondary-700 hover:bg-primary-50 hover:text-primary-600 transition-colors first:rounded-t-lg last:rounded-b-lg"
              >
                {{ category.name }}
              </RouterLink>
            </div>
          </div>

          <RouterLink
            to="/about"
            class="text-secondary-700 hover:text-primary-600 transition-colors font-medium"
            active-class="text-primary-600"
          >
            關於
          </RouterLink>

          <!-- Search -->
          <button
            @click="toggleSearch"
            class="text-secondary-700 hover:text-primary-600 transition-colors"
          >
            <svg
              class="w-5 h-5"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
              />
            </svg>
          </button>
        </div>

        <!-- Mobile Menu Button -->
        <button
          @click="toggleMobileMenu"
          class="md:hidden text-secondary-700 hover:text-primary-600 transition-colors"
        >
          <svg
            class="w-6 h-6"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              v-if="!mobileMenuOpen"
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M4 6h16M4 12h16M4 18h16"
            />
            <path
              v-else
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M6 18L18 6M6 6l12 12"
            />
          </svg>
        </button>
      </div>

      <!-- Mobile Menu -->
      <div
        v-if="mobileMenuOpen"
        class="md:hidden mt-4 pb-4 border-t border-secondary-100 pt-4"
      >
        <RouterLink
          to="/"
          class="block py-2 text-secondary-700 hover:text-primary-600 transition-colors"
          @click="closeMobileMenu"
        >
          首頁
        </RouterLink>
        <div v-if="categories.length > 0" class="py-2">
          <div class="text-secondary-700 font-medium mb-2">分類</div>
          <RouterLink
            v-for="category in categories"
            :key="category.id"
            :to="`/category/${category.slug}`"
            class="block py-2 pl-4 text-secondary-600 hover:text-primary-600 transition-colors"
            @click="closeMobileMenu"
          >
            {{ category.name }}
          </RouterLink>
        </div>
        <RouterLink
          to="/about"
          class="block py-2 text-secondary-700 hover:text-primary-600 transition-colors"
          @click="closeMobileMenu"
        >
          關於
        </RouterLink>
        <button
          @click="toggleSearch"
          class="block py-2 text-secondary-700 hover:text-primary-600 transition-colors w-full text-left"
        >
          搜尋
        </button>
      </div>
    </nav>

    <!-- Search Modal -->
    <Transition name="fade">
      <div
        v-if="searchOpen"
        class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-start justify-center pt-20"
        @click="closeSearch"
      >
        <div
          class="bg-white rounded-lg shadow-soft-lg w-full max-w-2xl mx-4"
          @click.stop
        >
          <div class="p-4">
            <input
              v-model="searchQuery"
              type="text"
              placeholder="搜尋文章..."
              class="input-minimal"
              @keyup.enter="performSearch"
              ref="searchInput"
            />
          </div>
        </div>
      </div>
    </Transition>
  </header>
</template>

<script setup>
import { ref, onMounted, watch, nextTick } from "vue";
import { RouterLink, useRouter } from "vue-router";
import { useCategoryStore } from "@/stores/category";
import { storeToRefs } from "pinia";

const router = useRouter();
const categoryStore = useCategoryStore();
const { categories } = storeToRefs(categoryStore);

const mobileMenuOpen = ref(false);
const searchOpen = ref(false);
const searchQuery = ref("");
const searchInput = ref(null);

onMounted(() => {
  categoryStore.fetchCategories();
});

const toggleMobileMenu = () => {
  mobileMenuOpen.value = !mobileMenuOpen.value;
};

const closeMobileMenu = () => {
  mobileMenuOpen.value = false;
};

const toggleSearch = () => {
  searchOpen.value = !searchOpen.value;
  if (searchOpen.value) {
    nextTick(() => {
      searchInput.value?.focus();
    });
  }
  mobileMenuOpen.value = false;
};

const closeSearch = () => {
  searchOpen.value = false;
  searchQuery.value = "";
};

const performSearch = () => {
  if (searchQuery.value.trim()) {
    router.push({ name: "search", query: { q: searchQuery.value } });
    closeSearch();
  }
};

watch(searchOpen, (newValue) => {
  if (newValue) {
    document.body.style.overflow = "hidden";
  } else {
    document.body.style.overflow = "";
  }
});
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
