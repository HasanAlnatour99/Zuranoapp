import 'package:flutter/material.dart';

/// Lays out [children] in one column when width is narrow, otherwise two columns.
class ResponsiveFieldsGrid extends StatelessWidget {
  const ResponsiveFieldsGrid({
    super.key,
    required this.children,
    this.twoColumnBreakpoint = 380,
    this.spacing = 12,
    this.runSpacing = 12,
  });

  final List<Widget> children;
  final double twoColumnBreakpoint;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSingleColumn = constraints.maxWidth < twoColumnBreakpoint;

        if (isSingleColumn) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i != children.length - 1) SizedBox(height: runSpacing),
              ],
            ],
          );
        }

        final half = (constraints.maxWidth - spacing) / 2;
        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children
              .map((child) => SizedBox(width: half, child: child))
              .toList(),
        );
      },
    );
  }
}
