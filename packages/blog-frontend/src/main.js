import { createApp } from "vue";
import { createPinia } from "pinia";
import router from "./router";
import App from "./App.vue";
import "./style.css";
import { useAuthStore } from "./stores/auth";
import { lazyLoadDirective } from "./directives/lazyLoad";

const app = createApp(App);
const pinia = createPinia();

app.use(pinia);
app.use(router);

// 注册全局指令
app.directive("lazy", lazyLoadDirective);

// Initialize auth state
const authStore = useAuthStore();
authStore.initAuth();

app.mount("#app");
