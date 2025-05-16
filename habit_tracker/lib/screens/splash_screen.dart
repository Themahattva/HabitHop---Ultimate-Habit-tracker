import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _rotateController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );

    _bounceController.forward();
    _rotateController.repeat();

    // Navigate to main screen after animation
    Timer(const Duration(milliseconds: 3000), () {
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1625),
      body: Stack(
        children: [
          // Animated background circles
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _rotateController,
              builder: (context, child) {
                return CustomPaint(
                  painter: CirclesPainter(
                    progress: _rotateController.value,
                  ),
                );
              },
            ),
          ),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Bouncing bunny logo
                AnimatedBuilder(
                  animation: _bounceAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -20 * (1 - _bounceAnimation.value)),
                      child: Transform.scale(
                        scale: 0.8 + (_bounceAnimation.value * 0.2),
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: SizedBox(
                            width: 150,
                            height: 150,
                            child: CustomPaint(
                              painter: BunnyPainter(),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
                // App name
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'HabitHop',
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Loading dots
                SizedBox(
                  height: 40,
                  child: AnimatedBuilder(
                    animation: _rotateController,
                    builder: (context, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          final delay = index * 0.2;
                          final progress = (_rotateController.value + delay) % 1.0;
                          return Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(
                                0.3 + (math.sin(progress * math.pi * 2) + 1) / 2 * 0.7,
                              ),
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BunnyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.3;

    // Body
    final bodyPath = Path()
      ..addOval(Rect.fromCenter(
        center: center,
        width: radius * 2,
        height: radius * 2.2,
      ));

    // Ears
    final leftEarPath = Path()
      ..moveTo(center.dx - radius * 0.5, center.dy - radius * 0.8)
      ..quadraticBezierTo(
        center.dx - radius * 0.8,
        center.dy - radius * 2.2,
        center.dx - radius * 0.3,
        center.dy - radius * 0.4,
      );

    final rightEarPath = Path()
      ..moveTo(center.dx + radius * 0.5, center.dy - radius * 0.8)
      ..quadraticBezierTo(
        center.dx + radius * 0.8,
        center.dy - radius * 2.2,
        center.dx + radius * 0.3,
        center.dy - radius * 0.4,
      );

    // Draw parts
    canvas.drawPath(bodyPath, paint);
    canvas.drawPath(leftEarPath, paint);
    canvas.drawPath(rightEarPath, paint);

    // Eyes
    final eyePaint = Paint()
      ..color = const Color(0xFF8B70FF)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(center.dx - radius * 0.3, center.dy),
      radius * 0.15,
      eyePaint,
    );

    canvas.drawCircle(
      Offset(center.dx + radius * 0.3, center.dy),
      radius * 0.15,
      eyePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CirclesPainter extends CustomPainter {
  final double progress;

  CirclesPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.4;

    for (var i = 0; i < 3; i++) {
      final radius = maxRadius * (0.5 + i * 0.25);
      final opacity = (0.1 - i * 0.02) * (1 + math.sin(progress * math.pi * 2)) / 2;
      
      paint.color = const Color(0xFF8B70FF).withOpacity(opacity);
      
      canvas.drawCircle(
        center,
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CirclesPainter oldDelegate) =>
      progress != oldDelegate.progress;
} 