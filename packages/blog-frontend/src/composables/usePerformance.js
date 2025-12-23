/**
 * 图片懒加载 Composable
 * 使用 Intersection Observer API 实现高性能懒加载
 */
import { ref, onMounted, onUnmounted } from "vue";

export function useLazyLoad(options = {}) {
  const { threshold = 0.1, rootMargin = "50px" } = options;
  const elements = ref(new Set());
  let observer = null;

  const observe = (el) => {
    if (el && observer) {
      elements.value.add(el);
      observer.observe(el);
    }
  };

  const unobserve = (el) => {
    if (el && observer) {
      elements.value.delete(el);
      observer.unobserve(el);
    }
  };

  onMounted(() => {
    observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            const img = entry.target;
            const src = img.dataset.src;

            if (src) {
              img.src = src;
              img.removeAttribute("data-src");
              observer.unobserve(img);
            }
          }
        });
      },
      { threshold, rootMargin }
    );
  });

  onUnmounted(() => {
    if (observer) {
      elements.value.forEach((el) => observer.unobserve(el));
      observer.disconnect();
    }
  });

  return { observe, unobserve };
}

/**
 * 防抖 Hook
 */
export function useDebounce(fn, delay = 300) {
  let timeoutId = null;

  const debouncedFn = (...args) => {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => {
      fn(...args);
    }, delay);
  };

  const cancel = () => {
    clearTimeout(timeoutId);
  };

  return { debouncedFn, cancel };
}

/**
 * 节流 Hook
 */
export function useThrottle(fn, delay = 300) {
  let lastRun = 0;

  const throttledFn = (...args) => {
    const now = Date.now();
    if (now - lastRun >= delay) {
      fn(...args);
      lastRun = now;
    }
  };

  return throttledFn;
}

/**
 * 无限滚动 Hook
 */
export function useInfiniteScroll(callback, options = {}) {
  const { distance = 200 } = options;
  const loading = ref(false);

  const handleScroll = () => {
    if (loading.value) return;

    const scrollHeight = document.documentElement.scrollHeight;
    const scrollTop = document.documentElement.scrollTop;
    const clientHeight = document.documentElement.clientHeight;

    if (scrollHeight - scrollTop - clientHeight < distance) {
      loading.value = true;
      callback().finally(() => {
        loading.value = false;
      });
    }
  };

  const throttledScroll = useThrottle(handleScroll, 200);

  onMounted(() => {
    window.addEventListener("scroll", throttledScroll);
  });

  onUnmounted(() => {
    window.removeEventListener("scroll", throttledScroll);
  });

  return { loading };
}
