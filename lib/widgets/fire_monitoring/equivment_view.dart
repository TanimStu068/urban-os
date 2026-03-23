import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/fire_monitoring_data_model.dart';
import 'package:urban_os/widgets/fire_monitoring/equibment_card.dart'; // adjust import

class EquipmentView extends StatelessWidget {
  final ScrollController scrollCtrl;
  final List<FireEquipment> equipmentList;

  const EquipmentView({
    super.key,
    required this.scrollCtrl,
    required this.equipmentList,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollCtrl,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: equipmentList
            .map(
              (eq) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: EquipmentCard(equipment: eq),
              ),
            )
            .toList(),
      ),
    );
  }
}
