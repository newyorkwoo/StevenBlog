/**
 * 图片懒加载指令
 * 使用方式：v-lazy="imageUrl"
 */
export const lazyLoadDirective = {
  mounted(el, binding) {
    const imageUrl = binding.value;

    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            const img = entry.target;
            img.src = imageUrl;
            img.classList.remove("lazy-loading");
            img.classList.add("lazy-loaded");
            observer.unobserve(img);
          }
        });
      },
      {
        rootMargin: "50px",
        threshold: 0.01,
      }
    );

    // 添加加载中样式
    el.classList.add("lazy-loading");
    el.src =
      'data:image/svg+xml,%3Csvg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 300"%3E%3Crect width="400" height="300" fill="%23f3f4f6"/%3E%3C/svg%3E';

    observer.observe(el);

    // 保存 observer 以便清理
    el._lazyLoadObserver = observer;
  },

  unmounted(el) {
    if (el._lazyLoadObserver) {
      el._lazyLoadObserver.disconnect();
      delete el._lazyLoadObserver;
    }
  },
};
