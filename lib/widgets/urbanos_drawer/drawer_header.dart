import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';
import 'package:urban_os/widgets/urbanos_drawer/orbit_logo.dart';
import 'package:urban_os/widgets/urbanos_drawer/status_strip.dart';

typedef _K = AppColors;

class DrawerHeaderWidget extends StatelessWidget {
  final AnimationController orbitCtrl;
  final AnimationController hotCtrl;
  final AnimationController entryCtrl;

  const DrawerHeaderWidget({
    super.key,
    required this.orbitCtrl,
    required this.hotCtrl,
    required this.entryCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo row
          Row(
            children: [
              // Orbiting hex logo
              OrbitLogo(ctrl: orbitCtrl),
              const SizedBox(width: 14),

              // Brand text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'URBAN',
                          style: TextStyle(
                            color: _K.text,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3,
                            height: 1,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _K.cyan.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: _K.cyan.withOpacity(0.4)),
                          ),
                          child: const Text(
                            'OS',
                            style: TextStyle(
                              color: _K.cyan,
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Smart City Control',
                      style: TextStyle(
                        color: _K.textSub,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Close button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _K.surfaceMd,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _K.border),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: _K.textSub,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Status strip
          StatusStrip(hotCtrl: hotCtrl),
        ],
      ),
    );
  }
}
