import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_case/features/home/presentation/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const String routeName = '/splash';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _floatController;
  late final Animation<double> _pulseScale;
  late final Animation<double> _floatOffset;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    )..repeat(reverse: true);

    _pulseScale = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _floatOffset = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    unawaited(_startTimerAndNavigate());
  }

  Future<void> _startTimerAndNavigate() async {
    await Future<void>.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    context.go(HomePage.routeName);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color duolingoGreen = Color(0xFF58CC02);
    const Color lightBackground = Color(0xFFF7FAF5);

    return Scaffold(
      backgroundColor: lightBackground,
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge(<Listenable>[
            _pulseController,
            _floatController,
          ]),
          builder: (_, _) {
            return Transform.translate(
              offset: Offset(0, _floatOffset.value),
              child: Transform.scale(
                scale: _pulseScale.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                          width: 132,
                          height: 132,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: duolingoGreen.withValues(alpha: 0.18),
                          ),
                        ),
                        Container(
                          width: 104,
                          height: 104,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: duolingoGreen,
                          ),
                          child: const Icon(
                            Icons.school_rounded,
                            size: 54,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Language app',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1E1E1E),
                          ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 72,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List<Widget>.generate(3, (int index) {
                          final double value =
                              ((_pulseController.value + index * 0.2) % 1.0);
                          return Transform.scale(
                            scale: 0.85 + (value * 0.35),
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: duolingoGreen,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
