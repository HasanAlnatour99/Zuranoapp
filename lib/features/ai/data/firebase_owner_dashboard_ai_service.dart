import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

import '../domain/models/ai_surface_response.dart';
import 'ai_surface_json_schema.dart';
import 'ai_tool_registry.dart';
import 'owner_dashboard_ai_prompt_builder.dart';

class OwnerDashboardAiService {
  OwnerDashboardAiService({
    required FirebaseAuth auth,
    required AiToolRegistry toolRegistry,
    required OwnerDashboardAiPromptBuilder promptBuilder,
  }) : _auth = auth,
       _toolRegistry = toolRegistry,
       _promptBuilder = promptBuilder;

  final FirebaseAuth _auth;
  final AiToolRegistry _toolRegistry;
  final OwnerDashboardAiPromptBuilder _promptBuilder;

  ChatSession? _chatSession;
  String? _activeLocaleCode;

  Future<AiSurfaceResponse> generateSurface({
    required String salonId,
    required String prompt,
    required String localeCode,
  }) async {
    final chat = _ensureChatSession(localeCode);
    final response = await _resolveToolingLoop(
      chat: chat,
      message: Content.text(
        _promptBuilder.buildUserPrompt(
          prompt: prompt,
          salonId: salonId,
          defaultTimeframe: inferTimeframe(prompt),
        ),
      ),
    );

    final text = response.text?.trim();
    if (text == null || text.isEmpty) {
      throw const FormatException(
        'Firebase AI returned an empty surface payload.',
      );
    }

    final decoded = jsonDecode(text);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
        'Firebase AI returned a non-object JSON payload.',
      );
    }

    final validationErrors = await AiSurfaceJsonSchema.schema.validate(decoded);
    if (validationErrors.isNotEmpty) {
      throw FormatException(
        'Firebase AI returned an invalid surface payload: ${validationErrors.first}',
      );
    }

    return AiSurfaceResponse.fromJson(decoded);
  }

  ChatSession _ensureChatSession(String localeCode) {
    if (_chatSession != null && _activeLocaleCode == localeCode) {
      return _chatSession!;
    }

    final model = FirebaseAI.googleAI(auth: _auth).generativeModel(
      model: 'gemini-2.5-flash',
      systemInstruction: Content('system', [
        TextPart(_promptBuilder.buildSystemPrompt(localeCode: localeCode)),
      ]),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseJsonSchema: AiSurfaceJsonSchema.json,
        temperature: 0.15,
        maxOutputTokens: 1800,
      ),
      tools: [_toolRegistry.tool],
      toolConfig: ToolConfig(
        functionCallingConfig: FunctionCallingConfig.auto(),
      ),
    );

    _activeLocaleCode = localeCode;
    _chatSession = model.startChat(maxTurns: 12);
    return _chatSession!;
  }

  Future<GenerateContentResponse> _resolveToolingLoop({
    required ChatSession chat,
    required Content message,
  }) async {
    var response = await chat.sendMessage(message);
    var safetyCounter = 0;

    while (response.functionCalls.isNotEmpty) {
      safetyCounter += 1;
      if (safetyCounter > 5) {
        throw const FormatException(
          'Too many AI tool-call rounds for one prompt.',
        );
      }

      final toolResponses = <FunctionResponse>[];
      for (final functionCall in response.functionCalls) {
        final payload = await _toolRegistry.invoke(functionCall);
        toolResponses.add(
          FunctionResponse(functionCall.name, payload, id: functionCall.id),
        );
      }

      response = await chat.sendMessage(Content('function', toolResponses));
    }

    return response;
  }

  @visibleForTesting
  static AiTimeframe inferTimeframe(String prompt, {DateTime? now}) {
    final normalized = prompt.toLowerCase();
    final anchor = now ?? DateTime.now();
    if (normalized.contains('today') || normalized.contains('اليوم')) {
      return const AiTimeframe(range: AiTimeRange.today);
    }
    if (normalized.contains('last 7 days') ||
        normalized.contains('last seven days') ||
        normalized.contains('past 7 days') ||
        normalized.contains('last week') ||
        normalized.contains('آخر 7 أيام') ||
        normalized.contains('اخر 7 ايام') ||
        normalized.contains('آخر سبعة أيام') ||
        normalized.contains('اخر سبعة ايام') ||
        normalized.contains('الأسبوع الماضي') ||
        normalized.contains('الاسبوع الماضي')) {
      return const AiTimeframe(range: AiTimeRange.last7Days);
    }
    final explicitDateRange = _matchExplicitDateRange(normalized);
    if (explicitDateRange != null) {
      return explicitDateRange;
    }
    final explicitQuarter = _matchExplicitQuarter(normalized, now: anchor);
    if (explicitQuarter != null) {
      return explicitQuarter;
    }
    if (normalized.contains('quarter') || normalized.contains('الربع')) {
      return AiTimeframe(
        range: AiTimeRange.quarter,
        year: anchor.year,
        quarter: _quarterForMonth(anchor.month),
      );
    }
    final explicitMonth = _matchExplicitMonth(normalized, now: anchor);
    if (explicitMonth != null) {
      return explicitMonth;
    }
    if (normalized.contains('month') || normalized.contains('الشهر')) {
      return AiTimeframe(
        range: AiTimeRange.month,
        year: anchor.year,
        month: anchor.month,
      );
    }
    return const AiTimeframe(range: AiTimeRange.today);
  }

  static AiTimeframe? _matchExplicitMonth(
    String normalizedPrompt, {
    required DateTime now,
  }) {
    final monthAliases = <int, List<String>>{
      1: ['january', 'jan', 'يناير'],
      2: ['february', 'feb', 'فبراير'],
      3: ['march', 'mar', 'مارس'],
      4: ['april', 'apr', 'ابريل', 'أبريل'],
      5: ['may', 'مايو'],
      6: ['june', 'jun', 'يونيو'],
      7: ['july', 'jul', 'يوليو'],
      8: ['august', 'aug', 'اغسطس', 'أغسطس'],
      9: ['september', 'sep', 'sept', 'سبتمبر'],
      10: ['october', 'oct', 'أكتوبر', 'اكتوبر'],
      11: ['november', 'nov', 'نوفمبر'],
      12: ['december', 'dec', 'ديسمبر'],
    };

    for (final entry in monthAliases.entries) {
      final matchedAlias = entry.value.any(normalizedPrompt.contains);
      if (!matchedAlias) {
        continue;
      }

      final yearMatch = RegExp(r'\b(20\d{2})\b').firstMatch(normalizedPrompt);
      final year = yearMatch != null
          ? int.tryParse(yearMatch.group(1)!)
          : now.year;
      return AiTimeframe(
        range: AiTimeRange.month,
        year: year,
        month: entry.key,
      );
    }

    return null;
  }

  static AiTimeframe? _matchExplicitQuarter(
    String normalizedPrompt, {
    required DateTime now,
  }) {
    final qNumberPattern = RegExp(r'\bq([1-4])(?:\s*(20\d{2}))?\b');
    final qNumberMatch = qNumberPattern.firstMatch(normalizedPrompt);
    if (qNumberMatch != null) {
      return AiTimeframe(
        range: AiTimeRange.quarter,
        year: qNumberMatch.group(2) != null
            ? int.parse(qNumberMatch.group(2)!)
            : now.year,
        quarter: int.parse(qNumberMatch.group(1)!),
      );
    }

    final quarterWordPattern = RegExp(
      r'\b(?:quarter\s*([1-4])|([1-4])(?:st|nd|rd|th)?\s+quarter)(?:\s*(20\d{2}))?\b',
    );
    final quarterWordMatch = quarterWordPattern.firstMatch(normalizedPrompt);
    if (quarterWordMatch != null) {
      final quarterRaw = quarterWordMatch.group(1) ?? quarterWordMatch.group(2);
      return AiTimeframe(
        range: AiTimeRange.quarter,
        year: quarterWordMatch.group(3) != null
            ? int.parse(quarterWordMatch.group(3)!)
            : now.year,
        quarter: int.parse(quarterRaw!),
      );
    }

    final arabicQuarterAliases = <int, List<String>>{
      1: ['الربع الأول', 'الربع الاول'],
      2: ['الربع الثاني'],
      3: ['الربع الثالث'],
      4: ['الربع الرابع'],
    };
    for (final entry in arabicQuarterAliases.entries) {
      final matchedAlias = entry.value.any(normalizedPrompt.contains);
      if (!matchedAlias) {
        continue;
      }
      final yearMatch = RegExp(r'\b(20\d{2})\b').firstMatch(normalizedPrompt);
      return AiTimeframe(
        range: AiTimeRange.quarter,
        year: yearMatch != null ? int.parse(yearMatch.group(1)!) : now.year,
        quarter: entry.key,
      );
    }

    final arabicQuarterNumberMatch = RegExp(
      r'ربع\s*([1-4])(?:\s*(20\d{2}))?',
    ).firstMatch(normalizedPrompt);
    if (arabicQuarterNumberMatch != null) {
      return AiTimeframe(
        range: AiTimeRange.quarter,
        year: arabicQuarterNumberMatch.group(2) != null
            ? int.parse(arabicQuarterNumberMatch.group(2)!)
            : now.year,
        quarter: int.parse(arabicQuarterNumberMatch.group(1)!),
      );
    }

    return null;
  }

  static AiTimeframe? _matchExplicitDateRange(String normalizedPrompt) {
    final matches = RegExp(
      r'\b(\d{4})-(\d{2})-(\d{2})\b',
    ).allMatches(normalizedPrompt).take(2).toList(growable: false);
    if (matches.length < 2) {
      return null;
    }

    final start = _parseIsoDateMatch(matches[0]);
    final end = _parseIsoDateMatch(matches[1]);
    if (start == null || end == null || start.isAfter(end)) {
      return null;
    }

    return AiTimeframe(
      range: AiTimeRange.custom,
      startDate: start,
      endDate: end,
    );
  }

  static DateTime? _parseIsoDateMatch(RegExpMatch match) {
    final year = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final day = int.parse(match.group(3)!);
    final parsed = DateTime(year, month, day);
    if (parsed.year != year || parsed.month != month || parsed.day != day) {
      return null;
    }
    return parsed;
  }

  static int _quarterForMonth(int month) {
    return ((month - 1) ~/ 3) + 1;
  }
}
