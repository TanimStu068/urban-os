import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/report_generator/slevel.dart';

typedef C = AppColors;

class ReportTitleFieldWidget extends StatelessWidget {
  final TextEditingController controller;

  const ReportTitleFieldWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: C.bgCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: C.gBdr),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SLabel('REPORT TITLE', 'OPTIONAL'),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: C.white,
              ),
              decoration: InputDecoration(
                hintText: 'Enter custom title...',
                hintStyle: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  color: C.mutedLt.withOpacity(0.5),
                ),
                filled: true,
                fillColor: C.bgCard2,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: C.gBdr),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: C.gBdr),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: C.cyan.withOpacity(0.5)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
