import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/salon_sales_settings.dart';
import '../../domain/payment_method.dart';
import '../providers/add_sale_controller.dart';
import '../providers/salon_sales_settings_provider.dart';

class AddSaleReceiptSection extends ConsumerWidget {
  const AddSaleReceiptSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(addSaleControllerProvider);
    final notifier = ref.read(addSaleControllerProvider.notifier);
    final settings =
        ref.watch(salonSalesSettingsStreamProvider).asData?.value ??
        SalonSalesSettings.defaults();

    final total = state.totalAmount;
    final p = state.paymentAmounts(total);
    final cardPart = state.paymentMethod == PosPaymentMethod.card
        ? total
        : (state.paymentMethod == PosPaymentMethod.mixed ? p.card : 0.0);
    final needsCardPhoto = settings.requireCardReceiptPhoto && cardPart > 0.009;
    final needsCashPhoto =
        settings.requireCashReceiptPhoto &&
        state.paymentMethod == PosPaymentMethod.cash;

    String? helper;
    if (needsCardPhoto) {
      helper = state.paymentMethod == PosPaymentMethod.mixed
          ? l10n.addSaleReceiptRequiredMixed
          : l10n.addSaleReceiptRequiredCard;
    } else if (state.paymentMethod == PosPaymentMethod.cash) {
      helper = l10n.addSaleOptionalCashPhotoHint;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: FinanceDashboardColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.addSaleReceiptSectionTitle,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: FinanceDashboardColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.addSaleReceiptSectionBody,
              style: TextStyle(
                fontSize: 13,
                height: 1.35,
                color: FinanceDashboardColors.textSecondary,
              ),
            ),
            if (helper != null) ...[
              const SizedBox(height: 8),
              Text(
                helper,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: (needsCardPhoto || needsCashPhoto)
                      ? Theme.of(context).colorScheme.error
                      : FinanceDashboardColors.textSecondary,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final file = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 82,
                    );
                    if (file != null) {
                      notifier.setReceiptImage(file);
                    }
                  },
                  icon: const Icon(Icons.photo_camera_rounded, size: 20),
                  label: Text(
                    state.receiptImage == null
                        ? l10n.addSaleReceiptTakePhoto
                        : l10n.addSaleReceiptRetake,
                  ),
                ),
                if (state.receiptImage != null) ...[
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: notifier.clearReceiptImage,
                    child: Text(l10n.addSaleReceiptRemove),
                  ),
                ],
              ],
            ),
            if (state.receiptImage != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: FinanceDashboardColors.primaryPurple.withValues(
                        alpha: 0.35,
                      ),
                    ),
                  ),
                  child: Image.file(
                    File(state.receiptImage!.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
