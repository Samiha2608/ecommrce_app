document.addEventListener("turbo:load", () => {
  const input  = document.querySelector("#navbar-search-input");
  const list   = document.querySelector("#search-suggestions");
  if (!input) return;

  let timer;
  input.addEventListener("input", () => {
    clearTimeout(timer);
    const q = input.value.trim();
    if (q.length < 2) return (list.innerHTML = "");

    timer = setTimeout(async () => {
      try {
        const res  = await fetch(`/search/products?q=${encodeURIComponent(q)}`);
        if (!res.ok) throw new Error(res.statusText);
        const hits = await res.json();

        list.innerHTML = hits.length
          ? hits.map(h =>
              `<li class="list-group-item">
                 <a class="text-decoration-none" href="${h.url}">${h.label}</a>
             </li>`).join("")
          : `<li class="list-group-item text-muted">No results</li>`;
      } catch (e) {
        console.error("Search error:", e);
      }
    }, 300);
  });
  document.addEventListener("click", (e) => {
    if (!list.contains(e.target) && e.target !== input) list.innerHTML = "";
  });
});
