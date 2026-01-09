import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/provider/auth_provider_notifier.dart';

class LoginPage extends ConsumerWidget {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
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
              const SizedBox(height: 48),
              _buildInput(
                  controller: _emailController,
                  label: "E-posta",
                  icon: Icons.alternate_email_rounded),
              const SizedBox(height: 16),
              _buildInput(
                  controller: _passController,
                  label: "Şifre",
                  icon: Icons.password_rounded,
                  isObscure: true),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: authState.isLoading
                      ? null
                      : () => ref
                          .read(authProvider.notifier)
                          .signIn(_emailController.text, _passController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: authState.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Giriş Yap",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white)),
                ),
              ),
              if (authState.hasError) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(authState.error.toString(),
                      style: const TextStyle(color: Colors.redAccent),
                      textAlign: TextAlign.center),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  // Yardımcı Input Widget'ı
  Widget _buildInput(
          {required final TextEditingController controller,
          required final String label,
          required final IconData icon,
          final bool isObscure = false}) =>
      TextField(
        controller: controller,
        obscureText: isObscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF6366F1)),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white60),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF6366F1))),
        ),
      );
}
