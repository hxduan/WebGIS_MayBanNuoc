// ============================================================
// auth-guard.js
// ============================================================

(async function () {
  const token = localStorage.getItem("token");
  const role = localStorage.getItem("role");

  // Nếu chưa đăng nhập → về trang login
  if (!token || !role) {
    window.location.href = "/login.html";
    return;
  }

  // Kiểm tra token còn hợp lệ không (gọi /api/auth/me)
  try {
    const res = await fetch("/api/auth/me", {
      headers: { Authorization: "Bearer " + token },
    });

    if (!res.ok) {
      // Token hết hạn hoặc không hợp lệ
      localStorage.clear();
      window.location.href = "/login.html";
      return;
    }

    const me = await res.json();

    // Kiểm tra đúng trang với role
    const currentPage = window.location.pathname;

    if (me.role === "admin" && currentPage.includes("buy.html")) {
      // Admin vào trang mua hàng → redirect về quản lý
      window.location.href = "/index.html";
      return;
    }

    if (
      me.role === "customer" &&
      (currentPage.includes("index.html") || currentPage === "/")
    ) {
      // Khách vào trang quản lý → redirect về mua hàng
      window.location.href = "/buy.html";
      return;
    }

    // ✅ Hợp lệ → hiện nút logout + username trên trang
    injectUserBar(me);
  } catch (err) {
    console.error("Auth check failed:", err);
    localStorage.clear();
    window.location.href = "/login.html";
  }
})();

// Thêm thanh user info + nút logout vào header
function injectUserBar(user) {
  // Tìm nút "Đăng nhập" trong header và thay bằng info + logout
  const loginBtns = document.querySelectorAll(
    '.login-btn, button[onclick*="đăng nhập"], button[onclick*="Đăng nhập"]',
  );

  const userHTML = `
    <div style="display:flex;align-items:center;gap:10px">
      <span style="font-size:13px;opacity:0.8">
        ${user.role === "admin" ? "🛡️" : "🥤"} ${user.username}
      </span>
      <button onclick="logout()" style="
  padding: 6px 14px;
  border-radius: 20px;
  border: 1px solid #ccc;
  background: #e74c3c;
  color: white;
  cursor: pointer;
  font-size: 13px;
  font-weight: 600;
  transition: background 0.2s;
" onmouseover="this.style.background='#c0392b'"
   onmouseout="this.style.background='#e74c3c'">
  Đăng xuất
</button>
    </div>
  `;

  loginBtns.forEach((btn) => {
    btn.outerHTML = userHTML;
  });
}

function logout() {
  localStorage.clear();
  window.location.href = "/login.html";
}
