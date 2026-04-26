import 'package:barber_shop_app/features/payroll/data/payroll_constants.dart';
import 'package:barber_shop_app/features/payroll/presentation/widgets/payroll_recurrence_badge.dart';
import 'package:barber_shop_app/features/payroll/presentation/widgets/payroll_status_chip.dart';
import 'package:barber_shop_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpLocalized(
    WidgetTester tester,
    Locale locale,
    Widget child,
  ) {
    return tester.pumpWidget(
      MaterialApp(
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(body: child),
      ),
    );
  }

  testWidgets('recurrence badge localizes in English and Arabic', (
    WidgetTester tester,
  ) async {
    await pumpLocalized(
      tester,
      const Locale('en'),
      const PayrollRecurrenceBadge(
        recurrenceType: PayrollRecurrenceTypes.recurring,
      ),
    );
    expect(find.text('Recurring'), findsOneWidget);

    await pumpLocalized(
      tester,
      const Locale('ar'),
      const PayrollRecurrenceBadge(
        recurrenceType: PayrollRecurrenceTypes.nonrecurring,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('مرة واحدة'), findsOneWidget);
  });

  testWidgets('status chip localizes rolled back status', (
    WidgetTester tester,
  ) async {
    await pumpLocalized(
      tester,
      const Locale('en'),
      const PayrollStatusChip(status: PayrollRunStatuses.rolledBack),
    );
    expect(find.text('Rolled back'), findsOneWidget);

    await pumpLocalized(
      tester,
      const Locale('ar'),
      const PayrollStatusChip(status: PayrollRunStatuses.rolledBack),
    );
    await tester.pumpAndSettle();
    expect(find.text('تم التراجع'), findsOneWidget);
  });
}
