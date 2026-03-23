import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/scenario_builder_data_model.dart';
import 'package:urban_os/widgets/scenario_builder/scenario_card.dart';

class ScenarioList extends StatefulWidget {
  final List<Scenario> filteredScenarios;
  final Set<String> expandedScenarios;
  final ScrollController scrollController;
  final AnimationController glowCtrl;
  // final ValueChanged<Set<String>> onExpandedChanged;
  final void Function(String scenarioId) onToggleScenario;

  const ScenarioList({
    super.key,
    required this.filteredScenarios,
    required this.expandedScenarios,
    required this.scrollController,
    required this.glowCtrl,
    required this.onToggleScenario,
  });

  @override
  _ScenarioListState createState() => _ScenarioListState();
}

class _ScenarioListState extends State<ScenarioList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      child: Column(
        children: widget.filteredScenarios.map((scenario) {
          final isExpanded = widget.expandedScenarios.contains(scenario.id);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ScenarioCard(
              scenario: scenario,
              isExpanded: isExpanded,
              onTap: () => widget.onToggleScenario(scenario.id),
              glowCtrl: widget.glowCtrl,
            ),
          );
        }).toList(),
      ),
    );
  }
}
