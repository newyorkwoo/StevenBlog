/**
 * Web Worker for image compression
 * 在独立线程中处理图片压缩，避免阻塞主线程
 */

self.onmessage = async function (e) {
  const { file, maxSizeMB, maxWidth, maxHeight } = e.data;

  try {
    const compressedFile = await compressImage(
      file,
      maxSizeMB,
      maxWidth,
      maxHeight
    );
    self.postMessage({ success: true, file: compressedFile });
  } catch (error) {
    self.postMessage({ success: false, error: error.message });
  }
};

async function compressImage(
  file,
  maxSizeMB = 1,
  maxWidth = 1920,
  maxHeight = 1920
) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();

    reader.onload = (e) => {
      const img = new Image();

      img.onload = () => {
        let width = img.width;
        let height = img.height;

        if (width > maxWidth || height > maxHeight) {
          const aspectRatio = width / height;
          if (width > height) {
            width = maxWidth;
            height = width / aspectRatio;
          } else {
            height = maxHeight;
            width = height * aspectRatio;
          }
        }

        const canvas = new OffscreenCanvas(width, height);
        const ctx = canvas.getContext("2d");
        ctx.drawImage(img, 0, 0, width, height);

        compressToTargetSize(canvas, file, maxSizeMB)
          .then(resolve)
          .catch(reject);
      };

      img.onerror = () => reject(new Error("图片加载失败"));
      img.src = e.target.result;
    };

    reader.onerror = () => reject(new Error("读取文件失败"));
    reader.readAsDataURL(file);
  });
}

async function compressToTargetSize(canvas, originalFile, maxSizeMB) {
  const maxSizeBytes = maxSizeMB * 1024 * 1024;
  const mimeType = "image/webp";

  let minQuality = 0.1;
  let maxQuality = 0.95;
  let iterations = 0;
  const maxIterations = 8;
  let blob = null;

  while (iterations < maxIterations) {
    const quality = (minQuality + maxQuality) / 2;
    blob = await canvas.convertToBlob({ type: mimeType, quality });

    if (!blob) throw new Error("图片压缩失败");

    if (blob.size <= maxSizeBytes) {
      minQuality = quality;
      if (blob.size < maxSizeBytes * 0.8) {
        maxQuality = maxQuality;
      } else {
        break;
      }
    } else {
      maxQuality = quality;
    }

    iterations++;
  }

  if (blob.size > maxSizeBytes) {
    blob = await canvas.convertToBlob({ type: mimeType, quality: 0.7 });
  }

  const fileName = originalFile.name.replace(/\.[^/.]+$/, ".webp");
  return new File([blob], fileName, {
    type: mimeType,
    lastModified: Date.now(),
  });
}
