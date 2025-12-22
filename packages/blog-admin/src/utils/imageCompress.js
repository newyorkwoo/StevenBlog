/**
 * 圖片壓縮工具
 * 自動將圖片壓縮至指定大小以下
 */

/**
 * 壓縮圖片
 * @param {File} file - 原始圖片檔案
 * @param {number} maxSizeMB - 目標大小上限（MB）
 * @param {number} maxWidth - 最大寬度（像素）
 * @param {number} maxHeight - 最大高度（像素）
 * @returns {Promise<File>} 壓縮後的圖片檔案
 */
export async function compressImage(
  file,
  maxSizeMB = 1,
  maxWidth = 1920,
  maxHeight = 1920
) {
  return new Promise((resolve, reject) => {
    // 檢查檔案類型
    if (!file.type.startsWith("image/")) {
      reject(new Error("檔案必須是圖片格式"));
      return;
    }

    const reader = new FileReader();

    reader.onload = (e) => {
      const img = new Image();

      img.onload = () => {
        // 計算壓縮後的尺寸
        let width = img.width;
        let height = img.height;

        // 按比例縮放
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

        // 創建 canvas
        const canvas = document.createElement("canvas");
        canvas.width = width;
        canvas.height = height;

        const ctx = canvas.getContext("2d");
        ctx.drawImage(img, 0, 0, width, height);

        // 嘗試不同的質量級別進行壓縮
        compressToTargetSize(canvas, file, maxSizeMB)
          .then(resolve)
          .catch(reject);
      };

      img.onerror = () => {
        reject(new Error("圖片載入失敗"));
      };

      img.src = e.target.result;
    };

    reader.onerror = () => {
      reject(new Error("讀取檔案失敗"));
    };

    reader.readAsDataURL(file);
  });
}

/**
 * 將 canvas 壓縮至目標大小
 * @param {HTMLCanvasElement} canvas - canvas 元素
 * @param {File} originalFile - 原始檔案
 * @param {number} maxSizeMB - 目標大小上限（MB）
 * @returns {Promise<File>} 壓縮後的圖片檔案
 */
async function compressToTargetSize(canvas, originalFile, maxSizeMB) {
  const maxSizeBytes = maxSizeMB * 1024 * 1024;
  let quality = 0.9;
  let blob = null;

  // 優先使用 webp 格式（更好的壓縮率）
  const useWebP = isWebPSupported();
  const mimeType = useWebP ? "image/webp" : "image/jpeg";

  // 如果原檔案是 PNG 且有透明度，保持 PNG 格式
  if (originalFile.type === "image/png") {
    const hasAlpha = await checkImageAlpha(canvas);
    if (hasAlpha) {
      // PNG 有透明度時不能轉換為 JPEG
      return compressPNG(canvas, originalFile, maxSizeBytes);
    }
  }

  // 二分搜尋最佳質量
  let minQuality = 0.1;
  let maxQuality = 0.95;
  let iterations = 0;
  const maxIterations = 8;

  while (iterations < maxIterations) {
    quality = (minQuality + maxQuality) / 2;
    blob = await new Promise((resolve) => {
      canvas.toBlob(resolve, mimeType, quality);
    });

    if (!blob) {
      throw new Error("圖片壓縮失敗");
    }

    // 如果已經小於目標大小，檢查是否可以提高質量
    if (blob.size <= maxSizeBytes) {
      minQuality = quality;

      // 如果大小遠小於目標，可以提高質量
      if (blob.size < maxSizeBytes * 0.8) {
        maxQuality = maxQuality;
      } else {
        break; // 大小接近目標，完成
      }
    } else {
      // 大於目標大小，降低質量
      maxQuality = quality;
    }

    iterations++;
  }

  // 如果壓縮後仍然太大，進一步降低質量
  if (blob.size > maxSizeBytes) {
    blob = await new Promise((resolve) => {
      canvas.toBlob(resolve, mimeType, 0.7);
    });
  }

  // 創建新的 File 對象
  const fileExt = mimeType === "image/webp" ? "webp" : "jpg";
  const fileName = originalFile.name.replace(/\.[^/.]+$/, `.${fileExt}`);

  return new File([blob], fileName, {
    type: mimeType,
    lastModified: Date.now(),
  });
}

/**
 * 壓縮 PNG 圖片（保留透明度）
 */
async function compressPNG(canvas, originalFile, maxSizeBytes) {
  let quality = 0.95;
  let blob = await new Promise((resolve) => {
    canvas.toBlob(resolve, "image/png", quality);
  });

  if (!blob) {
    throw new Error("PNG 壓縮失敗");
  }

  // PNG 壓縮選項有限，如果還是太大，需要降低解析度
  if (blob.size > maxSizeBytes) {
    const scale = Math.sqrt(maxSizeBytes / blob.size) * 0.9;
    const newCanvas = document.createElement("canvas");
    newCanvas.width = canvas.width * scale;
    newCanvas.height = canvas.height * scale;

    const ctx = newCanvas.getContext("2d");
    ctx.drawImage(canvas, 0, 0, newCanvas.width, newCanvas.height);

    blob = await new Promise((resolve) => {
      newCanvas.toBlob(resolve, "image/png");
    });
  }

  return new File([blob], originalFile.name, {
    type: "image/png",
    lastModified: Date.now(),
  });
}

/**
 * 檢查圖片是否有透明通道
 */
async function checkImageAlpha(canvas) {
  const ctx = canvas.getContext("2d");
  const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
  const data = imageData.data;

  // 檢查 alpha 通道（每個像素的第4個值）
  for (let i = 3; i < data.length; i += 4) {
    if (data[i] < 255) {
      return true; // 找到透明或半透明像素
    }
  }

  return false;
}

/**
 * 檢查瀏覽器是否支援 WebP
 */
function isWebPSupported() {
  const canvas = document.createElement("canvas");
  canvas.width = 1;
  canvas.height = 1;

  try {
    const data = canvas.toDataURL("image/webp");
    return data.indexOf("data:image/webp") === 0;
  } catch (e) {
    return false;
  }
}

/**
 * 格式化檔案大小顯示
 */
export function formatFileSize(bytes) {
  if (bytes === 0) return "0 Bytes";

  const k = 1024;
  const sizes = ["Bytes", "KB", "MB", "GB"];
  const i = Math.floor(Math.log(bytes) / Math.log(k));

  return Math.round((bytes / Math.pow(k, i)) * 100) / 100 + " " + sizes[i];
}
