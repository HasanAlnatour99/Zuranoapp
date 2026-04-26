// Debug session NDJSON (do not log secrets/PII).
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

// Primary: workspace log when the Dart VM runs on macOS/Linux (tests / macOS desktop).
const _workspaceNdjsonPath =
    '/Users/hasanalnatour/barber_shop_app/.cursor/debug-30c32b.log';

const _ingestPath = '/ingest/2df41b28-0bb2-47f8-8a30-f78fb0c7578c';

/// Append one NDJSON line for Cursor debug ingest analysis.
void agentSessionLog({
  required String hypothesisId,
  required String location,
  required String message,
  Map<String, Object?>? data,
  String runId = 'login-signup-test',
}) {
  // #region agent log
  final map = <String, Object?>{
    'sessionId': '30c32b',
    'runId': runId,
    'timestamp': DateTime.now().millisecondsSinceEpoch,
    'hypothesisId': hypothesisId,
    'location': location,
    'message': message,
    'data': data ?? const <String, Object?>{},
  };
  final line = jsonEncode(map);

  if (kDebugMode) {
    debugPrint('AGENT_SESSION_LOG $line');
  }

  if (kIsWeb) {
    return;
  }

  try {
    if (Platform.isMacOS || Platform.isLinux) {
      File(
        _workspaceNdjsonPath,
      ).writeAsStringSync('$line\n', mode: FileMode.append);
    }
  } catch (_) {}

  if (Platform.isAndroid || Platform.isIOS) {
    Future<void>(() => _postIngest(line));
  }
  // #endregion
}

Future<void> _postIngest(String line) async {
  final hosts = <String>['127.0.0.1', if (Platform.isAndroid) '10.0.2.2'];
  for (final host in hosts) {
    HttpClient? client;
    try {
      client = HttpClient();
      final uri = Uri.parse('http://$host:7355$_ingestPath');
      final req = await client
          .postUrl(uri)
          .timeout(const Duration(milliseconds: 900));
      req.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      req.headers.set('X-Debug-Session-Id', '30c32b');
      req.write(line);
      await req.close();
      return;
    } catch (_) {
      continue;
    } finally {
      client?.close(force: true);
    }
  }
}
