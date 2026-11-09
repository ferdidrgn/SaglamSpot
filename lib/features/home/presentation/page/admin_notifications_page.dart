import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/product_category_ex.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/design_system/atelier_background.dart';
import '../../../../core/widgets/design_system/atelier_components.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../products/domain/entites/product.dart';
import '../../../products/presentation/providers/product_filters_provider.dart';
import '../../../products/presentation/widgets/admin_form_widgets.dart';
import '../providers/campaign_notification_provider.dart';

enum _LinkType { none, product, page }

enum _Segment {
  all,
  favorited,
  category,
  favoritedConditionNew,
  favoritedConditionSpot,
  priceRange,
}

/// Admin > Bildirimler — esnafın TÜM kullanıcılara (veya bir segmente)
/// başlık+metin yazıp (isteğe bağlı bir ürüne/sayfaya bağlayıp) GERÇEKTEN
/// push bildirimi gönderebildiği ekran. Önceki "Firebase Servisleri"
/// sayfası (Crashlytics/Analytics anahtarları, Remote Config değerleri,
/// App Check durumu) esnaf için anlamsızdı — bunlar geliştirici
/// kaygılarıydı, esnafın hiçbir eylemi tetiklemiyordu. Telemetri
/// (crashlytics/analytics) artık sessizce her zaman açık (bkz.
/// app_initializer.dart) — esnafa gösterilecek, ona değer katan tek
/// gerçek Firebase özelliği bu ekrandaki kampanya gönderimi ve bildirim
/// izin durumu.
class AdminNotificationsPage extends ConsumerStatefulWidget {
  const AdminNotificationsPage({super.key});

  @override
  ConsumerState<AdminNotificationsPage> createState() =>
      _AdminNotificationsPageState();
}

class _AdminNotificationsPageState
    extends ConsumerState<AdminNotificationsPage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _priceMinController = TextEditingController();
  final _priceMaxController = TextEditingController();

  _LinkType _linkType = _LinkType.none;
  Product? _selectedProduct;
  String? _selectedPage;

  _Segment _segment = _Segment.all;
  ProductCategory? _selectedCategory;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _priceMinController.dispose();
    _priceMaxController.dispose();
    super.dispose();
  }

  bool get _canSend {
    if (_titleController.text.trim().isEmpty) return false;
    if (_bodyController.text.trim().isEmpty) return false;
    if (_linkType == _LinkType.product && _selectedProduct == null) {
      return false;
    }
    if (_linkType == _LinkType.page && _selectedPage == null) return false;
    if (_segment == _Segment.category && _selectedCategory == null) {
      return false;
    }
    if (_segment == _Segment.priceRange && _priceRange == null) return false;
    return true;
  }

  /// Fiyat alanlarından geçerli bir (min, max) aralığı okur — sayı değilse,
  /// negatifse veya min > max ise null (segment seçilemez/gönderilemez).
  (double, double)? get _priceRange {
    final min = double.tryParse(_priceMinController.text.trim());
    final max = double.tryParse(_priceMaxController.text.trim());
    if (min == null || max == null || min < 0 || max < min) return null;
    return (min, max);
  }

  /// Şu an seçili segmentin GERÇEK Firestore segment string'i — tüm alanlar
  /// doldurulmadıysa (ör. kategori/fiyat aralığı eksik) null döner, bu
  /// durumda ne önizleme sorgusu ne gönderim yapılabilir.
  String? get _segmentValue {
    switch (_segment) {
      case _Segment.all:
        return 'all';
      case _Segment.favorited:
        return 'favorited';
      case _Segment.category:
        final category = _selectedCategory;
        return category == null ? null : 'category:${category.toFirestore()}';
      case _Segment.favoritedConditionNew:
        return 'favorited_condition:new';
      case _Segment.favoritedConditionSpot:
        return 'favorited_condition:spot';
      case _Segment.priceRange:
        final range = _priceRange;
        if (range == null) return null;
        return 'favorited_price:${range.$1.round()}-${range.$2.round()}';
    }
  }

  Future<void> _confirmAndSend() async {
    if (!_canSend) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(context.l10n.campaignTitleRequired)));
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (final context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.l10n.campaignSendConfirmTitle),
        content: Text(context.l10n.campaignSendConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(context.l10n.campaignSendButton),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final segmentValue = _segmentValue;
    if (segmentValue == null) return;

    await ref.read(campaignNotificationProvider.notifier).send(
          title: _titleController.text.trim(),
          body: _bodyController.text.trim(),
          segment: segmentValue,
          linkType: _linkType == _LinkType.none ? null : _linkType.name,
          productId: _linkType == _LinkType.product ? _selectedProduct!.id : null,
          page: _linkType == _LinkType.page ? _selectedPage : null,
        );

    if (!mounted) return;
    final result = ref.read(campaignNotificationProvider);
    result.when(
      data: (final data) {
        if (data == null) return;
        final msg = data.sentCount < 0
            ? context.l10n.campaignSendSuccessAll
            : data.sentCount == 0
                ? context.l10n.campaignSendSuccessZero
                : context.l10n.campaignSendSuccessCount(data.sentCount);
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text(msg)));
        _titleController.clear();
        _bodyController.clear();
        _priceMinController.clear();
        _priceMaxController.clear();
        setState(() {
          _linkType = _LinkType.none;
          _selectedProduct = null;
          _selectedPage = null;
          _segment = _Segment.all;
          _selectedCategory = null;
        });
        ref.read(campaignNotificationProvider.notifier).reset();
      },
      error: (final e, final _) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(
              content: Text(context.l10n.campaignSendError(e.toString()))));
      },
      loading: () {},
    );
  }

  Future<void> _pickProduct() async {
    final available = ref.read(availableProductsProvider);
    final picked = await showModalBottomSheet<Product>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (final context) => _ProductPickerSheet(products: available),
    );
    if (picked != null) setState(() => _selectedProduct = picked);
  }

  @override
  Widget build(final BuildContext context) {
    final sendState = ref.watch(campaignNotificationProvider);
    final isSending = sendState.isLoading;

    return AtelierBackground(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(context.l10n.notificationsAdminTitle,
            style: AppTextStyles.serif(
                color: AppColors.mobileTextPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 21)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          AdminFormSection(
            title: context.l10n.campaignComposerSectionTitle,
            icon: Icons.campaign_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdminFormField(
                  controller: _titleController,
                  label: context.l10n.campaignTitleLabel,
                  icon: Icons.title_rounded,
                ),
                AdminFormField(
                  controller: _bodyController,
                  label: context.l10n.campaignBodyLabel,
                  hintText: context.l10n.campaignBodyHint,
                  icon: Icons.notes_rounded,
                  lines: 3,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(context.l10n.campaignLinkSectionTitle.toUpperCase(),
                    style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: AppColors.textTertiary)),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    AtelierChoiceChip(
                      label: context.l10n.campaignLinkNone,
                      selected: _linkType == _LinkType.none,
                      onTap: () => setState(() => _linkType = _LinkType.none),
                    ),
                    AtelierChoiceChip(
                      label: context.l10n.campaignLinkProduct,
                      selected: _linkType == _LinkType.product,
                      onTap: () => setState(() => _linkType = _LinkType.product),
                    ),
                    AtelierChoiceChip(
                      label: context.l10n.campaignLinkPage,
                      selected: _linkType == _LinkType.page,
                      onTap: () => setState(() => _linkType = _LinkType.page),
                    ),
                  ],
                ),
                if (_linkType == _LinkType.product) ...[
                  const SizedBox(height: AppSpacing.sm + 2),
                  OutlinedButton.icon(
                    onPressed: _pickProduct,
                    icon: const Icon(Icons.inventory_2_outlined, size: 18),
                    label: Text(_selectedProduct?.name ??
                        context.l10n.campaignPickProduct),
                  ),
                ],
                if (_linkType == _LinkType.page) ...[
                  const SizedBox(height: AppSpacing.sm + 2),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      AtelierChoiceChip(
                        label: context.l10n.campaignPageDiscover,
                        selected: _selectedPage == '/discover',
                        onTap: () => setState(() => _selectedPage = '/discover'),
                      ),
                      AtelierChoiceChip(
                        label: context.l10n.campaignPageNew,
                        selected: _selectedPage == '/new',
                        onTap: () => setState(() => _selectedPage = '/new'),
                      ),
                      AtelierChoiceChip(
                        label: context.l10n.campaignPageSpot,
                        selected: _selectedPage == '/spot',
                        onTap: () => setState(() => _selectedPage = '/spot'),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                Text(context.l10n.campaignSegmentSectionTitle.toUpperCase(),
                    style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: AppColors.textTertiary)),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    AtelierChoiceChip(
                      label: context.l10n.campaignSegmentAll,
                      selected: _segment == _Segment.all,
                      onTap: () => setState(() => _segment = _Segment.all),
                    ),
                    AtelierChoiceChip(
                      label: context.l10n.campaignSegmentFavorited,
                      selected: _segment == _Segment.favorited,
                      onTap: () => setState(() => _segment = _Segment.favorited),
                    ),
                    AtelierChoiceChip(
                      label: context.l10n.campaignSegmentCategory,
                      selected: _segment == _Segment.category,
                      onTap: () => setState(() => _segment = _Segment.category),
                    ),
                    AtelierChoiceChip(
                      label: context.l10n.campaignSegmentFavoritedNew,
                      selected: _segment == _Segment.favoritedConditionNew,
                      onTap: () =>
                          setState(() => _segment = _Segment.favoritedConditionNew),
                    ),
                    AtelierChoiceChip(
                      label: context.l10n.campaignSegmentFavoritedSpot,
                      selected: _segment == _Segment.favoritedConditionSpot,
                      onTap: () =>
                          setState(() => _segment = _Segment.favoritedConditionSpot),
                    ),
                    AtelierChoiceChip(
                      label: context.l10n.campaignSegmentPriceRange,
                      selected: _segment == _Segment.priceRange,
                      onTap: () => setState(() => _segment = _Segment.priceRange),
                    ),
                  ],
                ),
                if (_segment == _Segment.category) ...[
                  const SizedBox(height: AppSpacing.sm + 2),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: ProductCategory.values
                        .map((final c) => AtelierChoiceChip(
                              label: c.label(context),
                              selected: _selectedCategory == c,
                              onTap: () => setState(() => _selectedCategory = c),
                            ))
                        .toList(),
                  ),
                ],
                if (_segment == _Segment.priceRange) ...[
                  const SizedBox(height: AppSpacing.sm + 2),
                  Row(
                    children: [
                      Expanded(
                        child: AdminFormField(
                          controller: _priceMinController,
                          label: context.l10n.campaignPriceMinLabel,
                          icon: Icons.arrow_downward_rounded,
                          numeric: true,
                          onChanged: () => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: AdminFormField(
                          controller: _priceMaxController,
                          label: context.l10n.campaignPriceMaxLabel,
                          icon: Icons.arrow_upward_rounded,
                          numeric: true,
                          onChanged: () => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  if (_priceRange == null &&
                      (_priceMinController.text.isNotEmpty ||
                          _priceMaxController.text.isNotEmpty)) ...[
                    const SizedBox(height: 4),
                    Text(context.l10n.campaignPriceRangeInvalid,
                        style: TextStyle(fontSize: 12, color: AppColors.error)),
                  ],
                ],
                const SizedBox(height: AppSpacing.sm + 2),
                _AudiencePreview(segment: _segmentValue),
                const SizedBox(height: AppSpacing.lg + 4),
                AdminSubmitButton(
                  label: context.l10n.campaignSendButton,
                  isLoading: isSending,
                  onTap: _confirmAndSend,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AdminFormSection(
            title: context.l10n.firebaseNotificationsTitle,
            icon: Icons.notifications_active_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoLine(
                  icon: Icons.token_rounded,
                  text: NotificationService.currentToken != null
                      ? context.l10n.firebaseTokenAvailable
                      : context.l10n.firebaseTokenUnavailable,
                ),
                if (!kIsWeb) ...[
                  const SizedBox(height: 6),
                  FutureBuilder<NotificationSettings>(
                    future: FirebaseMessaging.instance.getNotificationSettings(),
                    builder: (final context, final snapshot) => _InfoLine(
                      icon: Icons.mark_email_read_outlined,
                      text: !snapshot.hasData
                          ? context.l10n.firebaseChecking
                          : snapshot.data!.authorizationStatus ==
                                  AuthorizationStatus.authorized
                              ? context.l10n.firebasePermissionGranted
                              : context.l10n.firebasePermissionDenied,
                      muted: true,
                    ),
                  ),
                  const SizedBox(height: 14),
                  AdminSubmitButton(
                    label: context.l10n.firebaseOpenNotificationSettings,
                    isLoading: false,
                    onTap: NotificationService.openSystemNotificationSettings,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AdminFormSection(
            title: context.l10n.campaignHistoryTitle,
            icon: Icons.history_rounded,
            child: const _CampaignHistoryList(),
          ),
        ],
      ),
    ));
  }
}

/// Önceden gönderilen bir kampanyanın "kime, kaç cihaza gitti" bilgisini
/// kalıcı olarak gösterir — eskiden bu sadece gönderim anındaki tek
/// seferlik SnackBar'da vardı, ekran kapanınca kaybolurdu (bkz.
/// campaign_notification_provider.dart > campaignHistoryProvider).
class _CampaignHistoryList extends ConsumerWidget {
  const _CampaignHistoryList();

  String _segmentLabel(final BuildContext context, final String? segment) {
    if (segment == null) return '';
    if (segment == 'all') return context.l10n.campaignSegmentAll;
    if (segment == 'favorited') return context.l10n.campaignSegmentFavorited;
    if (segment == 'favorited_condition:new') return context.l10n.campaignSegmentFavoritedNew;
    if (segment == 'favorited_condition:spot') return context.l10n.campaignSegmentFavoritedSpot;
    if (segment.startsWith('category:')) {
      final key = segment.substring('category:'.length);
      for (final category in ProductCategory.values) {
        if (category.toFirestore() == key) {
          return '${context.l10n.campaignSegmentCategory}: ${category.label(context)}';
        }
      }
      return context.l10n.campaignSegmentCategory;
    }
    if (segment.startsWith('favorited_price:')) {
      return context.l10n.campaignSegmentPriceRange;
    }
    return segment;
  }

  String _sentCountLabel(final BuildContext context, final int? sentCount) {
    if (sentCount == null) return '';
    if (sentCount < 0) return context.l10n.campaignSendSuccessAll;
    if (sentCount == 0) return context.l10n.campaignSendSuccessZero;
    return context.l10n.campaignSendSuccessCount(sentCount);
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final historyAsync = ref.watch(campaignHistoryProvider);

    return historyAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (final e, final _) => _InfoLine(
        icon: Icons.cloud_off_rounded,
        text: context.l10n.loadErrorMessage,
        muted: true,
      ),
      data: (final entries) {
        if (entries.isEmpty) {
          return _InfoLine(
            icon: Icons.history_rounded,
            text: context.l10n.campaignHistoryEmpty,
            muted: true,
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < entries.length; i++) ...[
              Text(entries[i].title,
                  style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.mobileTextPrimary)),
              const SizedBox(height: 2),
              Text(
                [
                  _segmentLabel(context, entries[i].segment),
                  _sentCountLabel(context, entries[i].sentCount),
                ].where((final s) => s.isNotEmpty).join(' · '),
                style: TextStyle(fontSize: 11.5, color: AppColors.mobileTextTertiary),
              ),
              if (i != entries.length - 1) const SizedBox(height: 12),
            ],
          ],
        );
      },
    );
  }
}

/// "Favorisi Olanlar" segmentine gönderilen bir kampanyanın gerçekte
/// TÜM kullanıcılara gitmiş gibi görünmesi (bkz. FavoriteIdsCache'teki
/// kök neden notu) esnafta güven kaybına yol açmıştı — bu widget admin'e
/// GÖNDERMEDEN ÖNCE seçtiği segmentte gerçekte kaç cihaz olduğunu
/// gösterir (bkz. getCampaignSegmentSize). "Tüm Kullanıcılar" FCM
/// konusu olduğu için kesin sayı hiçbir zaman önceden bilinemez — bu
/// durum "Tüm cihazlar" notuyla açıkça belirtilir, sahte bir sayı
/// UYDURULMAZ.
class _AudiencePreview extends ConsumerWidget {
  final String? segment;

  const _AudiencePreview({required this.segment});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final segmentValue = segment;
    if (segmentValue == null) return const SizedBox.shrink();

    final text = segmentValue == 'all'
        ? context.l10n.campaignAudiencePreviewUnknown
        : ref.watch(campaignSegmentSizeProvider(segmentValue)).when(
              data: (final size) => size == null
                  ? context.l10n.campaignAudiencePreviewUnknown
                  : size == 0
                      ? context.l10n.campaignAudiencePreviewZero
                      : context.l10n.campaignAudiencePreviewCount(size),
              loading: () => context.l10n.campaignAudiencePreviewLoading,
              error: (final _, final __) => context.l10n.campaignAudiencePreviewUnknown,
            );

    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.groups_rounded, size: 15, color: AppColors.textTertiary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text,
                style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
          ),
        ],
      ),
    );
  }
}

class _ProductPickerSheet extends StatefulWidget {
  final List<Product> products;
  const _ProductPickerSheet({required this.products});

  @override
  State<_ProductPickerSheet> createState() => _ProductPickerSheetState();
}

class _ProductPickerSheetState extends State<_ProductPickerSheet> {
  String _query = '';

  @override
  Widget build(final BuildContext context) {
    final filtered = widget.products
        .where((final p) =>
            _query.isEmpty || p.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: context.l10n.campaignPickProduct,
                prefixIcon: const Icon(Icons.search_rounded),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              onChanged: (final v) => setState(() => _query = v),
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.5),
              child: filtered.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(context.l10n.campaignPickProductEmpty),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filtered.length,
                      itemBuilder: (final context, final index) {
                        final product = filtered[index];
                        return ListTile(
                          title: Text(product.name),
                          subtitle: Text('₺${product.price.toStringAsFixed(0)}'),
                          onTap: () => Navigator.pop(context, product),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool muted;

  const _InfoLine({required this.icon, required this.text, this.muted = false});

  @override
  Widget build(final BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon,
              size: 15,
              color: muted
                  ? AppColors.mobileTextTertiary
                  : AppColors.mobileTextSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.4,
                color: muted
                    ? AppColors.mobileTextTertiary
                    : AppColors.mobileTextSecondary,
              ),
            ),
          ),
        ],
      );
}
