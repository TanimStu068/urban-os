import 'package:flutter/material.dart';
import 'dart:math';
import 'package:urban_os/datamodel/sensor_list_data_model.dart';

class SparkBar extends StatelessWidget {
  final double reading;
  final CatMeta cat;
  const SparkBar({required this.reading, required this.cat});

  @override
  Widget build(BuildContext context) {
    final rng = Random(reading.toInt());
    final bars = List.generate(7, (i) => 0.2 + rng.nextDouble() * 0.8);
    return Row(
      children: bars.map((h) {
        return Container(
          width: 3,
          height: 14 * h,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: cat.color.withOpacity(0.4 + h * 0.4),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }).toList(),
    );
  }
}
