import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:saglamspot/core/common/extentions/app_context_ui_extension.dart';
import '../common/enum/enums.dart';
import '../services/ad_manager.dart';
import '../services/remote_config_service.dart';

class AdsenseBanner extends StatelessWidget {
  final AdUnitType type;
  final double height;

  const AdsenseBanner({super.key, required this.type, this.height = 90});

  @override
  Widget build(final BuildContext context) {
    if (!kIsWeb) return const SizedBox.shrink();

    if (!RemoteConfigService.adsEnabled) return const SizedBox.shrink();

    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        'Adsense • ${AdManager.getAdUnitId(type)}',
        style: context.textTheme.bodySmall,
      ),
    );
  }
}
