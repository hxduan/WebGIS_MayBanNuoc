// ============================================================
// heatmap.js — Bản đồ nhiệt
// ============================================================

async function loadHeatData(type = "month") {
  const res = await fetch(`/api/heatmap?type=${type}`);
  return await res.json();
}

// ✅ Fix: tránh NaN khi tất cả weight = 0
function normalizeHeatData(data) {
  const positive = data.filter((p) => p.weight > 0);
  if (positive.length === 0) return [];
  const max = Math.max(...positive.map((p) => p.weight));
  return positive.map((p) => [p.lat, p.lng, p.weight / max]);
}

// ✅ Cải tiến: gradient dễ đọc hơn trên nền bản đồ
function createHeatLayer(heatData) {
  return L.heatLayer(heatData, {
    radius: 35,
    blur: 20,
    maxZoom: 18,
    max: 0.04,
    gradient: {
      0.2: "#ffffb2",
      0.4: "#fecc5c",
      0.6: "#fd8d3c",
      0.8: "#f03b20",
      1.0: "#bd0026",
    },
  });
}

// ✅ Hiện badge loại thời gian đang xem
function showHeatBadge(type) {
  const labelMap = { day: "Hôm nay", month: "Tháng này", year: "Năm nay" };
  let badge = document.getElementById("heatBadge");
  if (!badge) {
    badge = document.createElement("span");
    badge.id = "heatBadge";
    badge.style.cssText =
      "background:#ff5722;color:white;padding:3px 10px;border-radius:999px;" +
      "font-size:11px;font-weight:600;margin-left:4px;vertical-align:middle;";
    document.querySelector(".header").prepend(badge);
  }
  badge.textContent = "🔥 " + labelMap[type];
  badge.style.display = "inline";
}

function hideHeatBadge() {
  const badge = document.getElementById("heatBadge");
  if (badge) badge.style.display = "none";
}

// ✅ Fix: phân biệt tắt vs đổi type; ẩn/hiện markers khi bật/tắt
async function toggleHeatMap(type = "day") {
  // Cùng type đang bật → tắt heatmap
  if (heatOn && heatCurrentType === type) {
    map.removeLayer(heatLayer);
    heatLayer = null;
    heatOn = false;
    heatCurrentType = null;
    // Hiện lại markers
    markers.forEach((m) => m.setOpacity(1));
    hideHeatBadge();
    renderMarkers(getFilteredMachines());
    return;
  }

  // Đổi sang type khác khi đang bật → xóa layer cũ
  if (heatOn && heatLayer) {
    map.removeLayer(heatLayer);
    heatLayer = null;
  }

  const rawData = await loadHeatData(type);
  const filteredMachines = getFilteredMachines();
  const filteredHeat = rawData.filter((h) =>
    filteredMachines.some((m) => m.lat === h.lat && m.lng === h.lng),
  );
  const heatData = normalizeHeatData(filteredHeat);

  // Không có dữ liệu → thông báo và dừng
  if (heatData.length === 0) {
    alert("Không có dữ liệu bán hàng trong khoảng thời gian này!");
    heatOn = false;
    heatCurrentType = null;
    markers.forEach((m) => m.setOpacity(1));
    hideHeatBadge();
    return;
  }

  heatLayer = createHeatLayer(heatData);
  heatLayer.addTo(map);
  heatOn = true;
  heatCurrentType = type;

  // Ẩn markers để bản đồ nhiệt rõ hơn
  markers.forEach((m) => m.setOpacity(0));
  showHeatBadge(type);
  renderMachineList(filteredMachines);
}
