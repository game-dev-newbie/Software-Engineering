const form = document.getElementById("loginForm");
const usernameInput = document.getElementById("username");
const passwordInput = document.getElementById("password");
const rememberCheckbox = document.getElementById("remember");
const errorBox = document.getElementById("errorBox");
const cancelBtn = document.getElementById("cancelBtn");
const togglePass = document.getElementById("togglePass");

function showError(msg) {
  errorBox.style.display = "block";
  errorBox.textContent = msg;
}
function clearError() {
  errorBox.style.display = "none";
  errorBox.textContent = "";
}

togglePass.addEventListener("click", () => {
  if (passwordInput.type === "password") {
    passwordInput.type = "text";
    togglePass.textContent = "Ẩn";
  } else {
    passwordInput.type = "password";
    togglePass.textContent = "Hiện";
  }
});

cancelBtn.addEventListener("click", () => {
  form.reset();
  clearError();
  localStorage.removeItem("restaurant_login");
});

form.addEventListener("submit", (e) => {
  e.preventDefault();
  clearError();
  const u = usernameInput.value.trim();
  const p = passwordInput.value;
  if (!u) {
    showError("Vui lòng nhập tên đăng nhập");
    return;
  }
  if (p.length < 6) {
    showError("Mật khẩu tối thiểu 6 ký tự");
    return;
  }
  if (rememberCheckbox.checked) {
    localStorage.setItem("restaurant_login", JSON.stringify({ u }));
  } else {
    localStorage.removeItem("restaurant_login");
  }
  alert("Đăng nhập thành công!");
});
