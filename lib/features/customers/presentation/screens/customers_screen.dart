import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/salon_streams_provider.dart';
import '../../../../providers/session_provider.dart';
import '../../data/models/customer.dart';
import '../../domain/customer_model.dart';
import '../../logic/customer_providers.dart';
import '../widgets/customer_card.dart';
import '../widgets/customer_empty_state.dart';
import '../widgets/customer_filter_chips.dart';
import '../widgets/customer_info_banner.dart';
import '../widgets/customer_permission_error.dart';
import '../widgets/customers_premium_header.dart';

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key, this.ownerShellHeroEmbedded = false});

  /// When true, shown under [OwnerDashboardHeroTabScaffold] (shared hero + light canvas).
  final bool ownerShellHeroEmbedded;

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  final _searchController = TextEditingController();
  String _selectedTag = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Customer> _applyFilters(List<Customer> customers) {
    final q = _searchController.text.trim().toLowerCase();
    return customers.where((c) {
      final searchOk =
          q.isEmpty ||
          c.fullName.toLowerCase().contains(q) ||
          c.phone.toLowerCase().contains(q);
      final seg = segmentForCustomer(c);
      final tagOk = switch (_selectedTag) {
        'All' => c.isActive,
        'New' => c.isActive && seg == CustomerSegment.newCustomer,
        'Regular' => c.isActive && seg == CustomerSegment.regular,
        'VIP' => c.isActive && seg == CustomerSegment.vip,
        'Inactive' => !c.isActive,
        _ => true,
      };
      return searchOk && tagOk;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeName = Localizations.localeOf(context).toString();
    final user = ref.watch(sessionUserProvider).asData?.value;
    final salonId = user?.salonId?.trim() ?? '';
    final salonAsync = ref.watch(sessionSalonStreamProvider);
    final salonName = salonAsync.asData?.value?.name ?? '';

    final query = _searchController.text.trim();
    final rawAsync = query.isEmpty
        ? ref.watch(customersListProvider(salonId))
        : ref.watch(customerSearchProvider((salonId: salonId, query: query)));

    final canCreate =
        user != null && (user.role == 'owner' || user.role == 'admin');
    final embedded = widget.ownerShellHeroEmbedded;

    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final clearanceBelowContent = embedded
        ? bottomInset + 16
        : bottomInset + 24;

    Widget content(AsyncValue<List<Customer>> async) {
      return async.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: FinanceDashboardColors.primaryPurple,
          ),
        ),
        error: (error, _) {
          if (isCustomerPermissionDenied(error)) {
            return const CustomerPermissionError();
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                l10n.customersGenericLoadError,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: FinanceDashboardColors.textSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
        data: (customers) {
          final filtered = _applyFilters(customers);
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, embedded ? 24 : 0, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (salonId.isEmpty) ...[
                        Text(
                          l10n.ownerServicesWaitingForSalon,
                          style: const TextStyle(
                            color: FinanceDashboardColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ] else ...[
                        CustomerInfoBanner(salonName: salonName),
                        const SizedBox(height: 20),
                      ],
                      _CustomersTitleRow(
                        count: filtered.length,
                        onFilterTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.customersScreenTitle)),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: l10n.customersSearchHint,
                          hintStyle: const TextStyle(
                            color: FinanceDashboardColors.textSecondary,
                          ),
                          prefixIcon: const Icon(Icons.search_rounded),
                          filled: true,
                          fillColor: FinanceDashboardColors.surface,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 18,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      CustomerFilterChips(
                        selectedKey: _selectedTag,
                        onSelected: (v) => setState(() => _selectedTag = v),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              if (filtered.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: clearanceBelowContent),
                    child: CustomerEmptyState(
                      canCreate: canCreate,
                      onAddCustomer: canCreate
                          ? () => context.push(AppRoutes.customerNew)
                          : null,
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    0,
                    20,
                    clearanceBelowContent + (embedded ? 120 : 8),
                  ),
                  sliver: SliverList.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final c = filtered[index];
                      return CustomerCard(
                        customer: c,
                        l10n: l10n,
                        localeName: localeName,
                        onTap: () =>
                            context.push(AppRoutes.ownerCustomerDetails(c.id)),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      );
    }

    final bodyChild = salonId.isEmpty
        ? content(const AsyncData<List<Customer>>(<Customer>[]))
        : content(rawAsync);

    if (embedded) {
      return ColoredBox(
        color: FinanceDashboardColors.background,
        child: bodyChild,
      );
    }

    return Scaffold(
      backgroundColor: FinanceDashboardColors.background,
      appBar: const AppPageHeader(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (user != null)
            CustomersPremiumHeader(user: user, salonName: salonName),
          Expanded(child: bodyChild),
        ],
      ),
    );
  }
}

class _CustomersTitleRow extends StatelessWidget {
  const _CustomersTitleRow({required this.count, required this.onFilterTap});

  final int count;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Wrap(
            spacing: 10,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                l10n.customersScreenTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: FinanceDashboardColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: FinanceDashboardColors.lightPurple,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  l10n.customersCountBadge(count),
                  style: const TextStyle(
                    color: FinanceDashboardColors.primaryPurple,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          style: IconButton.styleFrom(
            backgroundColor: FinanceDashboardColors.surface,
            foregroundColor: FinanceDashboardColors.primaryPurple,
            side: BorderSide(
              color: FinanceDashboardColors.primaryPurple.withValues(
                alpha: 0.18,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          onPressed: onFilterTap,
          icon: const Icon(Icons.tune_rounded),
        ),
      ],
    );
  }
}
