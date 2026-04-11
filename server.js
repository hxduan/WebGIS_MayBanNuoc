const express = require("express");
const cors = require("cors");
const path = require("path");
const multer = require("multer"); // ✅ phải ở trên
const { Pool } = require("pg");

const app = express();

// 2. CẤU HÌNH MIDDLEWARE & STATIC FILES
app.use(cors());
app.use(express.json());
// Cấu hình phục vụ file tĩnh (ảnh upload và giao diện frontend)
app.use("/uploads", express.static("public/uploads"));
app.use(express.static("public"));

// 3. KẾT NỐI DATABASE
const pool = new Pool({
  user: "postgres",
  host: "localhost",
  database: "caybannuoc",
  password: "tokarin828",
  port: 5432,
});

// 4. CẤU HÌNH MULTER (UPLOAD FILE)
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
// --- GROUP 1: MACHINES ---
// CRUD
app.get("/api/machines", async (req, res) => {
  const result = await pool.query("SELECT * FROM machines");
  res.json(result.rows);
});
app.post("/api/machines", async (req, res) => {
  try {
    const { name, type, status, lat, lng } = req.body;

    if (!name || !lat || !lng) {
      return res.status(400).json({ error: "Thiếu dữ liệu" });
    }

    const result = await pool.query(
      `
              INSERT INTO machines (name, type, status, lat, lng)
              VALUES ($1, $2, $3, $4, $5)
              RETURNING *
          `,
      [name, type, status, lat, lng],
    );

    res.json(result.rows[0]);
  } catch (err) {
    console.error("❌ Lỗi tạo máy:", err);
    res.status(500).json({ error: "Server error" });
  }
});
app.put("/api/machines/:id", async (req, res) => {
  const { name, type, status, image } = req.body;

  await pool.query(
    "UPDATE machines SET name=$1, type=$2, status=$3, image=$4 WHERE id=$5",
    [name, type, status, image, req.params.id],
  );

  res.json({ message: "Đã cập nhật" });
});
app.delete("/api/machines/:id", async (req, res) => {
  await pool.query("DELETE FROM machines WHERE id=$1", [req.params.id]);
  res.json({ message: "Đã xóa" });
});
//thống kê toàn bộ máy
app.get("/api/system/revenue", async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT
        SUM(
          CASE WHEN DATE(created_at)=CURRENT_DATE
          THEN total ELSE 0 END
        ) AS today,

        SUM(
          CASE WHEN DATE_TRUNC('month',created_at)
               = DATE_TRUNC('month',CURRENT_DATE)
          THEN total ELSE 0 END
        ) AS month,

        SUM(
          CASE WHEN DATE_TRUNC('year',created_at)
               = DATE_TRUNC('year',CURRENT_DATE)
          THEN total ELSE 0 END
        ) AS year

      FROM sales
    `);

    res.json(result.rows[0]);
  } catch (err) {
    console.error("SYSTEM REVENUE ERROR:", err);
    res.status(500).json({ error: err.message });
  }
});

// actions
app.put("/api/machines/:id/move", async (req, res) => {
  try {
    const { lat, lng } = req.body;

    console.log("👉 MOVE:", req.params.id, lat, lng); // debug

    await pool.query("UPDATE machines SET lat=$1, lng=$2 WHERE id=$3", [
      lat,
      lng,
      req.params.id,
    ]);

    res.json({ message: "Đã cập nhật vị trí" });
  } catch (err) {
    console.error("❌ Lỗi move:", err);
    res.status(500).json({ error: "Server error" });
  }
});
app.post("/api/machines/:id/error", async (req, res) => {
  await pool.query(
    `
      UPDATE machines SET status='Lỗi' WHERE id=$1
    `,
    [req.params.id],
  );

  await pool.query(
    `
      INSERT INTO logs(machine_id,action,note)
      VALUES($1,'error','Máy lỗi')
    `,
    [req.params.id],
  );

  res.json({ message: "Đã báo lỗi" });
});
app.post("/api/machines/:id/fix", async (req, res) => {
  await pool.query(
    `
      UPDATE machines 
      SET status='Hoạt động', last_maintenance=NOW()
      WHERE id=$1
    `,
    [req.params.id],
  );

  await pool.query(
    `
      INSERT INTO logs(machine_id,action,note)
      VALUES($1,'fix','Đã sửa')
    `,
    [req.params.id],
  );

  res.json({ message: "Đã sửa xong" });
});
// detail
app.get("/api/machine/:id", async (req, res) => {
  const id = req.params.id;

  const machine = await pool.query("SELECT * FROM machines WHERE id=$1", [id]);

  const products = await pool.query(
    "SELECT * FROM products WHERE machine_id=$1",
    [id],
  );

  const sales = await pool.query(
    `
      SELECT 
        COALESCE(SUM(quantity),0) as total_sold,
        COALESCE(SUM(total),0) as revenue
      FROM sales WHERE machine_id=$1
    `,
    [id],
  );

  res.json({
    machine: machine.rows[0],
    products: products.rows,
    stats: sales.rows[0],
  });
});
app.get("/api/machines/hot", async (req, res) => {
  try {
    const { type } = req.query;

    let interval = "7 days";
    if (type === "month") interval = "30 days";
    if (type === "year") interval = "365 days";

    const result = await pool.query(`
        SELECT m.*, COALESCE(SUM(s.quantity),0) as total_sold
        FROM machines m
        LEFT JOIN sales s 
          ON m.id = s.machine_id
          AND s.created_at >= NOW() - INTERVAL '${interval}'
        GROUP BY m.id
        ORDER BY total_sold DESC   -- 🔥 KHÔNG LIMIT
      `);

    res.json(result.rows);
  } catch (err) {
    console.log(err);
    res.status(500).json({ error: "Lỗi server" });
  }
});
//  --- GROUP 2: PRODUCTS ---

app.post("/api/products", async (req, res) => {
  try {
    const { machine_id, name, price, stock } = req.body;

    await pool.query(
      `
      INSERT INTO products
      (machine_id, name, price, stock)
      VALUES ($1,$2,$3,$4)
      `,
      [machine_id, name, price, stock],
    );

    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      success: false,
      error: err.message,
    });
  }
}); //add prodducts
app.put("/api/products/:id", async (req, res) => {
  const { name, price, stock } = req.body;

  await pool.query(
    "UPDATE products SET name=$1,price=$2,stock=$3 WHERE id=$4",
    [name, price, stock, req.params.id],
  );

  res.json({ message: "ok" });
});

app.delete("/api/products/:id", async (req, res) => {
  await pool.query("DELETE FROM products WHERE id=$1", [req.params.id]);
  res.json({ message: "ok" });
});

// --- GROUP 3: STOCK ---
app.get("/api/machines/:id/stock", async (req, res) => {
  const machineId = req.params.id;

  try {
    const result = await pool.query(
      `
        SELECT id, name, stock, max_slot
        FROM products
        WHERE machine_id = $1
        ORDER BY id
        `,
      [machineId],
    );

    // 🔥 tính tổng
    const total_stock = result.rows.reduce((sum, p) => sum + p.stock, 0);
    const total_slot = result.rows.reduce((sum, p) => sum + p.max_slot, 0);

    res.json({
      products: result.rows,
      total: {
        total_stock,
        total_slot,
      },
    });
  } catch (err) {
    res.status(500).json({ error: "Lỗi load stock" });
  }
});
app.post("/api/machines/:id/refill", async (req, res) => {
  //trùng
  const machineId = req.params.id;

  try {
    // 🔥 set stock = max_slot
    await pool.query(
      `
        UPDATE products
        SET stock = max_slot
        WHERE machine_id = $1
      `,
      [machineId],
    );

    // (optional) log
    await pool.query(
      `
        INSERT INTO logs(machine_id, action, note)
        VALUES($1, 'refill', 'Tiếp hàng đầy')
      `,
      [machineId],
    );

    res.json({ message: "Refill OK" });
  } catch (err) {
    console.log(err);
    res.status(500).json({ error: "Lỗi refill" });
  }
});
app.post("/api/refill/:machineId", async (req, res) => {
  //trùng
  const id = req.params.machineId;

  await pool.query(
    `
      UPDATE products 
      SET stock = 50
      WHERE machine_id=$1
    `,
    [id],
  );

  await pool.query(
    `
      UPDATE machines 
      SET last_refill = NOW() 
      WHERE id=$1
    `,
    [id],
  );

  await pool.query(
    `
      INSERT INTO logs(machine_id,action,note)
      VALUES($1,'refill','Tiếp hàng')
    `,
    [id],
  );

  res.json({ message: "Đã tiếp hàng" });
});
// --- GROUP 4: SALES  ---
app.post("/api/sales", async (req, res) => {
  const { machine_id, items } = req.body;
  const client = await pool.connect();

  try {
    await client.query("BEGIN");

    for (const item of items) {
      // 1. Cập nhật kho trong bảng 'products' (Thay vì machine_products)
      // Cột 'id' là khóa chính của sản phẩm, 'machine_id' để định danh máy
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

      // 2. Ghi vào bảng 'sales'
      await client.query(
        `INSERT INTO sales (product_id, quantity, total, machine_id, created_at) 
                  VALUES ($1, $2, $3, $4, CURRENT_TIMESTAMP)`,
        [item.product_id, item.quantity, unitPrice * item.quantity, machine_id],
      );
    }

    await client.query("COMMIT");
    console.log("✅ Giao dịch thành công!");
    res.json({ success: true });
  } catch (err) {
    await client.query("ROLLBACK");
    console.error("❌ LỖI TẠI SERVER:", err.message);
    res.status(500).json({ error: err.message });
  } finally {
    client.release();
  }
});
app.post("/api/sell", async (req, res) => {
  const { product_id, quantity } = req.body;

  const product = await pool.query("SELECT * FROM products WHERE id=$1", [
    product_id,
  ]);

  if (product.rows[0].stock < quantity) {
    return res.status(400).json({ error: "Hết hàng" });
  }

  await pool.query(
    `
      UPDATE products
      SET stock = stock - $1
      WHERE id=$2
    `,
    [quantity, product_id],
  );

  await pool.query(
    `
      INSERT INTO sales(product_id, quantity, total, machine_id)
      VALUES($1,$2,$3,$4)
    `,
    [
      product_id,
      quantity,
      quantity * product.rows[0].price,
      product.rows[0].machine_id,
    ],
  );

  res.json({ message: "Đã bán" });
});
app.post("/api/report/:machineId", async (req, res) => {
  const { items } = req.body;
  const machineId = req.params.machineId;

  try {
    for (const item of items) {
      // 🔥 lấy giá + stock hiện tại
      const product = await pool.query(
        "SELECT price, stock FROM products WHERE id=$1",
        [item.product_id],
      );

      const price = product.rows[0].price;
      const currentStock = product.rows[0].stock;

      // ❌ nếu không đủ hàng
      if (currentStock < item.quantity) {
        return res.status(400).json({
          error: `Sản phẩm ID ${item.product_id} không đủ hàng`,
        });
      }

      // 🔥 1. TRỪ STOCK
      await pool.query(
        `
          UPDATE products
          SET stock = stock - $1
          WHERE id = $2
        `,
        [item.quantity, item.product_id],
      );

      // 🔥 2. LƯU SALES
      await pool.query(
        `
          INSERT INTO sales(product_id, quantity, total, machine_id)
          VALUES($1,$2,$3,$4)
        `,
        [item.product_id, item.quantity, item.quantity * price, machineId],
      );
    }

    // 🔥 log
    await pool.query(
      `
        INSERT INTO logs(machine_id,action,note)
        VALUES($1,'report','Báo cáo bán hàng')
      `,
      [machineId],
    );

    res.json({ message: "OK" });
  } catch (err) {
    console.log(err);
    res.status(500).json({ error: "Lỗi report" });
  }
});
// --- GROUP 5: STATS ---
app.get("/api/dashboard", async (req, res) => {
  try {
    const result = await pool.query(`
        WITH machine_stats AS (
          SELECT 
            COUNT(*) AS total,
            SUM(CASE WHEN status='Hoạt động' THEN 1 ELSE 0 END) AS active,
            SUM(CASE WHEN status!='Hoạt động' THEN 1 ELSE 0 END) AS inactive
          FROM machines
        ),
        revenue_stats AS (
          SELECT
            COALESCE(SUM(total) FILTER (WHERE DATE(created_at)=CURRENT_DATE),0) AS today,
            COALESCE(SUM(total) FILTER (
              WHERE DATE_TRUNC('month', created_at)=DATE_TRUNC('month', CURRENT_DATE)
            ),0) AS month
          FROM sales
        ),
        top_machines AS (
          SELECT 
            m.id, m.name,
            COALESCE(SUM(s.quantity),0) AS sold
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
          (SELECT low FROM low_stock) AS low_stock;
      `);

    res.json(result.rows[0]);
  } catch (err) {
    console.log(err);
    res.status(500).json({ error: "Lỗi dashboard" });
  }
});
app.get("/api/stats/overview/:id", async (req, res) => {
  try {
    const id = req.params.id;

    const today = await pool.query(
      `
        SELECT COALESCE(SUM(total),0) revenue
        FROM sales
        WHERE machine_id=$1
        AND DATE(created_at)=CURRENT_DATE
      `,
      [id],
    );

    const month = await pool.query(
      `
        SELECT COALESCE(SUM(total),0) revenue
        FROM sales
        WHERE machine_id=$1
        AND DATE_TRUNC('month',created_at)=DATE_TRUNC('month',CURRENT_DATE)
      `,
      [id],
    );

    const total = await pool.query(
      `
        SELECT COALESCE(SUM(quantity),0) qty
        FROM sales
        WHERE machine_id=$1
      `,
      [id],
    );

    const top = await pool.query(
      `
        SELECT p.name,SUM(s.quantity) total
        FROM sales s
        JOIN products p ON s.product_id=p.id
        WHERE s.machine_id=$1
        GROUP BY p.name
        ORDER BY total DESC
        LIMIT 1
      `,
      [id],
    );

    res.json({
      today: Number(today.rows[0].revenue),
      month: Number(month.rows[0].revenue),
      total: Number(total.rows[0].qty),
      top: top.rows[0] || null,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "stats error" });
  }
});
app.get("/api/stats/top-products/:id", async (req, res) => {
  const { type } = req.query;
  const id = req.params.id;

  let condition = "";

  if (type === "day") {
    condition =
      "DATE_TRUNC('month', s.created_at) = DATE_TRUNC('month', CURRENT_DATE)";
  }

  if (type === "month") {
    condition =
      "DATE_TRUNC('year', s.created_at) = DATE_TRUNC('year', CURRENT_DATE)";
  }

  if (type === "year") {
    condition = "1=1";
  }

  const result = await pool.query(
    `
      SELECT 
        p.name,
        SUM(s.quantity) as total
      FROM products p
      LEFT JOIN sales s 
        ON p.id = s.product_id
      WHERE p.machine_id = $1
        ${condition ? `AND ${condition}` : ""}
      GROUP BY p.name
      ORDER BY total DESC NULLS LAST
    `,
    [id],
  );

  res.json(result.rows);
});
app.get("/api/stats/compare/:id", async (req, res) => {
  const { type } = req.query;
  const id = req.params.id;

  let currentCond = "";
  let prevCond = "";
  let groupFormat = "";

  // 🔥 1. THEO NGÀY (trong tháng)
  if (type === "day") {
    currentCond =
      "DATE_TRUNC('month', created_at) = DATE_TRUNC('month', CURRENT_DATE)";
    prevCond =
      "DATE_TRUNC('month', created_at) = DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')";
    groupFormat = "DD"; // 🔥 ngày 1-31
  }

  // 🔥 2. THEO THÁNG (trong năm)
  if (type === "month") {
    currentCond =
      "DATE_TRUNC('year', created_at) = DATE_TRUNC('year', CURRENT_DATE)";
    prevCond =
      "DATE_TRUNC('year', created_at) = DATE_TRUNC('year', CURRENT_DATE - INTERVAL '1 year')";
    groupFormat = "MM"; // 🔥 tháng 1-12
  }

  // 🔥 3. THEO NĂM
  if (type === "year") {
    currentCond = "1=1";
    prevCond = "1=1";
    groupFormat = "YYYY"; // 🔥 năm
  }

  const current = await pool.query(
    `
      SELECT 
        TO_CHAR(created_at, '${groupFormat}') as label,
        SUM(total) as revenue
      FROM sales
      WHERE machine_id=$1 AND ${currentCond}
      GROUP BY label
      ORDER BY CAST(TO_CHAR(created_at, '${groupFormat}') AS INT)
    `,
    [id],
  );

  const previous = await pool.query(
    `
      SELECT 
        TO_CHAR(created_at, '${groupFormat}') as label,
        SUM(total) as revenue
      FROM sales
      WHERE machine_id=$1 AND ${prevCond}
      GROUP BY label
      ORDER BY CAST(TO_CHAR(created_at, '${groupFormat}') AS INT)
    `,
    [id],
  );

  res.json({
    current: current.rows,
    previous: previous.rows,
  });
});
app.get("/api/stats/revenue/:id", async (req, res) => {
  const { range, month } = req.query;
  const id = req.params.id;

  let condition = "";

  if (range === "7days") {
    condition = "created_at >= NOW() - INTERVAL '7 days'";
  } else if (range === "30days") {
    condition = "created_at >= NOW() - INTERVAL '30 days'";
  } else if (range === "month" && month) {
    condition = `DATE_TRUNC('month', created_at) = DATE_TRUNC('month', TO_DATE('${month}', 'YYYY-MM'))`;
  }

  const result = await pool.query(
    `
      SELECT 
        DATE(created_at) as date,
        SUM(total) as revenue
      FROM sales
      WHERE machine_id=$1
        ${condition ? `AND ${condition}` : ""}
      GROUP BY date
      ORDER BY date
    `,
    [id],
  );

  res.json(result.rows);
});
app.get("/api/stats/products/:id", async (req, res) => {
  const { range, month } = req.query;
  const id = req.params.id;

  let condition = "";

  if (range === "7days") {
    condition = "s.created_at >= NOW() - INTERVAL '7 days'";
  } else if (range === "30days") {
    condition = "s.created_at >= NOW() - INTERVAL '30 days'";
  } else if (range === "month" && month) {
    condition = `DATE_TRUNC('month', s.created_at) = DATE_TRUNC('month', TO_DATE('${month}', 'YYYY-MM'))`;
  }

  const result = await pool.query(
    `
      SELECT 
        p.name,
        SUM(s.quantity) as total
      FROM sales s
      JOIN products p ON s.product_id = p.id
      WHERE s.machine_id=$1
        ${condition ? `AND ${condition}` : ""}
      GROUP BY p.name
      ORDER BY total DESC
      LIMIT 10
    `,
    [id],
  );

  res.json(result.rows);
});
app.get("/api/stats/:id", async (req, res) => {
  const result = await pool.query(
    `
      SELECT 
        DATE(created_at) as date,
        SUM(total) as revenue
      FROM sales
      WHERE machine_id=$1
      GROUP BY date
      ORDER BY date
    `,
    [req.params.id],
  );

  res.json(result.rows);
});
app.get("/api/heatmap", async (req, res) => {
  const { type } = req.query;

  let condition = "";

  // 🔥 lọc theo thời gian
  if (type === "day") {
    condition = "AND DATE(s.created_at) = CURRENT_DATE";
  }

  if (type === "month") {
    condition =
      "AND DATE_TRUNC('month', s.created_at) = DATE_TRUNC('month', CURRENT_DATE)";
  }

  if (type === "year") {
    condition =
      "AND DATE_TRUNC('year', s.created_at) = DATE_TRUNC('year', CURRENT_DATE)";
  }

  const result = await pool.query(`
      SELECT 
        m.lat,
        m.lng,
        COALESCE(SUM(s.quantity),0) as weight
      FROM machines m
      LEFT JOIN sales s 
        ON m.id = s.machine_id
        ${condition}   -- 👈 CHÍNH CHỖ NÀY
      GROUP BY m.id
    `);

  res.json(result.rows);
});
// --- GROUP 6: LOGS ---
app.get("/api/logs/:id", async (req, res) => {
  const result = await pool.query(
    `SELECT action, note, created_at 
      FROM logs 
      WHERE machine_id=$1 AND action='refill'
      ORDER BY created_at DESC`,
    [req.params.id],
  );

  res.json(result.rows);
});
// --- GROUP 7: SEARCH ---
app.get("/api/search", async (req, res) => {
  const { q } = req.query;

  const result = await pool.query(
    "SELECT * FROM machines WHERE LOWER(name) LIKE LOWER($1)",
    [`%${q}%`],
  );

  res.json(result.rows);
});
// --- GROUP 8: UPLOAD ---
app.post(
  "/api/machines/:id/image",
  upload.single("machineImage"),
  async (req, res) => {
    try {
      const id = req.params.id;

      if (!req.file) {
        return res.status(400).send("Không có file");
      }

      // ✅ FIX CHỖ NÀY
      const imagePath = "/uploads/machines/" + req.file.filename;

      await pool.query("UPDATE machines SET image = $1 WHERE id = $2", [
        imagePath,
        id,
      ]);

      res.json({
        success: true,
        image: imagePath,
      });
    } catch (err) {
      console.error("Upload machine image lỗi:", err);
      res.status(500).send("Server lỗi");
    }
  },
); //api/machines/image
app.post(
  "/api/products/:id/image",

  upload.single("productImage"),
  async (req, res) => {
    try {
      const id = req.params.id;

      if (!req.file) {
        return res.status(400).send("Không có file");
      }

      const imagePath = "/uploads/products/" + req.file.filename;

      await pool.query("UPDATE products SET image=$1 WHERE id=$2", [
        imagePath,
        id,
      ]);

      res.json({
        success: true,
        image: imagePath,
      });
    } catch (err) {
      console.error("Upload product image lỗi:", err);
      res.status(500).send("Server lỗi");
    }
  },
); ///api/products/:id/image

// SERVER START
app.listen(3000, () => {
  console.log("http://localhost:3000");
});
