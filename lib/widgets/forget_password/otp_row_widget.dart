import 'package:flutter/material.dart';
import 'package:urban_os/widgets/forget_password/otp_box_widget.dart';

class OtpRow extends StatelessWidget {
  final List<TextEditingController> ctrls;
  final List<FocusNode> focuses;
  const OtpRow({super.key, required this.ctrls, required this.focuses});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        6,
        (i) => OtpBox(
          ctrl: ctrls[i],
          focus: focuses[i],
          onChanged: (v) {
            if (v.isNotEmpty && i < 5) focuses[i + 1].requestFocus();
            if (v.isEmpty && i > 0) focuses[i - 1].requestFocus();
          },
        ),
      ),
    );
  }
}
