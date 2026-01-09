import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/firestore_provider.dart';

final authProvider =
    NotifierProvider<AuthNotifier, AsyncValue<User?>>(AuthNotifier.new);

class AuthNotifier extends Notifier<AsyncValue<User?>> {
  FirebaseAuth get _auth => FirebaseAuth.instance;

  @override
  AsyncValue<User?> build() {
    // Auth durumunu sürekli dinliyoruz
    _auth.authStateChanges().listen((final user) {
      state = AsyncValue.data(user);
    });
    return const AsyncValue.loading();
  }

  Future<void> signIn(final String email, final String password) async {
    final cleanEmail = email.trim();
    if (cleanEmail.isEmpty || password.isEmpty) {
      state = AsyncValue.error(
          "E-posta ve şifre boş bırakılamaz.", StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();
    try {
      // 1. Önce Auth ile giriş (Loglardaki Recaptcha ve AppCheck sorunlarını bypass eder)
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        // 2. Admin Kontrolü
        final db = ref.read(firestoreProvider);
        final adminDoc = await db.collection('admins').doc(user.email).get();

        if (!adminDoc.exists) {
          await _auth.signOut();
          throw "Yetki Reddedildi: Bu e-posta yönetici listesinde bulunamadı.";
        }

        state = AsyncValue.data(user);
      }
    } on FirebaseAuthException catch (e) {
      // Firebase özel hatalarını kullanıcı dostu hale getiriyoruz
      state = AsyncValue.error(_mapFirebaseError(e.code), StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    state = const AsyncValue.data(null);
  }

  String _mapFirebaseError(final String code) {
    switch (code) {
      case 'invalid-email':
        return "Geçersiz bir e-posta adresi girdiniz.";
      case 'user-disabled':
        return "Bu kullanıcı hesabı devre dışı bırakılmış.";
      case 'user-not-found':
        return "Bu e-posta ile kayıtlı yönetici bulunamadı.";
      case 'wrong-password':
        return "Şifre hatalı, lütfen kontrol edin.";
      case 'invalid-credential':
        return "E-posta veya şifre hatalı.";
      case 'too-many-requests':
        return "Çok fazla deneme yaptınız. Lütfen sonra tekrar deneyin.";
      default:
        return "Giriş başarısız: $code";
    }
  }
}
