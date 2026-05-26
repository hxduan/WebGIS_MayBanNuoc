// ========== SEARCH ==========
document.getElementById("searchInput").addEventListener("input", function () {
  const q = this.value.toLowerCase().trim();
  if (q === "") {
    renderMarkers(machinesData);
    renderMachineList(machinesData);
    return;
  }
  const base = getFilteredMachines();
  const filtered = base.filter((m) => {
    const hasOut = m.has_out_of_stock === true || m.has_out_of_stock === "t";
    if (q.includes("lỗi") || q.includes("loi")) return m.status === "Lỗi";
    if (q.includes("hết") || q.includes("het")) return hasOut;
    return (
      m.name.toLowerCase().includes(q) ||
      (m.type && m.type.toLowerCase().includes(q))
    );
  });
  renderMarkers(filtered);
  renderMachineList(filtered);
});

// ========== CATEGORY FILTER ==========
function filterCategoryMulti() {
  const selectedTypes = Array.from(
    document.querySelectorAll("#categoryFilter input:checked"),
  ).map((cb) => cb.value.toLowerCase());
  if (selectedTypes.length === 0) {
    renderMarkers([]);
    renderMachineList([]);
    return;
  }
  const filtered = getFilteredMachines();
  renderMarkers(filtered);
  renderMachineList(filtered);
}

document.querySelectorAll("#categoryFilter input").forEach((cb) => {
  cb.addEventListener("change", filterCategoryMulti);
});

// ========== INIT ==========
document.getElementById("addMachinePopup").classList.add("hidden");
loadPlaces();
loadDistricts();
loadDashboard();
loadSystemRevenue();
loadOutOfStockMachines();
