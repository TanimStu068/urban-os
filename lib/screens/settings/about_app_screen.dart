import 'package:flutter/material.dart';
import 'package:urban_os/widgets/about_app/feature_card.dart';
import 'package:urban_os/widgets/about_app/featured_item.dart';
import 'package:urban_os/widgets/about_app/hero_section.dart';
import 'package:urban_os/widgets/about_app/tech_chip.dart';
import 'package:urban_os/widgets/about_app/tech_item.dart';
import 'package:urban_os/widgets/about_app/stat_item.dart';
import 'package:urban_os/widgets/about_app/section_header.dart';
import 'package:urban_os/widgets/about_app/info_row.dart';

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({super.key});

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen>
    with TickerProviderStateMixin {
  late AnimationController _orbitController;
  late AnimationController _entryController;

  @override
  void initState() {
    super.initState();
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _orbitController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  final List<StatItem> stats = const [
    StatItem(value: '40+', label: 'Screens'),
    StatItem(value: '200+', label: 'Sensors'),
    StatItem(value: '8', label: 'Districts'),
    StatItem(value: '∞', label: 'Rules'),
  ];

  final List<TechItem> _techStack = const [
    TechItem(
      name: 'Flutter',
      icon: Icons.flutter_dash,
      color: Color(0xFF00D4FF),
    ),
    TechItem(
      name: 'Riverpod',
      icon: Icons.account_tree_rounded,
      color: Color(0xFF00FF9D),
    ),
    TechItem(
      name: 'Hive DB',
      icon: Icons.storage_rounded,
      color: Color(0xFFFFAA00),
    ),
    TechItem(
      name: 'Simulation Engine',
      icon: Icons.memory_rounded,
      color: Color(0xFFB44FFF),
    ),
    TechItem(
      name: 'IoT Models',
      icon: Icons.sensors_rounded,
      color: Color(0xFFFF6B35),
    ),
    TechItem(
      name: 'AutoEngine',
      icon: Icons.auto_fix_high_rounded,
      color: Color(0xFF00D4FF),
    ),
  ];

  final List<FeatureItem> _features = const [
    FeatureItem(
      icon: Icons.location_city_rounded,
      title: 'Digital Twin',
      desc: 'Full city replica with real-time state',
    ),
    FeatureItem(
      icon: Icons.sensors_rounded,
      title: 'Virtual IoT',
      desc: '200+ sensor types across 8 categories',
    ),
    FeatureItem(
      icon: Icons.auto_fix_high_rounded,
      title: 'Automation',
      desc: 'Priority-based IF-THEN rule engine',
    ),
    FeatureItem(
      icon: Icons.analytics_rounded,
      title: 'Analytics',
      desc: 'Predictive intelligence & trend reports',
    ),
    FeatureItem(
      icon: Icons.security_rounded,
      title: 'Safety AI',
      desc: 'Emergency detection & auto-response',
    ),
    FeatureItem(
      icon: Icons.science_rounded,
      title: 'Simulation',
      desc: 'Scenario builder & event injection',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B14),
      body: CustomScrollView(
        slivers: [
          // Hero App Bar
          SliverAppBar(
            expandedHeight: 280,
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
              background: HeroSection(
                orbitController: _orbitController,
                entryController: _entryController,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App name and version
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF00D4FF).withOpacity(0.08),
                          const Color(0xFF0D1B2E),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF00D4FF).withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00D4FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF00D4FF).withOpacity(0.3),
                            ),
                          ),
                          child: const Icon(
                            Icons.hexagon_outlined,
                            color: Color(0xFF00D4FF),
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'UrbanOS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Smart City Digital Twin',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00FF9D).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(
                                    0xFF00FF9D,
                                  ).withOpacity(0.3),
                                ),
                              ),
                              child: const Text(
                                'v 1.0.0 — Beta',
                                style: TextStyle(
                                  color: Color(0xFF00FF9D),
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
                  const SizedBox(height: 24),

                  // Stats row
                  Row(
                    children: stats
                        .map(
                          (s) => Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.04),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.08),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    s.value,
                                    style: const TextStyle(
                                      color: Color(0xFF00D4FF),
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    s.label,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.45),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 32),

                  // About section
                  SectionHeader(
                    title: 'About',
                    icon: Icons.info_outline_rounded,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Text(
                      'UrbanOS is an enterprise-grade smart city control platform that models how a fully autonomous city operates. Built as an IoT digital twin, it simulates traffic, energy, environment, safety, and public services through virtual sensors, automation engines, and actuators — all without physical hardware.\n\nDesigned for city authorities, urban planners, and IoT researchers, UrbanOS demonstrates cutting-edge system design at scale.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.65),
                        fontSize: 14,
                        height: 1.7,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Features
                  SectionHeader(
                    title: 'Core Features',
                    icon: Icons.stars_rounded,
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.0,
                        ),
                    itemCount: _features.length,
                    itemBuilder: (context, i) =>
                        FeatureCard(feature: _features[i]),
                  ),
                  const SizedBox(height: 32),

                  // Tech stack
                  SectionHeader(
                    title: 'Technology Stack',
                    icon: Icons.code_rounded,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _techStack.map((t) => TechChip(item: t)).toList(),
                  ),
                  const SizedBox(height: 32),

                  // Build info
                  SectionHeader(title: 'Build Info', icon: Icons.build_rounded),
                  const SizedBox(height: 16),
                  InfoRow(label: 'Platform', value: 'Flutter 3.x — Dart 3.x'),
                  InfoRow(
                    label: 'Architecture',
                    value: 'MVVM + Repository Pattern',
                  ),
                  InfoRow(label: 'State Management', value: 'Riverpod'),
                  InfoRow(label: 'Database', value: 'Hive + SharedPreferences'),
                  InfoRow(label: 'Min SDK', value: 'Android 8.0 / iOS 14+'),
                  InfoRow(label: 'Build Date', value: 'June 2025'),
                  const SizedBox(height: 32),

                  // Legal
                  Center(
                    child: Column(
                      children: [
                        Text(
                          '© 2025 UrbanOS Platform',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'All rights reserved — MIT License',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.2),
                            fontSize: 11,
                          ),
                        ),
                      ],
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
