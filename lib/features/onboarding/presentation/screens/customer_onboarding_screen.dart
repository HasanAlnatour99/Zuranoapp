import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/onboarding_providers.dart';
import '../models/onboarding_page_data.dart';
import '../widgets/customer_onboarding_page.dart';

class CustomerOnboardingScreen extends ConsumerStatefulWidget {
  const CustomerOnboardingScreen({super.key});

  @override
  ConsumerState<CustomerOnboardingScreen> createState() =>
      _CustomerOnboardingScreenState();
}

class _CustomerOnboardingScreenState
    extends ConsumerState<CustomerOnboardingScreen> {
  final PageController _pageController = PageController();
  int _index = 0;
  bool _finishing = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboardingAndGoToAuth() async {
    setState(() => _finishing = true);
    await ref
        .read(onboardingPrefsProvider.notifier)
        .completeCustomerOnboarding();
    if (!mounted) return;
    context.go(AppRoutes.customerAuth);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pages = buildCustomerOnboardingPages(l10n);
    final isLast = _index == pages.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmall =
                constraints.maxHeight < 620 || constraints.maxWidth < 360;
            final imageHeight = isSmall ? 260.0 : 300.0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!isLast)
                  Padding(
                    padding: const EdgeInsets.only(top: 16, right: 28),
                    child: Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF7B2FF7),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: _finishing
                            ? null
                            : _completeOnboardingAndGoToAuth,
                        child: Text(
                          l10n.preAuthSkip,
                          style: const TextStyle(
                            color: Color(0xFF7B2FF7),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 48),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (value) => setState(() => _index = value),
                    itemCount: pages.length,
                    itemBuilder: (context, i) {
                      return CustomerOnboardingPage(
                        data: pages[i],
                        imageHeight: imageHeight,
                        isCompact: isSmall,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 28),
                _OnboardingDots(total: pages.length, current: _index),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: _OnboardingGradientCta(
                    label: isLast ? l10n.preAuthGetStarted : l10n.preAuthNext,
                    isLoading: _finishing && isLast,
                    onPressed: _finishing
                        ? null
                        : () async {
                            if (isLast) {
                              await _completeOnboardingAndGoToAuth();
                              return;
                            }
                            await _pageController.nextPage(
                              duration: const Duration(milliseconds: 260),
                              curve: Curves.easeOutCubic,
                            );
                          },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OnboardingDots extends StatelessWidget {
  const _OnboardingDots({required this.total, required this.current});

  final int total;
  final int current;

  static const _active = Color(0xFF7B2FF7);
  static const _inactive = Color(0xFFD6D6D6);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final selected = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: selected ? 28 : 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: selected ? _active : _inactive,
          ),
        );
      }),
    );
  }
}

class _OnboardingGradientCta extends StatelessWidget {
  const _OnboardingGradientCta({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  static const _gradient = LinearGradient(
    colors: [Color(0xFF6D28D9), Color(0xFFA855F7)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: enabled || isLoading ? _gradient : null,
        color: enabled || isLoading ? null : const Color(0xFFE5E5E5),
        borderRadius: BorderRadius.circular(22),
        boxShadow: enabled || isLoading
            ? [
                BoxShadow(
                  color: const Color(0xFF6D28D9).withValues(alpha: 0.28),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: enabled ? onPressed : null,
          child: SizedBox(
            height: 64,
            width: double.infinity,
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 26,
                      height: 26,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      label,
                      style: TextStyle(
                        color: enabled ? Colors.white : const Color(0xFF9CA3AF),
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
