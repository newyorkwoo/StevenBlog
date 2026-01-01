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
  try {
    // Use createImageBitmap which is available in Web Workers
    const imageBitmap = await createImageBitmap(file);

    let width = imageBitmap.width;
    let height = imageBitmap.height;

    // Calculate scaled dimensions
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

    // Use OffscreenCanvas (available in workers)
    const canvas = new OffscreenCanvas(width, height);
    const ctx = canvas.getContext("2d");
    ctx.drawImage(imageBitmap, 0, 0, width, height);

    // Clean up
    imageBitmap.close();

    return await compressToTargetSize(canvas, file, maxSizeMB);
  } catch (error) {
    throw new Error(`图片处理失败: ${error.message}`);
  }
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
