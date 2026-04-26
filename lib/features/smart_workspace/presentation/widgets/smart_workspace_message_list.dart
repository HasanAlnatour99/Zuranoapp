import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_surface_card.dart';
import '../../domain/models/smart_workspace_models.dart';
import '../../logic/smart_workspace_controller.dart';
import 'smart_workspace_surface_host.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class SmartWorkspacePromptSuggestion {
  const SmartWorkspacePromptSuggestion({
    required this.label,
    required this.prompt,
  });

  final String label;
  final String prompt;
}

class SmartWorkspaceMessageList extends StatelessWidget {
  const SmartWorkspaceMessageList({
    required this.messages,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.suggestions,
    required this.onSuggestionSelected,
    required this.onPromptAction,
    required this.onWorkspaceAction,
    required this.onEmployeeChanged,
    required this.onPeriodChanged,
    required this.onDateRangeChanged,
    super.key,
  });

  final List<SmartWorkspaceConversationMessage> messages;
  final String emptyTitle;
  final String emptyMessage;
  final List<SmartWorkspacePromptSuggestion> suggestions;
  final ValueChanged<String> onSuggestionSelected;
  final ValueChanged<String> onPromptAction;
  final ValueChanged<SmartWorkspaceAction> onWorkspaceAction;
  final ValueChanged<String> onEmployeeChanged;
  final ValueChanged<DateTime> onPeriodChanged;
  final void Function(DateTime startDate, DateTime endDate) onDateRangeChanged;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(AppSpacing.large),
        children: [
          AppEmptyState(
            title: emptyTitle,
            message: emptyMessage,
            icon: AppIcons.auto_awesome_outlined,
          ),
          if (suggestions.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.large),
            Wrap(
              spacing: AppSpacing.small,
              runSpacing: AppSpacing.small,
              children: suggestions
                  .map(
                    (suggestion) => ActionChip(
                      label: Text(suggestion.label),
                      onPressed: () => onSuggestionSelected(suggestion.prompt),
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.large),
      itemCount: messages.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.medium),
      itemBuilder: (context, index) {
        final message = messages[index];
        return Align(
          alignment: message.role == SmartWorkspaceConversationRole.user
              ? AlignmentDirectional.centerEnd
              : AlignmentDirectional.centerStart,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: switch (message.role) {
              SmartWorkspaceConversationRole.user => _UserMessageBubble(
                message: message,
              ),
              SmartWorkspaceConversationRole.assistant =>
                _AssistantMessageBubble(
                  message: message,
                  onPromptAction: onPromptAction,
                  onWorkspaceAction: onWorkspaceAction,
                  onEmployeeChanged: onEmployeeChanged,
                  onPeriodChanged: onPeriodChanged,
                  onDateRangeChanged: onDateRangeChanged,
                ),
            },
          ),
        );
      },
    );
  }
}

class _UserMessageBubble extends StatelessWidget {
  const _UserMessageBubble({required this.message});

  final SmartWorkspaceConversationMessage message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppSurfaceCard(
      color: scheme.primary.withValues(alpha: 0.14),
      showShadow: false,
      child: Text(message.text ?? ''),
    );
  }
}

class _AssistantMessageBubble extends StatelessWidget {
  const _AssistantMessageBubble({
    required this.message,
    required this.onPromptAction,
    required this.onWorkspaceAction,
    required this.onEmployeeChanged,
    required this.onPeriodChanged,
    required this.onDateRangeChanged,
  });

  final SmartWorkspaceConversationMessage message;
  final ValueChanged<String> onPromptAction;
  final ValueChanged<SmartWorkspaceAction> onWorkspaceAction;
  final ValueChanged<String> onEmployeeChanged;
  final ValueChanged<DateTime> onPeriodChanged;
  final void Function(DateTime startDate, DateTime endDate) onDateRangeChanged;

  @override
  Widget build(BuildContext context) {
    final surface = message.surface;
    if (surface == null) {
      return const SizedBox.shrink();
    }
    return SmartWorkspaceSurfaceHost(
      surface: surface,
      onPromptAction: onPromptAction,
      onWorkspaceAction: onWorkspaceAction,
      onEmployeeChanged: onEmployeeChanged,
      onPeriodChanged: onPeriodChanged,
      onDateRangeChanged: onDateRangeChanged,
    );
  }
}
