import 'package:flutter/material.dart';
import 'package:urban_os/datamodel/profile_screen_data_model.dart';
import 'package:urban_os/widgets/profile/login_history_card.dart';

class HistoryView extends StatelessWidget {
  final List<LoginHistory> loginHistory;

  const HistoryView({super.key, required this.loginHistory});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      child: Column(
        children: loginHistory
            .map(
              (login) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: LoginHistoryCard(login: login),
              ),
            )
            .toList(),
      ),
    );
  }
}
