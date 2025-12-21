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

        <!-- LINE QR Code -->
        <div>
          <h3 class="text-lg font-serif font-semibold text-secondary-800 mb-4">
            加入 LINE
          </h3>
          <div class="flex flex-col items-center md:items-start">
            <img
              src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAPoAAAD6AQAAAACgl2eQAAAC4klEQVR4Xu2YS46jMBRF3w8WQBeQJbAEegm0tOyAFbCE7qGVJdBLoPsABgFOFZnkjzFQRVDVmfTRJCg+vde+2A/j+Pj4+Pj4+Pj4vhv7+Pj4+Pj4+Pj+f/vx8fHx8fHx8f33fr8fHx8fHx8fH9/3ax8fHx8fHx8f3/dr3z4+Pj4+Pj6+79e+fXx8fHx8fHx/fP/+/Pj4+Pj4+Pj+/vr4+Pj4+Pj4/vr6+Pj4+Pj4+P76+vj4+Pj4+Pj++vr4+Pj4+Pj4/vr6+Pj4+Pj4+P76+vj4+Pj4+Pj++vr4+Pj4+Pj4/vr6+Pj4+Pj4+P76+vj4+Pj4+Pj++vr4+Pj4+Pj4/vr6+Pj4+Pj4+P76+vj4+Pj4+Pj++vr4+Pj4+Pj4/vr6/v/7+/Pj4+Pj4+P7++vj4+Pj4+Pj++vr4+Pj4+Pj4/vr6+Pj4+Pj4+P76+vj4+Pj4+Pj++vr4+Pj4+Pj4/vr6+Pj4+Pj4+P76+vj4+Pj4+Pj++vr+//vz4+Pj4+P7++vj4+Pj4+Pj++vr4+Pj4+Pj4/vr6+Pj4+Pj4+P76+vj4+Pj4+Pj++vr4+Pj4+Pj4/vr6+Pj4+Pj4+P76+v7/+/Pj4+Pj4+P7++vj4+Pj4+Pj++vr4+Pj4+Pj4/vr6+Pj4+Pj4+P76+vj4+Pj4+Pj++vr4+Pj4+Pj4/vr6+Pj4+Pj4+P76+v7/+/Pj4+Pj4+P7++vj4+Pj4+Pj++vr4+Pj4+Pj4/vr6+Pj4+Pj4+P76+vj4+Pj4+Pj++vr4+Pj4+Pj4/vr6+Pj4+Pj4+P76+v7/+/Pj4+Pj4+P7++vj4+Pj4+Pj++vr4+Pj4+Pj4/vr6+Pj4+Pj4+P76+vj4+Pj4+Pj++vr4+Pj4+Pj4/vr6+Pj4+Pj4+P76+v7/+/Pj4+Pj4+P7++vj4+Pj4+Pj++vr4+Pj4+Pj4/vr6+Pj4+Pj4+P76+vj4+Pj4+Pj++vr4+Pj4+Pj4/vr6+Pj4+Pj4+P76+v7/+/Pj4+Pj4+P7++vj4+Pj4+Pj++vr4+Pj4+Pj4/vr6+Pj4+Pj4+P76+vj4+Pj4+Pj++vr4+Pj4+Pj4/vr6+Pj4+Pj4+P76+v7/+/Pj4+Pj4+P7++vj4+Pj4+Pj++vr4+Pj4+Pj4/vr6+Pj4+Pj4+P76+vj4+Pj4+Pj++vr4+Pj4+Pj4/vr6+Pj4+Pj4+P76+v7/+/Pj4+Pj4+P7++vj4+Pj4+Pj++vr4+Pj4+Pj4/vr6+Pj4+Pj4+P76+vj4+Pj4+Pj++vr4+Pj4+Pj4/vr6+Pj4+Pj4+P76+v7/+/Pj4+Pj4+P7++vj4+Pj4+Pj++vr4+Pj4+Pj4/vr6+Pj4+Pj4+P76+vj4+Pj4+Pj++vr4+Pj4+Pj4/vr6+Pj4+Pj4+P76+v7/+/Pj4+Pj4+P7++vj4+Pj4+Pj++vr4+Pj4+Pj4/vr6+Pj4+Pj4+P76+vj4+Pj4+Pj++vr4+Pj4+Pj4/vr6+Pj4+Pj4+P76+vj4+Pj4+Pj++vr4+Pj4+Pj4/vr6+Pj4+Pj4+P76+v7/+/vw=="
              alt="LINE QR Code"
              class="w-32 h-32 rounded-lg shadow-soft"
            />
            <p class="text-xs text-secondary-500 mt-2 text-center">
              掃描加入好友
            </p>
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
import { computed } from "vue";

const currentYear = computed(() => new Date().getFullYear());
</script>
