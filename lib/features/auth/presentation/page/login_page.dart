import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/provider/auth_provider_notifier.dart';

/// Yönetici girişi. NOT: Önceki tasarımda uygulamanın markasıyla (zümrüt +
/// altın) hiç alakası olmayan indigo/lacivert bir renk şeması ve giriş
/// ekranında reklam banner'ı vardı — kendi yönetim panelinize giriş
/// yaparken reklam görmek anlamsız olduğu için kaldırdım.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    ref.listen<AsyncValue<User?>>(authProvider, (final previous, final next) {
      next.whenOrNull(data: (final user) {
        if (user != null && mounted) context.go('/');
      });
    });

    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;
    final errorMessage =
        authState.hasError ? (authState.error?.toString() ?? 'Bilinmeyen hata') : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Marka amblemi
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.primary.withOpacity(0.35),
                            blurRadius: 24,
                            offset: const Offset(0, 10)),
                      ],
                    ),
                    child: const Icon(Icons.storefront_rounded,
                        size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    context.l10n.loginBrand,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    context.l10n.adminLoginSubtitle,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 14.5),
                  ),
                  const SizedBox(height: 40),

                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.textPrimary.withOpacity(0.06),
                            blurRadius: 30,
                            offset: const Offset(0, 12)),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInput(
                          controller: _emailController,
                          label: context.l10n.emailLabel,
                          icon: Icons.alternate_email_rounded,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          enabled: !isLoading,
                        ),
                        const SizedBox(height: 14),
                        _buildInput(
                          controller: _passController,
                          label: context.l10n.passwordLabel,
                          icon: Icons.lock_rounded,
                          isObscure: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          enabled: !isLoading,
                          onSubmitted: (_) => _submit(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              color: AppColors.textTertiary,
                              size: 20,
                            ),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildSubmitButton(isLoading),
                        if (errorMessage != null) _buildErrorCard(errorMessage),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    ref.read(authProvider.notifier).signIn(
          _emailController.text,
          _passController.text,
        );
  }

  Widget _buildSubmitButton(final bool isLoading) => Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: AppColors.primary.withOpacity(0.35),
                blurRadius: 22,
                offset: const Offset(0, 10)),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: isLoading ? null : _submit,
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                    )
                  : Text(context.l10n.loginButton,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15.5,
                          color: Colors.white)),
            ),
          ),
        ),
      );

  Widget _buildErrorCard(final String message) => Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Container(
          padding: const EdgeInsets.all(12),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.error.withOpacity(0.25)),
          ),
          child: Row(
            children: [
              const Icon(Icons.error_outline_rounded,
                  color: AppColors.error, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(message,
                    style: const TextStyle(color: AppColors.error, fontSize: 13)),
              ),
            ],
          ),
        ),
      );

  Widget _buildInput({
    required final TextEditingController controller,
    required final String label,
    required final IconData icon,
    final bool isObscure = false,
    final TextInputType? keyboardType,
    final TextInputAction? textInputAction,
    final bool enabled = true,
    final ValueChanged<String>? onSubmitted,
    final Widget? suffixIcon,
  }) =>
      TextField(
        controller: controller,
        obscureText: isObscure,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        enabled: enabled,
        onSubmitted: onSubmitted,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.onSecondary, size: 20),
          suffixIcon: suffixIcon,
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textTertiary),
          filled: true,
          fillColor: AppColors.secondary,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      );
}
