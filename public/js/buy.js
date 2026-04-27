const HOST = "http://localhost:3000";

let allMachines = [];
let products = [];
let cart = [];
let currentMachineId = null;

// INIT
async function init() {
  try {
    const res = await fetch(`${HOST}/api/machines`);
    allMachines = await res.json();
  } catch (err) {
    alert("Lỗi load máy!");
  }
}

document.getElementById("searchInput").addEventListener("input", handleSearch);

// SEARCH DROPDOWN
function handleSearch() {
  const keyword = document.getElementById("searchInput").value.toLowerCase();
  const box = document.getElementById("searchList");

  if (!keyword) {
    box.style.display = "none";
    return;
  }

  const results = allMachines.filter((m) =>
    m.name?.toLowerCase().includes(keyword),
  );

  if (results.length === 0) {
    box.innerHTML = `<div class="search-item">Không có kết quả</div>`;
    box.style.display = "block";
    return;
  }

  box.innerHTML = results
    .map(
      (m) => `
    <div class="search-item" onclick="selectMachine(${m.id}, \`${m.name}\`)">
      ${m.name}
    </div>
  `,
    )
    .join("");

  box.style.display = "block";
}

// SELECT MACHINE
function selectMachine(id, name) {
  document.getElementById("searchInput").value = name;
  document.getElementById("searchList").style.display = "none";
  document.getElementById("headerTitle").innerText = "🥤 " + name;

  currentMachineId = id;
  loadProducts(id);
}

// LOAD PRODUCTS
async function loadProducts(id) {
  const res = await fetch(`${HOST}/api/machine/${id}`);
  const data = await res.json();
  products = data.products;
  renderProducts();
}

// RENDER PRODUCTS
function renderProducts() {
  const box = document.getElementById("productList");

  box.innerHTML = products
    .map(
      (p) => `
    <div class="product">
      <button class="add-btn"
        ${p.stock <= 0 ? "disabled" : ""}
        onclick="addToCart(${p.id}, \`${p.name}\`, ${p.price})">
        +
      </button>

      <img src="${p.image ? HOST + p.image : "https://via.placeholder.com/70"}"/>

      <p>${p.name}</p>
      <p>${Number(p.price).toLocaleString()}đ</p>
      <p>Còn ${p.stock}</p>

      ${p.stock <= 0 ? `<p class="out">Hết hàng</p>` : ""}
    </div>
  `,
    )
    .join("");
}

// CART
function addToCart(id, name, price) {
  const item = cart.find((i) => i.id === id);
  if (item) item.qty++;
  else cart.push({ id, name, price, qty: 1 });

  renderCart();
}

function renderCart() {
  const box = document.getElementById("cartList");

  if (cart.length === 0) {
    box.innerHTML = "<p>Chưa có sản phẩm</p>";
    document.getElementById("totalPrice").innerText = "Tổng: 0đ";
    return;
  }

  box.innerHTML = cart
    .map(
      (i) => `
    <div class="cart-item">
      <span>${i.name}</span>

      <input type="number" min="1" value="${i.qty}"
        onchange="changeQty(${i.id}, this.value)">

      <span>${(i.price * i.qty).toLocaleString()}đ</span>

      <button onclick="removeItem(${i.id})">❌</button>
    </div>
  `,
    )
    .join("");

  const total = cart.reduce((s, i) => s + i.price * i.qty, 0);
  document.getElementById("totalPrice").innerText =
    "Tổng: " + total.toLocaleString() + "đ";
}

function changeQty(id, val) {
  const item = cart.find((i) => i.id === id);
  item.qty = Math.max(1, parseInt(val) || 1);
  renderCart();
}

function removeItem(id) {
  cart = cart.filter((i) => i.id !== id);
  renderCart();
}

function clearCart() {
  cart = [];
  renderCart();
}

// CHECKOUT
async function checkout() {
  if (!currentMachineId) return alert("Chưa chọn máy");
  if (cart.length === 0) return alert("Chưa có sản phẩm");

  try {
    const res = await fetch(`${HOST}/api/sales`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        machine_id: currentMachineId,
        items: cart.map((i) => ({
          product_id: i.id,
          quantity: i.qty,
        })),
      }),
    });

    const result = await res.json();

    if (!res.ok) throw new Error(result.error);

    alert("✅ Thanh toán thành công");

    cart = [];
    renderCart();
    loadProducts(currentMachineId);
  } catch (err) {
    alert("❌ " + err.message);
  }
}

// CLICK OUTSIDE → ẨN DROPDOWN
document.addEventListener("click", (e) => {
  if (!e.target.closest(".search-box")) {
    document.getElementById("searchList").style.display = "none";
  }
});

init();
