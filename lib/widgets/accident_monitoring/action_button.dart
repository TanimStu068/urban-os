import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/accident_monitoring_data_model.dart';
import 'package:urban_os/widgets/accident_monitoring/action_btn.dart';

typedef C = AppColors;

const kAccent = C.teal;

class ActionButtons extends StatelessWidget {
  final AccidentEvent accident;
  final VoidCallback? onCloseIncident;

  const ActionButtons({
    super.key,
    required this.accident,
    this.onCloseIncident,
  });

  @override
  Widget build(BuildContext context) {
    final isActive =
        accident.severity != AccidentSeverity.cleared &&
        accident.responseStatus != ResponseStatus.closed;

    return Row(
      children: [
        Expanded(
          child: ActionBtn(
            'DISPATCH UNIT',
            Icons.local_shipping_rounded,
            C.amber,
            isActive ? () {} : null,
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: ActionBtn(
            'REROUTE TRAFFIC',
            Icons.alt_route_rounded,
            kAccent,
            isActive ? () {} : null,
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: ActionBtn(
            accident.responseStatus == ResponseStatus.closed
                ? 'REOPENED'
                : 'CLOSE INCIDENT',
            Icons.check_circle_outline_rounded,
            C.green,
            isActive ? onCloseIncident : null,
          ),
        ),
      ],
    );
  }
}
