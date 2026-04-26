import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import 'models/service.dart';
import 'service_category_catalog.dart';

/// Normalizes custom category names for duplicate detection (case + spacing).
String normalizeCustomCategoryName(String? raw) {
  if (raw == null) {
    return '';
  }
  var s = raw.trim().toLowerCase();
  s = s.replaceAll(RegExp(r'\s+'), ' ');
  return s;
}

/// Trims and collapses internal whitespace; preserves casing for display/storage.
String formatCustomCategoryForStorage(String raw) {
  return raw.trim().replaceAll(RegExp(r'\s+'), ' ');
}

String serviceCategoryLabelForKey(String key, AppLocalizations l10n) {
  switch (key) {
    case ServiceCategoryKeys.hair:
      return l10n.ownerServiceCategoryHair;
    case ServiceCategoryKeys.barberBeard:
      return l10n.ownerServiceCategoryBarberBeard;
    case ServiceCategoryKeys.nails:
      return l10n.ownerServiceCategoryNails;
    case ServiceCategoryKeys.hairRemovalWaxing:
      return l10n.ownerServiceCategoryHairRemovalWaxing;
    case ServiceCategoryKeys.other:
      return l10n.ownerServiceCategoryOther;
    case ServiceCategoryKeys.browsLashes:
      return l10n.ownerServiceCategoryBrowsLashes;
    case ServiceCategoryKeys.facialSkincare:
      return l10n.ownerServiceCategoryFacialSkincare;
    case ServiceCategoryKeys.makeup:
      return l10n.ownerServiceCategoryMakeup;
    case ServiceCategoryKeys.massageSpa:
      return l10n.ownerServiceCategoryMassageSpa;
    case ServiceCategoryKeys.packages:
      return l10n.ownerServiceCategoryPackages;
    case ServiceCategoryKeys.coloring:
      return l10n.ownerServiceCategoryColoring;
    case ServiceCategoryKeys.texturedHair:
      return l10n.ownerServiceCategoryTexturedHair;
    case ServiceCategoryKeys.bridal:
      return l10n.ownerServiceCategoryBridal;
    case ServiceCategoryKeys.tanning:
      return l10n.ownerServiceCategoryTanning;
    case ServiceCategoryKeys.medSpa:
      return l10n.ownerServiceCategoryMedSpa;
    case ServiceCategoryKeys.menGrooming:
      return l10n.ownerServiceCategoryMenGrooming;
    case ServiceCategoryKeys.haircutStyling:
      return l10n.ownerServiceCategoryHaircutStyling;
    case ServiceCategoryKeys.hairTreatments:
      return l10n.ownerServiceCategoryHairTreatments;
    case ServiceCategoryKeys.scalpTreatments:
      return l10n.ownerServiceCategoryScalpTreatments;
    case ServiceCategoryKeys.keratinSmoothing:
      return l10n.ownerServiceCategoryKeratinSmoothing;
    case ServiceCategoryKeys.hairExtensions:
      return l10n.ownerServiceCategoryHairExtensions;
    case ServiceCategoryKeys.kidsServices:
      return l10n.ownerServiceCategoryKidsServices;
    case ServiceCategoryKeys.manicurePedicure:
      return l10n.ownerServiceCategoryManicurePedicure;
    case ServiceCategoryKeys.nailArt:
      return l10n.ownerServiceCategoryNailArt;
    case ServiceCategoryKeys.threading:
      return l10n.ownerServiceCategoryThreading;
    case ServiceCategoryKeys.lashExtensions:
      return l10n.ownerServiceCategoryLashExtensions;
    case ServiceCategoryKeys.bodyTreatments:
      return l10n.ownerServiceCategoryBodyTreatments;
    case ServiceCategoryKeys.makeupPermanent:
      return l10n.ownerServiceCategoryMakeupPermanent;
    default:
      return key;
  }
}

/// Default catalog entries for pickers (keys only; labels via [serviceCategoryLabelForKey]).
List<String> getDefaultServiceCategories() =>
    List<String>.from(ServiceCategoryKeys.pickerOrderedKeys);

/// Resolved key for a service (migrates legacy `category` when needed).
String? effectiveCategoryKeyOf(SalonService s) {
  final k = s.categoryKey?.trim();
  if (k != null && k.isNotEmpty) {
    return k;
  }
  return ServiceCategoryKeys.migrateLegacyCategoryLabelToKey(s.category);
}

/// Human-readable category line for owner/customer UI.
String? displayCategoryLineForService(SalonService s, AppLocalizations l10n) {
  final key = effectiveCategoryKeyOf(s);
  if (key == null || key.isEmpty) {
    final legacy = s.category?.trim();
    return legacy?.isEmpty ?? true ? null : legacy;
  }
  if (key == ServiceCategoryKeys.other) {
    final custom = s.customCategoryName?.trim();
    if (custom != null && custom.isNotEmpty) {
      return custom;
    }
    return l10n.ownerServiceCategoryOther;
  }
  if (ServiceCategoryKeys.isKnownKey(key)) {
    return serviceCategoryLabelForKey(key, l10n);
  }
  final lbl = s.categoryLabel?.trim();
  if (lbl != null && lbl.isNotEmpty) {
    return lbl;
  }
  return key;
}

/// Custom bucket stats derived from live services.
final class CustomCategoryAggregate {
  const CustomCategoryAggregate({
    required this.normalized,
    required this.displayLabel,
    required this.serviceCount,
    required this.usageScore,
  });

  final String normalized;
  final String displayLabel;
  final int serviceCount;
  final int usageScore;
}

/// Picks the custom category to show in the 5th chip (most services, then usage).
CustomCategoryAggregate? getVisibleCustomCategory(List<SalonService> services) {
  final map =
      <
        String,
        ({int count, int totalUsage, String label, int labelTimesUsed})
      >{};
  for (final s in services) {
    if (effectiveCategoryKeyOf(s) != ServiceCategoryKeys.other) {
      continue;
    }
    final raw = s.customCategoryName?.trim();
    if (raw == null || raw.isEmpty) {
      continue;
    }
    final n = normalizeCustomCategoryName(raw);
    if (n.isEmpty) {
      continue;
    }
    final u = s.timesUsed ?? 0;
    final prev = map[n];
    if (prev == null) {
      map[n] = (count: 1, totalUsage: u, label: raw, labelTimesUsed: u);
    } else {
      final pickNewLabel = u > prev.labelTimesUsed;
      map[n] = (
        count: prev.count + 1,
        totalUsage: prev.totalUsage + u,
        label: pickNewLabel ? raw : prev.label,
        labelTimesUsed: pickNewLabel ? u : prev.labelTimesUsed,
      );
    }
  }
  if (map.isEmpty) {
    return null;
  }
  CustomCategoryAggregate? best;
  for (final e in map.entries) {
    final v = e.value;
    final cand = CustomCategoryAggregate(
      normalized: e.key,
      displayLabel: v.label,
      serviceCount: v.count,
      usageScore: v.totalUsage,
    );
    if (best == null) {
      best = cand;
      continue;
    }
    if (cand.serviceCount > best.serviceCount) {
      best = cand;
    } else if (cand.serviceCount == best.serviceCount &&
        cand.usageScore > best.usageScore) {
      best = cand;
    }
  }
  return best;
}

/// Other custom categories excluding [primaryNormalized] for overflow UI.
List<CustomCategoryAggregate> getOverflowCustomCategories(
  List<SalonService> services,
  String? primaryNormalized,
) {
  final map =
      <
        String,
        ({int count, int totalUsage, String label, int labelTimesUsed})
      >{};
  for (final s in services) {
    if (effectiveCategoryKeyOf(s) != ServiceCategoryKeys.other) {
      continue;
    }
    final raw = s.customCategoryName?.trim();
    if (raw == null || raw.isEmpty) {
      continue;
    }
    final n = normalizeCustomCategoryName(raw);
    if (n.isEmpty || n == primaryNormalized) {
      continue;
    }
    final u = s.timesUsed ?? 0;
    final prev = map[n];
    if (prev == null) {
      map[n] = (count: 1, totalUsage: u, label: raw, labelTimesUsed: u);
    } else {
      final pickNewLabel = u > prev.labelTimesUsed;
      map[n] = (
        count: prev.count + 1,
        totalUsage: prev.totalUsage + u,
        label: pickNewLabel ? raw : prev.label,
        labelTimesUsed: pickNewLabel ? u : prev.labelTimesUsed,
      );
    }
  }
  final out = map.entries
      .map(
        (e) => CustomCategoryAggregate(
          normalized: e.key,
          displayLabel: e.value.label,
          serviceCount: e.value.count,
          usageScore: e.value.totalUsage,
        ),
      )
      .toList(growable: false);
  out.sort((a, b) {
    final c = b.serviceCount.compareTo(a.serviceCount);
    if (c != 0) {
      return c;
    }
    return b.usageScore.compareTo(a.usageScore);
  });
  return out;
}

bool salonHasGenericOtherServices(List<SalonService> services) {
  for (final s in services) {
    if (effectiveCategoryKeyOf(s) != ServiceCategoryKeys.other) {
      continue;
    }
    final c = s.customCategoryName?.trim();
    if (c == null || c.isEmpty) {
      return true;
    }
  }
  return false;
}

/// Builds ordered keys for the scrollable chip row (excluding All and the 5th slot).
List<String> getTopBarCategories() {
  return [
    ...ServiceCategoryKeys.topBarHeadKeys,
    ...ServiceCategoryKeys.topBarTailKeys,
  ];
}

/// Owner filter for the services list.
@immutable
sealed class OwnerServiceCategorySelection {
  const OwnerServiceCategorySelection();

  bool matches(SalonService s);
}

final class OwnerAllServicesSelection extends OwnerServiceCategorySelection {
  const OwnerAllServicesSelection();

  @override
  bool matches(SalonService s) => true;
}

final class OwnerStandardCategorySelection
    extends OwnerServiceCategorySelection {
  const OwnerStandardCategorySelection(this.categoryKey);

  final String categoryKey;

  @override
  bool matches(SalonService s) => effectiveCategoryKeyOf(s) == categoryKey;
}

/// All services in the `other` bucket (any custom or blank custom).
final class OwnerGenericOtherSelection extends OwnerServiceCategorySelection {
  const OwnerGenericOtherSelection();

  @override
  bool matches(SalonService s) =>
      effectiveCategoryKeyOf(s) == ServiceCategoryKeys.other;
}

/// One specific custom “other” subgroup.
final class OwnerCustomOtherSelection extends OwnerServiceCategorySelection {
  const OwnerCustomOtherSelection(this.normalizedCustom);

  final String normalizedCustom;

  @override
  bool matches(SalonService s) {
    if (effectiveCategoryKeyOf(s) != ServiceCategoryKeys.other) {
      return false;
    }
    return normalizeCustomCategoryName(s.customCategoryName) ==
        normalizedCustom;
  }
}
