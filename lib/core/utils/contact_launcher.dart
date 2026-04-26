import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Launches phone dialer and WhatsApp using [url_launcher].
class ContactLauncher {
  ContactLauncher._();

  static Future<void> callPhone(
    BuildContext context,
    String? phone, {
    String? unavailableMessage,
    String? launchErrorMessage,
  }) async {
    final cleaned = _cleanPhone(phone);

    if (cleaned == null) {
      _showSnack(
        context,
        unavailableMessage ?? 'Phone number is not available',
      );
      return;
    }

    final uri = Uri.parse('tel:$cleaned');

    try {
      final ok = await launchUrl(uri);
      if (!ok && context.mounted) {
        _showSnack(
          context,
          launchErrorMessage ?? 'Could not open phone dialer',
        );
      }
    } catch (_) {
      if (context.mounted) {
        _showSnack(
          context,
          launchErrorMessage ?? 'Could not open phone dialer',
        );
      }
    }
  }

  /// [defaultCountryCallingCode] digits only, no leading + (e.g. `966`).
  static Future<void> openWhatsApp(
    BuildContext context,
    String? phone, {
    String message = 'Hello',
    String? defaultCountryCallingCode,
    String? unavailableMessage,
    String? unavailableAppMessage,
  }) async {
    final cleaned = _cleanPhone(phone);

    if (cleaned == null) {
      _showSnack(
        context,
        unavailableMessage ?? 'Phone number is not available',
      );
      return;
    }

    final normalized = _normalizeForWhatsApp(
      cleaned,
      defaultCountryCallingCode: defaultCountryCallingCode,
    );

    final appUri = Uri.parse(
      'whatsapp://send?phone=$normalized&text=${Uri.encodeComponent(message)}',
    );

    final webUri = Uri.parse(
      'https://wa.me/$normalized?text=${Uri.encodeComponent(message)}',
    );

    try {
      if (await canLaunchUrl(appUri)) {
        await launchUrl(appUri, mode: LaunchMode.externalApplication);
        return;
      }
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
        return;
      }
      if (context.mounted) {
        _showSnack(
          context,
          unavailableAppMessage ?? 'WhatsApp is not available on this device',
        );
      }
    } catch (_) {
      if (context.mounted) {
        _showSnack(
          context,
          unavailableAppMessage ?? 'WhatsApp is not available on this device',
        );
      }
    }
  }

  static String? _cleanPhone(String? phone) {
    if (phone == null || phone.trim().isEmpty) return null;
    final cleaned = phone.trim().replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (cleaned.isEmpty) return null;
    return cleaned;
  }

  static String _normalizeForWhatsApp(
    String phone, {
    String? defaultCountryCallingCode,
  }) {
    var p = phone;
    if (p.startsWith('+')) return p.substring(1);
    if (p.startsWith('00')) return p.substring(2);

    final cc = defaultCountryCallingCode?.replaceAll(RegExp(r'\D'), '') ?? '';
    if (cc.isNotEmpty && RegExp(r'^\d+$').hasMatch(p)) {
      return '$cc$p';
    }

    if (p.length == 8 && RegExp(r'^\d{8}$').hasMatch(p)) {
      return '974$p';
    }
    return p;
  }

  static void _showSnack(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
