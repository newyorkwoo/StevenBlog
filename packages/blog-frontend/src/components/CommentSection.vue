<template>
  <div class="max-w-4xl mx-auto">
    <h2 class="text-3xl font-serif font-bold text-secondary-800 mb-8">
      留言區
    </h2>

    <!-- Comment Form -->
    <div class="card-minimal mb-8">
      <h3 class="text-xl font-semibold text-secondary-800 mb-4">發表留言</h3>

      <form @submit.prevent="submitComment" class="space-y-4">
        <div>
          <label
            for="author"
            class="block text-sm font-medium text-secondary-700 mb-2"
          >
            姓名 *
          </label>
          <input
            v-model="formData.author"
            type="text"
            id="author"
            required
            class="input-minimal"
            placeholder="您的姓名"
          />
        </div>

        <div>
          <label
            for="email"
            class="block text-sm font-medium text-secondary-700 mb-2"
          >
            Email *
          </label>
          <input
            v-model="formData.email"
            type="email"
            id="email"
            required
            class="input-minimal"
            placeholder="您的 Email（不會公開顯示）"
          />
        </div>

        <div>
          <label
            for="content"
            class="block text-sm font-medium text-secondary-700 mb-2"
          >
            留言內容 *
          </label>
          <textarea
            v-model="formData.content"
            id="content"
            required
            rows="4"
            class="input-minimal resize-none"
            placeholder="寫下您的想法..."
          ></textarea>
        </div>

        <div class="flex items-center justify-between">
          <p class="text-sm text-secondary-500">* 留言需經審核後才會顯示</p>
          <button
            type="submit"
            :disabled="submitting"
            class="btn-primary disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {{ submitting ? "提交中..." : "提交留言" }}
          </button>
        </div>

        <Transition name="fade">
          <div
            v-if="submitSuccess"
            class="p-4 bg-green-50 text-green-700 rounded-md"
          >
            留言已提交，待審核後會顯示在頁面上！
          </div>
        </Transition>

        <Transition name="fade">
          <div v-if="submitError" class="p-4 bg-red-50 text-red-700 rounded-md">
            {{ submitError }}
          </div>
        </Transition>
      </form>
    </div>

    <!-- Comments List -->
    <div class="space-y-6">
      <h3 class="text-xl font-semibold text-secondary-800">
        所有留言 ({{ comments.length }})
      </h3>

      <div v-if="loading" class="flex justify-center py-8">
        <div
          class="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-600"
        ></div>
      </div>

      <div v-else-if="comments.length > 0" class="space-y-4">
        <div v-for="comment in comments" :key="comment.id" class="card-minimal">
          <div class="flex items-start justify-between mb-2">
            <div>
              <h4 class="font-semibold text-secondary-800">
                {{ comment.author }}
              </h4>
              <p class="text-xs text-secondary-500">
                {{ formatDate(comment.created_at) }}
              </p>
            </div>
          </div>
          <p class="text-secondary-700 whitespace-pre-wrap">
            {{ comment.content }}
          </p>
        </div>
      </div>

      <div v-else class="text-center py-8 text-secondary-500">
        還沒有留言，成為第一個留言的人吧！
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, reactive } from "vue";
import { useCommentStore } from "@/stores/comment";
import { storeToRefs } from "pinia";

const props = defineProps({
  postId: {
    type: String,
    required: true,
  },
});

const commentStore = useCommentStore();
const { comments, loading } = storeToRefs(commentStore);

const formData = reactive({
  author: "",
  email: "",
  content: "",
});

const submitting = ref(false);
const submitSuccess = ref(false);
const submitError = ref(null);

onMounted(async () => {
  await commentStore.fetchComments(props.postId);
  commentStore.subscribeToComments(props.postId);
});

onUnmounted(() => {
  commentStore.unsubscribeFromComments();
});

const submitComment = async () => {
  submitting.value = true;
  submitSuccess.value = false;
  submitError.value = null;

  try {
    const result = await commentStore.createComment({
      post_id: props.postId,
      author: formData.author,
      email: formData.email,
      content: formData.content,
    });

    if (result) {
      submitSuccess.value = true;
      // Reset form
      formData.author = "";
      formData.email = "";
      formData.content = "";

      // Hide success message after 5 seconds
      setTimeout(() => {
        submitSuccess.value = false;
      }, 5000);
    } else {
      submitError.value = "提交失敗，請稍後再試";
    }
  } catch (err) {
    submitError.value = err.message || "提交失敗，請稍後再試";
  } finally {
    submitting.value = false;
  }
};

const formatDate = (dateString) => {
  const date = new Date(dateString);
  return new Intl.DateTimeFormat("zh-TW", {
    year: "numeric",
    month: "long",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  }).format(date);
};
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
