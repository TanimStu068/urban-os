import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/system_setting_data_model.dart';
import 'package:flutter/material.dart';

typedef C = AppColors;

class FrequencySelector extends StatelessWidget {
  final String label;
  final String description;
  final DataUpdateFrequency selected;
  final Function(DataUpdateFrequency) onChanged;

  const FrequencySelector({
    super.key,
    required this.label,
    required this.description,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 7.5,
                  color: C.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 6,
                  color: C.mutedLt,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: DataUpdateFrequency.values
                .map(
                  (freq) => GestureDetector(
                    onTap: () => onChanged(freq),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: selected == freq
                            ? C.green.withOpacity(0.2)
                            : Colors.transparent,
                        border: Border.all(
                          color: selected == freq
                              ? C.green.withOpacity(0.5)
                              : C.green.withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        freq.label,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 6.5,
                          color: selected == freq
                              ? C.green
                              : C.green.withOpacity(0.6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
