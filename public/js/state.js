// ============================================================
// state.js — Biến global dùng chung cho toàn bộ app
// Load TRƯỚC TẤT CẢ module khác
// ============================================================

// Map
const map = L.map("map").setView([21.0285, 105.8542], 13);
L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png").addTo(map);

// Constants
const innerDistricts = [
  "Ba Đình",
  "Hoàn Kiếm",
  "Hai Bà Trưng",
  "Đống Đa",
  "Cầu Giấy",
  "Thanh Xuân",
  "Hoàng Mai",
  "Long Biên",
  "Hà Đông",
  "Nam Từ Liêm",
  "Bắc Từ Liêm",
  "Tây Hồ",
];

// Global state
let markers = [];
let machinesData = [];
let currentMachine = null;
let routingControl = null;
let userMarker = null;
let heatLayer = null;
let nearbyCircle = null;
let heatOn = false;
let compareList = [];
let revenueChart = null;
let productChart = null;
let compareChart = null;
let currentMode = "month";
let topProductChart = null;
let addingMachine = false;
let newLatLng = null;
let tempMarker = null;
let movingMachine = null;
let districtLayer;
let districtVisible = true;
let allDistricts = [];
let districtLayers = {};
