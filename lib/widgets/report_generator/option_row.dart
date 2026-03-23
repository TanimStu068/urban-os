import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class OptionRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool value;
  final ValueChanged<bool> onChanged;
  const OptionRow(
    this.label,
    this.icon,
    this.color,
    this.value,
    this.onChanged, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: value ? color.withOpacity(0.12) : AppColors.bgCard2,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: value ? color.withOpacity(0.4) : AppColors.gBdr,
                ),
              ),
              child: Icon(
                icon,
                size: 12,
                color: value ? color : AppColors.mutedLt,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 9,
                  color: value ? AppColors.white : AppColors.mutedLt,
                ),
              ),
            ),
            // Toggle
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 32,
              height: 18,
              decoration: BoxDecoration(
                color: value ? color.withOpacity(0.2) : AppColors.bgCard2,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(
                  color: value ? color.withOpacity(0.5) : AppColors.gBdr,
                ),
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 160),
                    left: value ? 16 : 2,
                    top: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: value
                            ? color
                            : AppColors.mutedLt.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
