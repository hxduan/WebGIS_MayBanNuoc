// ============================================================
// stats.js — Dashboard, thống kê doanh thu, lịch sử
// ============================================================
let allHistoryData = [];
async function loadDashboard() {
  try {
    const data = await fetch("/api/dashboard").then((r) => r.json());
    const m = data.machines;
    if (!m) return; // ✅ tránh crash nếu API trả về lỗi

    const setEl = (id, val) => {
      const el = document.getElementById(id);
      if (el) el.innerText = val; // ✅ tránh crash nếu element chưa có trong HTML
    };

    setEl("totalMachines", m.total ?? 0);
    setEl("activeMachines", m.active ?? 0);
    setEl("errorMachines", m.error ?? m.inactive ?? 0); // ✅ fallback sang inactive nếu server chưa sửa
    setEl("offlineMachines", (m.total ?? 0) - (m.active ?? 0));
  } catch (err) {
    console.error("❌ dashboard lỗi:", err);
  }
}

async function loadSystemRevenue() {
  const res = await fetch("/api/system/revenue");
  const data = await res.json();
  document.getElementById("sysToday").innerText = Number(
    data.today || 0,
  ).toLocaleString();
  document.getElementById("sysMonth").innerText = Number(
    data.month || 0,
  ).toLocaleString();
  document.getElementById("sysYear").innerText = Number(
    data.year || 0,
  ).toLocaleString();
}

async function loadOverview() {
  if (!currentMachine) return;
  try {
    const res = await fetch(`/api/stats/overview/${currentMachine.id}`);
    const data = await res.json();
    const today = Number(data.today) || 0;
    const month = Number(data.month) || 0;
    const total = Number(data.total) || 0;
    document.getElementById("ovToday").innerText =
      today.toLocaleString() + " đ";
    document.getElementById("ovMonth").innerText =
      month.toLocaleString() + " đ";
    document.getElementById("ovTotal").innerText = total.toLocaleString();
    document.getElementById("ovTop").innerText = data.top
      ? data.top.name
      : "Chưa có";
  } catch (err) {
    console.error("❌ lỗi overview:", err);
  }
}

async function loadHistory(machineId) {
  const res = await fetch(`/api/logs/${machineId}/all`);
  allHistoryData = await res.json();

  // Lần tiếp hàng gần nhất
  const latestRefill = allHistoryData.find((l) => l.action === "refill");
  document.getElementById("latestRefill").innerText = latestRefill
    ? new Date(latestRefill.created_at).toLocaleString("vi-VN")
    : "Chưa có lần tiếp hàng nào";

  renderHistoryList(allHistoryData);
}
function filterHistory(type, btn) {
  // Cập nhật active button
  document
    .querySelectorAll(".history-filter-btn")
    .forEach((b) => b.classList.remove("active"));
  btn.classList.add("active");

  const filtered =
    type === "all"
      ? allHistoryData
      : allHistoryData.filter((l) => l.action === type);

  renderHistoryList(filtered);
}
function renderHistoryList(logs) {
  const actionMap = {
    refill: { icon: "📦", color: "#e3f2fd", label: "Tiếp hàng" },
    error: { icon: "⚠️", color: "#fff3e0", label: "Báo lỗi" },
    fix: { icon: "🔧", color: "#e8f5e9", label: "Sửa xong" },
    report: { icon: "📋", color: "#f3e5f5", label: "Báo cáo" },
    sale: { icon: "🛒", color: "#e8f5e9", label: "Mua hàng" },
  };

  const box = document.getElementById("allHistoryList");

  if (!logs.length) {
    box.innerHTML =
      "<p style='text-align:center;color:#aaa;padding:12px;font-size:12px'>Chưa có thao tác nào</p>";
    return;
  }

  box.innerHTML = logs
    .map((l) => {
      const info = actionMap[l.action] || {
        icon: "📝",
        color: "#f5f5f5",
        label: l.action,
      };
      return `
      <div class="history-log-item">
        <div class="history-log-icon" style="background:${info.color}">${info.icon}</div>
        <div class="history-log-body">
          <div class="history-log-note">${info.label} — ${l.note}</div>
          <div class="history-log-time">${new Date(l.created_at).toLocaleString("vi-VN")}</div>
        </div>
      </div>`;
    })
    .join("");
}
async function loadNavData() {
  if (!currentMachine) return;
  try {
    const res = await fetch(`/api/machines/${currentMachine.id}/stock`);
    const data = await res.json();
    document.getElementById("nav-title").innerText =
      "Máy: " + currentMachine.name;
    renderNavStock(data.products);
    renderNavReport(data.products);
  } catch (err) {}
}

async function filterHot(type) {
  const data = await fetch(`/api/machines/hot?type=${type}`).then((res) =>
    res.json(),
  );
  const filtered = data.filter((m) => {
    const machines = getFilteredMachines();
    return machines.some((x) => x.id === m.id);
  });
  renderMarkers(filtered);
  renderHotList(filtered);
}
