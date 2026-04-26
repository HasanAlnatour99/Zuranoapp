import 'package:firebase_ai/firebase_ai.dart';

import '../../../core/constants/app_routes.dart';
import '../domain/models/ai_surface_response.dart';
import '../domain/repositories/owner_dashboard_ai_repository.dart';

class AiToolRegistry {
  const AiToolRegistry(this._repository);

  final OwnerDashboardAiRepository _repository;

  List<FunctionDeclaration> get declarations => [
    FunctionDeclaration(
      'getSalonRevenueSummary',
      'Returns read-only salon revenue totals for a supported range.',
      parameters: {
        'salonId': Schema.string(description: 'Target salon id'),
        'range': Schema.string(description: 'Requested time range'),
        'year': Schema.integer(description: 'Optional calendar year for month'),
        'month': Schema.integer(description: 'Optional calendar month 1-12'),
        'quarter': Schema.integer(description: 'Optional quarter 1-4'),
        'startDate': Schema.string(description: 'Optional ISO date YYYY-MM-DD'),
        'endDate': Schema.string(description: 'Optional ISO date YYYY-MM-DD'),
      },
    ),
    FunctionDeclaration(
      'getTopBarbers',
      'Returns ranked barbers by revenue for a supported range.',
      parameters: {
        'salonId': Schema.string(description: 'Target salon id'),
        'range': Schema.string(description: 'Requested time range'),
        'year': Schema.integer(description: 'Optional calendar year for month'),
        'month': Schema.integer(description: 'Optional calendar month 1-12'),
        'quarter': Schema.integer(description: 'Optional quarter 1-4'),
        'startDate': Schema.string(description: 'Optional ISO date YYYY-MM-DD'),
        'endDate': Schema.string(description: 'Optional ISO date YYYY-MM-DD'),
      },
    ),
  ];

  Tool get tool => Tool.functionDeclarations(declarations);

  Future<Map<String, Object?>> invoke(FunctionCall call) async {
    return switch (call.name) {
      'getSalonRevenueSummary' => _handleRevenueSummary(call.args),
      'getTopBarbers' => _handleTopBarbers(call.args),
      _ => <String, Object?>{
        'ok': false,
        'error': 'Unsupported tool: ${call.name}',
      },
    };
  }

  Future<Map<String, Object?>> _handleRevenueSummary(
    Map<String, Object?> args,
  ) async {
    final salonId = _requiredString(args, 'salonId');
    final timeframe = _parseTimeframe(args);
    final summary = await _repository.getSalonRevenueSummary(
      salonId: salonId,
      timeframe: timeframe,
    );
    return {
      'ok': true,
      'summary': summary.toToolPayload(),
      'recommendedRoute': AppRoutes.ownerSales,
    };
  }

  Future<Map<String, Object?>> _handleTopBarbers(
    Map<String, Object?> args,
  ) async {
    final salonId = _requiredString(args, 'salonId');
    final timeframe = _parseTimeframe(args);
    final items = await _repository.getTopBarbers(
      salonId: salonId,
      timeframe: timeframe,
    );
    return {
      'ok': true,
      'barbers': items.map((item) => item.toToolPayload()).toList(),
      'recommendedRoute': AppRoutes.ownerSales,
    };
  }

  String _requiredString(Map<String, Object?> args, String key) {
    final value = args[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    throw FormatException('Missing tool argument: $key');
  }

  AiTimeframe _parseTimeframe(Map<String, Object?> args) {
    final range = AiTimeRange.fromWireValue(_requiredString(args, 'range'));
    final year = _optionalInt(args, 'year');
    final month = _optionalInt(args, 'month');
    final quarter = _optionalInt(args, 'quarter');
    final startDate = _optionalDate(args, 'startDate');
    final endDate = _optionalDate(args, 'endDate');

    if (month != null && (month < 1 || month > 12)) {
      throw const FormatException(
        'Month tool argument must be between 1 and 12.',
      );
    }
    if (year != null && year < 2000) {
      throw const FormatException(
        'Year tool argument must be a valid four-digit year.',
      );
    }
    if (quarter != null && (quarter < 1 || quarter > 4)) {
      throw const FormatException(
        'Quarter tool argument must be between 1 and 4.',
      );
    }
    if ((startDate == null) != (endDate == null)) {
      throw const FormatException(
        'Start and end date tool arguments must be provided together.',
      );
    }
    if (startDate != null && endDate != null && startDate.isAfter(endDate)) {
      throw const FormatException('Start date must be on or before end date.');
    }

    switch (range) {
      case AiTimeRange.today:
      case AiTimeRange.last7Days:
        if (year != null ||
            month != null ||
            quarter != null ||
            startDate != null ||
            endDate != null) {
          throw FormatException(
            'Tool range "${range.wireValue}" does not support extra date arguments.',
          );
        }
        return AiTimeframe(range: range);
      case AiTimeRange.month:
        if ((year == null) != (month == null)) {
          throw const FormatException(
            'Month queries must provide year and month together.',
          );
        }
        if (quarter != null || startDate != null || endDate != null) {
          throw const FormatException(
            'Month queries only support optional year and month arguments.',
          );
        }
        return AiTimeframe(range: range, year: year, month: month);
      case AiTimeRange.quarter:
        if ((year == null) != (quarter == null)) {
          throw const FormatException(
            'Quarter queries must provide year and quarter together.',
          );
        }
        if (month != null || startDate != null || endDate != null) {
          throw const FormatException(
            'Quarter queries only support optional year and quarter arguments.',
          );
        }
        return AiTimeframe(range: range, year: year, quarter: quarter);
      case AiTimeRange.custom:
        if (year != null || month != null || quarter != null) {
          throw const FormatException(
            'Custom range queries only support startDate and endDate arguments.',
          );
        }
        if (startDate == null || endDate == null) {
          throw const FormatException(
            'Custom range queries must provide startDate and endDate.',
          );
        }
        return AiTimeframe(
          range: range,
          startDate: startDate,
          endDate: endDate,
        );
    }
  }

  int? _optionalInt(Map<String, Object?> args, String key) {
    final value = args[key];
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      if (value != value.roundToDouble()) {
        throw FormatException('Tool argument "$key" must be an integer.');
      }
      return value.toInt();
    }
    if (value is String && value.trim().isNotEmpty) {
      final parsed = int.tryParse(value.trim());
      if (parsed == null) {
        throw FormatException('Tool argument "$key" must be an integer.');
      }
      return parsed;
    }
    throw FormatException('Tool argument "$key" must be an integer.');
  }

  DateTime? _optionalDate(Map<String, Object?> args, String key) {
    final value = args[key];
    if (value == null) {
      return null;
    }
    if (value is! String || value.trim().isEmpty) {
      throw FormatException(
        'Tool argument "$key" must be an ISO date in YYYY-MM-DD format.',
      );
    }
    final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(value.trim());
    if (match == null) {
      throw FormatException(
        'Tool argument "$key" must be an ISO date in YYYY-MM-DD format.',
      );
    }
    final year = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final day = int.parse(match.group(3)!);
    final parsed = DateTime(year, month, day);
    if (parsed.year != year || parsed.month != month || parsed.day != day) {
      throw FormatException(
        'Tool argument "$key" must be a valid calendar date.',
      );
    }
    return parsed;
  }
}
