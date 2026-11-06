const {initializeApp, getApps} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");

if (!getApps().length) {
  initializeApp();
}

function getDb() {
  return getFirestore();
}

module.exports = {getDb};
