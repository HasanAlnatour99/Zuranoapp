import '../constants/sale_reporting.dart';
import '../../l10n/app_localizations.dart';

String localizedSalePaymentMethod(AppLocalizations l10n, String method) {
  return switch (method) {
    SalePaymentMethods.cash => l10n.paymentMethodCash,
    SalePaymentMethods.card => l10n.paymentMethodCard,
    SalePaymentMethods.mixed => l10n.paymentMethodMixed,
    SalePaymentMethods.digitalWallet => l10n.paymentMethodDigitalWallet,
    SalePaymentMethods.other => l10n.paymentMethodOther,
    _ => method,
  };
}
