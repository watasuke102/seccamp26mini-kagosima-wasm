let instance = null;
WebAssembly.instantiateStreaming(fetch("/filter.wasm")).then((e) => {
  instance = e.instance;
});

const canvas = document.getElementById("canvas");
if (!canvas) {
  alert("canvas not found");
}
const ctx = canvas.getContext("2d");

const img = new Image();
img.addEventListener("load", () => {
  canvas.width = img.naturalWidth;
  canvas.height = img.naturalHeight;
  ctx.drawImage(img, 0, 0);
});
img.src = "/image.jpg";

const button = document.getElementById("filter_button");
button?.addEventListener("click", () => {
  if (!instance) {
    return;
  }
  try {
    button.disabled = true;
    const image_data = ctx.getImageData(0, 0, canvas.width, canvas.height);
    let data = image_data.data;

    for (let i = 0; i < data.length; i += 4) {
      const r = data[i];
      const g = data[i + 1];
      const b = data[i + 2];

      const result = instance.exports.filter(r, g, b);

      data[i + 0] = result[0];
      data[i + 1] = result[1];
      data[i + 2] = result[2];
    }
    ctx.putImageData(image_data, 0, 0);
  } finally {
    button.disabled = false;
  }
});
