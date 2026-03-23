import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/event_injection_data_model.dart';
import 'package:urban_os/widgets/event_injection/event_card.dart';

/// EventList widget
class EventList extends StatelessWidget {
  final List<InjectedEvent> events;
  final String viewTab; // 'ACTIVE' or any other tab
  final ScrollController scrollController;
  final AnimationController pulseCtrl;

  const EventList({
    super.key,
    required this.events,
    required this.viewTab,
    required this.scrollController,
    required this.pulseCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = viewTab == 'ACTIVE'
        ? events.where((e) => e.status == EventStatus.active).toList()
        : events.where((e) => e.status != EventStatus.active).toList();

    return SingleChildScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      child: Column(
        children: filtered
            .map(
              (event) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: EventCard(event: event, pulseCtrl: pulseCtrl),
              ),
            )
            .toList(),
      ),
    );
  }
}
