/**
 * Chuyển đổi hiển thị giữa form Đăng nhập và Đăng ký
 * @param {string} type - Loại form muốn hiển thị ('login' hoặc 'register')
 */
function toggleForm(type) {
  const loginForm = document.getElementById("login-form");
  const regForm = document.getElementById("register-form");
  const title = document.getElementById("form-title");

  if (type === "register") {
    // Ẩn login, hiện register
    loginForm.style.display = "none";
    regForm.style.display = "block";
    title.innerText = "Đăng ký WebGIS";
  } else {
    // Ẩn register, hiện login
    loginForm.style.display = "block";
    regForm.style.display = "none";
    title.innerText = "Đăng nhập WebGIS";
  }
}

document.getElementById("register-form").addEventListener("submit", async function(e) {
  e.preventDefault();
  const username = this.tendangnhap.value;
  const password = this.matkhau.value;

  try {
    const res = await fetch("/api/register", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ username, password })
    });
    const data = await res.json();
    if (res.ok) {
      alert("Đăng ký thành công! Bạn có thể đăng nhập ngay.");
      toggleForm("login");
      this.reset();
    } else {
      alert(data.error || "Lỗi đăng ký");
    }
  } catch (err) {
    alert("Lỗi kết nối tới server");
  }
});

// Logic hiện/ẩn mật khẩu
document.querySelectorAll('.toggle-password').forEach(icon => {
    icon.addEventListener('click', function() {
        // Tìm ô input cùng cấp với icon
        const input = this.parentElement.querySelector('input');
        
        if (input.type === 'password') {
            input.type = 'text';
            // Đổi sang icon mắt gạch chéo
            this.classList.remove('fa-eye');
            this.classList.add('fa-eye-slash');
        } else {
            input.type = 'password';
            // Đổi lại icon mắt bình thường
            this.classList.remove('fa-eye-slash');
            this.classList.add('fa-eye');
        }
    });
});

document.getElementById("login-form").addEventListener("submit", async function(e) {
  e.preventDefault();
  const username = this.tendangnhap.value;
  const password = this.matkhau.value;

  try {
    const res = await fetch("/api/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ username, password })
    });
    const data = await res.json();
    if (res.ok) {
      alert("Đăng nhập thành công!");
      localStorage.setItem("user", JSON.stringify(data.user));
      window.location.href = "/index.html";
    } else {
      alert(data.error || "Lỗi đăng nhập");
    }
  } catch (err) {
    alert("Lỗi kết nối tới server");
  }
});
