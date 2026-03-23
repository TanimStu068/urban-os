import 'package:flutter/material.dart';
import 'package:urban_os/widgets/term_condition/check_box_card.dart';
import 'package:urban_os/widgets/term_condition/term_section_card.dart';
import 'package:urban_os/datamodel/term_conditon.dart';

class TermAndConditionScreen extends StatefulWidget {
  const TermAndConditionScreen({super.key});

  @override
  State<TermAndConditionScreen> createState() => _TermAndConditionScreenState();
}

class _TermAndConditionScreenState extends State<TermAndConditionScreen> {
  bool _agreedToTerms = false;
  bool _agreedToDataPolicy = false;
  bool _hasScrolledToBottom = false;
  final ScrollController _scrollController = ScrollController();
  int? _expandedSection;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        if (!_hasScrolledToBottom) setState(() => _hasScrolledToBottom = true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool get _canAccept => _agreedToTerms && _agreedToDataPolicy;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B14),
      body: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.5, -1),
                radius: 1.5,
                colors: [
                  const Color(0xFF00D4FF).withOpacity(0.1),
                  const Color(0xFF070B14),
                ],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Terms & Conditions',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00D4FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF00D4FF).withOpacity(0.3),
                            ),
                          ),
                          child: const Text(
                            'v3.0',
                            style: TextStyle(
                              color: Color(0xFF00D4FF),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.07),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.white.withOpacity(0.3),
                            size: 14,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Effective: June 1, 2025',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.45),
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '8 sections · ~5 min read',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.3),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Scrollable content
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              children: [
                // Intro
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00D4FF).withOpacity(0.06),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF00D4FF).withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: Color(0xFF00D4FF),
                        size: 18,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Please read these Terms carefully before operating the UrbanOS platform. Tap each section to expand the full details. You must agree to both checkboxes at the bottom to continue.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.65),
                            fontSize: 13,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Sections
                ...sections.asMap().entries.map((entry) {
                  final i = entry.key;
                  final section = entry.value;
                  final isExpanded = _expandedSection == i;
                  return TermSectionCard(
                    section: section,
                    isExpanded: isExpanded,
                    onTap: () => setState(
                      () => _expandedSection = isExpanded ? null : i,
                    ),
                  );
                }),

                const SizedBox(height: 28),

                // Agreement checkboxes
                CheckboxCard(
                  icon: Icons.gavel_rounded,
                  title: 'I have read and agree to the Terms & Conditions',
                  sublabel: 'Including all 8 sections listed above',
                  color: const Color(0xFF00D4FF),
                  value: _agreedToTerms,
                  onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                ),
                const SizedBox(height: 12),
                CheckboxCard(
                  icon: Icons.privacy_tip_outlined,
                  title: 'I consent to the data processing described',
                  sublabel: 'As outlined in the Privacy Policy',
                  color: const Color(0xFF00FF9D),
                  value: _agreedToDataPolicy,
                  onChanged: (v) =>
                      setState(() => _agreedToDataPolicy = v ?? false),
                ),

                const SizedBox(height: 28),

                // Accept button
                GestureDetector(
                  onTap: _canAccept
                      ? () {
                          Navigator.pop(context, true);
                        }
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      gradient: _canAccept
                          ? const LinearGradient(
                              colors: [Color(0xFF00D4FF), Color(0xFF0066CC)],
                            )
                          : null,
                      color: _canAccept ? null : Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _canAccept
                            ? Colors.transparent
                            : Colors.white.withOpacity(0.1),
                      ),
                      boxShadow: _canAccept
                          ? [
                              BoxShadow(
                                color: const Color(
                                  0xFF00D4FF,
                                ).withOpacity(0.35),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        'ACCEPT & CONTINUE',
                        style: TextStyle(
                          color: _canAccept
                              ? Colors.black
                              : Colors.white.withOpacity(0.25),
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Decline
                GestureDetector(
                  onTap: () => Navigator.pop(context, false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Center(
                      child: Text(
                        'Decline & Exit',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                          fontSize: 13,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
