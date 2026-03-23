import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:urban_os/core/themes/app_theme.dart';

class OtpBox extends StatefulWidget {
  final TextEditingController ctrl;
  final FocusNode focus;
  final ValueChanged<String> onChanged;
  const OtpBox({
    super.key,
    required this.ctrl,
    required this.focus,
    required this.onChanged,
  });
  @override
  State<OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<OtpBox> {
  @override
  void initState() {
    super.initState();
    widget.focus.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final isFoc = widget.focus.hasFocus;
    final hasVal = widget.ctrl.text.isNotEmpty;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 44,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isFoc
              ? AppColors.cyan
              : hasVal
              ? AppColors.cyan.withOpacity(.5)
              : AppColors.glassBdr,
          width: isFoc ? 1.5 : 1,
        ),
        color: isFoc ? AppColors.cyan.withOpacity(.08) : AppColors.inputBg,
        boxShadow: isFoc
            ? [BoxShadow(color: AppColors.cyan.withOpacity(.2), blurRadius: 12)]
            : [],
      ),
      child: TextField(
        controller: widget.ctrl,
        focusNode: widget.focus,
        textAlign: TextAlign.center,
        // Allow alphanumeric — Firebase OOB codes are alphanumeric
        keyboardType: TextInputType.visiblePassword,
        maxLength: 1,
        style: const TextStyle(
          fontFamily: 'Orbitron',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.cyan,
        ),
        cursorColor: AppColors.cyan,
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: widget.onChanged,
        inputFormatters: [
          // Alphanumeric only (Firebase codes use A-Z 0-9)
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
        ],
      ),
    );
  }
}
