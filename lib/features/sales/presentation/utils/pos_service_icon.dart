import 'package:flutter/material.dart';

import '../../../services/data/service_category_catalog.dart';

IconData posServiceIconForCategoryKey(String? categoryKey) {
  switch (categoryKey) {
    case ServiceCategoryKeys.hair:
      return Icons.content_cut_rounded;
    case ServiceCategoryKeys.barberBeard:
      return Icons.face_rounded;
    case ServiceCategoryKeys.facialSkincare:
    case ServiceCategoryKeys.browsLashes:
      return Icons.spa_rounded;
    case ServiceCategoryKeys.nails:
      return Icons.brush_rounded;
    default:
      return Icons.design_services_rounded;
  }
}
