import { createRouter, createWebHistory } from "vue-router";
import { supabase } from "../lib/supabase";

// 路由配置
const routes = [
  {
    path: "/login",
    name: "Login",
    component: () => import("../views/Login.vue"),
    meta: { requiresAuth: false },
  },
  {
    path: "/",
    name: "Dashboard",
    component: () => import("../views/Dashboard.vue"),
    meta: { requiresAuth: true },
  },
  {
    path: "/posts",
    name: "PostList",
    component: () => import("../views/PostList.vue"),
    meta: { requiresAuth: true },
  },
  {
    path: "/posts/new",
    name: "PostNew",
    component: () => import("../views/PostEdit.vue"),
    meta: { requiresAuth: true },
  },
  {
    path: "/posts/:id/edit",
    name: "PostEdit",
    component: () => import("../views/PostEdit.vue"),
    meta: { requiresAuth: true },
  },
  {
    path: "/categories",
    name: "CategoryList",
    component: () => import("../views/CategoryList.vue"),
    meta: { requiresAuth: true },
  },
  {
    path: "/comments",
    name: "CommentList",
    component: () => import("../views/CommentList.vue"),
    meta: { requiresAuth: true },
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

// 路由守衛 - 檢查認證狀態
router.beforeEach(async (to, from, next) => {
  const requiresAuth = to.matched.some((record) => record.meta.requiresAuth);

  const {
    data: { session },
  } = await supabase.auth.getSession();

  if (requiresAuth && !session) {
    // 需要認證但未登入，導向登入頁
    next("/login");
  } else if (to.path === "/login" && session) {
    // 已登入但訪問登入頁，導向首頁
    next("/");
  } else {
    next();
  }
});

export default router;
