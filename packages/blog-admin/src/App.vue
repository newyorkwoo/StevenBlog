<script setup>
import { computed } from "vue";
import { useRoute } from "vue-router";
import Layout from "./components/Layout.vue";

const route = useRoute();
const isLoginPage = computed(() => route.path === "/login");
</script>

<template>
  <div v-if="isLoginPage">
    <router-view />
  </div>
  <Layout v-else>
    <router-view />
  </Layout>
</template>

<style>
#app {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen",
    "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue",
    sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
</style>
