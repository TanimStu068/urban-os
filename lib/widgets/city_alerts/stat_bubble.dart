import 'package:flutter/material.dart';

class StatBubble extends StatelessWidget {
  final int value;
  final String label;
  final Color color;
  final AnimationController blinkCtrl;
  final bool doBlink;
  const StatBubble({
    super.key,
    required this.value,
    required this.label,
    required this.color,
    required this.blinkCtrl,
    required this.doBlink,
  });
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: blinkCtrl,
      builder: (_, __) => Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(
                .1 + (doBlink ? blinkCtrl.value * .06 : 0),
              ),
              border: Border.all(
                color: color.withOpacity(
                  .3 + (doBlink ? blinkCtrl.value * .2 : 0),
                ),
                width: doBlink ? 1.5 : 1,
              ),
              boxShadow: doBlink
                  ? [
                      BoxShadow(
                        color: color.withOpacity(.3 * blinkCtrl.value),
                        blurRadius: 12,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                '$value',
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: color,
                  shadows: [
                    Shadow(color: color.withOpacity(.5), blurRadius: 8),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 7,
              letterSpacing: 1.5,
              color: color.withOpacity(.7),
            ),
          ),
        ],
      ),
    );
  }
}
