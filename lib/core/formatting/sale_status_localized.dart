import '../../l10n/app_localizations.dart';
import '../constants/sale_reporting.dart';

String localizedSaleStatus(AppLocalizations l10n, String status) {
  return switch (status) {
    SaleStatuses.completed => l10n.salesStatusCompleted,
    SaleStatuses.pending => l10n.salesStatusPending,
    SaleStatuses.refunded => l10n.salesStatusRefunded,
    SaleStatuses.voided => l10n.salesStatusVoided,
    _ => status,
  };
}
