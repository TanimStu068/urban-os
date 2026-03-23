import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/event_log_data_model.dart';
import 'package:urban_os/widgets/event_logs/event_card.dart';

typedef C = AppColors;

class EventsListWidget extends StatelessWidget {
  final List<EventLog> filteredEvents;
  final Set<EventLog> expandedEvents;
  final ScrollController scrollController;
  final void Function(String eventId) onToggleExpanded;

  const EventsListWidget({
    super.key,
    required this.filteredEvents,
    required this.expandedEvents,
    required this.scrollController,
    required this.onToggleExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      child: Column(
        children: [
          if (filteredEvents.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Icon(Icons.inbox_rounded, color: C.muted, size: 48),
                    const SizedBox(height: 12),
                    const Text(
                      'No events match your filters',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10,
                        color: C.mutedLt,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...List.generate(filteredEvents.length, (i) {
              final event = filteredEvents[i];
              final isExpanded = expandedEvents.contains(event);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: EventCard(
                  event: event,
                  isExpanded: isExpanded,
                  onTap: () => onToggleExpanded(event.id),
                ),
              );
            }),
        ],
      ),
    );
  }
}
