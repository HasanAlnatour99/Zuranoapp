import 'package:json_schema_builder/json_schema_builder.dart';

abstract final class AiSurfaceJsonSchema {
  static final Schema schema = Schema.object(
    title: 'OwnerDashboardSurface',
    description: 'Structured GenUI surface for the owner dashboard assistant.',
    properties: {
      'surfaceId': Schema.string(),
      'title': Schema.string(),
      'summary': Schema.string(),
      'components': Schema.list(
        minItems: 1,
        items: Schema.object(
          properties: {
            'id': Schema.string(),
            'type': Schema.string(
              enumValues: const [
                'section_header',
                'kpi_card',
                'ranking_list',
                'action_button',
                'empty_state',
                'error_state',
              ],
            ),
            'title': Schema.string(),
            'subtitle': Schema.string(),
            'value': Schema.string(),
            'badge': Schema.string(),
            'items': Schema.list(
              items: Schema.object(
                properties: {
                  'id': Schema.string(),
                  'label': Schema.string(),
                  'value': Schema.string(),
                  'caption': Schema.string(),
                },
                required: const ['id', 'label', 'value'],
              ),
            ),
            'action': Schema.object(
              properties: {
                'id': Schema.string(),
                'label': Schema.string(),
                'type': Schema.string(
                  enumValues: const ['navigate', 'prompt', 'retry'],
                ),
                'route': Schema.string(),
                'prompt': Schema.string(),
              },
              required: const ['id', 'label', 'type'],
            ),
          },
          required: const ['id', 'type'],
        ),
      ),
    },
    required: const ['surfaceId', 'components'],
  );

  static Map<String, Object?> get json => schema.value;
}
