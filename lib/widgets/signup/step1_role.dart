import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/datamodel/signup_data_model.dart';

class Step1Role extends StatelessWidget {
  final int selectedRole;
  final ValueChanged<int> onSelect;
  const Step1Role({
    super.key,
    required this.selectedRole,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        children: [
          const Text(
            'SELECT YOUR DEPARTMENT ACCESS LEVEL',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 9,
              letterSpacing: 2,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 14),
          ...List.generate(roles.length, (i) {
            final (title, icon, sub) = roles[i];
            final selected = selectedRole == i;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () => onSelect(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected ? AppColors.cyan : AppColors.glassBdr,
                      width: selected ? 1.2 : 1,
                    ),
                    color: selected
                        ? AppColors.cyan.withOpacity(.08)
                        : AppColors.glassBg,
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: AppColors.cyan.withOpacity(.15),
                              blurRadius: 14,
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selected
                              ? AppColors.cyan.withOpacity(.15)
                              : AppColors.bgCard,
                          border: Border.all(
                            color: selected
                                ? AppColors.cyan
                                : AppColors.muted.withOpacity(.4),
                          ),
                        ),
                        child: Icon(
                          icon,
                          color: selected ? AppColors.cyan : AppColors.muted,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                                color: selected
                                    ? AppColors.white
                                    : AppColors.mutedLight,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              sub,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 9,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: selected ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.cyan,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.black,
                            size: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
