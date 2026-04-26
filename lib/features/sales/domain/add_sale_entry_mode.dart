enum AddSaleEntryMode { owner, employee }

AddSaleEntryMode addSaleEntryModeFromSourceQuery(String? source) {
  return source?.trim() == 'employee'
      ? AddSaleEntryMode.employee
      : AddSaleEntryMode.owner;
}
