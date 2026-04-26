import 'package:flutter/services.dart';

/// Loads bundled visual asset paths from [assetPath] (CSV with a `path` header).
class AppVisualCatalog {
  const AppVisualCatalog._();

  static const assetPath = 'assets/data/app_visuals.csv';

  static Future<List<String>> loadAssetPaths() async {
    final raw = await rootBundle.loadString(assetPath);
    final lines = raw.split(RegExp(r'\r?\n'));
    final out = <String>[];
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) {
        continue;
      }
      if (i == 0 && line.toLowerCase().startsWith('path')) {
        continue;
      }
      final path = line.split(',').first.trim();
      if (path.isEmpty || path.toLowerCase() == 'path') {
        continue;
      }
      out.add(path);
    }
    return out;
  }
}
