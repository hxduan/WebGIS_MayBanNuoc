const express = require("express");
const cors = require("cors");
const path = require("path");
const multer = require("multer");
const { Pool } = require("pg");
const fs = require("fs");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

const app = express();

const JWT_SECRET = "your_jwt_secret_change_this_in_production"; // ⚠️ đổi thành chuỗi random dài

// Tạo thư mục upload nếu chưa có
["public/uploads/machines", "public/uploads/products"].forEach((dir) => {
  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
});

// ============================================================
// MIDDLEWARE & STATIC FILES
// ============================================================
app.use(cors());
app.use(express.json());
app.use("/uploads", express.static("public/uploads"));
app.use(express.static("public"));

// ============================================================
// DATABASE
// ============================================================
const pool = new Pool({
  user: "postgres",
  host: "localhost",
  database: "caybannuoc",
  password: "tokarin828",
  port: 5432,
});

// ============================================================
// MULTER
// ============================================================
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    if (file.fieldname === "productImage") {
      cb(null, "public/uploads/products");
    } else {
      cb(null, "public/uploads/machines");
    }
  },
  filename: function (req, file, cb) {
    if (file.fieldname === "machineImage") {
      cb(null, "machine_" + req.params.id + path.extname(file.originalname));
    } else {
      cb(null, "product_" + req.params.id + path.extname(file.originalname));
    }
  },
});
const upload = multer({ storage });

// ============================================================
// AUTH MIDDLEWARE
// ============================================================
function authMiddleware(req, res, next) {
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1];
  if (!token) return res.status(401).json({ error: "Chưa đăng nhập" });
  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.user = decoded;
    next();
  } catch {
    return res.status(403).json({ error: "Token không hợp lệ hoặc hết hạn" });
  }
}

function adminOnly(req, res, next) {
  if (req.user?.role !== "admin") {
    return res.status(403).json({ error: "Chỉ admin mới có quyền này" });
  }
  next();
}

// ============================================================
// GROUP AUTH
// ============================================================

// POST /api/auth/register
app.post("/api/auth/register", authMiddleware, adminOnly, async (req, res) => {
  try {
    const { username, password, role } = req.body;
    if (!username || !password || !role) {
      return res.status(400).json({ error: "Thiếu thông tin" });
    }
    if (!["admin", "customer"].includes(role)) {
      return res.status(400).json({ error: "Role không hợp lệ" });
    }
    const existing = await pool.query(
      "SELECT id FROM users WHERE username = $1",
      [username],
    );
    if (existing.rows.length > 0) {
      return res.status(409).json({ error: "Tên đăng nhập đã tồn tại" });
    }
    const hash = await bcrypt.hash(password, 10);
    const result = await pool.query(
      "INSERT INTO users (username, password_hash, role) VALUES ($1, $2, $3) RETURNING id, username, role",
      [username, hash, role],
    );
    res.json({ message: "Tạo tài khoản thành công", user: result.rows[0] });
  } catch (err) {
    console.error("Register error:", err);
    res.status(500).json({ error: "Server error" });
  }
});

// POST /api/auth/login
app.post("/api/auth/login", async (req, res) => {
  try {
    const { username, password, role } = req.body;
    if (!username || !password) {
      return res.status(400).json({ error: "Thiếu tài khoản hoặc mật khẩu" });
    }
    const result = await pool.query(
      "SELECT * FROM users WHERE username = $1 AND role = $2",
      [username, role || "customer"],
    );
    if (result.rows.length === 0) {
      return res.status(401).json({ error: "Sai tài khoản hoặc mật khẩu" });
    }
    const user = result.rows[0];
    const match = await bcrypt.compare(password, user.password_hash);
    if (!match) {
      return res.status(401).json({ error: "Sai tài khoản hoặc mật khẩu" });
    }
    const token = jwt.sign(
      { id: user.id, username: user.username, role: user.role },
      JWT_SECRET,
      { expiresIn: "8h" },
    );
    res.json({ token, role: user.role, username: user.username });
  } catch (err) {
    console.error("Login error:", err);
    res.status(500).json({ error: "Server error" });
  }
});

// POST /api/auth/change-password
app.post("/api/auth/change-password", authMiddleware, async (req, res) => {
  try {
    const { oldPassword, newPassword } = req.body;
    const result = await pool.query("SELECT * FROM users WHERE id = $1", [
      req.user.id,
    ]);
    const user = result.rows[0];
    const match = await bcrypt.compare(oldPassword, user.password_hash);
    if (!match)
      return res.status(401).json({ error: "Mật khẩu cũ không đúng" });
    const hash = await bcrypt.hash(newPassword, 10);
    await pool.query("UPDATE users SET password_hash = $1 WHERE id = $2", [
      hash,
      req.user.id,
    ]);
    res.json({ message: "Đổi mật khẩu thành công" });
  } catch (err) {
    console.error("Change password error:", err);
    res.status(500).json({ error: "Server error" });
  }
});

// GET /api/auth/me
app.get("/api/auth/me", authMiddleware, (req, res) => {
  res.json({
    id: req.user.id,
    username: req.user.username,
    role: req.user.role,
  });
});

// GET /api/users
app.get("/api/users", authMiddleware, adminOnly, async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT id, username, role, created_at FROM users ORDER BY created_at DESC",
    );
    res.json(result.rows);
  } catch (err) {
    console.error("Get users error:", err);
    res.status(500).json({ error: "Server error" });
  }
});

// DELETE /api/users/:id
app.delete("/api/users/:id", authMiddleware, adminOnly, async (req, res) => {
  try {
    await pool.query("DELETE FROM users WHERE id = $1", [req.params.id]);
    res.json({ message: "Đã xóa user" });
  } catch (err) {
    console.error("Delete user error:", err);
    res.status(500).json({ error: "Server error" });
  }
});

// ============================================================
// GROUP 1: MACHINES
// ============================================================

app.get("/api/machines", async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT
        m.*,
        EXISTS (
          SELECT 1
          FROM products p
          WHERE p.machine_id = m.id
            AND p.stock <= 0
        ) AS has_out_of_stock
      FROM machines m
    `);
    res.json(result.rows);
  } catch (err) {
    console.error("Get machines error:", err);
    res.status(500).json({ error: "Lỗi load machines" });
  }
});

app.post("/api/machines", async (req, res) => {
  try {
    const { name, type, status, lat, lng } = req.body;
    if (!name || !lat || !lng) {
      return res.status(400).json({ error: "Thiếu dữ liệu" });
    }
    const result = await pool.query(
      `INSERT INTO machines (name, type, status, lat, lng)
       VALUES ($1, $2, $3, $4, $5) RETURNING *`,
      [name, type, status, lat, lng],
    );
    res.json(result.rows[0]);
  } catch (err) {
    console.error("Create machine error:", err);
    res.status(500).json({ error: "Server error" });
  }
});

// FIX: thêm try-catch
app.put("/api/machines/:id", async (req, res) => {
  try {
    const { name, type, status, image } = req.body;
    await pool.query(
      "UPDATE machines SET name=$1, type=$2, status=$3, image=$4 WHERE id=$5",
      [name, type, status, image, req.params.id],
    );
    res.json({ message: "Đã cập nhật" });
  } catch (err) {
    console.error("Update machine error:", err);
    res.status(500).json({ error: "Server error" });
  }
});

// FIX: thêm try-catch
app.delete("/api/machines/:id", async (req, res) => {
  try {
    await pool.query("DELETE FROM machines WHERE id=$1", [req.params.id]);
    res.json({ message: "Đã xóa" });
  } catch (err) {
    console.error("Delete machine error:", err);
    res.status(500).json({ error: "Server error" });
  }
});

app.get("/api/machines/out-of-stock", async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT
        m.id,
        m.name,
        COUNT(*) as out_count
      FROM machines m
      JOIN products p ON m.id = p.machine_id
      WHERE p.stock = 0
      GROUP BY m.id, m.name
      ORDER BY out_count DESC
    `);
    res.json(result.rows);
  } catch (err) {
    console.error("Out of stock error:", err);
    res.status(500).json({ error: "Lỗi out of stock" });
  }
});

app.put("/api/machines/:id/move", async (req, res) => {
  try {
    const { lat, lng } = req.body;
    await pool.query("UPDATE machines SET lat=$1, lng=$2 WHERE id=$3", [
      lat,
      lng,
      req.params.id,
    ]);
    res.json({ message: "Đã cập nhật vị trí" });
  } catch (err) {
    console.error("Move machine error:", err);
    res.status(500).json({ error: "Server error" });
  }
});

// FIX: thêm try-catch
app.post("/api/machines/:id/error", async (req, res) => {
  try {
    await pool.query("UPDATE machines SET status='Lỗi' WHERE id=$1", [
      req.params.id,
    ]);
    await pool.query(
      "INSERT INTO logs(machine_id,action,note) VALUES($1,'error','Máy lỗi')",
      [req.params.id],
    );
    res.json({ message: "Đã báo lỗi" });
  } catch (err) {
    console.error("Report error machine error:", err);
    res.status(500).json({ error: "Server error" });
  }
});

// FIX: thêm try-catch
app.post("/api/machines/:id/fix", async (req, res) => {
  try {
    await pool.query(
      "UPDATE machines SET status='Hoạt động', last_maintenance=NOW() WHERE id=$1",
      [req.params.id],
    );
    await pool.query(
      "INSERT INTO logs(machine_id,action,note) VALUES($1,'fix','Đã sửa')",
      [req.params.id],
    );
    res.json({ message: "Đã sửa xong" });
  } catch (err) {
    console.error("Fix machine error:", err);
    res.status(500).json({ error: "Server error" });
  }
});

// GET /api/machines/:id — detail (thống nhất tên route, thay /api/machine/:id cũ)
app.get("/api/machines/:id/detail", async (req, res) => {
  try {
    const id = req.params.id;
    const [machine, products, sales] = await Promise.all([
      pool.query("SELECT * FROM machines WHERE id=$1", [id]),
      pool.query("SELECT * FROM products WHERE machine_id=$1", [id]),
      pool.query(
        `SELECT
          COALESCE(SUM(quantity),0) as total_sold,
          COALESCE(SUM(total),0) as revenue
         FROM sales WHERE machine_id=$1`,
        [id],
      ),
    ]);
    res.json({
      machine: machine.rows[0],
      products: products.rows,
      stats: sales.rows[0],
    });
  } catch (err) {
    console.error("Machine detail error:", err);
    res.status(500).json({ error: "Server error" });
  }
});

// Giữ lại route cũ /api/machine/:id để không break frontend hiện tại
app.get("/api/machine/:id", async (req, res) => {
  try {
    const id = req.params.id;
    const [machine, products, sales] = await Promise.all([
      pool.query("SELECT * FROM machines WHERE id=$1", [id]),
      pool.query("SELECT * FROM products WHERE machine_id=$1", [id]),
      pool.query(
        `SELECT
          COALESCE(SUM(quantity),0) as total_sold,
          COALESCE(SUM(total),0) as revenue
         FROM sales WHERE machine_id=$1`,
        [id],
      ),
    ]);
    res.json({
      machine: machine.rows[0],
      products: products.rows,
      stats: sales.rows[0],
    });
  } catch (err) {
    console.error("Machine detail error:", err);
    res.status(500).json({ error: "Server error" });
  }
});

// FIX: whitelist interval, tránh SQL injection
app.get("/api/machines/hot", async (req, res) => {
  try {
    const { type } = req.query;
    const intervalMap = { week: "7 days", month: "30 days", year: "365 days" };
    const interval = intervalMap[type] || "7 days";

    const result = await pool.query(
      `SELECT m.*, COALESCE(SUM(s.quantity),0) as total_sold
       FROM machines m
       LEFT JOIN sales s
         ON m.id = s.machine_id
         AND s.created_at >= NOW() - INTERVAL '${interval}'
       GROUP BY m.id
       ORDER BY total_sold DESC`,
    );
    res.json(result.rows);
  } catch (err) {
    console.error("Hot machines error:", err);
    res.status(500).json({ error: "Lỗi server" });
  }
});

// ============================================================
// GROUP 2: PRODUCTS
// ============================================================

app.post("/api/products", async (req, res) => {
  try {
    const { machine_id, name, price, stock } = req.body;
    await pool.query(
      "INSERT INTO products (machine_id, name, price, stock) VALUES ($1,$2,$3,$4)",
      [machine_id, name, price, stock],
    );
    res.json({ success: true });
  } catch (err) {
    console.error("Create product error:", err);
    res.status(500).json({ success: false, error: err.message });
  }
});

// FIX: thêm try-catch
app.put("/api/products/:id", async (req, res) => {
  try {
    const { name, price, stock } = req.body;
    await pool.query(
      "UPDATE products SET name=$1, price=$2, stock=$3 WHERE id=$4",
      [name, price, stock, req.params.id],
    );
    res.json({ message: "ok" });
  } catch (err) {
    console.error("Update product error:", err);
    res.status(500).json({ error: err.message });
  }
});

app.delete("/api/products/:id", async (req, res) => {
  try {
    await pool.query("DELETE FROM products WHERE id=$1", [req.params.id]);
    res.json({ message: "ok" });
  } catch (err) {
    console.error("Delete product error:", err);
    res.status(500).json({ error: err.message });
  }
});

// ============================================================
// GROUP 3: STOCK
// ============================================================

app.get("/api/machines/:id/stock", async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT id, name, stock, max_slot
       FROM products
       WHERE machine_id = $1
       ORDER BY id`,
      [req.params.id],
    );
    const total_stock = result.rows.reduce((sum, p) => sum + p.stock, 0);
    const total_slot = result.rows.reduce((sum, p) => sum + p.max_slot, 0);
    res.json({
      products: result.rows,
      total: { total_stock, total_slot },
    });
  } catch (err) {
    console.error("Stock error:", err);
    res.status(500).json({ error: "Lỗi load stock" });
  }
});

// FIX: chỉ giữ 1 route refill duy nhất (set stock = max_slot là đúng hơn)
// Xóa /api/refill/:machineId (set cứng 50)
app.post("/api/machines/:id/refill", async (req, res) => {
  try {
    await pool.query(
      "UPDATE products SET stock = max_slot WHERE machine_id = $1",
      [req.params.id],
    );
    await pool.query(
      "INSERT INTO logs(machine_id, action, note) VALUES($1, 'refill', 'Tiếp hàng đầy')",
      [req.params.id],
    );
    res.json({ message: "Refill OK" });
  } catch (err) {
    console.error("Refill error:", err);
    res.status(500).json({ error: "Lỗi refill" });
  }
});

// ============================================================
// GROUP 4: SALES
// ============================================================

// FIX: chỉ giữ /api/sales (có transaction, đúng). Xóa /api/sell cũ.
app.post("/api/sales", async (req, res) => {
  const { machine_id, items } = req.body;
  const client = await pool.connect();
  try {
    await client.query("BEGIN");
    for (const item of items) {
      const updateResult = await client.query(
        `UPDATE products
         SET stock = stock - $1
         WHERE id = $2 AND machine_id = $3 AND stock >= $1
         RETURNING price`,
        [item.quantity, item.product_id, machine_id],
      );
      if (updateResult.rowCount === 0) {
        throw new Error("Sản phẩm không tồn tại hoặc đã hết hàng.");
      }
      const unitPrice = updateResult.rows[0].price;
      await client.query(
        `INSERT INTO sales (product_id, quantity, total, machine_id, created_at)
         VALUES ($1, $2, $3, $4, CURRENT_TIMESTAMP)`,
        [item.product_id, item.quantity, unitPrice * item.quantity, machine_id],
      );
    }
    await client.query("COMMIT");

    const nameRows = await client.query(
      "SELECT id, name FROM products WHERE id = ANY($1)",
      [items.map((i) => i.product_id)],
    );
    const nameMap = {};
    nameRows.rows.forEach((r) => (nameMap[r.id] = r.name));
    const itemSummary = items
      .map(
        (i) =>
          `${nameMap[i.product_id] || "SP#" + i.product_id} x${i.quantity}`,
      )
      .join(", ");
    await client.query(
      "INSERT INTO logs(machine_id, action, note) VALUES($1, 'sale', $2)",
      [machine_id, `Khách mua: ${itemSummary}`],
    );

    res.json({ success: true });
  } catch (err) {
    await client.query("ROLLBACK");
    console.error("Sale error:", err.message);
    res.status(500).json({ error: err.message });
  } finally {
    client.release();
  }
});

// FIX: /api/report — thêm transaction + dùng Promise.all để lấy data trước vòng lặp
app.post("/api/report/:machineId", async (req, res) => {
  const { items } = req.body;
  const machineId = req.params.machineId;
  const client = await pool.connect();

  try {
    // Lấy tất cả price + stock trong 1 query thay vì N query trong loop
    const productIds = items.map((i) => i.product_id);
    const productRows = await client.query(
      "SELECT id, price, stock FROM products WHERE id = ANY($1)",
      [productIds],
    );
    const productMap = {};
    productRows.rows.forEach((p) => (productMap[p.id] = p));

    // Kiểm tra stock trước khi BEGIN
    for (const item of items) {
      const p = productMap[item.product_id];
      if (!p || p.stock < item.quantity) {
        return res.status(400).json({
          error: `Sản phẩm ID ${item.product_id} không đủ hàng`,
        });
      }
    }

    await client.query("BEGIN");
    for (const item of items) {
      const price = productMap[item.product_id].price;
      await client.query(
        "UPDATE products SET stock = stock - $1 WHERE id = $2",
        [item.quantity, item.product_id],
      );
      await client.query(
        "INSERT INTO sales(product_id, quantity, total, machine_id) VALUES($1,$2,$3,$4)",
        [item.product_id, item.quantity, item.quantity * price, machineId],
      );
    }
    await client.query(
      "INSERT INTO logs(machine_id,action,note) VALUES($1,'report','Báo cáo bán hàng')",
      [machineId],
    );
    await client.query("COMMIT");

    res.json({ message: "OK" });
  } catch (err) {
    await client.query("ROLLBACK");
    console.error("Report error:", err);
    res.status(500).json({ error: "Lỗi report" });
  } finally {
    client.release();
  }
});

// ============================================================
// GROUP 5: STATS
// ============================================================

app.get("/api/system/revenue", async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT
        SUM(CASE WHEN DATE(created_at)=CURRENT_DATE THEN total ELSE 0 END) AS today,
        SUM(CASE WHEN DATE_TRUNC('month',created_at)=DATE_TRUNC('month',CURRENT_DATE) THEN total ELSE 0 END) AS month,
        SUM(CASE WHEN DATE_TRUNC('year',created_at)=DATE_TRUNC('year',CURRENT_DATE) THEN total ELSE 0 END) AS year
      FROM sales
    `);
    res.json(result.rows[0]);
  } catch (err) {
    console.error("System revenue error:", err);
    res.status(500).json({ error: err.message });
  }
});

app.get("/api/dashboard", async (req, res) => {
  try {
    const result = await pool.query(`
      WITH machine_stats AS (
        SELECT
          COUNT(*) AS total,
          SUM(CASE WHEN status='Hoạt động' THEN 1 ELSE 0 END) AS active,
          SUM(CASE WHEN status='Lỗi' THEN 1 ELSE 0 END) AS error,
          SUM(CASE WHEN status='Offline' THEN 1 ELSE 0 END) AS offline
        FROM machines
      ),
      revenue_stats AS (
        SELECT
          COALESCE(SUM(total) FILTER (WHERE DATE(created_at)=CURRENT_DATE),0) AS today,
          COALESCE(SUM(total) FILTER (WHERE DATE_TRUNC('month',created_at)=DATE_TRUNC('month',CURRENT_DATE)),0) AS month
        FROM sales
      ),
      top_machines AS (
        SELECT m.id, m.name, COALESCE(SUM(s.quantity),0) AS sold
        FROM machines m
        LEFT JOIN sales s ON m.id=s.machine_id
        GROUP BY m.id
        ORDER BY sold DESC
        LIMIT 5
      ),
      low_stock AS (
        SELECT COUNT(*) AS low
        FROM (
          SELECT machine_id, SUM(stock) AS total_stock
          FROM products
          GROUP BY machine_id
          HAVING SUM(stock) < 10
        ) t
      )
      SELECT
        (SELECT row_to_json(machine_stats) FROM machine_stats) AS machines,
        (SELECT row_to_json(revenue_stats) FROM revenue_stats) AS revenue,
        (SELECT json_agg(top_machines) FROM top_machines) AS top,
        (SELECT low FROM low_stock) AS low_stock
    `);
    res.json(result.rows[0]);
  } catch (err) {
    console.error("Dashboard error:", err);
    res.status(500).json({ error: "Lỗi dashboard" });
  }
});

// FIX: gộp 4 query riêng lẻ thành 1 query WITH
app.get("/api/stats/overview/:id", async (req, res) => {
  try {
    const id = req.params.id;
    const result = await pool.query(
      `WITH
        today_rev AS (
          SELECT COALESCE(SUM(total),0) AS val
          FROM sales
          WHERE machine_id=$1 AND DATE(created_at)=CURRENT_DATE
        ),
        month_rev AS (
          SELECT COALESCE(SUM(total),0) AS val
          FROM sales
          WHERE machine_id=$1
            AND DATE_TRUNC('month',created_at)=DATE_TRUNC('month',CURRENT_DATE)
        ),
        total_qty AS (
          SELECT COALESCE(SUM(quantity),0) AS val
          FROM sales WHERE machine_id=$1
        ),
        top_product AS (
          SELECT p.name, SUM(s.quantity) AS total
          FROM sales s
          JOIN products p ON s.product_id=p.id
          WHERE s.machine_id=$1
          GROUP BY p.name
          ORDER BY total DESC
          LIMIT 1
        )
      SELECT
        (SELECT val FROM today_rev) AS today,
        (SELECT val FROM month_rev) AS month,
        (SELECT val FROM total_qty) AS total,
        (SELECT row_to_json(top_product) FROM top_product) AS top`,
      [id],
    );
    const row = result.rows[0];
    res.json({
      today: Number(row.today),
      month: Number(row.month),
      total: Number(row.total),
      top: row.top || null,
    });
  } catch (err) {
    console.error("Stats overview error:", err);
    res.status(500).json({ error: "stats error" });
  }
});

app.get("/api/stats/top-products/:id", async (req, res) => {
  try {
    const { type } = req.query;
    const id = req.params.id;
    let condition = "";
    if (type === "day") {
      condition =
        "AND DATE_TRUNC('month', s.created_at) = DATE_TRUNC('month', CURRENT_DATE)";
    } else if (type === "month") {
      condition =
        "AND DATE_TRUNC('year', s.created_at) = DATE_TRUNC('year', CURRENT_DATE)";
    }
    const result = await pool.query(
      `SELECT p.name, SUM(s.quantity) as total
       FROM products p
       LEFT JOIN sales s ON p.id = s.product_id
       WHERE p.machine_id = $1 ${condition}
       GROUP BY p.name
       ORDER BY total DESC NULLS LAST`,
      [id],
    );
    res.json(result.rows);
  } catch (err) {
    console.error("Top products error:", err);
    res.status(500).json({ error: "Server error" });
  }
});

app.get("/api/stats/compare/:id", async (req, res) => {
  try {
    const { type } = req.query;
    const id = req.params.id;
    let currentCond = "",
      prevCond = "",
      groupFormat = "";

    if (type === "day") {
      currentCond =
        "DATE_TRUNC('month', created_at) = DATE_TRUNC('month', CURRENT_DATE)";
      prevCond =
        "DATE_TRUNC('month', created_at) = DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')";
      groupFormat = "DD";
    } else if (type === "month") {
      currentCond =
        "DATE_TRUNC('year', created_at) = DATE_TRUNC('year', CURRENT_DATE)";
      prevCond =
        "DATE_TRUNC('year', created_at) = DATE_TRUNC('year', CURRENT_DATE - INTERVAL '1 year')";
      groupFormat = "MM";
    } else {
      currentCond =
        "DATE_TRUNC('year', created_at) = DATE_TRUNC('year', CURRENT_DATE)";
      prevCond =
        "DATE_TRUNC('year', created_at) = DATE_TRUNC('year', CURRENT_DATE - INTERVAL '1 year')";
      groupFormat = "YYYY";
    }

    const [current, previous] = await Promise.all([
      pool.query(
        `SELECT TO_CHAR(created_at, '${groupFormat}') as label, SUM(total) as revenue
         FROM sales WHERE machine_id=$1 AND ${currentCond}
         GROUP BY label ORDER BY label`,
        [id],
      ),
      pool.query(
        `SELECT TO_CHAR(created_at, '${groupFormat}') as label, SUM(total) as revenue
         FROM sales WHERE machine_id=$1 AND ${prevCond}
         GROUP BY label ORDER BY label`,
        [id],
      ),
    ]);
    res.json({ current: current.rows, previous: previous.rows });
  } catch (err) {
    console.error("Stats compare error:", err);
    res.status(500).json({ error: "Server error" });
  }
});

// FIX: whitelist range/month để tránh SQL injection
app.get("/api/stats/revenue/:id", async (req, res) => {
  try {
    const { range, month } = req.query;
    const id = req.params.id;
    let condition = "";
    if (range === "7days") {
      condition = "AND created_at >= NOW() - INTERVAL '7 days'";
    } else if (range === "30days") {
      condition = "AND created_at >= NOW() - INTERVAL '30 days'";
    } else if (range === "month" && month && /^\d{4}-\d{2}$/.test(month)) {
      // FIX: validate format YYYY-MM trước khi dùng
      condition = `AND DATE_TRUNC('month', created_at) = DATE_TRUNC('month', TO_DATE('${month}', 'YYYY-MM'))`;
    }
    const result = await pool.query(
      `SELECT DATE(created_at) as date, SUM(total) as revenue
       FROM sales
       WHERE machine_id=$1 ${condition}
       GROUP BY date ORDER BY date`,
      [id],
    );
    res.json(result.rows);
  } catch (err) {
    console.error("Stats revenue error:", err);
    res.status(500).json({ error: "Server error" });
  }
});

// FIX: whitelist range/month
app.get("/api/stats/products/:id", async (req, res) => {
  try {
    const { range, month } = req.query;
    const id = req.params.id;
    let condition = "";
    if (range === "7days") {
      condition = "AND s.created_at >= NOW() - INTERVAL '7 days'";
    } else if (range === "30days") {
      condition = "AND s.created_at >= NOW() - INTERVAL '30 days'";
    } else if (range === "month" && month && /^\d{4}-\d{2}$/.test(month)) {
      condition = `AND DATE_TRUNC('month', s.created_at) = DATE_TRUNC('month', TO_DATE('${month}', 'YYYY-MM'))`;
    }
    const result = await pool.query(
      `SELECT p.name, SUM(s.quantity) as total
       FROM sales s
       JOIN products p ON s.product_id = p.id
       WHERE s.machine_id=$1 ${condition}
       GROUP BY p.name
       ORDER BY total DESC
       LIMIT 10`,
      [id],
    );
    res.json(result.rows);
  } catch (err) {
    console.error("Stats products error:", err);
    res.status(500).json({ error: "Server error" });
  }
});

// FIX: thêm try-catch
app.get("/api/stats/:id", async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT DATE(created_at) as date, SUM(total) as revenue
       FROM sales WHERE machine_id=$1
       GROUP BY date ORDER BY date`,
      [req.params.id],
    );
    res.json(result.rows);
  } catch (err) {
    console.error("Stats error:", err);
    res.status(500).json({ error: "Server error" });
  }
});

// FIX: whitelist type
app.get("/api/heatmap", async (req, res) => {
  try {
    const { type } = req.query;
    let condition = "";
    if (type === "day") {
      condition = "AND DATE(s.created_at) = CURRENT_DATE";
    } else if (type === "month") {
      condition =
        "AND DATE_TRUNC('month', s.created_at) = DATE_TRUNC('month', CURRENT_DATE)";
    } else if (type === "year") {
      condition =
        "AND DATE_TRUNC('year', s.created_at) = DATE_TRUNC('year', CURRENT_DATE)";
    }
    const result = await pool.query(`
      SELECT m.lat, m.lng, COALESCE(SUM(s.quantity),0) as weight
      FROM machines m
      LEFT JOIN sales s ON m.id = s.machine_id ${condition}
      GROUP BY m.id
    `);
    res.json(result.rows);
  } catch (err) {
    console.error("Heatmap error:", err);
    res.status(500).json({ error: "Server error" });
  }
});

// ============================================================
// GROUP 6: LOGS
// ============================================================

app.get("/api/logs/:id/all", async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT action, note, created_at
       FROM logs WHERE machine_id=$1
       ORDER BY created_at DESC LIMIT 50`,
      [req.params.id],
    );
    res.json(result.rows);
  } catch (err) {
    console.error("Logs all error:", err);
    res.status(500).json({ error: "Lỗi server" });
  }
});

// FIX: thêm try-catch
app.get("/api/logs/:id", async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT action, note, created_at
       FROM logs WHERE machine_id=$1 AND action='refill'
       ORDER BY created_at DESC`,
      [req.params.id],
    );
    res.json(result.rows);
  } catch (err) {
    console.error("Logs refill error:", err);
    res.status(500).json({ error: "Server error" });
  }
});

// ============================================================
// GROUP 7: SUGGEST & SEARCH
// ============================================================

app.get("/api/suggest-locations", async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT m.id, m.name, m.lat, m.lng, COUNT(*) as out_of_stock_count
      FROM machines m
      JOIN products p ON p.machine_id = m.id
      JOIN sales s ON s.product_id = p.id
      WHERE p.stock = 0
      GROUP BY m.id, m.name, m.lat, m.lng
      ORDER BY out_of_stock_count DESC
      LIMIT 5
    `);
    res.json(result.rows);
  } catch (err) {
    console.error("Suggest locations error:", err);
    res.status(500).json({ error: "Lỗi server" });
  }
});

// FIX: thêm try-catch
app.get("/api/search", async (req, res) => {
  try {
    const { q } = req.query;
    const result = await pool.query(
      "SELECT * FROM machines WHERE LOWER(name) LIKE LOWER($1)",
      [`%${q}%`],
    );
    res.json(result.rows);
  } catch (err) {
    console.error("Search error:", err);
    res.status(500).json({ error: "Server error" });
  }
});

// ============================================================
// GROUP 8: UPLOAD
// ============================================================

app.post(
  "/api/machines/:id/image",
  upload.single("machineImage"),
  async (req, res) => {
    try {
      const id = req.params.id;
      if (!req.file) return res.status(400).json({ error: "Không có file" });
      const imagePath = "/uploads/machines/" + req.file.filename;
      await pool.query("UPDATE machines SET image = $1 WHERE id = $2", [
        imagePath,
        id,
      ]);
      res.json({ success: true, image: imagePath });
    } catch (err) {
      console.error("Upload machine image error:", err);
      res.status(500).json({ error: "Server lỗi" });
    }
  },
);

app.post(
  "/api/products/:id/image",
  upload.single("productImage"),
  async (req, res) => {
    try {
      const id = req.params.id;
      if (!req.file) return res.status(400).json({ error: "Không có file" });
      const imagePath = "/uploads/products/" + req.file.filename;
      await pool.query("UPDATE products SET image=$1 WHERE id=$2", [
        imagePath,
        id,
      ]);
      res.json({ success: true, image: imagePath });
    } catch (err) {
      console.error("Upload product image error:", err);
      res.status(500).json({ error: "Server lỗi" });
    }
  },
);

// ============================================================
// START
// ============================================================
app.listen(3000, () => {
  console.log("http://localhost:3000");
});
