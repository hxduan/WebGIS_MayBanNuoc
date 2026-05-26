// ============================================================
// machine.js — Thêm / Xóa / Sửa / Di chuyển / Tiếp hàng máy
// ============================================================

async function loadPlaces() {
  const res = await fetch("/api/machines");
  let data = await res.json();
  data = await assignDistrictToMachines(data);
  machinesData = data;
  renderMarkers(machinesData);
  renderMachineList(machinesData);
  const geo = await fetch("/hanoi_districts.geojson").then((r) => r.json());
  renderDistrictFilter(geo);
}

async function loadMachines() {
  let machines = await fetch("/api/machines").then((r) => r.json());
  machines = await assignDistrictToMachines(machines);
  machinesData = machines;
  renderMarkers(machines);
  renderMachineList(machines);
}

async function showPlace(place) {
  currentMachine = place;
  const res = await fetch(`/api/machine/${place.id}`);
  const data = await res.json();
  renderOverview(data);
  loadOverview();
  loadHistory(place.id);
  loadStockCurrent();
}

function focusMachine(id, el) {
  const m = machinesData.find((x) => x.id === id);
  if (!m) return;
  currentMachine = m;
  map.setView([m.lat, m.lng], 17);
  showPlace(m);
  switchSidebar("detail");
  document
    .querySelectorAll(".machine-item")
    .forEach((item) => item.classList.remove("active"));
  if (el) el.classList.add("active");
  scrollToMachine(id);
}

function scrollToMachine(id) {
  const el = document.querySelector(`.machine-item[data-id="${id}"]`);
  if (el) el.scrollIntoView({ behavior: "smooth", block: "center" });
}

function addMachine() {
  addingMachine = true;
  alert("Click lên bản đồ để chọn vị trí đặt máy");
}

async function saveNewMachine() {
  const name = document.getElementById("newName").value;
  const type = document.getElementById("newType").value;
  const status = document.getElementById("newStatus").value;
  if (!name || !newLatLng) {
    alert("Thiếu thông tin!");
    return;
  }

  await fetch("/api/machines", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      name,
      type,
      status,
      lat: newLatLng.lat,
      lng: newLatLng.lng,
    }),
  });

  cancelAddMachine();
  loadPlaces();
}

function cancelAddMachine() {
  document.getElementById("addMachinePopup").classList.add("hidden");
  if (tempMarker) {
    map.removeLayer(tempMarker);
    tempMarker = null;
  }
  newLatLng = null;
}

async function deleteMachine(id, e) {
  e.stopPropagation();
  if (!confirm("Xóa máy này?")) return;
  await fetch(`/api/machines/${id}`, { method: "DELETE" });
  loadMachines();
}

function startMoveMachine(id, e) {
  e.stopPropagation();
  movingMachine = machinesData.find((m) => m.id === id);
  alert("👉 Click lên bản đồ để chọn vị trí mới");
}

async function editMachine() {
  const newName = prompt("Tên mới:", currentMachine.name);
  if (!newName) return;
  await fetch(`/api/machines/${currentMachine.id}`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      name: newName,
      type: currentMachine.type,
      status: currentMachine.status,
      image: currentMachine.image,
    }),
  });
  loadPlaces();
  showPlace({ ...currentMachine, name: newName });
}

async function fixMachine() {
  await fetch(`/api/machines/${currentMachine.id}/fix`, { method: "POST" });
  loadPlaces();
  showPlace(currentMachine);
}

async function reportError() {
  await fetch(`/api/machines/${currentMachine.id}/error`, { method: "POST" });
  loadPlaces();
  showPlace(currentMachine);
}

async function refillMachine() {
  await fetch(`/api/machines/${currentMachine.id}/refill`, { method: "POST" });
  loadPlaces();
  showPlace(currentMachine);
}

async function changeImage() {
  try {
    const input = document.getElementById("machineImageInput");
    if (!input) {
      alert("Không tìm thấy input file");
      return;
    }
    const file = input.files[0];
    if (!file) {
      alert("Chọn ảnh trước!");
      return;
    }
    const formData = new FormData();
    formData.append("machineImage", file);
    const res = await fetch(`/api/machines/${currentMachine.id}/image`, {
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
    alert("Lỗi upload!");
  }
}

async function loadOutOfStockMachines() {
  const res = await fetch("/api/machines/out-of-stock");
  const data = await res.json();
  const box = document.getElementById("outOfStockList");
  if (!data.length) {
    box.innerHTML = "<p>✅ Không có máy hết hàng</p>";
    return;
  }
  box.innerHTML = data
    .map(
      (m) =>
        `<div class="out-stock-item" onclick="focusMachine(${m.id})">⚠️ ${m.name} (${m.out_count} SP hết)</div>`,
    )
    .join("");
}
