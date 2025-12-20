import { defineStore } from "pinia";
import { ref, computed } from "vue";
import { supabase } from "@/lib/supabase";

export const useAuthStore = defineStore("auth", () => {
  const user = ref(null);
  const loading = ref(false);
  const error = ref(null);

  const isAuthenticated = computed(() => !!user.value);

  // 初始化：檢查是否已登入
  const initAuth = async () => {
    loading.value = true;
    try {
      const {
        data: { session },
      } = await supabase.auth.getSession();

      if (session?.user) {
        user.value = session.user;
      }

      // 監聽認證狀態變化
      supabase.auth.onAuthStateChange((event, session) => {
        user.value = session?.user || null;
      });
    } catch (err) {
      console.error("Init auth error:", err);
    } finally {
      loading.value = false;
    }
  };

  // 註冊
  const signUp = async (email, password, displayName) => {
    loading.value = true;
    error.value = null;

    try {
      const { data, error: signUpError } = await supabase.auth.signUp({
        email,
        password,
        options: {
          data: {
            display_name: displayName,
          },
        },
      });

      if (signUpError) throw signUpError;

      return { success: true, data };
    } catch (err) {
      error.value = err.message;
      console.error("Sign up error:", err);
      return { success: false, error: err.message };
    } finally {
      loading.value = false;
    }
  };

  // 登入
  const signIn = async (email, password) => {
    loading.value = true;
    error.value = null;

    try {
      const { data, error: signInError } =
        await supabase.auth.signInWithPassword({
          email,
          password,
        });

      if (signInError) throw signInError;

      user.value = data.user;
      return { success: true, data };
    } catch (err) {
      error.value = err.message;
      console.error("Sign in error:", err);
      return { success: false, error: err.message };
    } finally {
      loading.value = false;
    }
  };

  // 登出
  const signOut = async () => {
    loading.value = true;
    error.value = null;

    try {
      const { error: signOutError } = await supabase.auth.signOut();

      if (signOutError) throw signOutError;

      user.value = null;
      return { success: true };
    } catch (err) {
      error.value = err.message;
      console.error("Sign out error:", err);
      return { success: false, error: err.message };
    } finally {
      loading.value = false;
    }
  };

  // 更新個人資料
  const updateProfile = async (displayName) => {
    loading.value = true;
    error.value = null;

    try {
      const { data, error: updateError } = await supabase.auth.updateUser({
        data: { display_name: displayName },
      });

      if (updateError) throw updateError;

      user.value = data.user;
      return { success: true, data };
    } catch (err) {
      error.value = err.message;
      console.error("Update profile error:", err);
      return { success: false, error: err.message };
    } finally {
      loading.value = false;
    }
  };

  // 取得顯示名稱
  const getDisplayName = computed(() => {
    return (
      user.value?.user_metadata?.display_name || user.value?.email || "訪客"
    );
  });

  return {
    user,
    loading,
    error,
    isAuthenticated,
    getDisplayName,
    initAuth,
    signUp,
    signIn,
    signOut,
    updateProfile,
  };
});
