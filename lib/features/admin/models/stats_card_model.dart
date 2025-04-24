export 'package:notepro/features/admin/models/stats_card_model.dart';

// Le modèle reste inchangé
class StatItem {
  final String title;
  final String date;
  final String stat;
  final int percent;
  final bool isPositive;

  StatItem({
    required this.title,
    required this.date,
    required this.stat,
    required this.percent,
    required this.isPositive,
  });
}
