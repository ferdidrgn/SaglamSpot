import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/design_system/atelier_background.dart';
import '../../../../core/widgets/design_system/atelier_components.dart';
import '../../../products/presentation/widgets/admin_form_widgets.dart';
import '../providers/admin_management_provider.dart';

/// Admin > Yöneticiler — `admins/{email}` koleksiyonunu Admin SDK'lı
/// callable'lar (bkz. admin_management_provider.dart) üzerinden yönetir.
/// Firestore kuralları bu koleksiyonu istemciden tamamen kapattığı için
/// (`allow list, write: if false`) bu ekran TEK yönetim yolu.
class AdminManagersPage extends ConsumerStatefulWidget {
  const AdminManagersPage({super.key});

  @override
  ConsumerState<AdminManagersPage> createState() => _AdminManagersPageState();
}

class _AdminManagersPageState extends ConsumerState<AdminManagersPage> {
  final _emailController = TextEditingController();
  static final _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? get _myEmail => FirebaseAuth.instance.currentUser?.email?.toLowerCase();

  Future<void> _submitAdd() async {
    final email = _emailController.text.trim();
    if (!_emailRegex.hasMatch(email)) {
      _showSnack(context.l10n.adminManagersInvalidEmail);
      return;
    }
    final already =
        await ref.read(adminManagementProvider.notifier).addAdmin(email);
    if (!mounted) return;
    final state = ref.read(adminManagementProvider);
    state.whenOrNull(
      error: (final e, final _) =>
          _showSnack(context.l10n.adminManagersGenericError(_errorText(e))),
    );
    if (!state.hasError) {
      _showSnack(already
          ? context.l10n.adminManagersAddedSuccess
          : context.l10n.adminManagersAlreadyExists);
      _emailController.clear();
    }
  }

  Future<void> _confirmRemove(final AdminEntry admin) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (final context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.l10n.adminManagersRemoveConfirmTitle),
        content: Text(
            context.l10n.adminManagersRemoveConfirmMessage(admin.email)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(context.l10n.adminManagersRemoveButton),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    await ref.read(adminManagementProvider.notifier).removeAdmin(admin.email);
    if (!mounted) return;
    final state = ref.read(adminManagementProvider);
    state.whenOrNull(
      error: (final e, final _) =>
          _showSnack(context.l10n.adminManagersGenericError(_errorText(e))),
    );
    if (!state.hasError) _showSnack(context.l10n.adminManagersRemoveSuccess);
  }

  String _errorText(final Object e) {
    if (e is FirebaseFunctionsException) {
      switch (e.code) {
        case 'failed-precondition':
          return e.message ?? e.code;
        default:
          return e.message ?? e.code;
      }
    }
    return e.toString();
  }

  void _showSnack(final String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(final BuildContext context) {
    final adminsAsync = ref.watch(adminListProvider);
    final isBusy = ref.watch(adminManagementProvider).isLoading;

    return AtelierBackground(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(context.l10n.adminManagersTitle,
            style: AppTextStyles.serif(
                color: AppColors.mobileTextPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 21)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Text(context.l10n.adminManagersIntro,
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 13.5, height: 1.4)),
          ),
          AdminFormSection(
            title: context.l10n.adminManagersAddSectionTitle,
            icon: Icons.person_add_alt_1_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdminFormField(
                  controller: _emailController,
                  label: context.l10n.adminManagersEmailLabel,
                  hintText: context.l10n.adminManagersEmailHint,
                  icon: Icons.email_outlined,
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: isBusy ? null : _submitAdd,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.all(AppRadius.md)),
                    ),
                    child: isBusy
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text(context.l10n.adminManagersAddButton,
                            style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AtelierSectionHeader(title: context.l10n.adminManagersListTitle),
          const SizedBox(height: AppSpacing.sm),
          adminsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (final e, final _) => AtelierStateView(
              icon: Icons.cloud_off_rounded,
              title: context.l10n.loadErrorTitle,
              message: _errorText(e),
              actionLabel: context.l10n.retry,
              onAction: () => ref.invalidate(adminListProvider),
            ),
            data: (final admins) => admins.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(context.l10n.adminManagersEmpty,
                        style: TextStyle(color: AppColors.textTertiary)),
                  )
                : Column(
                    children: admins
                        .map((final a) => _AdminRow(
                              admin: a,
                              isSelf: a.email == _myEmail,
                              onRemove: () => _confirmRemove(a),
                            ))
                        .toList(),
                  ),
          ),
        ],
      ),
    ));
  }
}

class _AdminRow extends StatelessWidget {
  const _AdminRow(
      {required this.admin, required this.isSelf, required this.onRemove});

  final AdminEntry admin;
  final bool isSelf;
  final VoidCallback onRemove;

  @override
  Widget build(final BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: AtelierPanel(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: AppRadius.all(AppRadius.sm),
                ),
                child: Icon(Icons.person_rounded,
                    size: 18, color: AppColors.accentDark),
              ),
              const SizedBox(width: AppSpacing.sm + 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            admin.email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                                color: AppColors.textPrimary),
                          ),
                        ),
                        if (isSelf) ...[
                          const SizedBox(width: 6),
                          Text(context.l10n.adminManagersYouBadge,
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.textTertiary)),
                        ],
                      ],
                    ),
                    if (admin.addedBy != null)
                      Text(
                        context.l10n.adminManagersAddedByLabel(admin.addedBy!),
                        style:
                            TextStyle(fontSize: 11.5, color: AppColors.textTertiary),
                      ),
                  ],
                ),
              ),
              if (!isSelf)
                TextButton(
                  onPressed: onRemove,
                  style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
                  child: Text(context.l10n.adminManagersRemoveButton,
                      style: const TextStyle(fontSize: 12.5)),
                ),
            ],
          ),
        ),
      );
}
