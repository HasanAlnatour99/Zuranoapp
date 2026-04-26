import 'package:flutter/material.dart';

/// Bottom navigation with a soft green spotlight above the active destination
/// (inspired by premium streaming-style nav bars).
class AppGlowNavigationBar extends StatelessWidget {
  const AppGlowNavigationBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationDestination> destinations;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    final labelStyleSelected = theme.textTheme.labelMedium?.copyWith(
      color: scheme.primary,
      fontWeight: FontWeight.w700,
    );
    final labelStyleUnselected = theme.textTheme.labelMedium?.copyWith(
      color: scheme.onSurfaceVariant,
      fontWeight: FontWeight.w500,
    );

    return Material(
      color: Colors.transparent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surfaceContainer,
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 1,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    scheme.primary.withValues(alpha: 0),
                    scheme.primary.withValues(alpha: 0.5),
                    scheme.primary.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 6, 0, 8 + bottomInset),
              child: Row(
                children: List.generate(destinations.length, (i) {
                  final d = destinations[i];
                  final selected = i == selectedIndex;
                  return Expanded(
                    child: _GlowNavDestination(
                      destination: d,
                      selected: selected,
                      labelStyle: selected
                          ? labelStyleSelected
                          : labelStyleUnselected,
                      onTap: () => onDestinationSelected(i),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowNavDestination extends StatelessWidget {
  const _GlowNavDestination({
    required this.destination,
    required this.selected,
    required this.labelStyle,
    required this.onTap,
  });

  final NavigationDestination destination;
  final bool selected;
  final TextStyle? labelStyle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final primary = scheme.primary;
    final muted = scheme.onSurfaceVariant;

    final iconWidget = selected && destination.selectedIcon != null
        ? destination.selectedIcon!
        : destination.icon;

    return Semantics(
      selected: selected,
      button: true,
      label: destination.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: primary.withValues(alpha: 0.12),
          highlightColor: primary.withValues(alpha: 0.06),
          child: SizedBox(
            height: 72,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                if (selected)
                  Positioned(
                    top: -4,
                    child: IgnorePointer(
                      child: SizedBox(
                        width: 80,
                        height: 44,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment.topCenter,
                              radius: 1.05,
                              colors: [
                                primary.withValues(alpha: 0.55),
                                primary.withValues(alpha: 0.2),
                                primary.withValues(alpha: 0),
                              ],
                              stops: const [0.0, 0.42, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? primary.withValues(alpha: 0.18)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected
                              ? primary.withValues(alpha: 0.45)
                              : Colors.transparent,
                          width: selected ? 1.5 : 0,
                        ),
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: primary.withValues(alpha: 0.22),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: IconTheme(
                        data: IconThemeData(
                          size: 24,
                          color: selected ? primary : muted,
                        ),
                        child: iconWidget,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      destination.label,
                      style: labelStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
