import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../owner/presentation/widgets/add_barber/add_barber_header.dart';
import '../widgets/add_expense_form.dart';

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SafeArea(
            bottom: false,
            child: AddBarberHeader(
              title: l10n.expensesScreenAddExpense,
              subtitle: l10n.expensesScreenSubtitle,
              onBack: () => Navigator.of(context).maybePop(),
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: AddExpenseForm(
                  onSuccess: () {
                    if (context.canPop()) {
                      context.pop();
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
