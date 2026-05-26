// ============================================================
// district.js — Phân vùng quận, GeoJSON, point-in-polygon
// ============================================================

// ========== GEO UTILS ==========
function pointInPolygon(point, vs) {
  const x = point[0],
    y = point[1];
  let inside = false;
  for (let i = 0, j = vs.length - 1; i < vs.length; j = i++) {
    const xi = vs[i][0],
      yi = vs[i][1];
    const xj = vs[j][0],
      yj = vs[j][1];
    const intersect =
      yi > y !== yj > y && x < ((xj - xi) * (y - yi)) / (yj - yi) + xi;
    if (intersect) inside = !inside;
  }
  return inside;
}

function findDistrict(lat, lng, geo) {
  for (const f of geo.features) {
    const name = f.properties.NAME_2;
    const coords = f.geometry.coordinates;
    for (const polygon of coords) {
      for (const ring of polygon) {
        if (pointInPolygon([lng, lat], ring)) return name;
      }
    }
  }
  return "Không rõ";
}

async function assignDistrictToMachines(machines) {
  const geo = await fetch("/hanoi_districts.geojson").then((r) => r.json());
  machines.forEach((m) => {
    m.district = findDistrict(m.lat, m.lng, geo);
  });
  return machines;
}

// ========== LOAD DISTRICTS ==========
async function loadDistricts() {
  const geo = await fetch("/hanoi_districts.geojson").then((res) => res.json());
  renderDistrictFilter(geo);

  districtLayer = L.geoJSON(geo, {
    style: () => ({ opacity: 0, fillOpacity: 0 }), // ẩn hết lúc đầu, updateDistrictBorders() sẽ vẽ lại
    onEachFeature: function (feature, layer) {
      const name = feature.properties.NAME_2;
      districtLayers[name] = layer;
      layer.bindPopup("Quận: " + name);
      layer.on({
        mouseover: (e) => e.target.setStyle({ weight: 4, fillOpacity: 0.15 }),
        mouseout: () => updateDistrictBorders(),
      });
    },
  }).addTo(map); // ✅ addTo map nhưng tất cả opacity = 0

  districtVisible = false;
}

// ✅ Hàm mới — vẽ ranh giới chỉ những quận có máy, gọi sau khi machinesData sẵn sàng
function updateDistrictBorders() {
  if (!districtLayer) return;
  const countMap = countMachinesByDistrict(machinesData);
  const checked = Array.from(
    document.querySelectorAll("#districtFilter input:checked"),
  ).map((cb) => cb.value);

  Object.entries(districtLayers).forEach(([name, layer]) => {
    const hasMachines = (countMap[name] || 0) > 0;
    if (!hasMachines) {
      layer.setStyle({ opacity: 0, fillOpacity: 0 });
    } else if (districtVisible && checked.includes(name)) {
      layer.setStyle({
        color: "#0d47a1",
        weight: 3,
        fillColor: "#2196f3",
        fillOpacity: 0.4,
      });
    } else {
      // ✅ Chỉ ranh giới cam, không tô nền
      layer.setStyle({
        color: "#ff5500",
        weight: 2,
        fillOpacity: 0,
        opacity: 1,
      });
    }
  });
}

function resetDistrictStyle() {
  Object.values(districtLayers).forEach((layer) =>
    districtLayer.resetStyle(layer),
  );
}

function toggleDistrictLayer() {
  if (districtVisible) {
    map.removeLayer(districtLayer);
    districtVisible = false;
  } else {
    districtLayer.addTo(map);
    districtVisible = true;
    // Cập nhật lại style theo checkbox đang chọn
    applyDistrictFilter();
  }
}

// ========== FILTER ==========
function countMachinesByDistrict(data) {
  const countMap = {};
  data.forEach((m) => {
    if (!m.district) return;
    countMap[m.district] = (countMap[m.district] || 0) + 1;
  });
  return countMap;
}

function renderDistrictFilter(geo) {
  const box = document.getElementById("districtFilter");
  const countMap = countMachinesByDistrict(machinesData);
  allDistricts = geo.features.map((f) => f.properties.NAME_2);

  box.innerHTML = allDistricts
    .filter((d) => (countMap[d] || 0) > 0)
    .map(
      (d) =>
        `<label><input type="checkbox" value="${d}" checked>${d} (${countMap[d]})</label><br>`,
    )
    .join("");

  box
    .querySelectorAll("input")
    .forEach((cb) => cb.addEventListener("change", applyDistrictFilter));
}

function applyDistrictFilter() {
  const filtered = getFilteredMachines();
  renderMarkers(filtered);
  renderMachineList(filtered);

  if (!districtVisible) return; // ✅ nếu layer đang tắt thì không làm gì

  const checked = Array.from(
    document.querySelectorAll("#districtFilter input:checked"),
  ).map((cb) => cb.value);
  const countMap = countMachinesByDistrict(machinesData);

  Object.entries(districtLayers).forEach(([name, layer]) => {
    const hasMachines = (countMap[name] || 0) > 0;
    if (!hasMachines) {
      layer.setStyle({ opacity: 0, fillOpacity: 0 }); // ẩn quận không có máy
    } else if (checked.includes(name)) {
      layer.setStyle({
        fillColor: "#2196f3",
        fillOpacity: 0.4,
        weight: 3,
        color: "#0d47a1",
      }); // tô xanh quận đang lọc
    } else {
      layer.setStyle({
        color: "#ff5500",
        weight: 2,
        fillOpacity: 0,
        opacity: 1,
      }); // chỉ ranh giới
    }
  });
}

function updateDistrictHighlight() {
  const checked = [
    ...document.querySelectorAll("#districtFilter input:checked"),
  ].map((c) => c.value);
  districtLayer.eachLayer((layer) => {
    const districtName = layer.feature.properties.name;
    if (checked.includes(districtName)) {
      layer.setStyle({ fillColor: "#4CAF50", fillOpacity: 0.4, weight: 2 });
    } else {
      layer.setStyle({ fillColor: "#ccc", fillOpacity: 0.1, weight: 1 });
    }
  });
}

function checkAllDistrict() {
  document
    .querySelectorAll("#districtFilter input")
    .forEach((c) => (c.checked = true));
  updateDistrictHighlight();
}

function uncheckAllDistrict() {
  document
    .querySelectorAll("#districtFilter input")
    .forEach((c) => (c.checked = false));
  updateDistrictHighlight();
}
