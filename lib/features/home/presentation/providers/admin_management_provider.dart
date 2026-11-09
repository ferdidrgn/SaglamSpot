import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Admin > Yöneticiler ekranındaki bir satır — `admins/{email}` dokümanının
/// istemciye dönen görünümü (`functions/index.js > adminListAdmins`). O
/// koleksiyon istemciden tamamen kapalı (`firestore.rules`), bu yüzden
/// okuma da yazma da Admin SDK'lı callable'lardan geçer.
class AdminEntry {
  final String email;
  final DateTime? addedAt;
  final String? addedBy;

  const AdminEntry({required this.email, this.addedAt, this.addedBy});

  factory AdminEntry.fromMap(final Map<String, dynamic> map) => AdminEntry(
        email: map['email'] as String,
        addedAt: map['addedAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['addedAt'] as int)
            : null,
        addedBy: map['addedBy'] as String?,
      );
}

/// Panelde kayıtlı tüm yöneticileri listeler (`adminListAdmins` callable).
/// `admin add/remove` sonrası `ref.invalidateSelf()` ile tazelenir.
final adminListProvider =
    FutureProvider.autoDispose<List<AdminEntry>>((final ref) async {
  final callable = FirebaseFunctions.instance.httpsCallable(
    'adminListAdmins',
    options: HttpsCallableOptions(timeout: const Duration(seconds: 15)),
  );
  final response = await callable.call<Map<String, dynamic>>();
  final data = Map<String, dynamic>.from(response.data as Map);
  final list = (data['admins'] as List).cast<Map<dynamic, dynamic>>();
  return list
      .map((final e) => AdminEntry.fromMap(Map<String, dynamic>.from(e)))
      .toList();
});

/// E-posta ile yeni yönetici ekleme / mevcut birini kaldırma. Her iki işlem
/// de sunucuda (`adminAddAdmin`/`adminRemoveAdmin`) yeniden admin olduğu
/// doğrulanmış bir çağırandan gelmeli; kendini veya son yöneticiyi kaldırma
/// sunucuda reddedilir (bkz. functions/index.js).
class AdminManagementNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> addAdmin(final String email) async {
    state = const AsyncLoading();
    bool already = false;
    state = await AsyncValue.guard(() async {
      final callable = FirebaseFunctions.instance.httpsCallable(
        'adminAddAdmin',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 15)),
      );
      final response =
          await callable.call<Map<String, dynamic>>({'email': email});
      final data = Map<String, dynamic>.from(response.data as Map);
      already = data['already'] as bool? ?? false;
      ref.invalidate(adminListProvider);
    });
    return !already && state.hasError == false;
  }

  Future<void> removeAdmin(final String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final callable = FirebaseFunctions.instance.httpsCallable(
        'adminRemoveAdmin',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 15)),
      );
      await callable.call<Map<String, dynamic>>({'email': email});
      ref.invalidate(adminListProvider);
    });
  }
}

final adminManagementProvider =
    AsyncNotifierProvider<AdminManagementNotifier, void>(
  AdminManagementNotifier.new,
);
