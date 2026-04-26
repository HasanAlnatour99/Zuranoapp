class TeamSalesInsightModel {
  const TeamSalesInsightModel({
    required this.statusLabel,
    required this.shortMessage,
    required this.recommendation,
    required this.generatedAt,
  });

  final String statusLabel;
  final String shortMessage;
  final String recommendation;
  final DateTime generatedAt;

  bool get hasDisplayableContent =>
      statusLabel.trim().isNotEmpty ||
      shortMessage.trim().isNotEmpty ||
      recommendation.trim().isNotEmpty;
}
