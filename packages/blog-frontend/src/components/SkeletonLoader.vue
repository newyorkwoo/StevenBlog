<template>
  <div class="animate-pulse">
    <!-- Hero Section Skeleton -->
    <section class="text-center py-12">
      <div class="h-12 bg-gray-200 rounded w-3/4 mx-auto mb-4"></div>
      <div class="h-6 bg-gray-200 rounded w-1/2 mx-auto"></div>
    </section>

    <!-- Posts Grid Skeleton -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
      <div v-for="i in 6" :key="i" class="card-minimal">
        <!-- Image Skeleton -->
        <div class="aspect-video mb-4 rounded-lg bg-gray-200"></div>

        <!-- Category Badge Skeleton -->
        <div class="mb-2">
          <div class="h-6 bg-gray-200 rounded-full w-20"></div>
        </div>

        <!-- Title Skeleton -->
        <div class="h-7 bg-gray-200 rounded w-full mb-2"></div>
        <div class="h-7 bg-gray-200 rounded w-3/4 mb-4"></div>

        <!-- Excerpt Skeleton -->
        <div class="space-y-2 mb-4">
          <div class="h-4 bg-gray-200 rounded w-full"></div>
          <div class="h-4 bg-gray-200 rounded w-full"></div>
          <div class="h-4 bg-gray-200 rounded w-2/3"></div>
        </div>

        <!-- Meta Skeleton -->
        <div class="flex items-center justify-between">
          <div class="h-4 bg-gray-200 rounded w-24"></div>
          <div class="h-4 bg-gray-200 rounded w-20"></div>
        </div>

        <!-- Tags Skeleton -->
        <div class="mt-4 flex gap-2">
          <div class="h-5 bg-gray-200 rounded w-16"></div>
          <div class="h-5 bg-gray-200 rounded w-20"></div>
          <div class="h-5 bg-gray-200 rounded w-14"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
// 骨架屏组件 - 用于首页加载时显示
</script>
