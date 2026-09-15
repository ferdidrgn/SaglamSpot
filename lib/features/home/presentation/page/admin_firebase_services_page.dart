import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/services/firebase_feature_prefs.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/remote_config_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../products/presentation/widgets/admin_form_widgets.dart';

/// Admin > Firebase Servisleri — esnafın Firebase Console'a hiç girmeden
/// görebileceği/aç-kapa yapabileceği gerçek SDK durumları. BİLİNÇLİ SINIR:
/// Crashlytics/Analytics'in DETAYLI istatistik grafikleri (kaç kullanıcı,
/// hangi hata ne sıklıkla vb.) İSTEMCİ SDK'sından hiçbir şekilde
/// okunamaz — bunlar sadece Firebase Console'da vardır; burada uydurma bir
/// sayı göstermek yerine sadece bu cihazda GERÇEKTEN ölçülebilen bilgiler
/// (son oturumda çökme oldu mu, Remote Config'in en son ne zaman
/// güncellendiği, bildirim izni/token durumu) gösteriliyor. Remote
/// Config'in DEĞERLERİ de aynı şekilde sadece Firebase Console'dan
/// değiştirilebilir (istemci SDK'sı bilerek salt okunur) — burada sadece
/// güncel değeri görüp yeniden çekebiliyoruz.
class AdminFirebaseServicesPage extends StatefulWidget {
  const AdminFirebaseServicesPage({super.key});

  @override
  State<AdminFirebaseServicesPage> createState() =>
      _AdminFirebaseServicesPageState();
}

class _AdminFirebaseServicesPageState
    extends State<AdminFirebaseServicesPage> {
  bool _crashlyticsEnabled = FirebaseFeaturePrefs.crashlyticsEnabled;
  bool _analyticsEnabled = FirebaseFeaturePrefs.analyticsEnabled;
  bool _refreshingConfig = false;

  Future<void> _toggleCrashlytics(final bool value) async {
    setState(() => _crashlyticsEnabled = value);
    await FirebaseFeaturePrefs.setCrashlyticsEnabled(value);
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(value);
  }

  Future<void> _toggleAnalytics(final bool value) async {
    setState(() => _analyticsEnabled = value);
    await FirebaseFeaturePrefs.setAnalyticsEnabled(value);
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(value);
  }

  Future<void> _refreshRemoteConfig() async {
    setState(() => _refreshingConfig = true);
    final activated = await RemoteConfigService.refresh();
    if (!mounted) return;
    setState(() => _refreshingConfig = false);
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        content: Text(activated
            ? context.l10n.firebaseConfigRefreshed
            : context.l10n.firebaseConfigUnchanged),
        behavior: SnackBarBehavior.floating,
      ));
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        backgroundColor: AppColors.mobileBackground,
        appBar: AppBar(
          backgroundColor: AppColors.mobileBackground,
          elevation: 0,
          title: Text(context.l10n.firebaseServicesTitle,
              style: TextStyle(
                  color: AppColors.mobileTextPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 18)),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            if (!kIsWeb) ...[
              AdminFormSection(
                title: context.l10n.firebaseCrashlyticsTitle,
                icon: Icons.bug_report_rounded,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdminFormSwitch(
                      title: context.l10n.firebaseCrashlyticsToggle,
                      subtitle: context.l10n.firebaseCrashlyticsSubtitle,
                      value: _crashlyticsEnabled,
                      onChanged: _toggleCrashlytics,
                    ),
                    const Divider(height: 20),
                    FutureBuilder<bool>(
                      future: FirebaseCrashlytics.instance
                          .didCrashOnPreviousExecution(),
                      builder: (final context, final snapshot) => _InfoLine(
                        icon: Icons.info_outline_rounded,
                        text: !snapshot.hasData
                            ? context.l10n.firebaseChecking
                            : snapshot.data!
                                ? context.l10n.firebaseCrashedLastSession
                                : context.l10n.firebaseNoCrashLastSession,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _InfoLine(
                      icon: Icons.open_in_new_rounded,
                      text: context.l10n.firebaseStatsConsoleOnly,
                      muted: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
            ],
            AdminFormSection(
              title: context.l10n.firebaseAnalyticsTitle,
              icon: Icons.query_stats_rounded,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdminFormSwitch(
                    title: context.l10n.firebaseAnalyticsToggle,
                    subtitle: context.l10n.firebaseAnalyticsSubtitle,
                    value: _analyticsEnabled,
                    onChanged: _toggleAnalytics,
                  ),
                  const Divider(height: 20),
                  _InfoLine(
                    icon: Icons.open_in_new_rounded,
                    text: context.l10n.firebaseStatsConsoleOnly,
                    muted: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            AdminFormSection(
              title: context.l10n.firebaseRemoteConfigTitle,
              icon: Icons.tune_rounded,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoLine(
                    icon: Icons.campaign_outlined,
                    text: context.l10n.firebaseAdsEnabledValue(
                        RemoteConfigService.adsEnabled
                            ? context.l10n.firebaseValueOn
                            : context.l10n.firebaseValueOff),
                  ),
                  const SizedBox(height: 6),
                  _InfoLine(
                    icon: Icons.schedule_rounded,
                    text: context.l10n.firebaseLastFetch(
                        _formatTime(RemoteConfigService.lastFetchTime)),
                    muted: true,
                  ),
                  const SizedBox(height: 14),
                  AdminSubmitButton(
                    label: context.l10n.firebaseRefreshConfig,
                    isLoading: _refreshingConfig,
                    onTap: _refreshRemoteConfig,
                  ),
                  const SizedBox(height: 10),
                  _InfoLine(
                    icon: Icons.open_in_new_rounded,
                    text: context.l10n.firebaseConfigConsoleOnly,
                    muted: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            AdminFormSection(
              title: context.l10n.firebaseAppCheckTitle,
              icon: Icons.verified_user_rounded,
              child: kIsWeb
                  ? _InfoLine(
                      icon: Icons.info_outline_rounded,
                      text: context.l10n.firebaseAppCheckWebUnsupported,
                      muted: true,
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.14),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(context.l10n.firebaseActive,
                                  style: TextStyle(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 11.5)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _InfoLine(
                          icon: Icons.info_outline_rounded,
                          text: context.l10n.firebaseAppCheckDesc,
                          muted: true,
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 4),
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
                      future: FirebaseMessaging.instance
                          .getNotificationSettings(),
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
          ],
        ),
      );

  String _formatTime(final DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return context.l10n.timeJustNow;
    if (diff.inMinutes < 60) return context.l10n.timeMinutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return context.l10n.timeHoursAgo(diff.inHours);
    return context.l10n.timeDaysAgoGeneric(diff.inDays);
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
