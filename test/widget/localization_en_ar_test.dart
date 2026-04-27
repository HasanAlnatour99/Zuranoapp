import 'package:barber_shop_app/core/constants/app_routes.dart';
import 'package:barber_shop_app/features/auth/presentation/screens/customer_login_screen.dart';
import 'package:barber_shop_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

Widget _appWithLocale(Locale locale) {
  final router = GoRouter(
    initialLocation: AppRoutes.customerAuth,
    routes: [
      GoRoute(
        path: AppRoutes.customerAuth,
        builder: (_, _) => const CustomerLoginScreen(),
      ),
    ],
  );
  return ProviderScope(
    child: MaterialApp.router(
      routerConfig: router,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    ),
  );
}

void main() {
  testWidgets('localization renders Arabic login copy', (tester) async {
    await tester.pumpWidget(_appWithLocale(const Locale('ar')));
    await tester.pumpAndSettle();
    expect(find.text('سجّل الدخول للمتابعة.'), findsOneWidget);
  }, tags: ['critical', 'localization']);

  testWidgets('localization renders English login copy', (tester) async {
    await tester.pumpWidget(_appWithLocale(const Locale('en')));
    await tester.pumpAndSettle();
    expect(find.text('Sign in to continue.'), findsOneWidget);
  }, tags: ['critical', 'localization']);
}
