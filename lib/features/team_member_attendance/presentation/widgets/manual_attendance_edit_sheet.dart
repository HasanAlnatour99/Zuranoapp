import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/motion/app_motion_widgets.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/firebase_providers.dart';
import '../../../../providers/repository_providers.dart';
import '../../../../providers/session_provider.dart';
import '../../../team_member_profile/presentation/theme/team_member_profile_colors.dart';
import '../../application/team_member_attendance_providers.dart';
import '../../data/models/attendance_record_model.dart';

class ManualAttendanceEditSheet extends ConsumerStatefulWidget {
  const ManualAttendanceEditSheet({
    super.key,
    required this.salonId,
    required this.employeeId,
    required this.employeeName,
    required this.record,
    required this.args,
  });

  final String salonId;
  final String employeeId;
  final String employeeName;
  final AttendanceRecordModel? record;
  final TeamMemberAttendanceArgs args;

  @override
  ConsumerState<ManualAttendanceEditSheet> createState() =>
      _ManualAttendanceEditSheetState();
}

class _ManualAttendanceEditSheetState
    extends ConsumerState<ManualAttendanceEditSheet> {
  static const _statusValues = <String>[
    'present',
    'late',
    'absent',
    'incomplete',
    'manual',
    'dayOff',
  ];

  late DateTime _day;
  DateTime? _checkIn;
  DateTime? _checkOut;
  late String _status;
  final _lateController = TextEditingController();
  final _earlyExitController = TextEditingController();
  final _notesController = TextEditingController();
  bool _missingCheckout = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final r = widget.record;
    final now = DateTime.now();
    if (r != null) {
      final parsed = DateTime.tryParse(r.attendanceDate);
      _day = parsed ?? DateTime(now.year, now.month, now.day);
      _checkIn = r.checkInAt;
      _checkOut = r.checkOutAt;
      _status = _statusValues.contains(r.status) ? r.status : 'present';
      _lateController.text = '${r.lateMinutes}';
      _earlyExitController.text = '${r.earlyExitMinutes}';
      _notesController.text = r.notes;
      _missingCheckout = r.missingCheckout;
    } else {
      _day = DateTime(now.year, now.month, now.day);
      _status = 'present';
      _lateController.text = '0';
      _earlyExitController.text = '0';
    }
  }

  @override
  void dispose() {
    _lateController.dispose();
    _earlyExitController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDay() async {
    final clock = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _day,
      firstDate: DateTime(clock.year - 2),
      lastDate: DateTime(clock.year + 1),
    );
    if (picked != null) {
      setState(() => _day = DateTime(picked.year, picked.month, picked.day));
    }
  }

  Future<void> _pickCheckIn() async {
    final tod = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        _checkIn ?? DateTime(_day.year, _day.month, _day.day, 9),
      ),
    );
    if (tod != null) {
      setState(() {
        _checkIn = DateTime(
          _day.year,
          _day.month,
          _day.day,
          tod.hour,
          tod.minute,
        );
      });
    }
  }

  Future<void> _pickCheckOut() async {
    final tod = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        _checkOut ?? DateTime(_day.year, _day.month, _day.day, 17),
      ),
    );
    if (tod != null) {
      setState(() {
        _checkOut = DateTime(
          _day.year,
          _day.month,
          _day.day,
          tod.hour,
          tod.minute,
        );
      });
    }
  }

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    final l10n = AppLocalizations.of(context)!;
    final nav = Navigator.of(context);
    final auth = ref.read(firebaseAuthProvider).currentUser;
    final user = ref.read(sessionUserProvider).asData?.value;
    if (auth == null) {
      messenger?.showSnackBar(
        SnackBar(content: Text(l10n.teamAttendanceMarkError)),
      );
      return;
    }

    final late = int.tryParse(_lateController.text.trim()) ?? 0;
    final early = int.tryParse(_earlyExitController.text.trim()) ?? 0;

    setState(() => _submitting = true);
    try {
      await ref
          .read(teamMemberAttendanceRepositoryProvider)
          .upsertManualAttendance(
            salonId: widget.salonId,
            employeeId: widget.employeeId,
            employeeName: widget.employeeName,
            attendanceDate: _day,
            checkInAt: _checkIn,
            checkOutAt: _checkOut,
            status: _status,
            lateMinutes: late,
            earlyExitMinutes: early,
            missingCheckout: _missingCheckout,
            notes: _notesController.text.trim(),
            performedBy: auth.uid,
            performedByRole: user?.role ?? 'owner',
          );

      ref.invalidate(todayAttendanceProvider(widget.args));
      ref.invalidate(recentAttendanceProvider(widget.args));
      ref.invalidate(attendanceSummaryProvider(widget.args));

      if (mounted) {
        nav.pop();
        showAppSuccessSnackBar(context, l10n.teamMemberAttendanceManualSaved);
      }
    } catch (e) {
      if (mounted) {
        messenger?.showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final localeTag = Localizations.localeOf(context).toString();
    final timeFmt = DateFormat.jm(localeTag);

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        decoration: BoxDecoration(
          color: TeamMemberProfileColors.card,
          borderRadius: BorderRadius.circular(24),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.teamMemberAttendanceManualSheetTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.teamMemberAttendanceDateLabel),
                  subtitle: Text(_day.toIso8601String().substring(0, 10)),
                  trailing: const Icon(Icons.calendar_month_rounded),
                  onTap: _pickDay,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.teamMemberAttendanceCheckInLabel),
                  subtitle: Text(
                    _checkIn == null
                        ? '--'
                        : timeFmt.format(_checkIn!.toLocal()),
                  ),
                  onTap: _pickCheckIn,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.teamMemberAttendanceCheckOutLabel),
                  subtitle: Text(
                    _checkOut == null
                        ? '--'
                        : timeFmt.format(_checkOut!.toLocal()),
                  ),
                  onTap: _pickCheckOut,
                ),
                DropdownButtonFormField<String>(
                  value: _status, // ignore: deprecated_member_use
                  decoration: InputDecoration(
                    labelText: l10n.teamMemberAttendanceStatusFieldLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  items: _statusValues
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _status = v);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _lateController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: l10n.teamMemberAttendanceLateMinutes,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _earlyExitController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: l10n.teamMemberAttendanceEarlyExitMinutes,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.teamMemberAttendanceMissingCheckoutSwitch),
                  value: _missingCheckout,
                  onChanged: (v) => setState(() => _missingCheckout = v),
                ),
                TextField(
                  controller: _notesController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: l10n.teamMemberAttendanceNotes,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: TeamMemberProfileColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _submitting ? null : _save,
                  child: _submitting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.teamMemberAttendanceSave),
                ),
                TextButton(
                  onPressed: _submitting
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: Text(
                    MaterialLocalizations.of(context).cancelButtonLabel,
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
