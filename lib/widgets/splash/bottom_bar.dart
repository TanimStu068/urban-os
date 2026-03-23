import 'package:flutter/material.dart';
import 'package:urban_os/widgets/splash/bottom_item.dart';
import 'package:urban_os/widgets/splash/bottomsep.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 32,
      left: 0,
      right: 0,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BottomItem('© 2026 UrbanOS'),
            BottomSep(),
            BottomItem('IoT Platform v4.2.1'),
            BottomSep(),
            BottomItem('All Systems Nominal'),
          ],
        ),
      ),
    );
  }
}
