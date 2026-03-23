import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/profile_screen_data_model.dart';
import 'package:urban_os/widgets/profile/device_card.dart';

class DevicesView extends StatefulWidget {
  final List<ConnectedDevice> devices;

  const DevicesView({super.key, required this.devices});

  @override
  State<DevicesView> createState() => _DevicesViewState();
}

class _DevicesViewState extends State<DevicesView> {
  final Set<String> _expandedSections = {};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      child: Column(
        children: widget.devices
            .map(
              (device) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: DeviceCard(
                  device: device,
                  isExpanded: _expandedSections.contains(device.id),
                  onTap: () {
                    setState(() {
                      if (_expandedSections.contains(device.id)) {
                        _expandedSections.remove(device.id);
                      } else {
                        _expandedSections.add(device.id);
                      }
                    });
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
