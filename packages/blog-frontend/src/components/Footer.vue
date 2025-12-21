<template>
  <footer class="bg-white border-t border-secondary-100 mt-12">
    <div class="container mx-auto px-4 py-8 max-w-6xl">
      <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
        <!-- About -->
        <div>
          <h3 class="text-lg font-serif font-semibold text-secondary-800 mb-4">
            關於我
          </h3>
          <p class="text-secondary-600 text-sm leading-relaxed">
            分享軟體開發、旅遊記錄、美食評論與工作經驗的個人部落格。
          </p>
        </div>

        <!-- Contact -->
        <div>
          <h3 class="text-lg font-serif font-semibold text-secondary-800 mb-4">
            聯絡方式
          </h3>
          <ul class="space-y-3">
            <li>
              <a
                href="mailto:stephexx@gmail.com"
                class="text-secondary-600 hover:text-primary-600 transition-colors text-sm flex items-center"
              >
                <svg
                  class="w-5 h-5 mr-2"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"
                  />
                </svg>
                stephexx@gmail.com
              </a>
            </li>
            <li>
              <a
                href="https://www.facebook.com/stephexx"
                target="_blank"
                rel="noopener noreferrer"
                class="text-secondary-600 hover:text-primary-600 transition-colors text-sm flex items-center"
              >
                <svg
                  class="w-5 h-5 mr-2"
                  fill="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"
                  />
                </svg>
                Facebook
              </a>
            </li>
          </ul>
        </div>

        <!-- LINE -->
        <div>
          <h3 class="text-lg font-serif font-semibold text-secondary-800 mb-4">
            加入 LINE
          </h3>
          <div class="space-y-4">
            <button
              @click="showQRCode = !showQRCode"
              class="w-full md:w-auto px-4 py-2 bg-[#06C755] text-white rounded-lg hover:bg-[#05b34c] transition-colors flex items-center justify-center gap-2 text-sm font-medium"
            >
              <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                <path d="M19.365 9.863c.349 0 .63.285.63.631 0 .345-.281.63-.63.63H17.61v1.125h1.755c.349 0 .63.283.63.63 0 .344-.281.629-.63.629h-2.386c-.345 0-.627-.285-.627-.629V8.108c0-.345.282-.63.63-.63h2.386c.346 0 .627.285.627.63 0 .349-.281.63-.63.63H17.61v1.125h1.755zm-3.855 3.016c0 .27-.174.51-.432.596-.064.021-.133.031-.199.031-.211 0-.391-.09-.51-.25l-2.443-3.317v2.94c0 .344-.279.629-.631.629-.346 0-.626-.285-.626-.629V8.108c0-.27.173-.51.43-.595.06-.023.136-.033.194-.033.195 0 .375.104.495.254l2.462 3.33V8.108c0-.345.282-.63.63-.63.345 0 .63.285.63.63v4.771zm-5.741 0c0 .344-.282.629-.631.629-.345 0-.627-.285-.627-.629V8.108c0-.345.282-.63.63-.63.346 0 .628.285.628.63v4.771zm-2.466.629H4.917c-.345 0-.63-.285-.63-.629V8.108c0-.345.285-.63.63-.63.348 0 .63.285.63.63v4.141h1.756c.348 0 .629.283.629.63 0 .344-.282.629-.629.629M24 10.314C24 4.943 18.615.572 12 .572S0 4.943 0 10.314c0 4.811 4.27 8.842 10.035 9.608.391.082.923.258 1.058.59.12.301.079.766.038 1.08l-.164 1.02c-.045.301-.24 1.186 1.049.645 1.291-.539 6.916-4.078 9.436-6.975C23.176 14.393 24 12.458 24 10.314"/>
              </svg>
              {{ showQRCode ? '隱藏 QR Code' : '顯示 QR Code' }}
            </button>
            <Transition name="fade">
              <div v-if="showQRCode" class="flex flex-col items-center md:items-start">
                <div class="w-48 h-48 bg-white p-3 rounded-lg shadow-soft border-2 border-[#06C755]">
                  <img 
                    src="/line-qrcode.png" 
                    alt="LINE QR Code"
                    class="w-full h-full object-contain rounded"
                    @error="handleImageError"
                  />
                </div>
                <p class="text-xs text-secondary-500 mt-3 text-center">
                  掃描 QR Code 加入好友
                </p>
              </div>
            </Transition>
          </div>
        </div>
      </div>

      <div class="border-t border-secondary-100 mt-8 pt-8 text-center">
        <p class="text-secondary-500 text-sm">
          © {{ currentYear }} Steven's Blog. All rights reserved.
        </p>
      </div>
    </div>
  </footer>
</template>

<script setup>
import { ref, computed } from "vue";

const showQRCode = ref(false);
const currentYear = computed(() => new Date().getFullYear());

const handleImageError = (e) => {
  e.target.parentElement.innerHTML = '<div class="w-full h-full bg-secondary-100 rounded flex items-center justify-center text-secondary-500 text-xs text-center p-4">請將 LINE QR Code 圖片<br>放置到 /public/line-qrcode.png</div>';
};
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease, transform 0.3s ease;
}

.fade-enter-from {
  opacity: 0;
  transform: translateY(-10px);
}

.fade-leave-to {
  opacity: 0;
  transform: translateY(10px);
}
</style>
