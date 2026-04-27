import 'package:barber_shop_app/core/constants/app_routes.dart';
import 'package:barber_shop_app/features/auth/presentation/screens/owner_login_screen.dart';
import 'package:barber_shop_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('Login screen shows headline and navigates to sign up', (
    WidgetTester tester,
  ) async {
    final router = GoRouter(
      initialLocation: AppRoutes.ownerLogin,
      routes: [
        GoRoute(
          path: AppRoutes.ownerLogin,
          builder: (_, _) => const OwnerLoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.ownerSignup,
          redirect: (context, state) =>
              '${AppRoutes.signup}?${AppRoutes.registerFlowQueryKey}=${AppRoutes.registerFlowSalonOwner}',
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (_, _) => const Scaffold(body: Text('register-placeholder')),
        ),
        GoRoute(
          path: AppRoutes.signup,
          builder: (_, _) => const Scaffold(body: Text('signup-placeholder')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: router,
          locale: const Locale('ar'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('سجّل الدخول لإدارة صالونك.'), findsOneWidget);

    final signupLink = find.text('إنشاء حساب');
    await tester.ensureVisible(signupLink);
    await tester.tap(signupLink);
    await tester.pumpAndSettle();

    expect(router.state.uri.path, AppRoutes.signup);
    expect(find.text('signup-placeholder'), findsOneWidget);
  });
}
