import 'package:flutter/material.dart';
import 'package:notepro/features/admin/models/stats_card_model.dart';
import 'package:notepro/features/admin/widgets/stat_card.dart';

class ReorderableWrap extends StatefulWidget {
  const ReorderableWrap({super.key});

  @override
  State<ReorderableWrap> createState() => _ReorderableWrapState();
}

class _ReorderableWrapState extends State<ReorderableWrap> {
  List<StatItem> statsCards = [
    StatItem(
      title: "Abonnés",
      date: "Aujourd'hui",
      stat: "4.3k",
      percent: 12,
      isPositive: true,
    ),
    StatItem(
      title: "Vues",
      date: "Cette semaine",
      stat: "9.1k",
      percent: -4,
      isPositive: false,
    ),
    StatItem(
      title: "Revenus",
      date: "Ce mois",
      stat: "1.2M FCFA",
      percent: 20,
      isPositive: true,
    ),
    StatItem(
      title: "Partages",
      date: "Dernières 24h",
      stat: "836",
      percent: 8,
      isPositive: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return LayoutBuilder(
      builder: (context, constraints) {
        return ReorderableListView.builder(
          scrollDirection: isMobile ? Axis.vertical : Axis.horizontal,
          padding: const EdgeInsets.all(16),
          itemCount: statsCards.length,
          buildDefaultDragHandles: false,
          onReorder: (oldIndex, newIndex) {
            if (newIndex > oldIndex) newIndex -= 1;
            setState(() {
              final item = statsCards.removeAt(oldIndex);
              statsCards.insert(newIndex, item);
            });
          },
          itemBuilder: (context, index) {
            final item = statsCards[index];

            return Container(
              key: ValueKey(item.title),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              width: isMobile ? double.infinity : 300,
              height: 200,
              child: ReorderableDragStartListener(
                index: index,
                child: StatsCard(
                  title: item.title,
                  date: item.date,
                  stat: item.stat,
                  percent: item.percent,
                  isPositive: item.isPositive,
                  onDetailsPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Voir détails de ${item.title}")),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
