import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/profile_screen_data_model.dart';
import 'package:urban_os/widgets/profile/device_detail.dart';

typedef C = AppColors;

class DeviceCard extends StatefulWidget {
  final ConnectedDevice device;
  final bool isExpanded;
  final VoidCallback onTap;

  const DeviceCard({
    super.key,
    required this.device,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _expandCtrl;

  @override
  void initState() {
    super.initState();
    _expandCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    if (widget.isExpanded) _expandCtrl.forward();
  }

  @override
  void didUpdateWidget(covariant DeviceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _expandCtrl.forward();
      } else {
        _expandCtrl.reverse();
      }
    }
  }

  @override
  void dispose() {
    _expandCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _expandCtrl,
        builder: (_, __) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: C.bgCard.withOpacity(0.85),
            border: Border.all(
              color: widget.device.type.color.withOpacity(
                0.2 + _expandCtrl.value * 0.15,
              ),
            ),
            boxShadow: [
              if (widget.isExpanded)
                BoxShadow(
                  color: widget.device.type.color.withOpacity(0.1),
                  blurRadius: 12,
                ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: widget.device.type.color.withOpacity(0.15),
                      ),
                      child: Center(
                        child: Icon(
                          widget.device.type.icon,
                          color: widget.device.type.color,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.device.name,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 8.5,
                              color: C.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            widget.device.type.label,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 6.5,
                              color: widget.device.type.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.device.isActive ? C.green : C.muted,
                      ),
                    ),
                  ],
                ),
              ),
              SizeTransition(
                sizeFactor: CurvedAnimation(
                  parent: _expandCtrl,
                  curve: Curves.easeOut,
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DeviceDetail(
                        'IP Address',
                        widget.device.ipAddress,
                        C.cyan,
                      ),
                      const SizedBox(height: 6),
                      DeviceDetail(
                        'Last Active',
                        widget.device.lastActiveLabel,
                        C.orange,
                      ),
                      const SizedBox(height: 6),
                      DeviceDetail(
                        'Status',
                        widget.device.isActive ? 'ACTIVE NOW' : 'OFFLINE',
                        widget.device.isActive ? C.green : C.mutedLt,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
