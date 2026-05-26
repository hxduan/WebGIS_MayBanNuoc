// ============================================================
// map.js — Icon, Marker, Label trên bản đồ
// ============================================================

// ========== ICONS ==========
const iconTraSua = L.icon({
  iconUrl: "/icons/trasua.png",
  iconSize: [32, 32],
  iconAnchor: [16, 32],
});
const iconNuocNgot = L.icon({
  iconUrl: "/icons/nuocep.png",
  iconSize: [32, 32],
  iconAnchor: [16, 32],
});
const iconCafe = L.icon({
  iconUrl: "/icons/cafe.png",
  iconSize: [32, 32],
  iconAnchor: [16, 32],
});
const iconGiaiKhat = L.icon({
  iconUrl: "/icons/giaikhat.png",
  iconSize: [32, 32],
  iconAnchor: [16, 32],
});

function getIcon(type) {
  if (!type) return iconNuocNgot;
  const t = type.toLowerCase().trim();
  if (t.includes("trà") || t.includes("sữa")) return iconTraSua;
  if (t.includes("giải khát")) return iconGiaiKhat;
  if (t.includes("nước ép") || t.includes("nuoc ep")) return iconNuocNgot;
  if (t.includes("cafe") || t.includes("cà phê")) return iconCafe;
  return iconNuocNgot;
}

function createStockIcon(type, lowStock) {
  let iconUrl = "/icons/cafe.png";
  if (type === "Trà sữa") iconUrl = "/icons/trasua.png";
  if (type === "Nước ép") iconUrl = "/icons/nuocep.png";
  if (type === "Giải khát") iconUrl = "/icons/giaikhat.png";

  return L.divIcon({
    html: `<div class="machine-marker"><img src="${iconUrl}">${lowStock ? '<span class="stock-dot"></span>' : ""}</div>`,
    className: "",
    iconSize: [32, 32],
    iconAnchor: [16, 32],
  });
}

// ========== RENDER MARKERS ==========
function renderMarkers(data) {
  markers.forEach((m) => map.removeLayer(m));
  markers = [];

  data.forEach((p) => {
    if (!p || p.lat == null || p.lng == null) {
      console.warn("Machine lỗi:", p);
      return;
    }

    // Main marker
    const marker = L.marker([p.lat, p.lng], { icon: getIcon(p.type) }).addTo(
      map,
    );
    marker.data = p;

    marker.on("click", () => {
      currentMachine = p;
      showPlace(p);
      switchSidebar("detail");

      document
        .querySelectorAll(".machine-item")
        .forEach((item) => item.classList.remove("active"));
      const target = document.querySelector(`.machine-item[data-id="${p.id}"]`);
      if (target) {
        target.classList.add("active");
        target.scrollIntoView({ behavior: "smooth", block: "center" });
      }
      map.flyTo([p.lat, p.lng], 17, { duration: 0.8 });
    });

    markers.push(marker);

    // Label
    const labelIcon = L.divIcon({
      className: "machine-label",
      html: `<div class="label-text">${p.name}</div>`,
      iconSize: [100, 20],
      iconAnchor: [50, 40],
    });
    const labelMarker = L.marker([p.lat, p.lng], {
      icon: labelIcon,
      interactive: false,
    }).addTo(map);
    markers.push(labelMarker);

    // Error / stock icon
    if (p.status === "Lỗi") {
      const iconDiv = L.divIcon({
        html: `<div style="position:absolute;top:-10px;right:-10px;background:red;color:white;width:20px;height:20px;border-radius:50%;font-size:14px;display:flex;justify-content:center;align-items:center;">!</div>`,
      });
      markers.push(
        L.marker([p.lat, p.lng], { icon: iconDiv, interactive: false }).addTo(
          map,
        ),
      );
    } else if (p.has_out_of_stock === true || p.has_out_of_stock === "t") {
      const stockIcon = L.divIcon({
        html: `<div style="position:absolute;top:-8px;right:-8px;width:12px;height:12px;background:orange;border-radius:50%;border:2px solid white;"></div>`,
        className: "",
      });
      markers.push(
        L.marker([p.lat, p.lng], { icon: stockIcon, interactive: false }).addTo(
          map,
        ),
      );
    }

    if (p.has_out_of_stock && p.status !== "Lỗi") {
      const stockIcon = L.divIcon({
        html: `<div style="position:absolute;top:-8px;right:-8px;background:orange;width:12px;height:12px;border-radius:50%;border:2px solid white;"></div>`,
        className: "",
      });
      markers.push(
        L.marker([p.lat, p.lng], { icon: stockIcon, interactive: false }).addTo(
          map,
        ),
      );
    }
  });
}

// ========== MAP EVENTS ==========
map.on("zoomend", () => {
  const zoom = map.getZoom();
  const scale = Math.max(0.5, Math.min(1, zoom / 18));
  document.querySelectorAll(".label-text").forEach((el) => {
    el.style.transform = `translateY(-10px) scale(${scale})`;
  });
});

map.on("click", async function (e) {
  // Di chuyển máy
  if (movingMachine) {
    const lat = e.latlng.lat;
    const lng = e.latlng.lng;
    await fetch(`/api/machines/${movingMachine.id}/move`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ lat, lng }),
    });
    alert("✅ Đã di chuyển máy!");
    movingMachine = null;
    loadPlaces();
    return;
  }

  // Thêm máy mới
  if (!addingMachine) return;
  newLatLng = e.latlng;
  if (tempMarker) map.removeLayer(tempMarker);
  tempMarker = L.marker([newLatLng.lat, newLatLng.lng]).addTo(map);
  document.getElementById("addMachinePopup").classList.remove("hidden");
  addingMachine = false;
});

// ========== MAP UTILS ==========
function getRoute() {
  if (!currentMachine) {
    alert("Chọn máy trước!");
    return;
  }
  navigator.geolocation.getCurrentPosition(function (pos) {
    const userLat = pos.coords.latitude;
    const userLng = pos.coords.longitude;
    if (routingControl) map.removeControl(routingControl);
    routingControl = L.Routing.control({
      waypoints: [
        L.latLng(userLat, userLng),
        L.latLng(currentMachine.lat, currentMachine.lng),
      ],
    }).addTo(map);
  });
}

function closeRoute() {
  if (routingControl) {
    map.removeControl(routingControl);
    routingControl = null;
  }
}

function getLocation() {
  navigator.geolocation.getCurrentPosition((pos) => {
    const lat = pos.coords.latitude;
    const lng = pos.coords.longitude;
    map.setView([lat, lng], 16);
    if (userMarker) map.removeLayer(userMarker);
    userMarker = L.marker([lat, lng]).addTo(map);
  });
}
// ========== GỢI Ý VỊ TRÍ ĐẶT MÁY ==========
let suggestMarkers = [];
let suggestVisible = false;

async function toggleSuggestLocations() {
  const btn = document.getElementById("suggestBtn");

  // Nếu đang hiện → ẩn đi
  if (suggestVisible) {
    suggestMarkers.forEach((m) => map.removeLayer(m));
    suggestMarkers = [];
    suggestVisible = false;
    btn.innerText = "💡 Gợi ý đặt máy";
    return;
  }

  const res = await fetch("/api/suggest-locations");
  const data = await res.json();

  if (!data.length) {
    alert("Chưa có dữ liệu hết hàng để gợi ý!");
    return;
  }

  data.forEach((m, i) => {
    // Vẽ vòng tròn vùng nhu cầu cao
    const circle = L.circle([m.lat, m.lng], {
      radius: 400,
      color: "#ff6b35",
      fillColor: "#ff6b35",
      fillOpacity: 0.15,
      weight: 2,
      dashArray: "6,4",
    }).addTo(map);
    circle.bindTooltip(
      `🔥 ${m.name}<br>Hết hàng: ${m.out_of_stock_count} lần<br>→ Nên đặt thêm máy khu vực này`,
      { permanent: false, direction: "top" },
    );
    suggestMarkers.push(circle);

    // Vẽ điểm gợi ý lệch ~300m về phía đông bắc
    const offset = 0.003 * (i % 2 === 0 ? 1 : -1);
    const suggestLat = m.lat + offset;
    const suggestLng = m.lng + offset;

    const pin = L.marker([suggestLat, suggestLng], {
      icon: L.divIcon({
        html: `<div style="background:#ff6b35;color:white;border-radius:50%;width:32px;height:32px;display:flex;align-items:center;justify-content:center;font-size:18px;border:2px solid white;box-shadow:0 2px 6px rgba(0,0,0,0.3)">💡</div>`,
        className: "",
        iconSize: [32, 32],
        iconAnchor: [16, 32],
      }),
    }).addTo(map);
    pin.bindTooltip(
      `💡 Gợi ý #${i + 1}<br>Gần: ${m.name}<br>Hết hàng ${m.out_of_stock_count} lần`,
      { direction: "top" },
    );
    suggestMarkers.push(pin);
  });

  suggestVisible = true;
  btn.innerText = "✕ Ẩn gợi ý";
  map.setView([data[0].lat, data[0].lng], 14);
}
