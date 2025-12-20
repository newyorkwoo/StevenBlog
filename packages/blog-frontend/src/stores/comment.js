import { defineStore } from "pinia";
import { ref } from "vue";
import { supabase } from "@/lib/supabase";

export const useCommentStore = defineStore("comment", () => {
  const comments = ref([]);
  const loading = ref(false);
  const error = ref(null);
  const realtimeChannel = ref(null);

  // 獲取文章的所有留言
  const fetchComments = async (postId) => {
    loading.value = true;
    error.value = null;

    try {
      const { data, error: fetchError } = await supabase
        .from("comments")
        .select("*")
        .eq("post_id", postId)
        .eq("status", "approved")
        .order("created_at", { ascending: true });

      if (fetchError) throw fetchError;

      comments.value = data;
      return data;
    } catch (err) {
      error.value = err.message;
      console.error("Error fetching comments:", err);
      return [];
    } finally {
      loading.value = false;
    }
  };

  // 提交新留言
  const createComment = async (commentData) => {
    loading.value = true;
    error.value = null;

    try {
      const { data, error: createError } = await supabase
        .from("comments")
        .insert([
          {
            ...commentData,
            status: "pending", // 新留言預設為待審核
            created_at: new Date().toISOString(),
          },
        ])
        .select()
        .single();

      if (createError) throw createError;

      return data;
    } catch (err) {
      error.value = err.message;
      console.error("Error creating comment:", err);
      return null;
    } finally {
      loading.value = false;
    }
  };

  // 訂閱即時留言更新
  const subscribeToComments = (postId) => {
    // 取消之前的訂閱
    if (realtimeChannel.value) {
      supabase.removeChannel(realtimeChannel.value);
    }

    realtimeChannel.value = supabase
      .channel(`comments:${postId}`)
      .on(
        "postgres_changes",
        {
          event: "INSERT",
          schema: "public",
          table: "comments",
          filter: `post_id=eq.${postId}`,
        },
        (payload) => {
          // 只顯示已審核的留言
          if (payload.new.status === "approved") {
            comments.value.push(payload.new);
          }
        }
      )
      .on(
        "postgres_changes",
        {
          event: "UPDATE",
          schema: "public",
          table: "comments",
          filter: `post_id=eq.${postId}`,
        },
        (payload) => {
          const index = comments.value.findIndex(
            (c) => c.id === payload.new.id
          );
          if (index !== -1) {
            if (payload.new.status === "approved") {
              comments.value[index] = payload.new;
            } else {
              // 如果狀態變為非 approved，移除該留言
              comments.value.splice(index, 1);
            }
          } else if (payload.new.status === "approved") {
            // 如果之前不存在但現在被審核通過，加入列表
            comments.value.push(payload.new);
          }
        }
      )
      .subscribe();
  };

  // 取消訂閱
  const unsubscribeFromComments = () => {
    if (realtimeChannel.value) {
      supabase.removeChannel(realtimeChannel.value);
      realtimeChannel.value = null;
    }
  };

  return {
    comments,
    loading,
    error,
    fetchComments,
    createComment,
    subscribeToComments,
    unsubscribeFromComments,
  };
});
