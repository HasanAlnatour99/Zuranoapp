import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/user_roles.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../features/employees/data/models/employee.dart';
import '../../../../l10n/app_localizations.dart';

class BarberSelectorTile extends StatelessWidget {
  const BarberSelectorTile({
    super.key,
    required this.l10n,
    required this.employees,
    required this.selectedId,
    required this.onTap,
    this.enabled = true,
  });

  final AppLocalizations l10n;
  final List<Employee> employees;
  final String? selectedId;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    Employee? selected;
    if (selectedId != null) {
      for (final e in employees) {
        if (e.id == selectedId) {
          selected = e;
          break;
        }
      }
    }
    final name = selected?.name ?? l10n.ownerAddSaleBarberField;
    final selectedRole = selected?.role.trim() ?? '';
    final normalizedRole = selectedRole.toLowerCase();
    final roleLabel = normalizedRole.isEmpty
        ? ''
        : (normalizedRole == UserRoles.barber ||
              normalizedRole == 'barber' ||
              normalizedRole == 'حلاق' ||
              normalizedRole == 'الحلاق')
        ? l10n.ownerAddSaleBarberField
        : selectedRole;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        elevation: 0,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: FinanceDashboardColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.035),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Builder(
                  builder: (context) {
                    final url = selected?.avatarUrl?.trim();
                    final hasPhoto = url != null && url.isNotEmpty;
                    return Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: FinanceDashboardColors.lightPurple,
                        borderRadius: BorderRadius.circular(18),
                        image: hasPhoto
                            ? DecorationImage(
                                image: CachedNetworkImageProvider(url),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: hasPhoto
                          ? null
                          : const Icon(
                              Icons.person_rounded,
                              color: FinanceDashboardColors.primaryPurple,
                            ),
                    );
                  },
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.addSaleBarberLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          color: FinanceDashboardColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: FinanceDashboardColors.textPrimary,
                        ),
                      ),
                      Text(
                        roleLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          color: FinanceDashboardColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (enabled)
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: FinanceDashboardColors.lightPurple.withValues(
                        alpha: 0.54,
                      ),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: FinanceDashboardColors.deepPurple,
                      size: 24,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
