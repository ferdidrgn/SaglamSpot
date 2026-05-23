import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/firestore_provider.dart';

/// Auth state için basit, öngörülebilir state machine.
/// loading → data(null) = çıkış yapılmış
/// loading → data(user) = giriş yapılmış
/// loading → error     = hata
final authProvider =
    NotifierProvider<AuthNotifier, AsyncValue<User?>>(AuthNotifier.new);

class AuthNotifier extends Notifier<AsyncValue<User?>> {
  FirebaseAuth get _auth => FirebaseAuth.instance;

  @override
  AsyncValue<User?> build() {
    // Auth stream'i dinle — her değişimde state'i güncelle
    final sub = _auth.authStateChanges().listen(
      (final user) {
        // Sadece loading state'deyken veya farklı user gelince güncelle
        if (state.value != user) {
          state = AsyncValue.data(user);
        }
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
      state = AsyncValue.error(
        'E-posta ve şifre boş bırakılamaz.',
        StackTrace.current,
      );
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
        state = AsyncValue.error(
          'Kullanıcı bulunamadı.',
          StackTrace.current,
        );
        return;
      }

      // Admin kontrolü — Firestore'daki admins koleksiyonu
      final db = ref.read(firestoreProvider);
      final adminDoc =
          await db.collection('admins').doc(user.email).get().timeout(
                const Duration(seconds: 10),
                onTimeout: () =>
                    throw Exception('Yetki kontrolü zaman aşımına uğradı.'),
              );

      if (!adminDoc.exists) {
        // Yetkisiz kullanıcı — hemen çıkış yap
        await _auth.signOut();
        state = AsyncValue.error(
          'Bu hesabın yönetici yetkisi bulunmuyor.',
          StackTrace.current,
        );
        return;
      }

      // Başarılı giriş
      state = AsyncValue.data(user);
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(
        _mapFirebaseError(e.code),
        StackTrace.current,
      );
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (_) {}
    state = const AsyncValue.data(null);
  }

  String _mapFirebaseError(final String code) => switch (code) {
        'invalid-email' => 'Geçersiz e-posta adresi.',
        'user-disabled' => 'Bu hesap devre dışı bırakılmış.',
        'user-not-found' => 'Bu e-posta ile kayıtlı kullanıcı bulunamadı.',
        'wrong-password' => 'Şifre hatalı.',
        'invalid-credential' => 'E-posta veya şifre hatalı.',
        'too-many-requests' =>
          'Çok fazla deneme. Lütfen daha sonra tekrar deneyin.',
        'network-request-failed' => 'İnternet bağlantınızı kontrol edin.',
        _ => 'Giriş başarısız: $code',
      };
}
