import 'package:flutter/material.dart';
import 'package:urban_os/widgets/login/button_painter.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class LoginButton extends StatefulWidget {
  final bool isLoading;
  final AnimationController loadingCtrl;
  final VoidCallback onTap;
  const LoginButton({
    super.key,
    required this.isLoading,
    required this.loadingCtrl,
    required this.onTap,
  });
  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverCtrl;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _hoverCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _hoverCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _pressed = true);
        _hoverCtrl.forward();
      },
      onTapUp: (_) {
        setState(() => _pressed = false);
        _hoverCtrl.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _pressed = false);
        _hoverCtrl.reverse();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        height: 52,
        transform: Matrix4.identity()..scale(_pressed ? 0.98 : 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: _pressed
                ? [AppColors.cyanDim, AppColors.cyanDim]
                : [const Color(0xFF006080), AppColors.cyan, AppColors.teal],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cyan.withOpacity(_pressed ? 0.2 : 0.35),
              blurRadius: _pressed ? 10 : 20,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: AppColors.cyan.withOpacity(0.4), width: 1),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Shimmer overlay
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AnimatedBuilder(
                animation: widget.loadingCtrl,
                builder: (_, __) => CustomPaint(
                  painter: ButtonShimmerPainter(
                    widget.isLoading ? widget.loadingCtrl.value : -1,
                  ),
                  size: const Size(double.infinity, 52),
                ),
              ),
            ),

            if (widget.isLoading)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: widget.loadingCtrl,
                    builder: (_, __) => Row(
                      children: List.generate(3, (i) {
                        final t = (widget.loadingCtrl.value - i * 0.2).clamp(
                          0.0,
                          1.0,
                        );
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3 + t * 0.7),
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'AUTHENTICATING...',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shield_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'AUTHENTICATE & ENTER',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
