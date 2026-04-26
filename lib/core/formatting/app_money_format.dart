import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatAppMoney(double amount, String currencyCode, Locale locale) {
  final code = currencyCode.trim().isEmpty ? 'USD' : currencyCode.trim();
  try {
    return NumberFormat.simpleCurrency(
      name: code,
      locale: locale.toString(),
    ).format(amount);
  } on Object {
    return '${amount.toStringAsFixed(0)} $code';
  }
}

/// Salon-safe money string (QAR, SAR, AED, USD, …) — never hardcodes `\$`.
///
/// Pass [locale] from `Localizations.localeOf(context)` when available.
String formatMoney(num value, String currencyCode, [Locale? locale]) {
  return formatAppMoney(
    value.toDouble(),
    currencyCode,
    locale ?? const Locale('en'),
  );
}
