import { defineStore } from "pinia";
import { ref } from "vue";
import { supabase } from "@/lib/supabase";

export const useCategoryStore = defineStore("category", () => {
  const categories = ref([]);
  const loading = ref(false);
  const error = ref(null);

  // 獲取所有分類
  const fetchCategories = async () => {
    loading.value = true;
    error.value = null;

    try {
      const { data, error: fetchError } = await supabase
        .from("categories")
        .select("*")
        .order("order", { ascending: true });

      if (fetchError) throw fetchError;

      categories.value = data;
      return data;
    } catch (err) {
      error.value = err.message;
      console.error("Error fetching categories:", err);
      return [];
    } finally {
      loading.value = false;
    }
  };

  return {
    categories,
    loading,
    error,
    fetchCategories,
  };
});
