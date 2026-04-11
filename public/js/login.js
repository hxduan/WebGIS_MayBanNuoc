document.addEventListener("DOMContentLoaded", function () {
    const loginForm = document.getElementById("login-form");

    loginForm.addEventListener("submit", async (e) => {
        e.preventDefault(); // chặn load

        const username = document.getElementById("username").value;
        const password = document.getElementById("password").value;

        try {
            const response = await fetch("http://localhost:3000/login", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({ username, password }),
            });

            if (response.ok) {
                localStorage.setItem("isAdmin", "true");
                window.location.href = "admin.html";
            } else {
                alert("Đăng nhập thất bại");
            }
        } catch (error) {
            console.error("Lỗi khi đăng nhập:", error);
        }
    });
});
