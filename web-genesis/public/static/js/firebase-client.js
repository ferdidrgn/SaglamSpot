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

/** admins/{email} dokümanı var mı — "bu kullanıcı admin mi?" (firestore.rules'taki isAdmin() ile aynı mantık). */
export async function isCurrentUserAdmin() {
  const user = auth.currentUser;
  if (!user || !user.email) return false;
  const snap = await getDoc(doc(db, "admins", user.email));
  return snap.exists();
}
