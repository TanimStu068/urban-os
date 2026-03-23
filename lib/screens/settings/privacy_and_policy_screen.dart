import 'package:flutter/material.dart';
import 'package:urban_os/widgets/privacy_policy/commitment_chip.dart';
import 'package:urban_os/datamodel/privacy_and_policy_data_model.dart';
import 'package:urban_os/widgets/privacy_policy/policy_section_card.dart';

class PrivacyAndPolicyScreen extends StatefulWidget {
  const PrivacyAndPolicyScreen({super.key});

  @override
  State<PrivacyAndPolicyScreen> createState() => _PrivacyAndPolicyScreenState();
}

class _PrivacyAndPolicyScreenState extends State<PrivacyAndPolicyScreen> {
  int? _expandedSection;
  bool _hasRead = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B14),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFF070B14),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(-0.5, -0.8),
                    radius: 1.5,
                    colors: [Color(0xFF1A0D2E), Color(0xFF070B14)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFB44FFF,
                                ).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(
                                    0xFFB44FFF,
                                  ).withOpacity(0.4),
                                ),
                              ),
                              child: const Icon(
                                Icons.privacy_tip_outlined,
                                color: Color(0xFFB44FFF),
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Privacy Policy',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 4),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                              child: Text(
                                'Last updated: June 1, 2025',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.4),
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFB44FFF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(
                                    0xFFB44FFF,
                                  ).withOpacity(0.3),
                                ),
                              ),
                              child: const Text(
                                'Version 2.1',
                                style: TextStyle(
                                  color: Color(0xFFB44FFF),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Intro
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Text(
                      'At UrbanOS, your privacy is foundational to our mission. This policy explains how we collect, use, store, and protect your information when you operate the UrbanOS Smart City Platform. We are committed to transparent data practices and your right to control your information.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.65),
                        fontSize: 14,
                        height: 1.7,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quick summary pills
                  const Text(
                    'Key Commitments',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      CommitmentChip(
                        icon: Icons.do_not_disturb_rounded,
                        label: 'No Data Sales',
                        color: const Color(0xFF00FF9D),
                      ),
                      CommitmentChip(
                        icon: Icons.lock_rounded,
                        label: 'AES-256 Encryption',
                        color: const Color(0xFF00D4FF),
                      ),
                      CommitmentChip(
                        icon: Icons.visibility_off_rounded,
                        label: 'No Ad Tracking',
                        color: const Color(0xFFB44FFF),
                      ),
                      CommitmentChip(
                        icon: Icons.download_rounded,
                        label: 'Data Portability',
                        color: const Color(0xFFFFAA00),
                      ),
                      CommitmentChip(
                        icon: Icons.delete_forever_rounded,
                        label: 'Right to Delete',
                        color: const Color(0xFFFF6B35),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Sections
                  ...sections.asMap().entries.map((entry) {
                    final i = entry.key;
                    final section = entry.value;
                    final isExpanded = _expandedSection == i;
                    return PolicySectionCard(
                      section: section,
                      isExpanded: isExpanded,
                      onTap: () => setState(
                        () => _expandedSection = isExpanded ? null : i,
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // Contact for privacy
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB44FFF).withOpacity(0.07),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFB44FFF).withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Privacy Questions?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Contact our Data Protection Officer at privacy@urbanos.io or submit a GDPR request through the profile settings screen.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.55),
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Accept button
                  if (!_hasRead)
                    GestureDetector(
                      onTap: () {
                        setState(() => _hasRead = true);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFB44FFF), Color(0xFF7B2FF7)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFB44FFF).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'I Understand & Accept',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (_hasRead)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00FF9D).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFF00FF9D).withOpacity(0.3),
                        ),
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: Color(0xFF00FF9D),
                              size: 18,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Policy Accepted',
                              style: TextStyle(
                                color: Color(0xFF00FF9D),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
