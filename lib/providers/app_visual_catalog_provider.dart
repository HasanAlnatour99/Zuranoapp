import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/data/app_visual_catalog.dart';

final appVisualPathsProvider = FutureProvider<List<String>>((ref) {
  return AppVisualCatalog.loadAssetPaths();
});
