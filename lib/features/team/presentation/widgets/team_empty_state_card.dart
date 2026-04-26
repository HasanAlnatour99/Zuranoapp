import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class TeamEmptyStateCard extends StatelessWidget {
  const TeamEmptyStateCard({
    super.key,
    required this.isSearchMode,
    required this.searchQuery,
    required this.onPrimaryAction,
    required this.onSecondaryAction,
    this.activeFilterLabel,
  });

  final bool isSearchMode;
  final String searchQuery;
  final VoidCallback onPrimaryAction;
  final VoidCallback onSecondaryAction;
  final String? activeFilterLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final trimmedQuery = searchQuery.trim();
    final filterLabel = activeFilterLabel?.trim() ?? '';
    final hasFilterOnly =
        isSearchMode && trimmedQuery.isEmpty && filterLabel.isNotEmpty;
    final normalizedFilter = filterLabel.toLowerCase();

    final title = hasFilterOnly
        ? l10n.teamEmptyNoFilterResultTitle(normalizedFilter)
        : isSearchMode
        ? l10n.teamEmptyNoMatchTitle
        : l10n.teamEmptyBuildTitle;

    final subtitle = hasFilterOnly
        ? l10n.teamEmptyNoFilterResultSubtitle(filterLabel)
        : isSearchMode
        ? l10n.teamEmptyNoMatchSubtitle(trimmedQuery)
        : l10n.teamEmptyBuildSubtitle;

    final primaryText = isSearchMode
        ? l10n.teamEmptyPrimaryClearSearch
        : l10n.teamEmptyPrimaryAddMember;
    final secondaryText = isSearchMode
        ? l10n.teamEmptySecondaryAddMember
        : l10n.teamEmptySecondaryLearnHow;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final offset = Tween<Offset>(
          begin: const Offset(0, 0.03),
          end: Offset.zero,
        ).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: offset, child: child),
        );
      },
      child: Container(
        key: ValueKey<String>('$isSearchMode-$trimmedQuery-$filterLabel'),
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFE9E4F5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isSearchMode)
              Image.asset(
                'assets/images/onboarding_1.png',
                height: 165,
                fit: BoxFit.contain,
              )
            else
              Container(
                height: 88,
                width: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.10),
                ),
                child: const Icon(
                  Icons.search_off_rounded,
                  size: 40,
                  color: Color(0xFF7C3AED),
                ),
              ),
            const SizedBox(height: 22),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14.5,
                height: 1.4,
                color: const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.22),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: onPrimaryAction,
                  icon: Icon(
                    isSearchMode
                        ? Icons.close_rounded
                        : Icons.person_add_alt_1_rounded,
                  ),
                  label: Text(primaryText),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: onSecondaryAction,
              child: Text(
                secondaryText,
                style: const TextStyle(
                  color: Color(0xFF6D28D9),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
