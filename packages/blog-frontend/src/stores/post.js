import { defineStore } from "pinia";
import { ref, computed } from "vue";
import { supabase } from "@/lib/supabase";

export const usePostStore = defineStore("post", () => {
  const posts = ref([]);
  const currentPost = ref(null);
  const loading = ref(false);
  const error = ref(null);

  // 獲取所有已發布的文章
  const fetchPosts = async (categoryId = null, limit = 10, offset = 0) => {
    loading.value = true;
    error.value = null;

    try {
      let query = supabase
        .from("posts")
        .select(
          `
          *,
          categories(id, name, slug),
          post_tags(tags(id, name, slug))
        `
        )
        .eq("status", "published")
        .order("published_at", { ascending: false })
        .range(offset, offset + limit - 1);

      if (categoryId) {
        query = query.eq("category_id", categoryId);
      }

      const { data, error: fetchError } = await query;

      if (fetchError) throw fetchError;

      posts.value = data;
      return data;
    } catch (err) {
      error.value = err.message;
      console.error("Error fetching posts:", err);
      return [];
    } finally {
      loading.value = false;
    }
  };

  // 根據 slug 獲取單篇文章
  const fetchPostBySlug = async (slug) => {
    loading.value = true;
    error.value = null;

    try {
      const { data, error: fetchError } = await supabase
        .from("posts")
        .select(
          `
          *,
          categories(id, name, slug),
          post_tags(tags(id, name, slug))
        `
        )
        .eq("slug", slug)
        .eq("status", "published")
        .single();

      if (fetchError) throw fetchError;

      currentPost.value = data;
      return data;
    } catch (err) {
      error.value = err.message;
      console.error("Error fetching post:", err);
      return null;
    } finally {
      loading.value = false;
    }
  };

  // 搜尋文章
  const searchPosts = async (keyword) => {
    loading.value = true;
    error.value = null;

    try {
      const { data, error: searchError } = await supabase
        .from("posts")
        .select(
          `
          *,
          categories(id, name, slug),
          post_tags(tags(id, name, slug))
        `
        )
        .eq("status", "published")
        .or(`title.ilike.%${keyword}%,content.ilike.%${keyword}%`)
        .order("published_at", { ascending: false });

      if (searchError) throw searchError;

      return data;
    } catch (err) {
      error.value = err.message;
      console.error("Error searching posts:", err);
      return [];
    } finally {
      loading.value = false;
    }
  };

  return {
    posts,
    currentPost,
    loading,
    error,
    fetchPosts,
    fetchPostBySlug,
    searchPosts,
  };
});
