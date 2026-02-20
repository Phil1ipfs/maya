import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../../core/constants/app_colors.dart';

/// Custom zigzag loading animation widget
class ZigzagLoading extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;

  const ZigzagLoading({
    super.key,
    this.size = 50,
    this.color = AppColors.primary,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<ZigzagLoading> createState() => _ZigzagLoadingState();
}

class _ZigzagLoadingState extends State<ZigzagLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: ZigzagPainter(
              progress: _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class ZigzagPainter extends CustomPainter {
  final double progress;
  final Color color;

  ZigzagPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final segmentWidth = size.width / 4;
    final amplitude = size.height / 4;
    final centerY = size.height / 2;

    // Create zigzag path
    path.moveTo(0, centerY);
    for (int i = 0; i < 4; i++) {
      final x1 = segmentWidth * i + segmentWidth / 2;
      final y1 = i.isEven ? centerY - amplitude : centerY + amplitude;
      final x2 = segmentWidth * (i + 1);
      final y2 = centerY;
      path.quadraticBezierTo(x1, y1, x2, y2);
    }

    // Animate the path drawing
    final pathMetrics = path.computeMetrics().first;
    final animatedPath = pathMetrics.extractPath(
      0,
      pathMetrics.length * _easeInOut(progress),
    );

    canvas.drawPath(animatedPath, paint);

    // Draw dots at zigzag points
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (int i = 0; i <= 4; i++) {
      final dotProgress = (progress * 5 - i).clamp(0.0, 1.0);
      if (dotProgress > 0) {
        final x = segmentWidth * i;
        final y = centerY;
        canvas.drawCircle(
          Offset(x, y),
          4 * dotProgress,
          dotPaint,
        );
      }
    }
  }

  double _easeInOut(double t) {
    return t < 0.5 ? 2 * t * t : 1 - math.pow(-2 * t + 2, 2) / 2;
  }

  @override
  bool shouldRepaint(covariant ZigzagPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Animated loading dots widget
class LoadingDots extends StatefulWidget {
  final Color color;
  final double size;

  const LoadingDots({
    super.key,
    this.color = AppColors.primary,
    this.size = 10,
  });

  @override
  State<LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final delay = index * 0.2;
            final progress = ((_controller.value - delay) % 1.0).clamp(0.0, 1.0);
            final scale = math.sin(progress * math.pi);

            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.size * 0.3),
              child: Transform.scale(
                scale: 0.5 + (scale * 0.5),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: 0.5 + (scale * 0.5)),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

/// Pulse loading animation
class PulseLoading extends StatefulWidget {
  final double size;
  final Color color;

  const PulseLoading({
    super.key,
    this.size = 60,
    this.color = AppColors.primary,
  });

  @override
  State<PulseLoading> createState() => _PulseLoadingState();
}

class _PulseLoadingState extends State<PulseLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer pulse
              Transform.scale(
                scale: 0.5 + (_controller.value * 0.5),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withValues(alpha: 1 - _controller.value),
                  ),
                ),
              ),
              // Inner circle
              Container(
                width: widget.size * 0.4,
                height: widget.size * 0.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
