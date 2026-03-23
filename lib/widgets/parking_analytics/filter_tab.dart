import 'package:flutter/material.dart';
import 'package:urban_os/core/themes/app_theme.dart';

typedef C = AppColors;

const kAccent = C.cyan;

typedef OnTabChanged = void Function(int);

class FilterTabs extends StatefulWidget {
  final int activeTab;
  final OnTabChanged onTabChanged;

  const FilterTabs({
    Key? key,
    required this.activeTab,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  State<FilterTabs> createState() => _FilterTabsState();
}

class _FilterTabsState extends State<FilterTabs> {
  late int _selectedTab;

  final List<String> labels = ['ALL LOTS', 'AVAILABLE', 'HIGH USAGE'];
  final List<Color> colors = [kAccent, C.green, C.red];

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.activeTab;
  }

  void _onTabTap(int index) {
    setState(() {
      _selectedTab = index;
    });
    widget.onTabChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: C.bgCard.withOpacity(0.88),
        border: Border.all(color: C.gBdr),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final isSel = i == _selectedTab;
          return Expanded(
            child: GestureDetector(
              onTap: () => _onTabTap(i),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isSel
                      ? colors[i].withOpacity(0.14)
                      : Colors.transparent,
                  border: isSel
                      ? Border.all(color: colors[i].withOpacity(0.4))
                      : null,
                ),
                child: Center(
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 8.5,
                      letterSpacing: 1.2,
                      color: isSel ? colors[i] : C.muted,
                      fontWeight: isSel ? FontWeight.w700 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
