import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urban_os/screens/auth/login_screen.dart';
import 'package:urban_os/widgets/onboarding/grid_painter_widget.dart';
import 'package:urban_os/widgets/onboarding/onboarding_page.dart';
import 'package:urban_os/datamodel/onboarding_data_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _bgAnimController;
  late AnimationController _particleController;
  late AnimationController _pageEntryController;

  late Animation<double> _bgAnimation;
  late Animation<double> _pageEntryAnimation;

  @override
  void initState() {
    super.initState();
    _bgAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _pageEntryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _bgAnimation = CurvedAnimation(
      parent: _bgAnimController,
      curve: Curves.easeInOut,
    );

    _pageEntryAnimation = CurvedAnimation(
      parent: _pageEntryController,
      curve: Curves.easeOutCubic,
    );

    _pageEntryController.forward();
  }

  @override
  void dispose() {
    _bgAnimController.dispose();
    _particleController.dispose();
    _pageEntryController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    _pageEntryController.reset();
    _pageEntryController.forward();
  }

  void _nextPage() {
    if (_currentPage < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _navigateToDashboard();
    }
  }

  Future<void> _navigateToDashboard() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentData = pages[_currentPage];
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF070B14),
      body: AnimatedBuilder(
        animation: _bgAnimation,
        builder: (context, child) {
          return Stack(
            children: [
              // Animated gradient background
              Positioned.fill(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(
                        -0.3 + (_bgAnimation.value * 0.6),
                        -0.5 + (_bgAnimation.value * 0.4),
                      ),
                      radius: 1.5,
                      colors: [
                        currentData.accentColor.withOpacity(0.12),
                        const Color(0xFF070B14),
                        const Color(0xFF070B14),
                      ],
                    ),
                  ),
                ),
              ),

              // Grid lines
              Positioned.fill(child: GridPainterWidget()),

              // Floating particles
              ...List.generate(12, (i) {
                return AnimatedBuilder(
                  animation: _particleController,
                  builder: (context, _) {
                    final progress =
                        (_particleController.value + i * 0.083) % 1.0;
                    return Positioned(
                      left: (size.width * ((i * 0.137 + 0.05) % 1.0)),
                      top: size.height * (1 - progress),
                      child: Opacity(
                        opacity: (math.sin(progress * math.pi)).clamp(0.0, 1.0),
                        child: Container(
                          width: 2 + (i % 3).toDouble(),
                          height: 2 + (i % 3).toDouble(),
                          decoration: BoxDecoration(
                            color: currentData.accentColor.withOpacity(0.6),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: currentData.accentColor.withOpacity(0.4),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),

              // Main content
              SafeArea(
                child: Column(
                  children: [
                    // Top bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: currentData.accentColor.withOpacity(
                                    0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: currentData.accentColor.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                ),
                                child: Icon(
                                  Icons.hexagon_outlined,
                                  color: currentData.accentColor,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'URBAN OS',
                                style: TextStyle(
                                  color: currentData.accentColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 3,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: _navigateToDashboard,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.15),
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'SKIP',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 11,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Page view
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: _onPageChanged,
                        itemCount: pages.length,
                        itemBuilder: (context, index) {
                          return OnboardingPage(
                            data: pages[index],
                            animation: _pageEntryAnimation,
                            isActive: index == _currentPage,
                          );
                        },
                      ),
                    ),

                    // Bottom controls
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                      child: Column(
                        children: [
                          // Step indicators
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(pages.length, (i) {
                              final isActive = i == _currentPage;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: isActive ? 32 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? currentData.accentColor
                                      : Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: isActive
                                      ? [
                                          BoxShadow(
                                            color: currentData.accentColor
                                                .withOpacity(0.5),
                                            blurRadius: 8,
                                          ),
                                        ]
                                      : null,
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 32),

                          // Next / Get Started button
                          GestureDetector(
                            onTap: _nextPage,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: double.infinity,
                              height: 58,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    currentData.accentColor,
                                    currentData.accentColor.withOpacity(0.7),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: currentData.accentColor.withOpacity(
                                      0.4,
                                    ),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _currentPage == pages.length - 1
                                          ? 'LAUNCH URBANOS'
                                          : 'CONTINUE',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Icon(
                                      _currentPage == pages.length - 1
                                          ? Icons.rocket_launch_rounded
                                          : Icons.arrow_forward_rounded,
                                      color: Colors.black,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
