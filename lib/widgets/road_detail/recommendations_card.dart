import 'package:flutter/material.dart';
import 'package:urban_os/widgets/road_detail/card_widget.dart';
import 'package:urban_os/widgets/road_detail/recommandation.dart';
import 'package:urban_os/widgets/road_detail/recommend_row.dart';

class RecommendationsCard extends StatelessWidget {
  final List<Recommendation> recommendations;

  const RecommendationsCard({Key? key, required this.recommendations})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      title: 'AI RECOMMENDATIONS',
      sub: 'System-generated action items',
      icon: Icons.auto_fix_high_rounded,
      child: Column(
        children: recommendations
            .map(
              (r) => RecommendRow(
                text: r.text,
                icon: r.icon,
                color: r.color,
                priority: r.priority,
              ),
            )
            .toList(),
      ),
    );
  }
}
