import 'package:flutter/material.dart';

/// Owner overview premium dashboard tokens (not theme-driven for consistency).
abstract final class OwnerOverviewTokens {
  static const Color canvas = Color(0xFFF8F7FC);
  static const Color purple = Color(0xFF7C3AED);
  static const Color blue = Color(0xFF0EA5E9);
  static const Color green = Color(0xFF22C55E);
  static const Color orange = Color(0xFFF97316);
  static const Color textPrimary = Color(0xFF111827);
  static const double cardRadius = 24;
}

/// Type scale for owner shell hero + overview dashboard body.
abstract final class OwnerOverviewTypography {
  static const double insightTitle = 17;
  static const double insightBody = 14;
  static const double insightIcon = 18;

  /// KPI metric cards (2×2 grid).
  static const double kpiTitle = 15;
  static const double kpiValue = 30;
  static const double kpiDelta = 13;

  static const double chartTitle = 15;
  static const double chartSubtitle = 12;
  static const double chartBadge = 11;
  static const double chartAxis = 9;
  static const double chartTooltip = 11;

  static const double miniTitle = 14;
  static const double miniSubtitle = 12;

  static const double actionLabel = 13;
  static const double actionIcon = 18;

  /// Hero: greeting on first line, owner name on second.
  static const double heroGreeting = 14;
  static const double heroName = 16;
  static const double heroSalon = 13;
  static const double heroAvatarInitials = 12;
}
