import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/formatting/app_money_format.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../services/data/models/service.dart';
import '../providers/add_sale_controller.dart';
import '../utils/pos_service_icon.dart';
import 'service_quick_card.dart';
import 'selected_service_tile.dart';

class ServiceSelectionCard extends StatelessWidget {
  const ServiceSelectionCard({
    super.key,
    required this.l10n,
    required this.locale,
    required this.currencyCode,
    required this.services,
    required this.lines,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onServiceTap,
    required this.onRemoveLine,
    this.serviceStripScrollController,
    this.showManageServicesLink = true,
  });

  final AppLocalizations l10n;
  final Locale locale;
  final String currencyCode;
  final List<SalonService> services;
  final List<CartLine> lines;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<SalonService> onServiceTap;
  final ValueChanged<String> onRemoveLine;
  final ScrollController? serviceStripScrollController;

  /// When false, the link to salon service management is hidden (e.g. employee role).
  final bool showManageServicesLink;

  @override
  Widget build(BuildContext context) {
    final q = searchQuery.trim().toLowerCase();
    final filtered = services.where((s) {
      if (q.isEmpty) return true;
      final name = s.serviceName.trim().isNotEmpty ? s.serviceName : s.name;
      return name.toLowerCase().contains(q);
    }).toList();

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 6, 20, 14),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: FinanceDashboardColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: FinanceDashboardColors.border),
        boxShadow: [
          BoxShadow(
            color: FinanceDashboardColors.primaryPurple.withValues(alpha: 0.07),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: FinanceDashboardColors.lightPurple,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.content_cut_rounded,
                  color: FinanceDashboardColors.primaryPurple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.addSaleSelectServicesTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: FinanceDashboardColors.textPrimary,
                  ),
                ),
              ),
              if (showManageServicesLink)
                TextButton(
                  onPressed: () => context.push(AppRoutes.ownerServices),
                  style: TextButton.styleFrom(
                    foregroundColor: FinanceDashboardColors.deepPurple,
                    textStyle: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  child: Text(l10n.addSaleManageServices),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: FinanceDashboardColors.background,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: FinanceDashboardColors.border),
            ),
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 22,
                  color: FinanceDashboardColors.textSecondary.withValues(
                    alpha: 0.76,
                  ),
                ),
                hintText: l10n.addSaleSearchServicesHint,
                hintStyle: const TextStyle(
                  color: FinanceDashboardColors.textSecondary,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 138,
            child: filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: services.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  l10n.addSaleNoActiveServicesYet,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    color: FinanceDashboardColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  l10n.addSaleCreateServicesFirst,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    height: 1.35,
                                    color: FinanceDashboardColors.textSecondary,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              l10n.customerNoServicesListed,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: FinanceDashboardColors.textSecondary,
                              ),
                            ),
                    ),
                  )
                : ListView.separated(
                    controller: serviceStripScrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: filtered.length,
                    separatorBuilder: (_, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final s = filtered[index];
                      final name = s.serviceName.trim().isNotEmpty
                          ? s.serviceName.trim()
                          : s.name.trim();
                      final selected = lines.any((e) => e.serviceId == s.id);
                      return ServiceQuickCard(
                        title: name,
                        priceLabel: formatAppMoney(
                          s.price,
                          currencyCode,
                          locale,
                        ),
                        icon: posServiceIconForCategoryKey(s.categoryKey),
                        isSelected: selected,
                        onTap: () => onServiceTap(s),
                      );
                    },
                  ),
          ),
          if (lines.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              l10n.addSaleSelectedServicesTitle(lines.length),
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: FinanceDashboardColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: FinanceDashboardColors.background.withValues(
                  alpha: 0.72,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: FinanceDashboardColors.border),
              ),
              child: Column(
                children: [
                  for (final line in lines)
                    SelectedServiceTile(
                      title: '${line.serviceName} × ${line.quantity}',
                      priceLabel: formatAppMoney(
                        line.lineTotal,
                        currencyCode,
                        locale,
                      ),
                      onRemove: () => onRemoveLine(line.serviceId),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Material(
            color: FinanceDashboardColors.lightPurple.withValues(alpha: 0.28),
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                final c = serviceStripScrollController;
                if (c != null && c.hasClients) {
                  c.animateTo(
                    0,
                    duration: const Duration(milliseconds: 320),
                    curve: Curves.easeOutCubic,
                  );
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: FinanceDashboardColors.primaryPurple.withValues(
                      alpha: 0.24,
                    ),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add_rounded,
                      color: FinanceDashboardColors.primaryPurple,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.addSaleAddAnotherService,
                      style: const TextStyle(
                        color: FinanceDashboardColors.deepPurple,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
