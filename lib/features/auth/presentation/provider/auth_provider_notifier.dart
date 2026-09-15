import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/admin_session_cache.dart';
import '../../../../core/services/firestore_provider.dart';

/// Auth state için basit, öngörülebilir state machine.
/// loading → data(null) = çıkış yapılmış
/// loading → data(user) = giriş yapılmış
/// loading → error     = hata
final authProvider =
    NotifierProvider<AuthNotifier, AsyncValue<User?>>(AuthNotifier.new);

/// Bu notifier bir [BuildContext] taşımadığı (dolayısıyla context.l10n'a
/// erişemediği) için hata durumlarını yerelleştirilmiş metin yerine STABİL
/// BİR KOD olarak state'e yazar (aşağıdaki `err*` sabitleri, ya da
/// [FirebaseAuthException.code]'un kendisi). Kodu kullanıcıya gösterilecek
/// yerelleştirilmiş metne çeviren yer login_page.dart'taki
/// authErrorMessage() fonksiyonudur.
class AuthNotifier extends Notifier<AsyncValue<User?>> {
  static const String errEmptyCredentials = 'empty-credentials';
  static const String errUserNotFound = 'post-login-user-null';
  static const String errAdminCheckTimeout = 'admin-check-timeout';
  static const String errNotAdmin = 'not-admin';

  FirebaseAuth get _auth => FirebaseAuth.instance;

  @override
  AsyncValue<User?> build() {
    // Auth stream'i dinle — her değişimde state'i güncelle
    final sub = _auth.authStateChanges().listen(
      (final user) {
        // Sadece loading state'deyken veya farklı user gelince güncelle
        if (state.value != user) state = AsyncValue.data(user);
      },
      onError: (final e, final st) {
        state = AsyncValue.error(e, st);
      },
    );

    // Provider dispose olunca stream'i iptal et
    ref.onDispose(sub.cancel);

    // Başlangıç: Firebase zaten bir kullanıcı biliyor olabilir
    final currentUser = _auth.currentUser;
    return AsyncValue.data(currentUser);
  }

  Future<void> signIn(final String email, final String password) async {
    final trimmedEmail = email.trim();

    if (trimmedEmail.isEmpty || password.isEmpty) {
      state = AsyncValue.error(errEmptyCredentials, StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();

    try {
      // Firebase Auth ile giriş
      final credential = await _auth.signInWithEmailAndPassword(
        email: trimmedEmail,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        state = AsyncValue.error(errUserNotFound, StackTrace.current);
        return;
      }

      // Admin kontrolü — Firestore'daki admins koleksiyonu
      final db = ref.read(firestoreProvider);
      final DocumentSnapshot<Map<String, dynamic>> adminDoc;
      try {
        adminDoc = await db
            .collection('admins')
            .doc(user.email)
            .get()
            .timeout(const Duration(seconds: 10));
      } on TimeoutException {
        state = AsyncValue.error(errAdminCheckTimeout, StackTrace.current);
        return;
      }

      if (!adminDoc.exists) {
        // Yetkisiz kullanıcı — hemen çıkış yap
        await _auth.signOut();
        state = AsyncValue.error(errNotAdmin, StackTrace.current);
        return;
      }

      // Başarılı giriş — bu cihazda bir yöneticinin oturum açtığını hatırla,
      // uygulama bir sonraki açılışta doğrudan yönetici paneline gitsin.
      await AdminSessionCache.setAdminLoggedIn(true);
      state = AsyncValue.data(user);
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(e.code, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (_) {}
    await AdminSessionCache.setAdminLoggedIn(false);
    state = const AsyncValue.data(null);
  }
}
