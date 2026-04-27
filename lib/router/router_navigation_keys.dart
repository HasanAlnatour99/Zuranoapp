import 'package:flutter/material.dart';

/// Root [Navigator] for [GoRouter]. Do not pass this to [StatefulShellBranch].
final GlobalKey<NavigatorState> appRootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'router_root',
);

/// One distinct [Navigator] key per [StatefulShellBranch] (required by go_router).
final GlobalKey<NavigatorState> ownerShellBranchOverviewNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'owner_shell_overview');

final GlobalKey<NavigatorState> ownerShellBranchTeamNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'owner_shell_team');

final GlobalKey<NavigatorState> ownerShellBranchCustomersNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'owner_shell_customers');

final GlobalKey<NavigatorState> ownerShellBranchMoneyNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'owner_shell_money');
