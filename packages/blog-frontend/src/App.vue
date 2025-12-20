<template>
  <div class="min-h-screen flex flex-col bg-primary-50">
    <Header />
    <main class="flex-1 container mx-auto px-4 py-8 max-w-6xl">
      <RouterView />
    </main>
    <Footer />
  </div>
</template>

<script setup>
import { RouterView } from "vue-router";
import Header from "@/components/Header.vue";
import Footer from "@/components/Footer.vue";
</script>
