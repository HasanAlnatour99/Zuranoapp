import '../../../../l10n/app_localizations.dart';

/// Static content for a single customer onboarding screen (copy + image asset).
class OnboardingPageData {
  const OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    this.showImageCardBackground = false,
  });

  final String title;
  final String subtitle;
  final String imagePath;

  /// When false, [OnboardingImageCard] is plain white (no purple frame/shadow) for
  /// transparent PNGs. Default: false for all customer onboarding slides.
  final bool showImageCardBackground;
}

/// Image paths for bundled onboarding art (`pubspec.yaml`).
abstract final class CustomerOnboardingAssets {
  /// First onboarding slide (swapped with onboarding_5).
  static const onboarding3 = 'assets/images/onboarding_3.png';

  /// Second onboarding slide (replaces former onboarding_2 art).
  static const onboarding4 = 'assets/images/onboarding_4.png';

  /// Third onboarding slide (swapped with onboarding_3).
  static const onboarding5 = 'assets/images/onboarding_5.png';
}

/// Localized page list for [CustomerOnboardingScreen].
List<OnboardingPageData> buildCustomerOnboardingPages(AppLocalizations l10n) {
  return [
    OnboardingPageData(
      title: l10n.preAuthSlideSalonTitle,
      subtitle: l10n.preAuthSlideSalonSubtitle,
      imagePath: CustomerOnboardingAssets.onboarding3,
    ),
    OnboardingPageData(
      title: l10n.preAuthSlideBarberTitle,
      subtitle: l10n.preAuthSlideBarberSubtitle,
      imagePath: CustomerOnboardingAssets.onboarding4,
    ),
    OnboardingPageData(
      title: l10n.preAuthSlideBookingTitle,
      subtitle: l10n.preAuthSlideBookingSubtitle,
      imagePath: CustomerOnboardingAssets.onboarding5,
    ),
  ];
}
