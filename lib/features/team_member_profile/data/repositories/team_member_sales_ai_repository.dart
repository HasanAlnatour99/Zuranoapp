import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/firestore/firestore_paths.dart';
import '../../../../core/firestore/firestore_serializers.dart';
import '../models/team_sales_insight_model.dart';
import '../models/team_sales_summary_model.dart';

class TeamMemberSalesAiRepository {
  TeamMemberSalesAiRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  static const Duration _cacheTtl = Duration(hours: 6);

  String _docId({
    required String employeeId,
    required DateTime historyStart,
    required DateTime historyEndExclusive,
  }) {
    return 'emp_${employeeId}_${historyStart.millisecondsSinceEpoch}_'
        '${historyEndExclusive.millisecondsSinceEpoch}';
  }

  DocumentReference<Map<String, dynamic>> _ref(String salonId, String docId) {
    return _firestore
        .collection(FirestorePaths.salons)
        .doc(salonId)
        .collection(FirestorePaths.aiInsights)
        .doc(docId);
  }

  Future<TeamSalesInsightModel?> readCachedInsight({
    required String salonId,
    required String employeeId,
    required DateTime historyStart,
    required DateTime historyEndExclusive,
  }) async {
    final snap = await _ref(
      salonId,
      _docId(
        employeeId: employeeId,
        historyStart: historyStart,
        historyEndExclusive: historyEndExclusive,
      ),
    ).get();
    if (!snap.exists) {
      return null;
    }
    final data = snap.data();
    if (data == null) {
      return null;
    }
    final generatedAt = FirestoreSerializers.dateTime(data['generatedAt']);
    if (generatedAt == null) {
      return null;
    }
    if (DateTime.now().difference(generatedAt) > _cacheTtl) {
      return null;
    }
    return TeamSalesInsightModel(
      statusLabel: FirestoreSerializers.string(data['statusLabel']) ?? '',
      shortMessage: FirestoreSerializers.string(data['shortMessage']) ?? '',
      recommendation: FirestoreSerializers.string(data['recommendation']) ?? '',
      generatedAt: generatedAt,
    );
  }

  Future<TeamSalesInsightModel?> generateAndCacheInsight({
    required String salonId,
    required String employeeId,
    required String employeeName,
    required TeamSalesSummaryModel summary,
    required DateTime historyStart,
    required DateTime historyEndExclusive,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      return null;
    }

    final top = summary.topSoldServices
        .map((e) => '${e.serviceName}: ${e.quantity}')
        .join(', ');

    final prompt =
        '''
You are analyzing sales performance for a salon team member.

Do not mention AI or machine learning.

Employee name: $employeeName
Date range: ${historyStart.toIso8601String()} to ${historyEndExclusive.toIso8601String()}

Metrics:
Revenue today: ${summary.revenueToday}
Revenue this week: ${summary.revenueThisWeek}
Revenue this month: ${summary.revenueThisMonth}
Services today: ${summary.servicesToday}
Services this month: ${summary.servicesThisMonth}
Average ticket value: ${summary.averageTicketValue}
Top services: $top

Return JSON only:
{
  "statusLabel": "string",
  "shortMessage": "string",
  "recommendation": "string"
}
''';

    try {
      final model = FirebaseAI.googleAI(auth: _auth).generativeModel(
        model: 'gemini-2.0-flash',
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          temperature: 0.2,
          maxOutputTokens: 512,
        ),
      );
      final response = await model.generateContent([Content.text(prompt)]);
      final raw = response.text?.trim();
      if (raw == null || raw.isEmpty) {
        return null;
      }
      final parsed = _parseInsightJson(raw);
      if (parsed == null) {
        return null;
      }
      final withTime = TeamSalesInsightModel(
        statusLabel: parsed.statusLabel,
        shortMessage: parsed.shortMessage,
        recommendation: parsed.recommendation,
        generatedAt: DateTime.now(),
      );

      final docId = _docId(
        employeeId: employeeId,
        historyStart: historyStart,
        historyEndExclusive: historyEndExclusive,
      );
      await _ref(salonId, docId).set({
        'salonId': salonId,
        'employeeId': employeeId,
        'type': 'employee_sales',
        'historyStart': Timestamp.fromDate(historyStart),
        'historyEndExclusive': Timestamp.fromDate(historyEndExclusive),
        'statusLabel': withTime.statusLabel,
        'shortMessage': withTime.shortMessage,
        'recommendation': withTime.recommendation,
        'generatedAt': FieldValue.serverTimestamp(),
        'createdBy': uid,
      }, SetOptions(merge: true));
      return withTime;
    } on Object {
      return null;
    }
  }

  Future<TeamSalesInsightModel?> loadOrGenerateInsight({
    required String salonId,
    required String employeeId,
    required String employeeName,
    required TeamSalesSummaryModel summary,
    required DateTime historyStart,
    required DateTime historyEndExclusive,
  }) async {
    final cached = await readCachedInsight(
      salonId: salonId,
      employeeId: employeeId,
      historyStart: historyStart,
      historyEndExclusive: historyEndExclusive,
    );
    if (cached != null && cached.hasDisplayableContent) {
      return cached;
    }
    return generateAndCacheInsight(
      salonId: salonId,
      employeeId: employeeId,
      employeeName: employeeName,
      summary: summary,
      historyStart: historyStart,
      historyEndExclusive: historyEndExclusive,
    );
  }

  TeamSalesInsightModel? _parseInsightJson(String raw) {
    var text = raw.trim();
    if (text.startsWith('```')) {
      text = text.replaceFirst(RegExp(r'^```(?:json)?\s*'), '');
      text = text.replaceFirst(RegExp(r'\s*```\s*$'), '');
    }
    final decoded = jsonDecode(text);
    if (decoded is! Map<String, dynamic>) {
      return null;
    }
    return TeamSalesInsightModel(
      statusLabel: (decoded['statusLabel'] as String?)?.trim() ?? '',
      shortMessage: (decoded['shortMessage'] as String?)?.trim() ?? '',
      recommendation: (decoded['recommendation'] as String?)?.trim() ?? '',
      generatedAt: DateTime.now(),
    );
  }
}
