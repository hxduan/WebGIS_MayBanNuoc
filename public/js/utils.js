// ============================================================
// utils.js — Hàm tiện ích dùng chung
// ============================================================

function highlight(text, keyword) {
  if (!keyword) return text;
  const re = new RegExp(`(${keyword})`, "gi");
  return text.replace(re, `<span style="color:red">$1</span>`);
}

function timeAgo(date) {
  if (!date) return "Chưa có dữ liệu";
  const diff = (Date.now() - new Date(date)) / 1000;
  if (diff < 60) return "vừa xong";
  if (diff < 3600) return Math.floor(diff / 60) + " phút trước";
  if (diff < 86400) return Math.floor(diff / 3600) + " giờ trước";
  return Math.floor(diff / 86400) + " ngày trước";
}

function renderStatus(status) {
  if (status === "Hoạt động") return `<span style="color:green">🟢 Hoạt động</span>`;
  if (status === "Lỗi") return `<span style="color:red">🔴 Lỗi</span>`;
  return `<span style="color:gray">⚪ Offline</span>`;
}

function getFilteredMachines() {
  const checkedDistricts = Array.from(document.querySelectorAll("#districtFilter input:checked")).map((cb) => cb.value);
  const selectedTypes = Array.from(document.querySelectorAll("#categoryFilter input:checked")).map((cb) => cb.value.toLowerCase());

  return machinesData.filter((m) => {
    if (checkedDistricts.length > 0 && !checkedDistricts.includes(m.district)) return false;
    if (selectedTypes.length > 0) {
      if (!m.type) return false;
      const t = m.type.toLowerCase();
      if (!selectedTypes.some((type) => t.includes(type))) return false;
    }
    return true;
  });
}
