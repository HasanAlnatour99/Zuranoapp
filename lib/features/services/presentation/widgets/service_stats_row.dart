import 'package:flutter/material.dart';

import '../../../../core/ui/app_icons.dart';
import '../../../../core/widgets/zurano/zurano_stat_card.dart';
import '../../../../l10n/app_localizations.dart';

class ServiceStatsRow extends StatelessWidget {
  const ServiceStatsRow({
    super.key,
    required this.total,
    required this.active,
    required this.inactive,
  });

  final int total;
  final int active;
  final int inactive;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final cards = <Widget>[
      SizedBox(
        width: 156,
        child: ZuranoStatCard(
          label: l10n.ownerServicesStatTotal,
          value: '$total',
          icon: AppIcons.inventory_2_outlined,
          highlighted: false,
        ),
      ),
      SizedBox(
        width: 156,
        child: ZuranoStatCard(
          label: l10n.ownerServicesStatActive,
          value: '$active',
          icon: AppIcons.check_rounded,
          highlighted: true,
        ),
      ),
      SizedBox(
        width: 156,
        child: ZuranoStatCard(
          label: l10n.ownerServicesStatInactive,
          value: '$inactive',
          icon: AppIcons.close_rounded,
          highlighted: false,
        ),
      ),
    ];

    return SizedBox(
      height: 92,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final fitsWithoutScroll = constraints.maxWidth >= (156 * 3) + 20;
          if (fitsWithoutScroll) {
            return Row(
              children: [
                Expanded(child: cards[0]),
                const SizedBox(width: 10),
                Expanded(child: cards[1]),
                const SizedBox(width: 10),
                Expanded(child: cards[2]),
              ],
            );
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                cards[0],
                const SizedBox(width: 10),
                cards[1],
                const SizedBox(width: 10),
                cards[2],
              ],
            ),
          );
        },
      ),
    );
  }
}
