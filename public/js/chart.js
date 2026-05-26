// ============================================================
// chart.js — Biểu đồ doanh thu, sản phẩm, so sánh
// ============================================================

// ✅ Helper: ẩn/hiện canvas và placeholder — tránh xóa canvas khỏi DOM
function setChartEmpty(id, isEmpty) {
  const canvas = document.getElementById(id);
  const empty = document.getElementById(id + "-empty");
  if (canvas) canvas.style.display = isEmpty ? "none" : "block";
  if (empty) empty.style.display = isEmpty ? "block" : "none";
}
// ========== CHART MODE SWITCH ==========
function switchChartMode(type) {
  // Cập nhật active button
  ["btnDay", "btnMonth", "btnYear"].forEach((id) => {
    document.getElementById(id)?.classList.remove("active");
  });
  document
    .getElementById("btn" + type.charAt(0).toUpperCase() + type.slice(1))
    ?.classList.add("active");

  // Hiện/ẩn date picker
  document.getElementById("datePicker").style.display =
    type === "day" ? "block" : "none";

  if (type === "day") {
    // Set mặc định là hôm nay
    const today = new Date().toISOString().split("T")[0];
    document.getElementById("selectedDate").value = today;
    loadChartByDate();
  } else {
    loadCompare(type);
    loadChart(type === "month" ? "30days" : "7days");
  }
}

// Load biểu đồ theo ngày được chọn
async function loadChartByDate() {
  if (!currentMachine) return;
  const date = document.getElementById("selectedDate").value;
  if (!date) return;

  // Truyền date vào API — dùng range=month&month=YYYY-MM để lọc
  const [year, month] = date.split("-");
  const monthStr = `${year}-${month}`;

  // Load doanh thu và sản phẩm theo tháng chứa ngày đó
  await loadChart("month", monthStr);

  // Load compare theo ngày
  await loadCompare("day");
  await loadTopProducts("day");
}
// ========== RENDER CHARTS ==========
function renderTopProductChart(data) {
  const ctx = document.getElementById("topProductChart").getContext("2d");
  if (topProductChart) topProductChart.destroy();

  if (!data || data.length === 0) {
    setChartEmpty("topProductChart", true); // ✅ đúng id
    return;
  }
  setChartEmpty("topProductChart", false); // ✅ hiện canvas trước khi vẽ

  topProductChart = new Chart(ctx, {
    type: "bar",
    data: {
      labels: data.map((d) => d.name),
      datasets: [
        {
          label: "Số lượng bán",
          data: data.map((d) => d.total || 0),
          backgroundColor: "#4a90e2",
        },
      ],
    },
    options: {
      indexAxis: "y",
      plugins: {
        tooltip: { callbacks: { label: (ctx) => ctx.raw + " sản phẩm" } },
      },
    },
  });
}

function renderRevenueChart(data) {
  const ctx = document.getElementById("revenueChart").getContext("2d");
  if (revenueChart) revenueChart.destroy();

  if (!data || data.length === 0) {
    setChartEmpty("revenueChart", true); // ✅ đúng id
    return;
  }
  setChartEmpty("revenueChart", false); // ✅ hiện canvas trước khi vẽ

  revenueChart = new Chart(ctx, {
    type: "line",
    data: {
      labels: data.map((d) => d.date),
      datasets: [
        {
          label: "Doanh thu",
          data: data.map((d) => d.revenue),
          borderColor: "#4a90e2",
          backgroundColor: "rgba(74,144,226,0.1)",
          tension: 0.4,
          fill: true,
        },
      ],
    },
    options: {
      plugins: {
        tooltip: {
          callbacks: {
            label: (ctx) => Number(ctx.raw).toLocaleString("vi-VN") + " đ",
          },
        },
      },
      scales: {
        y: {
          ticks: {
            callback: (val) => Number(val).toLocaleString("vi-VN") + " đ",
          },
        },
      },
    },
  });
}

function renderCompareChart(data) {
  const ctx = document.getElementById("compareChart").getContext("2d");
  if (compareChart) compareChart.destroy();

  if (!data || (!data.current?.length && !data.previous?.length)) {
    setChartEmpty("compareChart", true); // ✅ đúng id
    return;
  }
  setChartEmpty("compareChart", false); // ✅ hiện canvas trước khi vẽ

  let labels = [
    ...new Set([
      ...data.current.map((d) => d.label),
      ...data.previous.map((d) => d.label),
    ]),
  ];
  labels = labels.sort((a, b) => parseInt(a) - parseInt(b));

  const currentData = labels.map((l) => {
    const f = data.current.find((d) => d.label === l);
    return f ? f.revenue : 0;
  });
  const prevData = labels.map((l) => {
    const f = data.previous.find((d) => d.label === l);
    return f ? f.revenue : 0;
  });

  const formattedLabels = labels.map((l) => {
    if (currentMode === "day") return "Ngày " + parseInt(l);
    if (currentMode === "month") return "Tháng " + parseInt(l);
    return l;
  });

  compareChart = new Chart(ctx, {
    type: "bar",
    data: {
      labels: formattedLabels,
      datasets: [
        { label: "Hiện tại", data: currentData, backgroundColor: "#4a90e2" },
        { label: "Kỳ trước", data: prevData, backgroundColor: "#ffb3c1" },
      ],
    },
    options: {
      responsive: true,
      plugins: {
        tooltip: {
          callbacks: {
            label: (ctx) =>
              ctx.dataset.label +
              ": " +
              Number(ctx.raw).toLocaleString("vi-VN") +
              " đ",
          },
        },
      },
      scales: {
        y: {
          ticks: {
            callback: (val) => Number(val).toLocaleString("vi-VN") + " đ",
          },
        },
      },
    },
  });
}

function renderProductChart(data) {
  const ctx = document.getElementById("productChart").getContext("2d");
  if (productChart) productChart.destroy();

  if (!data || data.length === 0) {
    setChartEmpty("productChart", true); // ✅ đúng id
    return;
  }
  setChartEmpty("productChart", false); // ✅ hiện canvas trước khi vẽ

  productChart = new Chart(ctx, {
    type: "bar",
    data: {
      labels: data.map((d) => d.name),
      datasets: [
        {
          label: "Số lượng bán",
          data: data.map((d) => d.total),
          backgroundColor: "#4a90e2",
        },
      ],
    },
  });
}

// ========== LOAD CHART DATA ==========
async function loadTopProducts(type) {
  if (!currentMachine) return;
  const data = await fetch(
    `/api/stats/top-products/${currentMachine.id}?type=${type}`,
  ).then((r) => r.json());
  renderTopProductChart(data);
}

async function loadChart(range, month = null) {
  if (!currentMachine) return;
  let url1 = `/api/stats/revenue/${currentMachine.id}?range=${range}`;
  let url2 = `/api/stats/products/${currentMachine.id}?range=${range}`;
  if (range === "month" && month) {
    url1 += `&month=${month}`;
    url2 += `&month=${month}`;
  }
  const revenueData = await fetch(url1).then((r) => r.json());
  const productData = await fetch(url2).then((r) => r.json());
  renderRevenueChart(revenueData);
  renderProductChart(productData);
}

async function loadCompare(type) {
  currentMode = type;
  if (!currentMachine) return;
  const data = await fetch(
    `/api/stats/compare/${currentMachine.id}?type=${type}`,
  ).then((r) => r.json());
  renderCompareChart(data);
  await loadTopProducts(type); // ✅ đảm bảo luôn cập nhật cùng type
}
