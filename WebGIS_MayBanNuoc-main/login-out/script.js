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
