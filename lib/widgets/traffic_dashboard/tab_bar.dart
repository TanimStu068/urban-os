import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

// Traffic theme accent
const kAccent = C.cyan;
const kAccentDim = C.cyanDim;
const kScreenName = 'TRAFFIC DASHBOARD';

class TabBarWidget extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTap;
  const TabBarWidget({super.key, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext ctx) => Container(
    height: 52,
    margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: C.bgCard.withOpacity(.88),
      border: Border.all(color: C.gBdr),
    ),
    child: Row(
      children: List.generate(_tabs.length, (i) {
        final isSel = i == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onTap(i),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isSel ? kAccent.withOpacity(.12) : Colors.transparent,
                border: isSel
                    ? Border.all(color: kAccent.withOpacity(.4))
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _tabIcons[i],
                    color: isSel ? kAccent : C.muted,
                    size: 13,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _tabs[i],
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 6.5,
                      letterSpacing: .8,
                      color: isSel ? kAccent : C.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    ),
  );
}

const _tabs = ['OVERVIEW', 'ROADS', 'SIGNALS', 'INCIDENTS', 'PARKING'];
const _tabIcons = [
  Icons.dashboard_rounded,
  Icons.route_rounded,
  Icons.traffic_rounded,
  Icons.warning_amber_rounded,
  Icons.local_parking_rounded,
];
