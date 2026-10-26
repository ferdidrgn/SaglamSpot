import {auth, signInWithEmailAndPassword, firebaseSignOut, isCurrentUserAdmin} from "./firebase-client.js";

const form = document.getElementById("admin-login-form");
const errorEl = document.getElementById("admin-login-error");

function showError(message) {
  errorEl.textContent = message;
  errorEl.hidden = false;
}

form.addEventListener("submit", async (event) => {
  event.preventDefault();
  errorEl.hidden = true;
  const submitBtn = form.querySelector("button[type=submit]");
  submitBtn.disabled = true;

  const email = form.email.value.trim();
  const password = form.password.value;

  try {
    await signInWithEmailAndPassword(auth, email, password);
    const isAdmin = await isCurrentUserAdmin();
    if (!isAdmin) {
      await firebaseSignOut(auth);
      showError("Bu hesap yönetici değil.");
      return;
    }
    window.location.href = "/admin";
  } catch (err) {
    showError("Giriş başarısız: e-posta veya şifre hatalı.");
  } finally {
    submitBtn.disabled = false;
  }
});
