import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/user_roles.dart';
import '../../../../providers/repository_providers.dart';
import '../../../../providers/session_provider.dart';

class CustomerDetailsController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> toggleVip({
    required String customerId,
    required bool isVip,
  }) async {
    final user = ref.read(sessionUserProvider).asData?.value;
    final sid = user?.salonId?.trim() ?? '';
    if (user == null || sid.isEmpty) {
      throw StateError('Missing session.');
    }
    final role = user.role.trim();
    if (role != UserRoles.owner && role != UserRoles.admin) {
      throw StateError('Only owner or admin can change VIP.');
    }
    await ref
        .read(customerRepositoryProvider)
        .toggleVipStatus(
          salonId: sid,
          customerId: customerId,
          isVip: isVip,
          updatedByUid: user.uid,
        );
  }

  Future<void> updateDiscount({
    required String customerId,
    required double discountPercentage,
  }) async {
    final user = ref.read(sessionUserProvider).asData?.value;
    final sid = user?.salonId?.trim() ?? '';
    if (user == null || sid.isEmpty) {
      throw StateError('Missing session.');
    }
    final role = user.role.trim();
    if (role != UserRoles.owner && role != UserRoles.admin) {
      throw StateError('Only owner or admin can change discount.');
    }
    await ref
        .read(customerRepositoryProvider)
        .updateCustomerDiscount(
          salonId: sid,
          customerId: customerId,
          discountPercentage: discountPercentage,
          updatedByUid: user.uid,
        );
  }

  Future<void> callCustomer(String phone) async {
    final cleanPhone = phone.trim();
    if (cleanPhone.isEmpty) {
      throw StateError('Phone number is empty');
    }
    final uri = Uri(scheme: 'tel', path: cleanPhone);
    final launched = await _tryLaunch(uri);
    if (!launched) {
      throw StateError('Cannot open phone dialer');
    }
  }

  Future<void> openWhatsApp(String phone) async {
    var cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.startsWith('00')) {
      cleanPhone = cleanPhone.substring(2);
    }
    if (cleanPhone.isEmpty) {
      throw StateError('Phone number is empty');
    }

    final appUri = Uri.parse('whatsapp://send?phone=$cleanPhone');
    final webUri = Uri.parse('https://wa.me/$cleanPhone');
    final launchedApp = await _tryLaunch(
      appUri,
      preferredMode: LaunchMode.externalApplication,
    );
    if (launchedApp) {
      return;
    }
    final launchedWeb = await _tryLaunch(
      webUri,
      preferredMode: LaunchMode.externalApplication,
    );
    if (!launchedWeb) {
      throw StateError('Cannot open WhatsApp');
    }
  }

  Future<bool> _tryLaunch(
    Uri uri, {
    LaunchMode preferredMode = LaunchMode.platformDefault,
  }) async {
    final modes = <LaunchMode>{
      preferredMode,
      LaunchMode.externalApplication,
      LaunchMode.platformDefault,
      LaunchMode.inAppBrowserView,
    };
    for (final mode in modes) {
      try {
        final launched = await launchUrl(uri, mode: mode);
        if (launched) return true;
      } on Object {
        // Try next mode.
      }
    }
    return false;
  }
}
