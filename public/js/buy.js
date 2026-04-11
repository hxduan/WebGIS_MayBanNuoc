// Cấu hình địa chỉ Server Backend
const HOST = "http://localhost:3000";

// Ảnh mặc định dùng mã SVG để không bao giờ bị lỗi load ảnh
const DEFAULT_IMG =
  "data:image/svg+xml;charset=UTF-8,%3Csvg%20width%3D%2270%22%20height%3D%2270%22%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3E%3Crect%20width%3D%22100%25%22%20height%3D%22100%25%22%20fill%3D%22%23eee%22%2F%3E%3Ctext%20x%3D%2250%25%22%20y%3D%2250%25%22%20font-family%3D%22Arial%22%20font-size%3D%2210%22%20fill%3D%22%23aaa%22%20text-anchor%3D%22middle%22%20dy%3D%22.3em%22%3ENo%20Image%3C%2Ftext%3E%3C%2Fsvg%3E";

let allMachines = [];

// 1. Khởi tạo dữ liệu
async function init() {
  try {
    const res = await fetch(`${HOST}/api/machines`);
    if (!res.ok) throw new Error("Server không phản hồi");
    allMachines = await res.json();
    console.log("✅ Đã tải dữ liệu máy thành công");
  } catch (err) {
    console.error("❌ Lỗi kết nối:", err);
  }
}

// 2. Hàm tìm kiếm máy (Đã fix lỗi ReferenceError)
async function handleSearch() {
  const keyword = document
    .getElementById("searchInput")
    .value.trim()
    .toLowerCase();
  const machineDetail = document.getElementById("machineDetail");
  const productList = document.getElementById("productList");
  const welcomeNote = document.getElementById("welcomeNote");

  if (!keyword) {
    machineDetail.style.display = "none";
    productList.innerHTML = "";
    welcomeNote.style.display = "block";
    return;
  }

  const found = allMachines.find(
    (m) => m.name && m.name.toLowerCase().includes(keyword),
  );

  if (found) {
    welcomeNote.style.display = "none";
    machineDetail.style.display = "block";
    document.getElementById("mName").innerText = found.name;
    document.getElementById("mStatus").innerText =
      "Trạng thái: " + found.status;
    loadMachineProducts(found.id, found.status);
  } else {
    machineDetail.style.display = "none";
    productList.innerHTML = "";
    welcomeNote.style.display = "block";
    welcomeNote.innerText = "Không tìm thấy máy này.";
  }
}

// 3. Tải sản phẩm
async function loadMachineProducts(machineId, status) {
  try {
    const res = await fetch(`${HOST}/api/machine/${machineId}`);
    const data = await res.json();
    renderUI(data.products, machineId, status);
  } catch (err) {
    console.error("❌ Lỗi tải sản phẩm:", err);
  }
}

// 4. Hiển thị UI
// Trong hàm renderUI của buy.js, hãy đảm bảo bạn truyền đúng p.id
// p.id trong bảng của bạn chính là ID duy nhất của dòng đó

function renderUI(products, machineId, status) {
  const list = document.getElementById("productList");
  if (!products || products.length === 0) {
    list.innerHTML = "<p>Máy trống.</p>";
    return;
  }

  list.innerHTML = products
    .map((p) => {
      const imageURL = p.image ? `${HOST}${p.image}` : DEFAULT_IMG;
      return `
        <div class="product-card" style="display: flex; align-items: center; margin-bottom: 10px; border: 1px solid #ddd; padding: 10px; border-radius: 8px;">
            <img src="${imageURL}" onerror="this.src='${DEFAULT_IMG}'" style="width: 70px; height: 70px; object-fit: cover; margin-right: 15px;">
            <div style="flex:1">
                <strong>${p.name}</strong><br>
                <span style="color: #e67e22; font-weight: bold;">${Number(p.price).toLocaleString()}đ</span><br>
                <small>Kho: ${p.stock}</small>
            </div>
            
            <div style="margin-right: 15px;">
                <input type="number" id="qty_${p.id}" value="1" min="1" max="${p.stock}" 
                    style="width: 50px; padding: 5px; border-radius: 4px; border: 1px solid #ccc;">
            </div>

            <button class="buy-btn" 
                ${p.stock <= 0 || status !== "Hoạt động" ? "disabled" : ""} 
                onclick="executeBuy(${p.id}, '${p.name}', ${machineId})">
                Mua
            </button>
        </div>`;
    })
    .join("");
}

// 5. Thanh toán (Khớp bảng Sales của bạn)
async function executeBuy(productId, productName, machineId) {
  // Lấy số lượng từ ô input tương ứng
  const quantityInput = document.getElementById(`qty_${productId}`);
  const quantity = parseInt(quantityInput.value);

  if (isNaN(quantity) || quantity <= 0) {
    alert("Vui lòng nhập số lượng hợp lệ!");
    return;
  }

  if (!confirm(`Xác nhận mua ${quantity} ${productName}?`)) return;

  try {
    const response = await fetch(`${HOST}/api/sales`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        machine_id: Number(machineId),
        items: [
          {
            product_id: Number(productId),
            quantity: quantity, // Gửi số lượng người dùng đã chọn
          },
        ],
      }),
    });

    const result = await response.json();
    if (response.ok) {
      alert(`✅ Đã mua thành công ${quantity} ${productName}!`);
      loadMachineProducts(machineId, "Hoạt động"); // Cập nhật lại kho
    } else {
      alert("❌ Lỗi: " + result.error);
    }
  } catch (err) {
    alert("Lỗi kết nối server!");
  }
}

// Gọi khởi tạo
init();
