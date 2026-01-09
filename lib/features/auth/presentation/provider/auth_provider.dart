import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider =
    NotifierProvider<AuthNotifier, AsyncValue<User?>>(AuthNotifier.new);

class AuthNotifier extends Notifier<AsyncValue<User?>> {
  final _db = FirebaseFirestore.instance;

  @override
  AsyncValue<User?> build() {
    // Firebase auth durumunu dinliyoruz.
    FirebaseAuth.instance.authStateChanges().listen((final user) async {
      if (user != null) {
        final isAuthorized = await _checkAdminStatus(user.email);
        state = isAuthorized ? AsyncValue.data(user) : const AsyncValue.data(null);
      } else state = const AsyncValue.data(null);
    });
    return const AsyncValue.loading();
  }

  // Firestore üzerinden admin kontrolü yapar.
  Future<bool> _checkAdminStatus(final String? email) async {
    if (email == null) return false;
    final doc = await _db.collection('admins').doc(email).get();
    return doc.exists;
  }

  Future<void> signIn(final String email, final String password) async {
    state = const AsyncValue.loading();
    try {
      // 1. Önce admin listesinde var mı kontrol et.
      final isAuthorized = await _checkAdminStatus(email);
      if (!isAuthorized) throw "Bu panel için giriş yetkiniz bulunmamaktadır.";

      // 2. Ardından Firebase Auth ile giriş yap.
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> signOut() async => FirebaseAuth.instance.signOut();
}
