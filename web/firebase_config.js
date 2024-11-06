// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyBK9yf5VECMPSIXaAW87qfaRc18nUvVlio",
  authDomain: "saglamspotflutter-cec3a.firebaseapp.com",
  projectId: "saglamspotflutter-cec3a",
  storageBucket: "saglamspotflutter-cec3a.firebasestorage.app",
  messagingSenderId: "124526169307",
  appId: "1:124526169307:web:a7869fa7a35ae1c95b10fe",
  measurementId: "G-CH4DW461LH"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);