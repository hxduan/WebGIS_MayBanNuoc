# WebGIS Quản Lý Máy Bán Nước Tự Động

Hệ thống WebGIS quản lý và vận hành mạng lưới máy bán nước tự động trên địa bàn Hà Nội, xây dựng cho đồ án học phần. Tích hợp bản đồ tương tác, phân tích doanh thu và giao diện mua hàng trực tuyến trên cùng một nền tảng.

---

## Tính Năng Chính

### Dành cho khách hàng (`buy.html`)

- Đăng nhập và mua hàng trực tuyến với giỏ hàng, điều chỉnh số lượng, lưu lịch sử giao dịch
- Tìm máy theo tên theo thời gian thực, hỗ trợ từ khóa không dấu (`loi`, `het`)
- Lọc máy theo loại đồ uống và theo quận/huyện nội thành
- Chỉ đường từ vị trí hiện tại đến máy bán hàng

### Dành cho quản trị viên (`index.html`)

- CRUD máy bán hàng và sản phẩm, thêm/di chuyển máy bằng click trực tiếp trên bản đồ
- Tiếp hàng thông minh, báo lỗi và xác nhận sửa xong với ghi nhật ký tự động
- Dashboard doanh thu 3 cấp: theo máy, toàn hệ thống, theo thời gian
- 4 loại biểu đồ phân tích với bộ lọc ngày / tháng / năm
- Bản đồ nhiệt (heatmap) trực quan hóa mật độ bán hàng
- Gợi ý vị trí đặt thêm máy dựa trên dữ liệu hết hàng theo khu vực
- So sánh máy theo doanh thu, khoảng cách, sản phẩm và trạng thái

---

## Công Nghệ Sử Dụng

| Tầng     | Công nghệ                                      |
| -------- | ---------------------------------------------- |
| Backend  | Node.js, Express.js                            |
| Database | PostgreSQL                                     |
| Xác thực | JWT, bcrypt                                    |
| Frontend | Vanilla JavaScript, HTML, CSS                  |
| Bản đồ   | Leaflet.js, OpenStreetMap                      |
| GIS      | Leaflet.heat, Leaflet Routing Machine, GeoJSON |
| Biểu đồ  | Chart.js                                       |

---

## Cài Đặt và Chạy

### Yêu cầu

- Node.js v18 trở lên
- PostgreSQL 14 trở lên

### Các bước

**1. Clone và cài dependencies**

```bash
git clone <repo-url>
cd <project-folder>
npm install
```

**2. Khôi phục database**

```bash
psql -U postgres -c "CREATE DATABASE water_machine;"
psql -U postgres -d water_machine < data.backup
```

**3. Cấu hình kết nối database** trong `server.js`:

```javascript
const pool = new Pool({
  user: "postgres",
  host: "localhost",
  database: "water_machine",
  password: "your_password",
  port: 5432,
});
```

**4. Khởi động server**

```bash
node server.js
```

**5. Truy cập**

- Trang mua hàng: `http://localhost:3000/buy.html`
- Trang quản trị: `http://localhost:3000/index.html`

---

## Tài Khoản Mặc Định

| Role       | Username   | Password |
| ---------- | ---------- | -------- |
| Admin      | `admin`    | `123456` |
| Khách hàng | `customer` | `123456` |

---

## Cấu Trúc Dự Án

```
├── server.js              # Backend Express, toàn bộ API
├── public/
│   ├── index.html         # Trang quản trị
│   ├── buy.html           # Trang mua hàng
│   ├── login.html         # Trang đăng nhập
│   ├── js/
│   │   ├── app.js         # Khởi tạo, tìm kiếm, lọc loại
│   │   ├── map.js         # Render marker, bản đồ
│   │   ├── machine.js     # CRUD máy, báo lỗi, sửa máy
│   │   ├── product.js     # CRUD sản phẩm, tồn kho
│   │   ├── chart.js       # Biểu đồ doanh thu
│   │   ├── stats.js       # Dashboard, thống kê, lịch sử
│   │   ├── district.js    # Lọc quận, point-in-polygon
│   │   ├── heatmap.js     # Bản đồ nhiệt
│   │   ├── sidebar.js     # Danh sách máy, so sánh
│   │   ├── buy.js         # Giao diện mua hàng
│   │   ├── auth-guard.js  # Bảo vệ route theo role
│   │   ├── state.js       # State toàn cục
│   │   └── utils.js       # Hàm dùng chung, getFilteredMachines
│   └── css/
└── data.backup            # PostgreSQL dump
```

---
