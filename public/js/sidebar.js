// ============================================================
// sidebar.js — Render sidebar trái/phải, tabs, so sánh máy
// ============================================================

// ========== RENDER UI ==========
function renderMachineList(data) {
  const box = document.getElementById("machineList");
  if (!data || data.length === 0) {
    box.innerHTML = "<p style='padding:10px'>❌ Không tìm thấy máy</p>";
    return;
  }

  box.innerHTML = data
    .map(
      (m) => `
    <div class="machine-item ${currentMachine && currentMachine.id === m.id ? "active" : ""}" 
         data-id="${m.id}" onclick="focusMachine(${m.id}, this)">
      <div class="machine-row">
        <div class="machine-info">
          <div class="machine-name">
            ${m.status === "Lỗi" ? "<span class='dot-red'></span>" : m.has_out_of_stock === true || m.has_out_of_stock === "t" ? "<span class='dot-orange'></span>" : ""}
            ${highlight(m.name, document.getElementById("searchInput").value)}
          </div>
          <div class="machine-type">Loại: ${m.type}</div>
        </div>
        <div style="display:flex;gap:6px">
          <div class="machine-move" onclick="startMoveMachine(${m.id}, event)">Di chuyển</div>
          <div class="machine-delete" onclick="deleteMachine(${m.id}, event)">✖</div>
        </div>
      </div>
    </div>
  `,
    )
    .join("");
}

function renderOverview(data) {
  const p = data.machine;
  document.getElementById("overviewImg").src =
    p.image || "https://picsum.photos/600/300";
  document.getElementById("machineName").innerHTML =
    `${p.status === "Lỗi" ? "<span style='color:red'>●</span> " : ""}${p.name}`;
  document.getElementById("machineStatus").innerText =
    p.status === "Lỗi" ? "Trạng thái: 🔴 Lỗi" : "Trạng thái: 🟢 Hoạt động";
  document.getElementById("machineType").innerText = "Loại: " + p.type;

  document.getElementById("productList").innerHTML = data.products
    .map(
      (p) => `
    <div class="product-card">
      <img class="product-img" src="${p.image || "https://via.placeholder.com/50"}">
      <div class="product-info">
        <div class="product-name">${p.name}</div>
        <div class="product-price">${p.price}đ</div>
      </div>
      <input type="file" id="img-${p.id}" accept="image/*" style="display:none" onchange="uploadProductImage(${p.id})">
<button onclick="document.getElementById('img-${p.id}').click()">📷 Tải ảnh</button>
      <div class="product-actions">
        <span onclick="editProduct(${p.id})">Sửa</span>
        <span onclick="deleteProduct(${p.id})">Xóa</span>
      </div>
    </div>
  `,
    )
    .join("");

  if (userMarker) {
    const distance = map.distance(
      userMarker.getLatLng(),
      L.latLng(p.lat, p.lng),
    );
    document.getElementById("overviewDistance").innerText =
      "📍 Cách bạn: " + (distance / 1000).toFixed(2) + " km";
  }
  loadReport(data.products);
}

function renderStock(products) {
  const html = products
    .map((p) => {
      let color = "green";
      if (p.stock < 3) color = "red";
      else if (p.stock < 10) color = "orange";
      return `
      <div class="stock-card">
        <div class="stock-header"><span>${p.name}</span><span>${p.stock}/${p.max_slot}</span></div>
        <div class="stock-bar"><div class="stock-fill" style="width:${p.percent}%; background:${color}"></div></div>
      </div>`;
    })
    .join("");
  document.getElementById("stock-list").innerHTML = html;
}

function renderNavStock(products) {
  const html = products
    .map((p) => {
      const percent = Math.round((p.stock / p.max_slot) * 100);
      let color = "#4a6cf7";
      if (percent < 30) color = "red";
      else if (percent < 60) color = "orange";
      return `
      <div class="stock-item">
        <div>${p.name} (${p.stock}/${p.max_slot})</div>
        <div class="stock-bar"><div class="stock-fill" style="width:${percent}%; background:${color}"></div></div>
      </div>`;
    })
    .join("");
  document.getElementById("nav-stock-list").innerHTML = html;
}

function renderHotList(data) {
  const box = document.getElementById("machineList");
  if (!data || data.length === 0) {
    box.innerHTML = "<p style='padding:10px'>Không có dữ liệu</p>";
    return;
  }
  box.innerHTML = data
    .map(
      (m, index) => `
    <div class="machine-item" onclick="focusMachine(${m.id})">
      <div class="machine-row">
        <div class="machine-info">
          <div class="machine-name">🔥 #${index + 1} - ${m.name}</div>
          <div class="machine-type">📦 Đã bán: ${m.total_sold || 0}</div>
        </div>
        <div class="machine-delete" onclick="deleteMachine(${m.id}, event)">✖</div>
      </div>
    </div>
  `,
    )
    .join("");
}

function renderStatus(status) {
  if (status === "Hoạt động")
    return `<span style="color:green">🟢 Hoạt động</span>`;
  if (status === "Lỗi") return `<span style="color:red">🔴 Lỗi</span>`;
  return `<span style="color:gray">⚪ Offline</span>`;
}

function loadReport(products) {
  const box = document.getElementById("reportList");
  box.innerHTML = products
    .map(
      (p) => `
    <div style="display:flex;justify-content:space-between;align-items:center;margin:8px 0;padding:8px;background:#f5f5f5;border-radius:8px">
      <div><strong>${p.name}</strong><br><span style="font-size:12px;color:#666">${p.price}đ</span></div>
      <input type="number" min="0" value="0" id="report-${p.id}" style="width:80px;padding:5px;border-radius:6px;border:1px solid #ccc">
    </div>
  `,
    )
    .join("");
}

// ========== UI CONTROL ==========
function switchSidebar(tab) {
  document
    .querySelectorAll(".sidebar-panel")
    .forEach((el) => (el.style.display = "none"));
  document.getElementById("sidebar-" + tab).style.display = "block";
  if (tab === "nav") loadNavData();
}

function openTab(tab) {
  document
    .querySelectorAll(".tab-content")
    .forEach((t) => t.classList.remove("active"));
  document.getElementById(tab).classList.add("active");
  if (tab === "chart" && currentMachine) {
    loadCompare("month");
    loadTopProducts("month");
  }
}

let sidebarHidden = false;
function toggleLeftSidebar() {
  const sidebar = document.getElementById("leftSidebar");
  const btn = document.getElementById("toggleSidebarBtn");
  sidebarHidden = !sidebarHidden;
  sidebar.classList.toggle("hidden", sidebarHidden);
  btn.innerText = sidebarHidden ? "➡" : "⬅";
  setTimeout(() => map.invalidateSize(), 300);
}

let rightSidebarHidden = false;
function toggleRightSidebar() {
  const sidebar = document.querySelector(".sidebar");
  const btn = document.getElementById("toggleRightSidebarBtn");
  rightSidebarHidden = !rightSidebarHidden;
  sidebar.classList.toggle("hidden", rightSidebarHidden);
  btn.innerText = rightSidebarHidden ? "⬅" : "➡";
  setTimeout(() => map.invalidateSize(), 300);
}

// ========== SO SÁNH MÁY ==========
async function addToCompare() {
  if (!currentMachine) {
    alert("Chọn máy trước!");
    return;
  }
  if (compareList.find((m) => m.id === currentMachine.id)) {
    alert("Máy đã có trong danh sách so sánh!");
    return;
  }
  if (compareList.length >= 2) {
    alert("Chỉ so sánh 2 máy!");
    return;
  }
  compareList.push(currentMachine);
  if (compareList.length === 2) showCompare();
}

async function showCompare() {
  const [p1, p2] = compareList;
  const [d1, d2] = await Promise.all([
    fetch(`/api/machine/${p1.id}`).then((r) => r.json()),
    fetch(`/api/machine/${p2.id}`).then((r) => r.json()),
  ]);
  const [s1, s2] = await Promise.all([
    fetch(`/api/stats/overview/${p1.id}`).then((r) => r.json()),
    fetch(`/api/stats/overview/${p2.id}`).then((r) => r.json()),
  ]);

  document.getElementById("c1Name").innerText = p1.name;
  document.getElementById("c2Name").innerText = p2.name;
  document.getElementById("c1Rating").innerText =
    Number(s1.today || 0).toLocaleString() + " đ";
  document.getElementById("c2Rating").innerText =
    Number(s2.today || 0).toLocaleString() + " đ";
  document.getElementById("c1Distance").innerText = userMarker
    ? (
        map.distance(userMarker.getLatLng(), L.latLng(p1.lat, p1.lng)) / 1000
      ).toFixed(2) + " km"
    : "—";
  document.getElementById("c2Distance").innerText = userMarker
    ? (
        map.distance(userMarker.getLatLng(), L.latLng(p2.lat, p2.lng)) / 1000
      ).toFixed(2) + " km"
    : "—";
  document.getElementById("c1Price").innerHTML = d1.products
    .map((p) => p.name)
    .join("<br>");
  document.getElementById("c2Price").innerHTML = d2.products
    .map((p) => p.name)
    .join("<br>");
  document.getElementById("c1Open").innerText = p1.status;
  document.getElementById("c2Open").innerText = p2.status;
  document.getElementById("compareBox").classList.remove("hidden");
}

function clearCompare() {
  compareList = [];
  document.getElementById("compareBox").classList.add("hidden");
}
