import 'package:barber_shop_app/core/widgets/adaptive_app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'owner shell bottom navigation renders and switches tab callback',
    (tester) async {
      var selected = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return AdaptiveAppShell(
                destinations: const [
                  AdaptiveShellDestination(
                    icon: Icon(Icons.dashboard_outlined),
                    selectedIcon: Icon(Icons.dashboard),
                    label: 'Overview',
                  ),
                  AdaptiveShellDestination(
                    icon: Icon(Icons.groups_outlined),
                    selectedIcon: Icon(Icons.groups),
                    label: 'Customers',
                  ),
                ],
                selectedIndex: selected,
                onDestinationSelected: (i) => setState(() => selected = i),
                body: const SizedBox(),
              );
            },
          ),
        ),
      );

      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Customers'), findsOneWidget);

      await tester.tap(find.text('Customers'));
      await tester.pumpAndSettle();

      expect(selected, 1);
    },
  );
}
