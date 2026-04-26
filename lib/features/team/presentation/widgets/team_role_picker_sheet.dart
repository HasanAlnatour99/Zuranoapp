import 'package:flutter/material.dart';

import '../../../employees/domain/employee_role.dart';
import '../../../../l10n/app_localizations.dart';

class TeamRolePickerSheet extends StatelessWidget {
  const TeamRolePickerSheet({
    super.key,
    required this.selectedRole,
    required this.onRoleSelected,
  });

  final EmployeeRole selectedRole;
  final ValueChanged<EmployeeRole> onRoleSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 32),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.teamRolePickerTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.teamRolePickerSubtitle,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 16),
            _RoleCard(
              role: EmployeeRole.barber,
              selectedRole: selectedRole,
              icon: Icons.content_cut_rounded,
              title: l10n.teamRolePickerBarberTitle,
              subtitle: l10n.teamRolePickerBarberSubtitle,
              badge: l10n.teamRolePickerBarberBadge,
              onTap: onRoleSelected,
            ),
            const SizedBox(height: 12),
            _RoleCard(
              role: EmployeeRole.admin,
              selectedRole: selectedRole,
              icon: Icons.admin_panel_settings_rounded,
              title: l10n.teamRolePickerAdminTitle,
              subtitle: l10n.teamRolePickerAdminSubtitle,
              badge: l10n.teamRolePickerAdminBadge,
              onTap: onRoleSelected,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.role,
    required this.selectedRole,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.onTap,
  });

  final EmployeeRole role;
  final EmployeeRole selectedRole;
  final IconData icon;
  final String title;
  final String subtitle;
  final String badge;
  final ValueChanged<EmployeeRole> onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = role == selectedRole;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFF4ECFF) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFFE5E7EB),
          width: isSelected ? 1.6 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => onTap(role),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE9DDFE)),
                  ),
                  child: Icon(icon, color: const Color(0xFF7C3AED)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13.5,
                          height: 1.35,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: const Color(0xFFE9DDFE)),
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF7C3AED),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF7C3AED),
                      size: 22,
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
