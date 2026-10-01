import "/src/style.css";

let instance = null;
WebAssembly.instantiateStreaming(fetch("/add.wasm")).then((e) => {
  instance = e.instance;
});

document.getElementById("eq")?.addEventListener("click", () => {
  function calc() {
    if (!instance) {
      return null;
    }
    const lhs = document.getElementById("lhs");
    const lhs_number = Number(lhs?.value);
    if (!lhs_number) {
      alert("左辺が不正です");
      return null;
    }
    const rhs = document.getElementById("rhs");
    const rhs_number = Number(rhs.value);
    if (!rhs_number) {
      alert("右辺が不正です");
      return null;
    }
    return instance?.exports.add(lhs_number, rhs_number);
  }
  document.getElementById("answer").innerHTML = calc() ?? "?";
});
