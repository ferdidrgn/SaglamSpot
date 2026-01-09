import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/firestore_provider.dart';

final authProvider =
    NotifierProvider<AuthNotifier, AsyncValue<User?>>(AuthNotifier.new);

class AuthNotifier extends Notifier<AsyncValue<User?>> {
  // Notifier içinde doğrudan servisleri tanımlamak yerine ref kullanmak
  // test edilebilirliği artırır.
  FirebaseAuth get _auth => FirebaseAuth.instance;

  @override
  AsyncValue<User?> build() {
    // Uygulama açıldığında Firebase Auth durumunu dinle
    _auth.authStateChanges().listen((final user) {
      state = AsyncValue.data(user);
    });

    return const AsyncValue.loading();
  }

  Future<void> signIn(final String email, final String password) async {
    state = const AsyncValue.loading();
    try {
      // firestoreProvider'ı kullanarak veritabanına erişiyoruz
      final db = ref.read(firestoreProvider);

      // 1. ADIM: Firestore'da 'admins' koleksiyonunu kontrol et
      // Görseldeki gibi döküman ID'si e-posta olan kaydı arıyoruz
      final adminDoc = await db.collection('admins').doc(email.trim()).get();

      if (!adminDoc.exists)
        throw "Bu e-posta adresi yönetici (admin) olarak tanımlı değil.";

      // 2. ADIM: Firebase Auth ile giriş yap
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);

      state = AsyncValue.data(_auth.currentUser);
    } catch (e, stack) {
      // Hataları UI'da göstermek üzere state'e paslıyoruz
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    state = const AsyncValue.data(null);
  }
}
