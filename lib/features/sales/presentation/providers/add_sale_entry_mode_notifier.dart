import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/add_sale_entry_mode.dart';

class AddSaleEntryModeNotifier extends Notifier<AddSaleEntryMode> {
  @override
  AddSaleEntryMode build() => AddSaleEntryMode.owner;

  void setMode(AddSaleEntryMode mode) => state = mode;
}

final addSaleEntryModeProvider =
    NotifierProvider.autoDispose<AddSaleEntryModeNotifier, AddSaleEntryMode>(
      AddSaleEntryModeNotifier.new,
    );
