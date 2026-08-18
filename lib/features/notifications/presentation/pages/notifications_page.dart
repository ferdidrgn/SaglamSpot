import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/providers/notification_inbox_provider.dart';
import '../../../../core/services/notification_inbox_cache.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/navigation/widgets/mobile_bottom_nav.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';

/// Bildirim gelen kutusu — hem push (FCM) hem uygulama içi bildirimlerin
/// ortak listesi. Veri kaynağı: NotificationInboxCache (cihazda kalıcı,
/// bkz. core/services/notification_service.dart).
class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final inboxAsync = ref.watch(notificationInboxProvider);

    final scaffold = Scaffold(
      backgroundColor: AppColors.mobileBackground,
      bottomNavigationBar: !kIsWeb ? const MobileBottomNav() : null,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, ref, inboxAsync.value ?? const []),
            Expanded(
              child: inboxAsync.when(
                loading: () => Center(
                    child: CircularProgressIndicator(color: AppColors.mobilePrimary)),
                error: (final e, final _) => Center(child: Text('$e')),
                data: (final items) => items.isEmpty
                    ? _buildEmptyState(context)
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: items.length,
                        separatorBuilder: (final _, final __) => const SizedBox(height: 10),
                        itemBuilder: (final context, final index) => _NotificationCard(
                          notification: items[index],
                          onTap: () =>
                              ref.read(notificationInboxProvider.notifier).markRead(items[index].id),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );

    return scaffold;
  }

  Widget _buildHeader(
          final BuildContext context, final WidgetRef ref, final List<AppNotification> items) =>
      Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 16, 4),
        child: Row(
          children: [
            IconButton(
              onPressed: () => NavigationHandler.smartGoBack(context),
              icon: Icon(Icons.arrow_back_rounded, color: AppColors.mobileTextPrimary),
            ),
            Expanded(
              child: Text(
                context.l10n.notificationsTitle,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.mobileTextPrimary),
              ),
            ),
            if (items.isNotEmpty)
              PopupMenuButton<_MenuAction>(
                icon: Icon(Icons.more_vert_rounded, color: AppColors.mobileTextSecondary),
                onSelected: (final action) {
                  final notifier = ref.read(notificationInboxProvider.notifier);
                  if (action == _MenuAction.markAllRead) notifier.markAllRead();
                  if (action == _MenuAction.clearAll) notifier.clear();
                },
                itemBuilder: (final context) => [
                  PopupMenuItem(
                      value: _MenuAction.markAllRead,
                      child: Text(context.l10n.markAllReadAction)),
                  PopupMenuItem(
                      value: _MenuAction.clearAll, child: Text(context.l10n.clearAllAction)),
                ],
              ),
          ],
        ),
      );

  Widget _buildEmptyState(final BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(color: AppColors.mobileCardBg, shape: BoxShape.circle),
                child: Icon(Icons.notifications_none_rounded,
                    size: 38, color: AppColors.mobileMutedDark),
              ),
              const SizedBox(height: 18),
              Text(context.l10n.notificationsEmptyTitle,
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.mobileTextPrimary)),
              const SizedBox(height: 6),
              Text(context.l10n.notificationsEmptyDesc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13, color: AppColors.mobileTextSecondary, height: 1.5)),
            ],
          ),
        ),
      );
}

enum _MenuAction { markAllRead, clearAll }

class _NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const _NotificationCard({required this.notification, required this.onTap});

  String _relativeTime(final BuildContext context) {
    final diff = DateTime.now().difference(notification.receivedAt);
    if (diff.inMinutes < 1) return context.l10n.timeJustNow;
    if (diff.inMinutes < 60) return context.l10n.timeMinutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return context.l10n.timeHoursAgo(diff.inHours);
    return context.l10n.timeDaysAgoGeneric(diff.inDays);
  }

  @override
  Widget build(final BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.mobileSurface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
                color: notification.read
                    ? AppColors.mobileBorder
                    : AppColors.mobilePrimary.withOpacity(0.35)),
            boxShadow: [
              BoxShadow(
                  color: AppColors.mobileTextPrimary.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 5)),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppColors.mobileAccentGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.campaign_rounded, color: Colors.white, size: 19),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification.title,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w800,
                            color: AppColors.mobileTextPrimary)),
                    const SizedBox(height: 4),
                    Text(notification.body,
                        style: TextStyle(
                            fontSize: 12.5, color: AppColors.mobileTextSecondary, height: 1.4)),
                    const SizedBox(height: 6),
                    Text(_relativeTime(context),
                        style: TextStyle(fontSize: 11, color: AppColors.mobileTextTertiary)),
                  ],
                ),
              ),
              if (!notification.read)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 4, left: 6),
                  decoration: BoxDecoration(
                      color: AppColors.mobilePrimary, shape: BoxShape.circle),
                ),
            ],
          ),
        ),
      );
}
