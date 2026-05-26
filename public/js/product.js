// ============================================================
// product.js — Thêm / Sửa / Xóa sản phẩm, tồn kho, báo cáo
// ============================================================

// ========== PRODUCT CRUD ==========
// Mở popup thêm sản phẩm
function addProduct() {
  if (!currentMachine) {
    alert("Chọn máy trước!");
    return;
  }
  // Reset form
  document.getElementById("newProductName").value = "";
  document.getElementById("newProductPrice").value = "";
  document.getElementById("newProductStock").value = "";
  // Hiện popup
  document.getElementById("addProductPopup").classList.remove("hidden");
}

// Lưu sản phẩm mới
async function saveNewProduct() {
  const name = document.getElementById("newProductName").value.trim();
  const price = parseFloat(document.getElementById("newProductPrice").value);
  const stock = parseInt(document.getElementById("newProductStock").value);

  if (stock > 50) {
    alert("Số lượng không được vượt quá 50!");
    return;
  }

  await fetch("/api/products", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ machine_id: currentMachine.id, name, price, stock }),
  });

  closeAddProductPopup();
  showPlace(currentMachine);
}

// Đóng popup
function closeAddProductPopup() {
  document.getElementById("addProductPopup").classList.add("hidden");
}

async function deleteProduct(id) {
  if (!confirm("Xóa sản phẩm?")) return;
  await fetch(`/api/products/${id}`, { method: "DELETE" });
  showPlace(currentMachine);
}

window.editProduct = async function (id) {
  const name = prompt("Tên mới:");
  const price = parseFloat(prompt("Giá mới:"));
  const stock = parseInt(prompt("Stock:"));
  await fetch(`/api/products/${id}`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ name, price, stock }),
  });
  showPlace(currentMachine);
};

async function uploadProductImage(id) {
  try {
    const input = document.getElementById(`img-${id}`);
    if (!input) {
      alert("Không tìm thấy input file");
      return;
    }
    const file = input.files[0];
    if (!file) {
      alert("Chọn ảnh trước!");
      return;
    }

    // ✅ Đọc file thành ArrayBuffer ngay lập tức
    const arrayBuffer = await file.arrayBuffer();
    const blob = new Blob([arrayBuffer], { type: file.type });

    const formData = new FormData();
    formData.append("productImage", blob, file.name);

    const res = await fetch(`/api/products/${id}/image`, {
      method: "POST",
      body: formData,
    });

    if (!res.ok) {
      const text = await res.text();
      console.error("Upload lỗi:", text);
      alert("Upload thất bại!");
      return;
    }

    await res.json().catch(() => null);
    alert("Upload OK");
    showPlace(currentMachine);
  } catch (err) {
    console.error("❌ Upload crash:", err);
    alert("Lỗi upload: " + err.message);
  }
}

// ========== STOCK ==========
async function loadStockCurrent() {
  if (!currentMachine) return;
  try {
    const res = await fetch(`/api/machines/${currentMachine.id}/stock`);
    const data = await res.json();
    renderStock(data.products);
    renderMaxStock(data.products);
    document.getElementById("totalStockNote").innerText =
      `Tổng: ${data.total.total_stock} / ${data.total.total_slot}`;
    document.getElementById("navMachineName").innerText = currentMachine.name;
  } catch (err) {}
}

async function updateMaxStock() {
  const inputs = document.querySelectorAll("#nav-maxstock input");
  let total = 0;
  let products = [];
  inputs.forEach((i) => {
    const value = parseInt(i.value) || 0;
    total += value;
    products.push({ id: i.id.replace("max-", ""), max_slot: value });
  });
  if (total > 250) {
    alert("Tổng max stock không được vượt quá 250!");
    return;
  }
  try {
    const res = await fetch("/api/products/maxstock", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ products }),
    });
    if (!res.ok) {
      const text = await res.text();
      console.error(text);
      alert("Lỗi server!");
      return;
    }
    alert("Cập nhật thành công!");
    loadNavData();
  } catch (err) {}
}

function updateTotalMaxStock() {
  const inputs = document.querySelectorAll("#nav-maxstock input");
  let total = 0;
  inputs.forEach((i) => {
    total += parseInt(i.value) || 0;
  });
  document.getElementById("maxstock-total").innerText = `Tổng: ${total} / 250`;
}

// ========== REPORT / SALES ==========
async function submitReport() {
  try {
    if (!currentMachine) {
      alert("Chưa chọn máy!");
      return;
    }
    const inputs = document.querySelectorAll("#reportList input");
    let reportData = [];
    inputs.forEach((i) => {
      const qty = parseInt(i.value) || 0;
      if (qty > 0)
        reportData.push({
          product_id: i.id.replace("report-", ""),
          quantity: qty,
        });
    });
    if (reportData.length === 0) {
      alert("Chưa nhập dữ liệu!");
      return;
    }
    const res = await fetch(`/api/report/${currentMachine.id}`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ items: reportData }),
    });
    if (!res.ok) {
      const text = await res.text();
      console.error("Lỗi server:", text);
      alert("Lỗi báo cáo!");
      return;
    }
    const data = await res.json();
    console.log("Report OK:", data);
    alert("Đã gửi báo cáo!");
    await loadStockCurrent();
    await loadNavData();
    showPlace(currentMachine);
    loadChart("7days");
    inputs.forEach((i) => (i.value = 0));
  } catch (err) {
    console.error("Lỗi submitReport:", err);
    alert("Có lỗi xảy ra!");
  }
}
