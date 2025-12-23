import { defineStore } from "pinia";
import { ref, computed } from "vue";
import { supabase } from "@/lib/supabase";

// 缓存配置
const CACHE_DURATION = 5 * 60 * 1000; // 5 分钟
const cache = new Map();

function getCacheKey(type, params) {
  return `${type}-${JSON.stringify(params)}`;
}

function getFromCache(key) {
  const cached = cache.get(key);
  if (cached && Date.now() - cached.timestamp < CACHE_DURATION) {
    return cached.data;
  }
  cache.delete(key);
  return null;
}

function setCache(key, data) {
  cache.set(key, { data, timestamp: Date.now() });
}

export const usePostStore = defineStore("post", () => {
  const posts = ref([]);
  const currentPost = ref(null);
  const loading = ref(false);
  const error = ref(null);

  // 获取所有已发布的文章（带缓存）
  const fetchPosts = async (categoryId = null, limit = 10, offset = 0) => {
    const cacheKey = getCacheKey("posts", { categoryId, limit, offset });
    const cached = getFromCache(cacheKey);

    if (cached) {
      posts.value = cached;
      return cached;
    }

    loading.value = true;
    error.value = null;

    try {
      let query = supabase
        .from("posts")
        .select(
          `
          id,
          title,
          slug,
          excerpt,
          cover_image,
          published_at,
          read_time,
          category_id,
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
      setCache(cacheKey, data);
      return data;
    } catch (err) {
      error.value = err.message;
      console.error("Error fetching posts:", err);
      return [];
    } finally {
      loading.value = false;
    }
  };

  // 根据 slug 获取单篇文章（带缓存）
  const fetchPostBySlug = async (slug) => {
    const cacheKey = getCacheKey("post", { slug });
    const cached = getFromCache(cacheKey);

    if (cached) {
      currentPost.value = cached;
      return cached;
    }

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
      setCache(cacheKey, data);
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
