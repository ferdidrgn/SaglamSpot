import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/ads/widgets/ad_banner_widget.dart';
import '../../../../core/ads/widgets/ad_native_widget.dart';
import '../../../auth/presentation/provider/auth_provider_notifier.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AsyncValue<User?>>(authProvider, (final previous, final next) {
      next.whenOrNull(
        data: (final user) {
          if (user != null) context.go('/');
        },
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Column(
        children: [
          // --- SAYFA BAŞI REKLAM (BANNER) ---
          const SafeArea(child: AdBannerWidget()),

          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_person_rounded,
                        size: 80, color: Color(0xFF6366F1)),
                    const SizedBox(height: 24),
                    const Text("Sağlam Spotçu",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900)),
                    const Text("Yönetici Paneli Girişi",
                        style: TextStyle(color: Colors.white60, fontSize: 16)),
                    const SizedBox(height: 32),

                    // Giriş alanları
                    _buildInput(
                      controller: _emailController,
                      label: "E-posta",
                      icon: Icons.alternate_email_rounded,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _buildInput(
                      controller: _passController,
                      label: "Şifre",
                      icon: Icons.password_rounded,
                      isObscure: true,
                    ),

                    // --- FORM ORTASI REKLAM (NATIVE) ---
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: AdNativeWidget(), // Şık bir yerel reklam
                    ),

                    _buildSubmitButton(authState),
                    _buildErrorMessage(authState),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          // --- SAYFA SONU REKLAM (BANNER) ---
          const AdBannerWidget(),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(final AsyncValue<User?> authState) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: authState.isLoading
            ? null
            : () {
                FocusScope.of(context).unfocus();
                ref.read(authProvider.notifier).signIn(
                      _emailController.text,
                      _passController.text,
                    );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6366F1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: authState.isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
            : const Text("Giriş Yap",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white)),
      ),
    );
  }

  Widget _buildErrorMessage(final AsyncValue<User?> authState) {
    if (!authState.hasError) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8)),
        child: Text(
          authState.error.toString(),
          style: const TextStyle(color: Colors.redAccent),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildInput({
    required final TextEditingController controller,
    required final String label,
    required final IconData icon,
    final bool isObscure = false,
    final TextInputType? keyboardType,
  }) =>
      TextField(
        controller: controller,
        obscureText: isObscure,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF6366F1)),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white60),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF6366F1)),
          ),
        ),
      );
}
