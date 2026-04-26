import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_modal_sheet.dart';
import '../../../../core/widgets/keyboard_safe_form_scaffold.dart';
import '../../../expenses/presentation/widgets/add_expense_form.dart';

/// Opens [AddExpenseForm] as a modal bottom sheet. The optional
/// [onCreated] callback fires once the expense is written to Firestore.
Future<void> showOwnerAddExpenseSheet(
  BuildContext context, {
  VoidCallback? onCreated,
}) {
  return showAppModalBottomSheet<void>(
    context: context,
    expand: true,
    builder: (sheetContext) => OwnerAddExpenseSheet(onCreated: onCreated),
  );
}

/// Minimal create-expense form used by the Owner overview quick action.
///
/// Writes through [expenseRepositoryProvider] with
/// [Expense.reportYear] / [Expense.reportMonth] derived from today's date so
/// the existing money aggregations pick the row up immediately.
class OwnerAddExpenseSheet extends ConsumerWidget {
  const OwnerAddExpenseSheet({super.key, this.onCreated});

  final VoidCallback? onCreated;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return KeyboardSafeModalFormScroll(
      child: AddExpenseForm(
        onSuccess: () {
          Navigator.of(context).maybePop();
          onCreated?.call();
        },
      ),
    );
  }
}
