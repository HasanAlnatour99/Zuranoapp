import 'package:barber_shop_app/core/session/app_session_status.dart';
import 'package:barber_shop_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:barber_shop_app/l10n/app_localizations.dart';
import 'package:barber_shop_app/providers/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestSplashBootstrap extends AppSessionBootstrapNotifier {
  @override
  AppSessionState build() {
    return const AppSessionState(status: AppSessionStatus.initializing);
  }
}

void main() {
  testWidgets('Splash screen renders branding', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appSessionBootstrapProvider.overrideWith(_TestSplashBootstrap.new),
        ],
        child: MaterialApp(
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const SplashScreen(),
        ),
      ),
    );

    await tester.pump();
    expect(
      find.image(const AssetImage('assets/images/branding/zurano_lang.png')),
      findsOneWidget,
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
