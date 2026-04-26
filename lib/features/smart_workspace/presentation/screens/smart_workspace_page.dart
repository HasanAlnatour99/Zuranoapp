import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_bar_leading_back.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/session_provider.dart';
import '../../../ai/presentation/widgets/ai_chat_input.dart';
import '../../../ai/presentation/widgets/ai_status_widgets.dart';
import '../../logic/smart_workspace_controller.dart';
import '../widgets/smart_workspace_message_list.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class SmartWorkspacePage extends ConsumerStatefulWidget {
  const SmartWorkspacePage({super.key});

  @override
  ConsumerState<SmartWorkspacePage> createState() => _SmartWorkspacePageState();
}

class _SmartWorkspacePageState extends ConsumerState<SmartWorkspacePage> {
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
    final state = ref.watch(smartWorkspaceControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeadingBack(),
        automaticallyImplyLeading: false,
        title: Text(l10n.smartWorkspaceTitle),
      ),
      body: sessionAsync.when(
        loading: () => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: AiLoadingCard(
              title: l10n.smartWorkspaceLoadingTitle,
              message: l10n.smartWorkspaceLoadingMessage,
            ),
          ),
        ),
        error: (_, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: AiErrorCard(
              title: l10n.smartWorkspaceErrorTitle,
              message: l10n.smartWorkspaceErrorMessage,
              retryLabel: l10n.smartWorkspaceRetryAction,
              onRetry: () => ref.invalidate(sessionUserProvider),
            ),
          ),
        ),
        data: (user) {
          final salonId = user?.salonId?.trim() ?? '';
          final currentUserId = user?.uid ?? '';
          if (salonId.isEmpty || currentUserId.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.large),
              child: AppEmptyState(
                title: l10n.smartWorkspaceSalonRequiredTitle,
                message: l10n.smartWorkspaceSalonRequiredMessage,
                icon: AppIcons.storefront_outlined,
              ),
            );
          }

          final suggestions = [
            SmartWorkspacePromptSuggestion(
              label: l10n.smartWorkspaceSuggestionPayrollSetup,
              prompt: l10n.smartWorkspaceSuggestionPayrollSetup,
            ),
            SmartWorkspacePromptSuggestion(
              label: l10n.smartWorkspaceSuggestionPayrollExplain,
              prompt: l10n.smartWorkspaceSuggestionPayrollExplain,
            ),
            SmartWorkspacePromptSuggestion(
              label: l10n.smartWorkspaceSuggestionAnalytics,
              prompt: l10n.smartWorkspaceSuggestionAnalytics,
            ),
            SmartWorkspacePromptSuggestion(
              label: l10n.smartWorkspaceSuggestionAttendance,
              prompt: l10n.smartWorkspaceSuggestionAttendance,
            ),
          ];

          return Column(
            children: [
              Expanded(
                child: SmartWorkspaceMessageList(
                  messages: state.messages,
                  emptyTitle: l10n.smartWorkspaceWelcomeTitle,
                  emptyMessage: l10n.smartWorkspaceWelcomeMessage,
                  suggestions: suggestions,
                  onSuggestionSelected: (prompt) => _submitPrompt(
                    salonId: salonId,
                    currentUserId: currentUserId,
                    prompt: prompt,
                  ),
                  onPromptAction: (prompt) => _submitPrompt(
                    salonId: salonId,
                    currentUserId: currentUserId,
                    prompt: prompt,
                  ),
                  onWorkspaceAction: (action) => ref
                      .read(smartWorkspaceControllerProvider.notifier)
                      .applyAction(
                        action: action,
                        salonId: salonId,
                        localeCode: Localizations.localeOf(
                          context,
                        ).languageCode,
                        currentUserId: currentUserId,
                      ),
                  onEmployeeChanged: (employeeId) => ref
                      .read(smartWorkspaceControllerProvider.notifier)
                      .selectEmployee(
                        employeeId: employeeId,
                        salonId: salonId,
                        localeCode: Localizations.localeOf(
                          context,
                        ).languageCode,
                        currentUserId: currentUserId,
                      ),
                  onPeriodChanged: (period) => ref
                      .read(smartWorkspaceControllerProvider.notifier)
                      .selectPeriod(
                        period: period,
                        salonId: salonId,
                        localeCode: Localizations.localeOf(
                          context,
                        ).languageCode,
                        currentUserId: currentUserId,
                      ),
                  onDateRangeChanged: (startDate, endDate) => ref
                      .read(smartWorkspaceControllerProvider.notifier)
                      .selectDateRange(
                        startDate: startDate,
                        endDate: endDate,
                        salonId: salonId,
                        localeCode: Localizations.localeOf(
                          context,
                        ).languageCode,
                        currentUserId: currentUserId,
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
                    title: l10n.smartWorkspaceLoadingTitle,
                    message: l10n.smartWorkspaceLoadingMessage,
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
                    title: l10n.smartWorkspaceErrorTitle,
                    message: l10n.smartWorkspaceErrorMessage,
                    retryLabel: l10n.smartWorkspaceRetryAction,
                    onRetry: () => ref
                        .read(smartWorkspaceControllerProvider.notifier)
                        .retry(
                          salonId: salonId,
                          localeCode: Localizations.localeOf(
                            context,
                          ).languageCode,
                          currentUserId: currentUserId,
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
                    label: l10n.smartWorkspaceInputLabel,
                    hintText: l10n.smartWorkspaceInputHint,
                    sendLabel: l10n.smartWorkspaceSendAction,
                    isLoading: state.isLoading,
                    onSend: () => _submitPrompt(
                      salonId: salonId,
                      currentUserId: currentUserId,
                    ),
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
    required String salonId,
    required String currentUserId,
    String? prompt,
  }) async {
    final nextPrompt = (prompt ?? _promptController.text).trim();
    if (nextPrompt.isEmpty) {
      return;
    }

    _promptController.clear();
    await ref
        .read(smartWorkspaceControllerProvider.notifier)
        .submitPrompt(
          prompt: nextPrompt,
          salonId: salonId,
          localeCode: Localizations.localeOf(context).languageCode,
          currentUserId: currentUserId,
        );
  }
}
