/**
 * 优化的图片压缩工具 - 支持 Web Worker
 */

let worker = null;

/**
 * 初始化 Web Worker
 */
function initWorker() {
  if (!worker && typeof Worker !== "undefined") {
    try {
      worker = new Worker(
        new URL("../workers/imageCompressWorker.js", import.meta.url),
        { type: "module" }
      );
    } catch (error) {
      console.warn("Web Worker 初始化失败，使用主线程压缩:", error);
    }
  }
  return worker;
}

/**
 * 使用 Web Worker 压缩图片（推荐）
 */
export async function compressImageAsync(
  file,
  maxSizeMB = 1,
  maxWidth = 1920,
  maxHeight = 1920
) {
  const w = initWorker();

  if (w) {
    return new Promise((resolve, reject) => {
      w.onmessage = (e) => {
        if (e.data.success) {
          resolve(e.data.file);
        } else {
          reject(new Error(e.data.error));
        }
      };

      w.onerror = (error) => {
        reject(error);
      };

      w.postMessage({ file, maxSizeMB, maxWidth, maxHeight });
    });
  } else {
    // 降级：使用主线程压缩
    return compressImage(file, maxSizeMB, maxWidth, maxHeight);
  }
}

/**
 * 批量压缩图片（并行处理）
 */
export async function compressImagesParallel(files, maxSizeMB = 1) {
  const promises = files.map((file) =>
    compressImageAsync(file, maxSizeMB, 1920, 1920)
  );
  return Promise.all(promises);
}

/**
 * 原有的同步压缩方法（保持向后兼容）
 */
export async function compressImage(
  file,
  maxSizeMB = 1,
  maxWidth = 1920,
  maxHeight = 1920
) {
  return new Promise((resolve, reject) => {
    if (!file.type.startsWith("image/")) {
      reject(new Error("文件必须是图片格式"));
      return;
    }

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

        const canvas = document.createElement("canvas");
        canvas.width = width;
        canvas.height = height;

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
  const maxIterations = 6; // 减少迭代次数提升速度
  let blob = null;

  while (iterations < maxIterations) {
    const quality = (minQuality + maxQuality) / 2;
    blob = await new Promise((resolve) => {
      canvas.toBlob(resolve, mimeType, quality);
    });

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
    blob = await new Promise((resolve) => {
      canvas.toBlob(resolve, mimeType, 0.7);
    });
  }

  const fileName = originalFile.name.replace(/\.[^/.]+$/, ".webp");
  return new File([blob], fileName, {
    type: mimeType,
    lastModified: Date.now(),
  });
}

// 检测浏览器支持
export function isWebPSupported() {
  const canvas = document.createElement("canvas");
  return canvas.toDataURL("image/webp").indexOf("data:image/webp") === 0;
}

export function formatFileSize(bytes) {
  if (bytes === 0) return "0 Bytes";
  const k = 1024;
  const sizes = ["Bytes", "KB", "MB", "GB"];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return Math.round((bytes / Math.pow(k, i)) * 100) / 100 + " " + sizes[i];
}
