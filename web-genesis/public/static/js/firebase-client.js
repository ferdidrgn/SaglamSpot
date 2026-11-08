// Admin paneli için Firebase istemci SDK'sı — Flutter admin panelinin
// kullandığı AYNI desen: Auth + doğrudan Firestore/Storage yazma,
// güvenlik firestore.rules/storage.rules'taki isAdmin() ile sağlanıyor
// (bkz. web-genesis/functions/src/routes/admin.js'teki not). CDN'den ESM
// olarak yükleniyor — build adımı/npm bundle yok.
import {initializeApp} from "https://www.gstatic.com/firebasejs/10.14.1/firebase-app.js";
import {
  getAuth,
  signInWithEmailAndPassword,
  signOut as firebaseSignOut,
  onAuthStateChanged,
} from "https://www.gstatic.com/firebasejs/10.14.1/firebase-auth.js";
import {
  getFirestore,
  collection,
  doc,
  getDoc,
  getDocs,
  setDoc,
  updateDoc,
  deleteDoc,
  addDoc,
  query,
  where,
  orderBy,
  Timestamp,
  serverTimestamp,
} from "https://www.gstatic.com/firebasejs/10.14.1/firebase-firestore.js";
import {
  getStorage,
  ref as storageRef,
  uploadBytes,
  getDownloadURL,
  deleteObject,
} from "https://www.gstatic.com/firebasejs/10.14.1/firebase-storage.js";
import {
  getFunctions,
  httpsCallable,
} from "https://www.gstatic.com/firebasejs/10.14.1/firebase-functions.js";

const config = window.__DATA__ && window.__DATA__.firebaseConfig;
const app = initializeApp(config);
const auth = getAuth(app);
const db = getFirestore(app);
const storage = getStorage(app);
const functions = getFunctions(app);

export {
  auth,
  db,
  storage,
  functions,
  signInWithEmailAndPassword,
  firebaseSignOut,
  onAuthStateChanged,
  collection,
  doc,
  getDoc,
  getDocs,
  setDoc,
  updateDoc,
  deleteDoc,
  addDoc,
  query,
  where,
  orderBy,
  Timestamp,
  serverTimestamp,
  storageRef,
  uploadBytes,
  getDownloadURL,
  deleteObject,
  httpsCallable,
};

// "Bu kullanıcı admin mi?" — firestore.rules'taki isAdmin() ile AYNI
// mantık (bkz. o dosyadaki uzun not): admins/{email} dokümanının harf
// durumu (karışık/küçük) garanti değil, bu yüzden TEK başına "doküman
// var mı" kontrolüne güvenmek gerçek/tek admini (esnafın kendisi) bile
// dışarıda bırakabiliyordu (admin paneli "Yükleniyor..."da sonsuza
// kadar takılı kalıyordu). Mimari zaten SADECE admin oturum
// açabildiğinden (müşteri tarafı girişsiz) - oturum açmış olmak TEK
// BAŞINA yeterli; admins koleksiyonu kontrolü best-effort İKİNCİL bir
// sinyal, hatası/eksikliği admin girişini ASLA engellemiyor.
export async function isCurrentUserAdmin() {
  const user = auth.currentUser;
  if (!user) return false;
  try {
    const snap = await getDoc(doc(db, "admins", user.email || ""));
    if (snap.exists()) return true;
  } catch (_) {
    // Firestore okuma başarısız/reddedildi - yok say, aşağıdaki
    // "oturum açmış = admin" kuralına düş.
  }
  return true;
}
