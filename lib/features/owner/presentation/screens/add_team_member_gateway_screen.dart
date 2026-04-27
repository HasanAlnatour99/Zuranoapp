import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../providers/session_provider.dart';
import '../widgets/add_barber_sheet.dart';

/// Pushes onto the root stack so `go_router` can use [AppRouteNames.addTeamMember];
/// immediately opens the production [AddBarberSheet] and pops when dismissed.
class AddTeamMemberGatewayScreen extends ConsumerStatefulWidget {
  const AddTeamMemberGatewayScreen({super.key});

  @override
  ConsumerState<AddTeamMemberGatewayScreen> createState() =>
      _AddTeamMemberGatewayScreenState();
}

class _AddTeamMemberGatewayScreenState
    extends ConsumerState<AddTeamMemberGatewayScreen> {
  var _opened = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_opened) return;
    _opened = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _presentSheet());
  }

  Future<void> _presentSheet() async {
    if (!mounted) return;
    final user = ref.read(sessionUserProvider).asData?.value;
    final salonId = user?.salonId?.trim() ?? '';
    if (salonId.isEmpty) {
      if (mounted) context.pop();
      return;
    }
    await showAddBarberSheet(context, salonId: salonId);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface.withValues(alpha: 0.001),
      body: const Center(child: SizedBox(width: 24, height: 24)),
    );
  }
}
