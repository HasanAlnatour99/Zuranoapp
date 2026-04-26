import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/sale_reporting.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/repository_providers.dart';
import '../../../../providers/session_provider.dart';
import '../../data/models/expense.dart';
import '../providers/expense_providers.dart';

/// Shared create-expense form (modal sheet or full-screen route).
class AddExpenseForm extends ConsumerStatefulWidget {
  const AddExpenseForm({super.key, required this.onSuccess});

  /// Called after Firestore write succeeds (pop route or sheet).
  final VoidCallback onSuccess;

  @override
  ConsumerState<AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends ConsumerState<AddExpenseForm> {
  static const String _manualCategoryValue = '__manual_category__';
  static const List<({String en, String ar})> _defaultExpenseCategories = [
    (en: 'Rent', ar: 'الإيجار'),
    (en: 'Utilities', ar: 'المرافق'),
    (en: 'Water', ar: 'المياه'),
    (en: 'Electricity', ar: 'الكهرباء'),
    (en: 'Internet', ar: 'الإنترنت'),
    (en: 'Phone', ar: 'الهاتف'),
    (en: 'Insurance', ar: 'التأمين'),
    (en: 'Licenses & Permits', ar: 'التراخيص والتصاريح'),
    (en: 'Software & Subscriptions', ar: 'البرامج والاشتراكات'),
    (en: 'POS & Payment Fees', ar: 'رسوم نقاط البيع والدفع'),
    (en: 'Bank Fees', ar: 'الرسوم البنكية'),
    (en: 'Payroll', ar: 'الرواتب'),
    (en: 'Commissions', ar: 'العمولات'),
    (en: 'Staff Benefits', ar: 'مزايا الموظفين'),
    (en: 'Training & Education', ar: 'التدريب والتعليم'),
    (en: 'Recruitment', ar: 'التوظيف'),
    (en: 'Salon Supplies', ar: 'مستلزمات الصالون'),
    (en: 'Retail Inventory', ar: 'مخزون البيع بالتجزئة'),
    (en: 'Cleaning Supplies', ar: 'مواد التنظيف'),
    (en: 'Sanitation & PPE', ar: 'التعقيم ومعدات الحماية'),
    (en: 'Laundry', ar: 'الغسيل'),
    (en: 'Towels & Linens', ar: 'المناشف والمفارش'),
    (en: 'Equipment Purchase', ar: 'شراء المعدات'),
    (en: 'Equipment Maintenance', ar: 'صيانة المعدات'),
    (en: 'Furniture & Fixtures', ar: 'الأثاث والتجهيزات'),
    (en: 'Repairs', ar: 'الإصلاحات'),
    (en: 'Marketing', ar: 'التسويق'),
    (en: 'Advertising', ar: 'الإعلانات'),
    (en: 'Social Media', ar: 'وسائل التواصل الاجتماعي'),
    (en: 'Photography & Content', ar: 'التصوير وصناعة المحتوى'),
    (en: 'Website & Hosting', ar: 'الموقع والاستضافة'),
    (en: 'Branding & Design', ar: 'الهوية والتصميم'),
    (en: 'Promotions & Discounts', ar: 'العروض والخصومات'),
    (en: 'Shipping & Delivery', ar: 'الشحن والتوصيل'),
    (en: 'Travel & Transport', ar: 'السفر والمواصلات'),
    (en: 'Fuel', ar: 'الوقود'),
    (en: 'Office Supplies', ar: 'مستلزمات المكتب'),
    (en: 'Refreshments', ar: 'الضيافة والمرطبات'),
    (en: 'Professional Services', ar: 'الخدمات المهنية'),
    (en: 'Accounting', ar: 'المحاسبة'),
    (en: 'Legal', ar: 'الخدمات القانونية'),
    (en: 'Security', ar: 'الأمن'),
    (en: 'Waste Disposal', ar: 'إدارة النفايات'),
    (en: 'Taxes & Government Fees', ar: 'الضرائب والرسوم الحكومية'),
    (en: 'Loan Repayments', ar: 'سداد القروض'),
    (en: 'Interest Charges', ar: 'رسوم الفوائد'),
    (en: 'Miscellaneous', ar: 'مصروفات متنوعة'),
  ];

  final _titleC = TextEditingController();
  final _amountC = TextEditingController();
  final _categoryC = TextEditingController();
  final _vendorC = TextEditingController();
  final _notesC = TextEditingController();
  String _paymentMethod = SalePaymentMethods.cash;
  String _selectedCategory = _manualCategoryValue;
  DateTime _incurredAt = DateTime.now();

  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _titleC.dispose();
    _amountC.dispose();
    _categoryC.dispose();
    _vendorC.dispose();
    _notesC.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final title = _titleC.text.trim();
    final amount = double.tryParse(_amountC.text.replaceAll(',', '.').trim());
    final category = _selectedCategory == _manualCategoryValue
        ? _categoryC.text.trim()
        : _selectedCategory.trim();
    if (title.isEmpty || amount == null || amount <= 0 || category.isEmpty) {
      setState(() => _error = l10n.ownerOverviewAddExpenseValidationError);
      return;
    }

    final user = ref.read(sessionUserProvider).asData?.value;
    final salonId = user?.salonId?.trim() ?? '';
    if (user == null || salonId.isEmpty) {
      setState(() => _error = l10n.genericError);
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      final expense = Expense(
        id: '',
        salonId: salonId,
        title: title,
        category: category,
        amount: amount,
        incurredAt: _incurredAt,
        createdByUid: user.uid,
        createdByName: user.name,
        paymentMethod: _paymentMethod,
        linkedSupplierName: _vendorC.text.trim().isEmpty
            ? null
            : _vendorC.text.trim(),
        vendorName: _vendorC.text.trim().isEmpty ? null : _vendorC.text.trim(),
        notes: _notesC.text.trim().isEmpty ? null : _notesC.text.trim(),
      );
      await ref.read(expenseRepositoryProvider).createExpense(salonId, expense);
      if (!mounted) return;
      widget.onSuccess();
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error.toString());
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _incurredAt,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && mounted) {
      setState(() {
        _incurredAt = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _incurredAt.hour,
          _incurredAt.minute,
        );
      });
    }
  }

  String _paymentMethodLabel(AppLocalizations l10n, String method) {
    return switch (method) {
      SalePaymentMethods.cash => l10n.paymentMethodCash,
      SalePaymentMethods.card => l10n.paymentMethodCard,
      SalePaymentMethods.digitalWallet => l10n.paymentMethodDigitalWallet,
      SalePaymentMethods.other => l10n.paymentMethodOther,
      _ => l10n.paymentMethodOther,
    };
  }

  IconData _paymentMethodIcon(String method) {
    return switch (method) {
      SalePaymentMethods.cash => Icons.payments_rounded,
      SalePaymentMethods.card => Icons.credit_card_rounded,
      SalePaymentMethods.digitalWallet => Icons.account_balance_wallet_rounded,
      SalePaymentMethods.other => Icons.more_horiz_rounded,
      _ => Icons.payments_outlined,
    };
  }

  IconData _categoryIcon(String category) {
    final c = category.toLowerCase();
    if (c.contains('rent') || c.contains('lease') || c.contains('إيجار')) {
      return Icons.home_work_outlined;
    }
    if (c.contains('utility') ||
        c.contains('water') ||
        c.contains('electric') ||
        c.contains('مرافق') ||
        c.contains('مياه') ||
        c.contains('كهرب')) {
      return Icons.bolt_outlined;
    }
    if (c.contains('payroll') ||
        c.contains('commission') ||
        c.contains('staff') ||
        c.contains('راتب') ||
        c.contains('عمول') ||
        c.contains('موظف')) {
      return Icons.groups_outlined;
    }
    if (c.contains('marketing') ||
        c.contains('advertising') ||
        c.contains('social') ||
        c.contains('تسويق') ||
        c.contains('إعلان') ||
        c.contains('تواصل')) {
      return Icons.campaign_outlined;
    }
    if (c.contains('tax') ||
        c.contains('fee') ||
        c.contains('bank') ||
        c.contains('ضريب') ||
        c.contains('رسوم') ||
        c.contains('بنك')) {
      return Icons.receipt_long_outlined;
    }
    if (c.contains('software') ||
        c.contains('subscription') ||
        c.contains('برنامج') ||
        c.contains('اشتراك')) {
      return Icons.laptop_chromebook_outlined;
    }
    if (c.contains('inventory') ||
        c.contains('supplies') ||
        c.contains('مخزون') ||
        c.contains('مستلزم')) {
      return Icons.inventory_2_outlined;
    }
    if (c.contains('equipment') ||
        c.contains('repair') ||
        c.contains('معدات') ||
        c.contains('صيان') ||
        c.contains('إصلاح')) {
      return Icons.build_circle_outlined;
    }
    if (c.contains('travel') ||
        c.contains('fuel') ||
        c.contains('transport') ||
        c.contains('سفر') ||
        c.contains('وقود') ||
        c.contains('مواصل')) {
      return Icons.directions_car_outlined;
    }
    if (c.contains('other') ||
        c.contains('misc') ||
        c.contains('أخرى') ||
        c.contains('متنوع')) {
      return Icons.edit_outlined;
    }
    return Icons.category_outlined;
  }

  List<String> _combinedCategoryOptions(
    List<String> suggestions,
    bool isArabic,
  ) {
    final seen = <String>{};
    final combined = <String>[];
    final defaults = _defaultExpenseCategories.map(
      (entry) => isArabic ? entry.ar : entry.en,
    );
    for (final value in [...suggestions, ...defaults]) {
      final normalized = value.trim();
      if (normalized.isEmpty) {
        continue;
      }
      final key = normalized.toLowerCase();
      if (seen.add(key)) {
        combined.add(normalized);
      }
    }
    return combined;
  }

  Future<void> _openPaymentMethodPicker(AppLocalizations l10n) async {
    if (_submitting) {
      return;
    }
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _OptionPickerSheet(
        title: l10n.addSalePaymentMethodField,
        subtitle: l10n.ownerOverviewAddExpenseSubtitle,
        selectedValue: _paymentMethod,
        options: [
          _OptionSheetItem(
            value: SalePaymentMethods.cash,
            label: l10n.paymentMethodCash,
            icon: Icons.payments_rounded,
          ),
          _OptionSheetItem(
            value: SalePaymentMethods.card,
            label: l10n.paymentMethodCard,
            icon: Icons.credit_card_rounded,
          ),
          _OptionSheetItem(
            value: SalePaymentMethods.digitalWallet,
            label: l10n.paymentMethodDigitalWallet,
            icon: Icons.account_balance_wallet_rounded,
          ),
          _OptionSheetItem(
            value: SalePaymentMethods.other,
            label: l10n.paymentMethodOther,
            icon: Icons.more_horiz_rounded,
          ),
        ],
      ),
    );
    if (!mounted || selected == null) {
      return;
    }
    setState(() => _paymentMethod = selected);
  }

  Future<void> _openCategoryPicker(
    AppLocalizations l10n,
    List<String> categories,
  ) async {
    if (_submitting) {
      return;
    }
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _OptionPickerSheet(
        title: l10n.ownerOverviewAddExpenseCategoryField,
        subtitle: l10n.ownerOverviewAddExpenseSuggestedCategories,
        selectedValue: _selectedCategory,
        options: [
          for (final category in categories)
            _OptionSheetItem(
              value: category,
              label: category,
              icon: _categoryIcon(category),
            ),
          _OptionSheetItem(
            value: _manualCategoryValue,
            label: l10n.paymentMethodOther,
            icon: Icons.edit_outlined,
          ),
        ],
      ),
    );
    if (!mounted || selected == null) {
      return;
    }
    setState(() {
      _selectedCategory = selected;
      if (selected != _manualCategoryValue) {
        _categoryC.text = selected;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final suggestions = ref.watch(expenseCategorySuggestionsProvider);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final categories = _combinedCategoryOptions(suggestions, isArabic);
    final isManualCategory = _selectedCategory == _manualCategoryValue;
    final selectedCategoryLabel = isManualCategory
        ? (_categoryC.text.trim().isEmpty
              ? l10n.ownerOverviewAddExpenseCategoryField
              : _categoryC.text.trim())
        : _selectedCategory;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.ownerOverviewAddExpenseTitle,
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.small),
        Text(
          l10n.ownerOverviewAddExpenseSubtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.large),
        InkWell(
          onTap: _submitting ? null : _pickDate,
          borderRadius: BorderRadius.circular(12),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: l10n.ownerOverviewAddExpenseDateField,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              MaterialLocalizations.of(context).formatMediumDate(_incurredAt),
              style: theme.textTheme.titleMedium,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.medium),
        AppTextField(
          label: l10n.ownerOverviewAddExpenseTitleField,
          controller: _titleC,
        ),
        const SizedBox(height: AppSpacing.medium),
        InkWell(
          onTap: _submitting
              ? null
              : () => _openCategoryPicker(l10n, categories),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE9DDFE)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE9DDFE)),
                  ),
                  child: Icon(
                    _categoryIcon(selectedCategoryLabel),
                    color: const Color(0xFF7C3AED),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.ownerOverviewAddExpenseCategoryField,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        selectedCategoryLabel,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF111827),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF7C3AED),
                ),
              ],
            ),
          ),
        ),
        if (isManualCategory) ...[
          const SizedBox(height: AppSpacing.small),
          AppTextField(
            label:
                '${l10n.ownerOverviewAddExpenseCategoryField} (${l10n.paymentMethodOther})',
            controller: _categoryC,
          ),
        ],
        const SizedBox(height: AppSpacing.medium),
        AppTextField(
          label: l10n.ownerOverviewAddExpenseAmountField,
          controller: _amountC,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
          ],
        ),
        const SizedBox(height: AppSpacing.medium),
        InkWell(
          onTap: _submitting ? null : () => _openPaymentMethodPicker(l10n),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE9DDFE)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE9DDFE)),
                  ),
                  child: Icon(
                    _paymentMethodIcon(_paymentMethod),
                    color: const Color(0xFF7C3AED),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.addSalePaymentMethodField,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _paymentMethodLabel(l10n, _paymentMethod),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF111827),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF7C3AED),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.medium),
        AppTextField(
          label: l10n.ownerOverviewAddExpenseVendorField,
          controller: _vendorC,
        ),
        const SizedBox(height: AppSpacing.medium),
        AppTextField(
          label: l10n.ownerOverviewAddExpenseNotesField,
          controller: _notesC,
          maxLines: 3,
        ),
        if (_error != null) ...[
          const SizedBox(height: AppSpacing.medium),
          Text(
            _error!,
            style: theme.textTheme.bodySmall?.copyWith(color: scheme.error),
          ),
        ],
        const SizedBox(height: AppSpacing.large),
        AppPrimaryButton(
          label: l10n.ownerOverviewAddExpenseSubmit,
          isLoading: _submitting,
          onPressed: _submitting ? null : _submit,
        ),
      ],
    );
  }
}

class _OptionSheetItem {
  const _OptionSheetItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;
}

class _OptionPickerSheet extends StatelessWidget {
  const _OptionPickerSheet({
    required this.title,
    required this.subtitle,
    required this.selectedValue,
    required this.options,
  });

  final String title;
  final String subtitle;
  final String selectedValue;
  final List<_OptionSheetItem> options;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
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
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.55,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final option = options[index];
                  final selected = selectedValue == option.value;
                  return Material(
                    color: selected ? const Color(0xFFF4ECFF) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => Navigator.pop(context, option.value),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFF7C3AED)
                                : const Color(0xFFE5E7EB),
                            width: selected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE9DDFE),
                                ),
                              ),
                              child: Icon(
                                option.icon,
                                color: const Color(0xFF7C3AED),
                                size: 21,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                option.label,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF111827),
                                ),
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
