import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/user_roles.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_fade_in.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../features/employees/data/models/employee.dart';
import '../../../../features/sales/data/models/salon_sales_settings.dart';
import '../../../../features/sales/domain/add_sale_entry_mode.dart';
import '../../../../features/users/data/models/app_user.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/salon_streams_provider.dart';
import '../../../../providers/session_provider.dart';
import '../../../customers/presentation/providers/customer_details_providers.dart';
import '../../domain/payment_method.dart';
import '../../../owner/presentation/widgets/add_barber/add_barber_header.dart';
import '../providers/add_sale_controller.dart';
import '../providers/add_sale_entry_mode_notifier.dart';
import '../providers/add_sale_session_employee_provider.dart';
import '../providers/salon_sales_settings_provider.dart';
import '../widgets/add_sale_payment_split_fields.dart';
import '../widgets/add_sale_receipt_section.dart';
import '../widgets/barber_selector_tile.dart';
import '../widgets/customer_selector_tile.dart';
import '../widgets/order_summary_card.dart';
import '../widgets/payment_method_selector.dart';
import '../widgets/record_sale_bottom_bar.dart';
import '../widgets/service_selection_card.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

/// Single Add Sale screen for the salon (owner / admin / barber entry modes).
///
/// Wired to the canonical `/owner-sales/add` route via [AppRoutes.ownerSalesAdd]
/// (legacy `/owner-add-sale` redirects to the same screen). Reads the active
/// salon from [sessionUserProvider] and active services / employees from
/// salon-scoped Firestore streams. Always renders one of:
/// loading, error-with-retry, no-services, no-staff, or the full sale form
/// — never a blank page.
class AddSaleScreen extends ConsumerStatefulWidget {
  const AddSaleScreen({
    super.key,
    this.entryMode = AddSaleEntryMode.owner,
    this.initialBarberId,
    this.initialServiceId,
    this.initialCustomerId,
  });

  final AddSaleEntryMode entryMode;
  final String? initialBarberId;
  final String? initialServiceId;
  final String? initialCustomerId;

  @override
  ConsumerState<AddSaleScreen> createState() => _AddSaleScreenState();
}

class _AddSaleScreenState extends ConsumerState<AddSaleScreen> {
  late final ScrollController _serviceStripScrollController;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      debugPrint('[AddSaleScreen] opened (mode=${widget.entryMode.name})');
    }
    _serviceStripScrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      ref.read(addSaleEntryModeProvider.notifier).setMode(widget.entryMode);
      final settings =
          ref.read(salonSalesSettingsStreamProvider).asData?.value ??
          SalonSalesSettings.defaults();
      final notifier = ref.read(addSaleControllerProvider.notifier);
      notifier.syncEmployeeSalePolicy(settings, widget.entryMode);
      final sessionUser = ref.read(sessionUserProvider).asData?.value;
      notifier.initialize(
        barberId:
            widget.initialBarberId ??
            (widget.entryMode == AddSaleEntryMode.employee
                ? sessionUser?.employeeId
                : null),
        serviceId: widget.initialServiceId,
      );
      final cid = widget.initialCustomerId?.trim();
      if (cid == null || cid.isEmpty) return;
      final customer = await ref.read(customerByIdOnceProvider(cid).future);
      if (!mounted) return;
      if (customer != null) {
        notifier.applyLinkedCustomer(customer);
      }
    });
  }

  @override
  void dispose() {
    _serviceStripScrollController.dispose();
    super.dispose();
  }

  Future<void> _pickBarber(
    BuildContext context,
    List<Employee> activeEmployees,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final selectedId = ref.read(addSaleControllerProvider).selectedBarberId;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.only(top: 32),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
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
                  l10n.ownerAddSaleBarberField,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.ownerAddSaleSubtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: activeEmployees.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (_, index) {
                      final employee = activeEmployees[index];
                      return _ServiceProviderPickerTile(
                        employee: employee,
                        roleLabel: _serviceProviderRoleLabel(
                          l10n,
                          employee.role,
                        ),
                        selected: employee.id == selectedId,
                        onTap: () {
                          ref
                              .read(addSaleControllerProvider.notifier)
                              .selectBarber(employee.id);
                          Navigator.of(ctx).pop();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _serviceProviderRoleLabel(AppLocalizations l10n, String rawRole) {
    final normalized = rawRole.trim().toLowerCase();
    if (normalized == UserRoles.barber ||
        normalized == 'barber' ||
        normalized == 'حلاق' ||
        normalized == 'الحلاق') {
      return l10n.ownerAddSaleBarberField;
    }
    if (normalized == UserRoles.owner) {
      return l10n.roleOwner;
    }
    if (normalized == UserRoles.admin) {
      return l10n.roleAdmin;
    }
    return rawRole;
  }

  Future<void> _discountDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final currentDiscount = ref.read(addSaleControllerProvider).discountAmount;
    final initialText = currentDiscount > 0 ? currentDiscount.toString() : '';

    final rawValue = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        final controller = TextEditingController(text: initialText);

        return AlertDialog(
          title: Text(l10n.addSaleDiscountTitle),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            ],
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(hintText: l10n.addSaleDiscountHint),
            onSubmitted: (_) {
              Navigator.of(dialogContext).pop(controller.text.trim());
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(null),
              child: Text(
                MaterialLocalizations.of(dialogContext).cancelButtonLabel,
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(controller.text.trim());
              },
              child: Text(
                MaterialLocalizations.of(dialogContext).okButtonLabel,
              ),
            ),
          ],
        );
      },
    );

    if (!mounted || rawValue == null) return;

    final loc = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final value = double.tryParse(rawValue.replaceAll(',', '.')) ?? 0;
    final addState = ref.read(addSaleControllerProvider);
    final subtotal = addState.subtotal;
    final maxManual = (subtotal - addState.customerPercentDiscountAmount).clamp(
      0,
      subtotal,
    );

    if (value > maxManual) {
      messenger.showSnackBar(
        SnackBar(content: Text(loc.addSaleDiscountInvalid)),
      );
      return;
    }

    ref.read(addSaleControllerProvider.notifier).setDiscount(value);
  }

  Future<void> _customerNameDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final currentName = ref.read(addSaleControllerProvider).customerName;

    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        final controller = TextEditingController(text: currentName);

        return AlertDialog(
          title: Text(l10n.ownerAddSaleCustomerHint),
          content: TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(hintText: l10n.addSaleWalkInCustomer),
            onSubmitted: (_) {
              Navigator.of(dialogContext).pop(controller.text.trim());
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(null),
              child: Text(
                MaterialLocalizations.of(dialogContext).cancelButtonLabel,
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(controller.text.trim());
              },
              child: Text(
                MaterialLocalizations.of(dialogContext).okButtonLabel,
              ),
            ),
          ],
        );
      },
    );

    if (!mounted || name == null) return;

    ref.read(addSaleControllerProvider.notifier).updateCustomerName(name);
  }

  /// Short hint shown above the sticky checkout button when the form is invalid.
  ///
  /// Mirrors the rules in [AddSaleState.canSubmit] so the user always knows
  /// why the bottom button is disabled (instead of "disabled forever").
  String? _disabledReason({
    required AddSaleState state,
    required AppLocalizations l10n,
    required bool entryModeNeedsBarber,
    required bool receiptOk,
  }) {
    if (state.lines.isEmpty) {
      return l10n.addSaleSelectAtLeastOneService;
    }
    if (entryModeNeedsBarber &&
        (state.selectedBarberId == null ||
            state.selectedBarberId!.trim().isEmpty)) {
      return l10n.addSaleSelectStaffMember;
    }
    if (state.totalAmount <= 0.001) {
      return l10n.addSaleTotalMustBePositive;
    }
    if (state.paymentMethod == PosPaymentMethod.mixed &&
        !state.paymentStructureValid(state.totalAmount)) {
      return l10n.addSaleMixedPaymentMustEqualTotal;
    }
    if (!receiptOk) {
      return state.paymentMethod == PosPaymentMethod.mixed
          ? l10n.addSaleReceiptRequiredMixed
          : l10n.addSaleReceiptRequiredCard;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final sessionAsync = ref.watch(sessionUserProvider);

    return Scaffold(
      backgroundColor: FinanceDashboardColors.background,
      resizeToAvoidBottomInset: true,
      body: sessionAsync.when(
        loading: () => const _LoadingShell(),
        error: (e, _) => _ErrorShell(
          title: l10n.ownerAddSaleTitle,
          message: l10n.genericError,
          onBack: () => Navigator.of(context).maybePop(),
        ),
        data: (user) {
          if (user == null) {
            return _ErrorShell(
              title: l10n.ownerAddSaleTitle,
              message: l10n.genericError,
              onBack: () => Navigator.of(context).maybePop(),
            );
          }
          return _AddSaleBody(
            user: user,
            entryMode: widget.entryMode,
            l10n: l10n,
            locale: locale,
            serviceStripScrollController: _serviceStripScrollController,
            onPickBarber: _pickBarber,
            onCustomerNameDialog: _customerNameDialog,
            onDiscountDialog: _discountDialog,
            disabledReasonBuilder: _disabledReason,
          );
        },
      ),
    );
  }
}

class _AddSaleBody extends ConsumerWidget {
  const _AddSaleBody({
    required this.user,
    required this.entryMode,
    required this.l10n,
    required this.locale,
    required this.serviceStripScrollController,
    required this.onPickBarber,
    required this.onCustomerNameDialog,
    required this.onDiscountDialog,
    required this.disabledReasonBuilder,
  });

  final AppUser user;
  final AddSaleEntryMode entryMode;
  final AppLocalizations l10n;
  final Locale locale;
  final ScrollController serviceStripScrollController;
  final Future<void> Function(BuildContext, List<Employee>) onPickBarber;
  final Future<void> Function() onCustomerNameDialog;
  final Future<void> Function() onDiscountDialog;
  final String? Function({
    required AddSaleState state,
    required AppLocalizations l10n,
    required bool entryModeNeedsBarber,
    required bool receiptOk,
  })
  disabledReasonBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesStreamProvider);
    final employeesAsync = ref.watch(employeesStreamProvider);
    final salonAsync = ref.watch(sessionSalonStreamProvider);
    final addState = ref.watch(addSaleControllerProvider);
    final addNotifier = ref.read(addSaleControllerProvider.notifier);
    final settings =
        ref.watch(salonSalesSettingsStreamProvider).asData?.value ??
        SalonSalesSettings.defaults();

    ref.listen(employeesStreamProvider, (previous, next) {
      next.whenData((employees) {
        addNotifier.applyDefaultBarberIfNeeded(user, employees);
      });
    });

    ref.listen(salonSalesSettingsStreamProvider, (previous, next) {
      next.whenData((settings) {
        addNotifier.syncEmployeeSalePolicy(settings, entryMode);
      });
    });

    if (entryMode == AddSaleEntryMode.employee &&
        !settings.allowEmployeeAddSale) {
      return _ErrorShell(
        title: l10n.ownerAddSaleTitle,
        message: l10n.employeeSalesNotAllowedAdd,
        icon: AppIcons.lock_outline,
        onBack: () => Navigator.of(context).maybePop(),
      );
    }

    if (servicesAsync.isLoading && !servicesAsync.hasValue) {
      return const _LoadingShell();
    }
    if (servicesAsync.hasError && !servicesAsync.hasValue) {
      return _ErrorShell(
        title: l10n.addSaleUnableToLoadServices,
        message: l10n.genericError,
        primaryActionLabel: l10n.commonRetry,
        onPrimaryAction: () => ref.invalidate(servicesStreamProvider),
        onBack: () => Navigator.of(context).maybePop(),
      );
    }

    final services = servicesAsync.requireValue;
    final activeServices = services.where((s) => s.isActive).toList();

    final List<Employee> activeEmployees;
    if (entryMode == AddSaleEntryMode.employee) {
      final empAsync = ref.watch(addSaleSessionEmployeeProvider);
      if (empAsync.isLoading) {
        return const _LoadingShell();
      }
      if (empAsync.hasError) {
        return _ErrorShell(
          title: l10n.ownerAddSaleTitle,
          message: l10n.genericError,
          icon: AppIcons.cloud_off_outlined,
          onBack: () => Navigator.of(context).maybePop(),
        );
      }
      final emp = empAsync.asData?.value;
      if (emp == null || !emp.isActive) {
        return _ErrorShell(
          title: l10n.ownerAddSaleTitle,
          message: l10n.ownerAddSaleNoStaff,
          icon: AppIcons.groups_outlined,
          onBack: () => Navigator.of(context).maybePop(),
        );
      }
      activeEmployees = [emp];
    } else {
      if (employeesAsync.isLoading && !employeesAsync.hasValue) {
        return const _LoadingShell();
      }
      if (employeesAsync.hasError && !employeesAsync.hasValue) {
        return _ErrorShell(
          title: l10n.ownerAddSaleTitle,
          message: l10n.genericError,
          icon: AppIcons.cloud_off_outlined,
          primaryActionLabel: l10n.commonRetry,
          onPrimaryAction: () => ref.invalidate(employeesStreamProvider),
          onBack: () => Navigator.of(context).maybePop(),
        );
      }
      final employees = employeesAsync.requireValue;
      activeEmployees = employees.where((e) => e.isActive).toList();
      if (activeEmployees.isEmpty) {
        return _ErrorShell(
          title: l10n.ownerAddSaleTitle,
          message: l10n.ownerAddSaleNoStaff,
          icon: AppIcons.groups_outlined,
          onBack: () => Navigator.of(context).maybePop(),
        );
      }
    }

    final currencyCode = salonAsync.asData?.value?.currencyCode ?? 'USD';
    final canPickBarber =
        (user.role == UserRoles.owner || user.role == UserRoles.admin) &&
        entryMode != AddSaleEntryMode.employee;

    final allowedPayments = <PosPaymentMethod>{
      PosPaymentMethod.cash,
      PosPaymentMethod.card,
      if (settings.allowMixedPayment) PosPaymentMethod.mixed,
    };
    final showDiscountEditor =
        entryMode != AddSaleEntryMode.employee ||
        settings.allowEmployeeDiscount;
    final receiptOk = addState.receiptRequirementMet(
      settings: settings,
      mode: entryMode,
    );
    final entryNeedsBarber = entryMode != AddSaleEntryMode.employee;
    final canRecord = addState.canSubmit && receiptOk && !addState.isSubmitting;
    final disabledReason = canRecord
        ? null
        : disabledReasonBuilder(
            state: addState,
            l10n: l10n,
            entryModeNeedsBarber: entryNeedsBarber,
            receiptOk: receiptOk,
          );

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FinanceDashboardColors.lightPurple.withValues(alpha: 0.42),
            FinanceDashboardColors.background,
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0, 0.34, 1],
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: AppFadeIn(
              child: CustomScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverToBoxAdapter(
                    child: AddBarberHeader(
                      title: l10n.ownerAddSaleTitle,
                      subtitle: l10n.ownerAddSaleSubtitle,
                      onBack: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ServiceSelectionCard(
                      l10n: l10n,
                      locale: locale,
                      currencyCode: currencyCode,
                      services: activeServices,
                      lines: addState.lines,
                      searchQuery: addState.searchQuery,
                      onSearchChanged: addNotifier.setSearchQuery,
                      onServiceTap: addNotifier.addOrIncrementService,
                      onRemoveLine: addNotifier.removeLine,
                      serviceStripScrollController:
                          serviceStripScrollController,
                    ),
                  ),
                  if (entryMode != AddSaleEntryMode.employee)
                    SliverToBoxAdapter(
                      child: BarberSelectorTile(
                        l10n: l10n,
                        employees: activeEmployees,
                        selectedId: addState.selectedBarberId,
                        enabled: canPickBarber,
                        onTap: () => onPickBarber(context, activeEmployees),
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: CustomerSelectorTile(
                      l10n: l10n,
                      customerName: addState.customerName,
                      onAddNameTap: onCustomerNameDialog,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: PaymentMethodSelector(
                      selected: addState.paymentMethod,
                      onChanged: addNotifier.setPaymentMethod,
                      l10n: l10n,
                      allowedMethods: allowedPayments,
                    ),
                  ),
                  const SliverToBoxAdapter(child: AddSalePaymentSplitFields()),
                  const SliverToBoxAdapter(child: AddSaleReceiptSection()),
                  SliverToBoxAdapter(
                    child: OrderSummaryCard(
                      l10n: l10n,
                      locale: locale,
                      currencyCode: currencyCode,
                      subtotal: addState.subtotal,
                      discount: addState.totalDiscountAmount,
                      total: addState.totalAmount,
                      onDiscountTap: onDiscountDialog,
                      showManualDiscountEditor: showDiscountEditor,
                    ),
                  ),
                  if (addState.submitError != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 4,
                        ),
                        child: Text(
                          addState.submitError!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                ],
              ),
            ),
          ),
          _CheckoutBar(
            l10n: l10n,
            locale: locale,
            currencyCode: currencyCode,
            total: addState.totalAmount,
            enabled: canRecord,
            isLoading: addState.isSubmitting,
            disabledReason: disabledReason,
            onPressed: () async {
              if (!addState.canSubmit) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.ownerAddSaleValidation)),
                );
                return;
              }
              if (!receiptOk) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.addSaleReceiptRequiredCard)),
                );
                return;
              }
              final ok = await addNotifier.recordSale();
              if (!context.mounted) return;
              if (ok) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      entryMode == AddSaleEntryMode.employee
                          ? l10n.employeeSaleRecordedSuccess
                          : l10n.ownerAddSaleSuccess,
                    ),
                  ),
                );
                context.pop(true);
              }
            },
          ),
        ],
      ),
    );
  }
}

/// Sticky checkout strip rendered as a regular Column child (not a Stack
/// overlay) so the form sliver list is always visible above it.
class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar({
    required this.l10n,
    required this.locale,
    required this.currencyCode,
    required this.total,
    required this.enabled,
    required this.isLoading,
    required this.disabledReason,
    required this.onPressed,
  });

  final AppLocalizations l10n;
  final Locale locale;
  final String currencyCode;
  final double total;
  final bool enabled;
  final bool isLoading;
  final String? disabledReason;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (disabledReason != null && !isLoading)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: FinanceDashboardColors.lightPurple,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: FinanceDashboardColors.primaryPurple.withValues(
                      alpha: 0.18,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 18,
                      color: FinanceDashboardColors.primaryPurple,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        disabledReason!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: FinanceDashboardColors.deepPurple,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          RecordSaleBottomBar(
            l10n: l10n,
            locale: locale,
            currencyCode: currencyCode,
            total: total,
            enabled: enabled,
            isLoading: isLoading,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}

class _LoadingShell extends StatelessWidget {
  const _LoadingShell();

  @override
  Widget build(BuildContext context) {
    return const Center(child: AppLoadingIndicator(size: 40));
  }
}

class _ErrorShell extends StatelessWidget {
  const _ErrorShell({
    required this.title,
    required this.message,
    this.icon = AppIcons.cloud_off_outlined,
    this.primaryActionLabel,
    this.onPrimaryAction,
    required this.onBack,
  });

  final String title;
  final String message;
  final IconData icon;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_rounded),
              ),
            ),
          ),
          Expanded(
            child: AppFadeIn(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: AppEmptyState(
                    title: title,
                    message: message,
                    icon: icon,
                    centerContent: true,
                    primaryActionLabel: primaryActionLabel,
                    onPrimaryAction: onPrimaryAction,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceProviderPickerTile extends StatelessWidget {
  const _ServiceProviderPickerTile({
    required this.employee,
    required this.roleLabel,
    required this.selected,
    required this.onTap,
  });

  final Employee employee;
  final String roleLabel;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasPhoto =
        employee.avatarUrl != null && employee.avatarUrl!.trim().isNotEmpty;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFF4ECFF) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: selected ? const Color(0xFF7C3AED) : const Color(0xFFE5E7EB),
          width: selected ? 1.6 : 1,
        ),
        boxShadow: selected
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
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4ECFF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE9DDFE)),
                    image: hasPhoto
                        ? DecorationImage(
                            image: NetworkImage(employee.avatarUrl!.trim()),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: hasPhoto
                      ? null
                      : const Icon(
                          Icons.person_rounded,
                          color: Color(0xFF7C3AED),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        roleLabel,
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                if (selected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF7C3AED),
                    size: 22,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
