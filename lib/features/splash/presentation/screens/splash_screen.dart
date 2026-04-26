import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/app_inline_message.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/app_submit_button.dart';
import '../../../../core/session/app_session_status.dart';
import '../../../../providers/session_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sessionState = ref.watch(appSessionBootstrapProvider);
    final hasBootstrapError = sessionState.status == AppSessionStatus.error;

    void retryBootstrap() {
      ref.invalidate(appEntrySessionProvider);
      ref.invalidate(appSessionBootstrapProvider);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/branding/zurano_lang.png',
                  height: 120,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.medium,
                ),
                const SizedBox(height: 24),
                if (!hasBootstrapError)
                  const AppLoader()
                else ...[
                  AppInlineMessage.error(
                    message: l10n.splashBootstrapErrorMessage,
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  AppSubmitButton(
                    label: l10n.splashRetryStartup,
                    onPressed: retryBootstrap,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
