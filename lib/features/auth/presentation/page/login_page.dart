import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/design_system/atelier_background.dart';
import '../../../../shared/navigation/widgets/back_navigation_guards.dart';
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
        authState.hasError ? _authErrorMessage(context, authState.error) : null;

    final Widget scaffold = Scaffold(
      backgroundColor: AppColors.background,
      body: AtelierBackground(
        child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              // Genişlik sınırı yoktu — bu form TextField'ları içeriyor,
              // onlar mevcut tüm genişliği doldurmak ister; masaüstünde
              // formu makul bir genişlikte tutuyoruz (mobilde <420px zaten
              // ekran genişliği olduğu için hiçbir etkisi yok).
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
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
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      context.l10n.adminLoginSubtitle,
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 14.5),
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
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () => _showForgotPasswordDialog(),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.accentDark,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 8),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                context.l10n.forgotPassword,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildSubmitButton(isLoading),
                          if (errorMessage != null)
                            _buildErrorCard(errorMessage),
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
      )),
    );

    return kIsWeb ? scaffold : BackToHomeGuard(child: scaffold);
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    ref.read(authProvider.notifier).signIn(
          _emailController.text,
          _passController.text,
        );
  }

  Future<void> _showForgotPasswordDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (final dialogContext) => _ForgotPasswordDialog(
        initialEmail: _emailController.text.trim(),
        onSend: (final email) =>
            ref.read(authProvider.notifier).sendPasswordResetEmail(email),
        mapError: (final code) => _authErrorMessage(context, code),
      ),
    );
  }

  /// AuthNotifier hataları context'i olmadığı için stabil bir KOD olarak
  /// tutar (bkz. AuthNotifier.err* sabitleri ve FirebaseAuthException.code).
  /// Bu kodu burada, context.l10n erişimi olan tek yerde, kullanıcıya
  /// gösterilecek yerelleştirilmiş metne çeviriyoruz.
  String _authErrorMessage(final BuildContext context, final Object? error) {
    final l10n = context.l10n;
    final code = error?.toString() ?? '';
    switch (code) {
      case AuthNotifier.errEmptyCredentials:
        return l10n.authErrorEmptyCredentials;
      case AuthNotifier.errEmptyEmail:
        return l10n.authErrorEmptyEmail;
      case AuthNotifier.errFirebaseUnavailable:
        return l10n.authErrorFirebaseUnavailable;
      case AuthNotifier.errUserNotFound:
        return l10n.authErrorUserNotFound;
      case AuthNotifier.errAdminCheckTimeout:
        return l10n.authErrorAdminCheckTimeout;
      case AuthNotifier.errNotAdmin:
        return l10n.authErrorNotAdmin;
      case 'invalid-email':
        return l10n.authErrorInvalidEmail;
      case 'user-disabled':
        return l10n.authErrorUserDisabled;
      case 'user-not-found':
        return l10n.authErrorAccountNotFound;
      case 'wrong-password':
        return l10n.authErrorWrongPassword;
      case 'invalid-credential':
        return l10n.authErrorInvalidCredential;
      case 'too-many-requests':
        return l10n.authErrorTooManyRequests;
      case 'network-request-failed':
        return l10n.error_check_connection;
      default:
        return code.isEmpty
            ? l10n.authErrorUnknown
            : l10n.authErrorGeneric(code);
    }
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
              Icon(Icons.error_outline_rounded,
                  color: AppColors.error, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(message,
                    style: TextStyle(color: AppColors.error, fontSize: 13)),
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
        style: TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.onSecondary, size: 20),
          suffixIcon: suffixIcon,
          labelText: label,
          labelStyle: TextStyle(color: AppColors.textTertiary),
          filled: true,
          fillColor: AppColors.secondary,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.accent, width: 1.5),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      );
}

/// Firebase şifre sıfırlama diyaloğu — e-posta alıp
/// [AuthNotifier.sendPasswordResetEmail] çağırır; başarı/hata metni
/// yerelleştirilmiş olarak gösterilir.
class _ForgotPasswordDialog extends StatefulWidget {
  const _ForgotPasswordDialog({
    required this.initialEmail,
    required this.onSend,
    required this.mapError,
  });

  final String initialEmail;
  final Future<String?> Function(String email) onSend;
  final String Function(String code) mapError;

  @override
  State<_ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<_ForgotPasswordDialog> {
  late final TextEditingController _emailController =
      TextEditingController(text: widget.initialEmail);
  bool _sending = false;
  String? _error;
  bool _success = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_sending) {
      return;
    }
    setState(() {
      _sending = true;
      _error = null;
      _success = false;
    });

    final code = await widget.onSend(_emailController.text);
    if (!mounted) {
      return;
    }

    if (code == null) {
      setState(() {
        _sending = false;
        _success = true;
      });
      return;
    }

    setState(() {
      _sending = false;
      _error = widget.mapError(code);
    });
  }

  @override
  Widget build(final BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        context.l10n.resetPasswordTitle,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.resetPasswordSubtitle,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13.5,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              enabled: !_sending && !_success,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              autofocus: widget.initialEmail.isEmpty,
              style: TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.alternate_email_rounded,
                    color: AppColors.onSecondary, size: 20),
                labelText: context.l10n.emailLabel,
                labelStyle: TextStyle(color: AppColors.textTertiary),
                filled: true,
                fillColor: AppColors.secondary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.accent, width: 1.5),
                ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: AppColors.error.withValues(alpha: 0.25)),
                ),
                child: Text(
                  _error!,
                  style: TextStyle(color: AppColors.error, fontSize: 13),
                ),
              ),
            ],
            if (_success) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.28)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.mark_email_read_rounded,
                        color: AppColors.success, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        context.l10n.resetPasswordSuccess,
                        style: TextStyle(
                          color: AppColors.success,
                          fontSize: 13,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _sending ? null : () => Navigator.of(context).pop(),
          child: Text(context.l10n.cancel),
        ),
        if (!_success)
          FilledButton(
            onPressed: _sending ? null : _submit,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _sending
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: Colors.white,
                    ),
                  )
                : Text(context.l10n.resetPasswordSend),
          ),
      ],
    );
  }
}
