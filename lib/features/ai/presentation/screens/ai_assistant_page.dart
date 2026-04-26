import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_bar_leading_back.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/session_provider.dart';
import '../../application/ai_controller.dart';
import '../widgets/ai_chat_input.dart';
import '../widgets/ai_message_list.dart';
import '../widgets/ai_status_widgets.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class AiAssistantPage extends ConsumerStatefulWidget {
  const AiAssistantPage({super.key});

  @override
  ConsumerState<AiAssistantPage> createState() => _AiAssistantPageState();
}

class _AiAssistantPageState extends ConsumerState<AiAssistantPage> {
  final TextEditingController _promptController = TextEditingController();

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sessionAsync = ref.watch(sessionUserProvider);
    final state = ref.watch(aiControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeadingBack(),
        automaticallyImplyLeading: false,
        title: Text(l10n.aiAssistantTitle),
      ),
      body: sessionAsync.when(
        loading: () => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: AiLoadingCard(
              title: l10n.aiAssistantLoadingTitle,
              message: l10n.aiAssistantLoadingMessage,
            ),
          ),
        ),
        error: (_, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: AiErrorCard(
              title: l10n.aiAssistantErrorTitle,
              message: l10n.aiAssistantErrorMessage,
              retryLabel: l10n.aiAssistantRetry,
              onRetry: () => ref.invalidate(sessionUserProvider),
            ),
          ),
        ),
        data: (user) {
          final salonId = user?.salonId?.trim() ?? '';
          if (salonId.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.large),
              child: AppEmptyState(
                title: l10n.aiAssistantSalonRequiredTitle,
                message: l10n.aiAssistantSalonRequiredMessage,
                icon: AppIcons.storefront_outlined,
              ),
            );
          }

          final suggestions = [
            AiPromptSuggestion(
              label: l10n.aiAssistantSuggestionTodayRevenue,
              prompt: l10n.aiAssistantSuggestionTodayRevenue,
            ),
            AiPromptSuggestion(
              label: l10n.aiAssistantSuggestionMonthRevenue,
              prompt: l10n.aiAssistantSuggestionMonthRevenue,
            ),
            AiPromptSuggestion(
              label: l10n.aiAssistantSuggestionTopBarbers,
              prompt: l10n.aiAssistantSuggestionTopBarbers,
            ),
          ];

          return Column(
            children: [
              Expanded(
                child: AiMessageList(
                  messages: state.messages,
                  emptyTitle: l10n.aiAssistantWelcomeTitle,
                  emptyMessage: l10n.aiAssistantWelcomeMessage,
                  suggestions: suggestions,
                  onSuggestionSelected: (prompt) => _submitPrompt(
                    context: context,
                    salonId: salonId,
                    prompt: prompt,
                  ),
                  onPromptAction: (prompt) => _submitPrompt(
                    context: context,
                    salonId: salonId,
                    prompt: prompt,
                  ),
                  onRetryAction: () => ref
                      .read(aiControllerProvider.notifier)
                      .retry(
                        salonId: salonId,
                        localeCode: Localizations.localeOf(
                          context,
                        ).languageCode,
                      ),
                ),
              ),
              if (state.isLoading)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.large,
                    0,
                    AppSpacing.large,
                    AppSpacing.medium,
                  ),
                  child: AiLoadingCard(
                    title: l10n.aiAssistantLoadingTitle,
                    message: l10n.aiAssistantLoadingMessage,
                  ),
                ),
              if (state.lastError != null && !state.isLoading)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.large,
                    0,
                    AppSpacing.large,
                    AppSpacing.medium,
                  ),
                  child: AiErrorCard(
                    title: l10n.aiAssistantErrorTitle,
                    message: l10n.aiAssistantErrorMessage,
                    retryLabel: l10n.aiAssistantRetry,
                    onRetry: () => ref
                        .read(aiControllerProvider.notifier)
                        .retry(
                          salonId: salonId,
                          localeCode: Localizations.localeOf(
                            context,
                          ).languageCode,
                        ),
                  ),
                ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.large,
                    0,
                    AppSpacing.large,
                    AppSpacing.large,
                  ),
                  child: AiChatInput(
                    controller: _promptController,
                    label: l10n.aiAssistantInputLabel,
                    hintText: l10n.aiAssistantInputHint,
                    sendLabel: l10n.aiAssistantSend,
                    isLoading: state.isLoading,
                    onSend: () =>
                        _submitPrompt(context: context, salonId: salonId),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _submitPrompt({
    required BuildContext context,
    required String salonId,
    String? prompt,
  }) async {
    final nextPrompt = (prompt ?? _promptController.text).trim();
    if (nextPrompt.isEmpty) {
      return;
    }

    _promptController.clear();
    await ref
        .read(aiControllerProvider.notifier)
        .submitPrompt(
          prompt: nextPrompt,
          salonId: salonId,
          localeCode: Localizations.localeOf(context).languageCode,
        );
  }
}
