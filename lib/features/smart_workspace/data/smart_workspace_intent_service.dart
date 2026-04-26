import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/models/smart_workspace_intent.dart';
import '../domain/models/smart_workspace_models.dart';
import 'smart_workspace_intent_json_schema.dart';

class SmartWorkspaceIntentService {
  SmartWorkspaceIntentService({required FirebaseAuth auth}) : _auth = auth;

  final FirebaseAuth _auth;

  Future<SmartWorkspaceIntent> parseIntent({
    required String prompt,
    required String localeCode,
  }) async {
    try {
      final response = await FirebaseAI.googleAI(auth: _auth)
          .generativeModel(
            model: 'gemini-2.5-flash',
            systemInstruction: Content('system', [
              TextPart(_systemPrompt(localeCode)),
            ]),
            generationConfig: GenerationConfig(
              responseMimeType: 'application/json',
              responseJsonSchema: SmartWorkspaceIntentJsonSchema.json,
              temperature: 0,
              maxOutputTokens: 700,
            ),
          )
          .generateContent([Content.text(prompt)]);

      final text = response.text?.trim();
      if (text == null || text.isEmpty) {
        return _heuristicIntent(prompt);
      }

      final decoded = jsonDecode(text);
      if (decoded is! Map<String, dynamic>) {
        return _heuristicIntent(prompt);
      }

      return SmartWorkspaceIntent.fromJson(decoded);
    } on Object {
      return _heuristicIntent(prompt);
    }
  }

  String _systemPrompt(String localeCode) {
    return '''
You classify barber shop assistant requests into ONE smart workspace flow.

Allowed flows:
- payroll_setup_wizard
- add_payroll_element
- payroll_explanation
- dynamic_analytics
- attendance_correction
- booking_helper
- unknown

Rules:
- Return JSON only.
- Extract only what the user clearly asked for.
- Do not invent employee ids or dates.
- Prefer employeeQuery over guessing an employee id.
- For dates use YYYY-MM-DD when explicit dates are present.
- For month requests, extract numeric year/month when possible.
- For attendance correction, extract checkInTime and checkOutTime in 24h HH:mm when possible.
- For payroll element creation, extract:
  - elementName
  - elementClassification
  - elementRecurrenceType
  - elementCalculationMethod
  - elementDefaultAmount
- Active locale: $localeCode.
''';
  }

  static SmartWorkspaceIntent _heuristicIntent(String prompt) {
    final normalized = prompt.toLowerCase();
    final dateRange = _parseExplicitDateRange(normalized);
    final monthMatch = _parseMonth(normalized);
    final timeRange = _parseTimes(normalized);

    if (_containsAny(normalized, const [
      'attendance correction',
      'correct attendance',
      'fix attendance',
      'attendance request',
      'check in',
      'check out',
      'late',
      'absent',
      'attendance',
      'تصحيح حضور',
      'تعديل حضور',
      'الحضور',
      'تسجيل الدخول',
      'تسجيل الخروج',
    ])) {
      return SmartWorkspaceIntent(
        flow: SmartWorkspaceFlowType.attendanceCorrection,
        employeeQuery: _extractAfterFor(normalized),
        startDate: dateRange?.$1,
        endDate: dateRange?.$2,
        attendanceStatus: _parseAttendanceStatus(normalized),
        checkInTime: timeRange.$1,
        checkOutTime: timeRange.$2,
      );
    }

    if (_containsAny(normalized, const [
      'add payroll element',
      'new payroll element',
      'payroll element',
      'allowance',
      'bonus',
      'deduction',
      'اضافة عنصر راتب',
      'إضافة عنصر راتب',
      'بدل',
      'مكافأة',
      'خصم',
    ])) {
      return SmartWorkspaceIntent(
        flow: SmartWorkspaceFlowType.addPayrollElement,
        elementName: _extractElementName(normalized),
        elementClassification: _parseClassification(normalized),
        elementRecurrenceType: _parseRecurrence(normalized),
        elementCalculationMethod: _parseCalculationMethod(normalized),
        elementDefaultAmount: _parseAmount(normalized),
      );
    }

    if (_containsAny(normalized, const [
      'explain payroll',
      'payroll breakdown',
      'break down payroll',
      'why is payroll',
      'explain pay',
      'اشرح الراتب',
      'تفصيل الراتب',
      'تفكيك الراتب',
    ])) {
      return SmartWorkspaceIntent(
        flow: SmartWorkspaceFlowType.payrollExplanation,
        employeeQuery: _extractAfterFor(normalized),
        year: monthMatch?.$1,
        month: monthMatch?.$2,
      );
    }

    if (_containsAny(normalized, const [
      'payroll setup',
      'setup payroll',
      'configure payroll',
      'salary setup',
      'اعداد الرواتب',
      'إعداد الرواتب',
      'تهيئة الرواتب',
    ])) {
      return SmartWorkspaceIntent(
        flow: SmartWorkspaceFlowType.payrollSetupWizard,
        employeeQuery: _extractAfterFor(normalized),
        year: monthMatch?.$1,
        month: monthMatch?.$2,
      );
    }

    if (_containsAny(normalized, const [
      'analytics',
      'analysis',
      'revenue',
      'expenses',
      'profit',
      'compare',
      'summary',
      'trend',
      'تحليل',
      'ايرادات',
      'إيرادات',
      'مصاريف',
      'ربح',
      'مقارنة',
      'ملخص',
    ])) {
      return SmartWorkspaceIntent(
        flow: SmartWorkspaceFlowType.dynamicAnalytics,
        year: monthMatch?.$1,
        month: monthMatch?.$2,
        startDate: dateRange?.$1,
        endDate: dateRange?.$2,
      );
    }

    return const SmartWorkspaceIntent(flow: SmartWorkspaceFlowType.unknown);
  }

  static bool _containsAny(String normalized, List<String> values) {
    return values.any(normalized.contains);
  }

  static (String?, String?) _parseTimes(String prompt) {
    final matches = RegExp(
      r'\b([01]?\d|2[0-3]):([0-5]\d)\b',
    ).allMatches(prompt).toList(growable: false);
    final checkIn = matches.isNotEmpty ? matches.first.group(0) : null;
    final checkOut = matches.length > 1 ? matches[1].group(0) : null;
    return (checkIn, checkOut);
  }

  static (DateTime, DateTime)? _parseExplicitDateRange(String prompt) {
    final matches = RegExp(
      r'\b(\d{4})-(\d{2})-(\d{2})\b',
    ).allMatches(prompt).take(2).toList(growable: false);
    if (matches.length < 2) {
      return null;
    }
    final start = _dateFromMatch(matches.first);
    final end = _dateFromMatch(matches.last);
    if (start == null || end == null || start.isAfter(end)) {
      return null;
    }
    return (start, end);
  }

  static DateTime? _dateFromMatch(RegExpMatch match) {
    final year = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final day = int.parse(match.group(3)!);
    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }
    return date;
  }

  static (int, int)? _parseMonth(String prompt) {
    final now = DateTime.now();
    final aliases = <int, List<String>>{
      1: ['january', 'jan', 'يناير'],
      2: ['february', 'feb', 'فبراير'],
      3: ['march', 'mar', 'مارس'],
      4: ['april', 'apr', 'ابريل', 'أبريل'],
      5: ['may', 'مايو'],
      6: ['june', 'jun', 'يونيو'],
      7: ['july', 'jul', 'يوليو'],
      8: ['august', 'aug', 'اغسطس', 'أغسطس'],
      9: ['september', 'sep', 'sept', 'سبتمبر'],
      10: ['october', 'oct', 'اكتوبر', 'أكتوبر'],
      11: ['november', 'nov', 'نوفمبر'],
      12: ['december', 'dec', 'ديسمبر'],
    };
    for (final entry in aliases.entries) {
      if (!entry.value.any(prompt.contains)) {
        continue;
      }
      final yearMatch = RegExp(r'\b(20\d{2})\b').firstMatch(prompt);
      return (
        yearMatch != null ? int.parse(yearMatch.group(1)!) : now.year,
        entry.key,
      );
    }

    if (_containsAny(prompt, const [
      'this month',
      'الشهر',
      'this payroll month',
    ])) {
      return (now.year, now.month);
    }
    return null;
  }

  static String? _extractAfterFor(String prompt) {
    final match = RegExp(r'\bfor\s+([a-z0-9 _-]+)$').firstMatch(prompt);
    if (match == null) {
      return null;
    }
    final value = match.group(1)?.trim();
    return value == null || value.isEmpty ? null : value;
  }

  static String? _extractElementName(String prompt) {
    final explicitMatch = RegExp(
      r'(?:called|named|اسم(?:ه)?|اسمها)\s+["“]?([a-z0-9 _-]+)["”]?',
    ).firstMatch(prompt);
    if (explicitMatch != null) {
      return explicitMatch.group(1)?.trim();
    }
    for (final keyword in const ['allowance', 'bonus', 'deduction']) {
      final index = prompt.indexOf(keyword);
      if (index >= 0) {
        return keyword;
      }
    }
    return null;
  }

  static String? _parseClassification(String prompt) {
    if (_containsAny(prompt, const ['deduction', 'خصم'])) {
      return 'deduction';
    }
    if (_containsAny(prompt, const ['information', 'info'])) {
      return 'information';
    }
    if (_containsAny(prompt, const [
      'earning',
      'bonus',
      'allowance',
      'بدل',
      'مكافأة',
    ])) {
      return 'earning';
    }
    return null;
  }

  static String? _parseRecurrence(String prompt) {
    if (_containsAny(prompt, const [
      'one time',
      'one-time',
      'non recurring',
      'nonrecurring',
    ])) {
      return 'nonrecurring';
    }
    if (_containsAny(prompt, const ['monthly', 'recurring', 'شهري', 'متكرر'])) {
      return 'recurring';
    }
    return null;
  }

  static String? _parseCalculationMethod(String prompt) {
    if (_containsAny(prompt, const ['percent', 'percentage', '%', 'نسبة'])) {
      return 'percentage';
    }
    if (_containsAny(prompt, const ['derived', 'formula', 'calculated'])) {
      return 'derived';
    }
    if (_containsAny(prompt, const ['fixed', 'flat', 'ثابت'])) {
      return 'fixed';
    }
    return null;
  }

  static double? _parseAmount(String prompt) {
    final match = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(prompt);
    if (match == null) {
      return null;
    }
    return double.tryParse(match.group(1)!);
  }

  static String? _parseAttendanceStatus(String prompt) {
    if (_containsAny(prompt, const ['absent', 'غياب'])) {
      return 'absent';
    }
    if (_containsAny(prompt, const ['present', 'حاضر'])) {
      return 'present';
    }
    if (_containsAny(prompt, const ['leave', 'إجازة', 'اجازة'])) {
      return 'leave';
    }
    return null;
  }
}
