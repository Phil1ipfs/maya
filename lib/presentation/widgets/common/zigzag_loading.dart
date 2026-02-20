import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../../core/constants/app_colors.dart';

/// Custom zigzag loading animation widget - similar to fintech app style
class ZigzagLoading extends StatefulWidget {
  final double width;
  final double height;
  final Color activeColor;
  final Color inactiveColor;
  final Duration duration;

  const ZigzagLoading({
    super.key,
    this.width = 80,
    this.height = 40,
    this.activeColor = AppColors.primary,
    this.inactiveColor = const Color(0xFFE0E0E0),
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
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _ZigzagWavePainter(
              progress: _controller.value,
              activeColor: widget.activeColor,
              inactiveColor: widget.inactiveColor,
            ),
            size: Size(widget.width, widget.height),
          );
        },
      ),
    );
  }
}

class _ZigzagWavePainter extends CustomPainter {
  final double progress;
  final Color activeColor;
  final Color inactiveColor;

  _ZigzagWavePainter({
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 4.0;
    final centerY = size.height / 2;
    final amplitude = size.height * 0.35;
    final segments = 3; // Number of zigzag peaks
    final segmentWidth = size.width / segments;

    // Create the zigzag path
    final path = Path();
    path.moveTo(0, centerY);

    for (int i = 0; i < segments; i++) {
      final startX = segmentWidth * i;
      final peakX = startX + segmentWidth / 2;
      final endX = startX + segmentWidth;
      final peakY = i.isEven ? centerY - amplitude : centerY + amplitude;

      path.lineTo(peakX, peakY);
      path.lineTo(endX, centerY);
    }

    // Draw inactive (gray) background line
    final inactivePaint = Paint()
      ..color = inactiveColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, inactivePaint);

    // Calculate the animated portion
    final pathMetrics = path.computeMetrics().first;
    final totalLength = pathMetrics.length;

    // Create a moving segment effect
    final segmentLength = totalLength * 0.4; // 40% of path is colored
    final startOffset = progress * totalLength;
    final endOffset = startOffset + segmentLength;

    // Draw the active (green) animated portion
    final activePaint = Paint()
      ..color = activeColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // Handle wrap-around for continuous animation
    if (endOffset <= totalLength) {
      final activePath = pathMetrics.extractPath(startOffset, endOffset);
      canvas.drawPath(activePath, activePaint);
    } else {
      // Draw two segments when wrapping around
      final firstPart = pathMetrics.extractPath(startOffset, totalLength);
      final secondPart = pathMetrics.extractPath(0, endOffset - totalLength);
      canvas.drawPath(firstPart, activePaint);
      canvas.drawPath(secondPart, activePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ZigzagWavePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Alternative zigzag with gradient effect
class ZigzagGradientLoading extends StatefulWidget {
  final double width;
  final double height;
  final Color primaryColor;
  final Color secondaryColor;
  final Duration duration;

  const ZigzagGradientLoading({
    super.key,
    this.width = 80,
    this.height = 40,
    this.primaryColor = AppColors.primary,
    this.secondaryColor = const Color(0xFFE0E0E0),
    this.duration = const Duration(milliseconds: 2000),
  });

  @override
  State<ZigzagGradientLoading> createState() => _ZigzagGradientLoadingState();
}

class _ZigzagGradientLoadingState extends State<ZigzagGradientLoading>
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
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _ZigzagGradientPainter(
              progress: _controller.value,
              primaryColor: widget.primaryColor,
              secondaryColor: widget.secondaryColor,
            ),
            size: Size(widget.width, widget.height),
          );
        },
      ),
    );
  }
}

class _ZigzagGradientPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;

  _ZigzagGradientPainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 4.0;
    final centerY = size.height / 2;
    final amplitude = size.height * 0.35;
    final segments = 3;
    final segmentWidth = size.width / segments;

    // Create zigzag path
    final path = Path();
    path.moveTo(0, centerY);

    for (int i = 0; i < segments; i++) {
      final startX = segmentWidth * i;
      final peakX = startX + segmentWidth / 2;
      final endX = startX + segmentWidth;
      final peakY = i.isEven ? centerY - amplitude : centerY + amplitude;

      path.lineTo(peakX, peakY);
      path.lineTo(endX, centerY);
    }

    // Create gradient that moves with animation
    final gradientStart = -0.5 + (progress * 2);
    final gradientEnd = gradientStart + 0.5;

    final gradient = LinearGradient(
      begin: Alignment(gradientStart, 0),
      end: Alignment(gradientEnd, 0),
      colors: [
        secondaryColor,
        primaryColor,
        primaryColor,
        secondaryColor,
      ],
      stops: const [0.0, 0.3, 0.7, 1.0],
    );

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ZigzagGradientPainter oldDelegate) {
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

/// Full screen loading overlay with zigzag animation
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Color? backgroundColor;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: backgroundColor ?? Colors.white,
            child: const Center(
              child: ZigzagLoading(
                width: 100,
                height: 50,
                activeColor: AppColors.primary,
                inactiveColor: Color(0xFFE0E0E0),
              ),
            ),
          ),
      ],
    );
  }
}

/// Full screen loading page (for initial screen loads)
class LoadingScreen extends StatelessWidget {
  final String? title;

  const LoadingScreen({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: title != null
          ? AppBar(
              title: Text(title!),
              backgroundColor: Colors.white,
              elevation: 0,
            )
          : null,
      body: const Center(
        child: ZigzagLoading(
          width: 100,
          height: 50,
          activeColor: AppColors.primary,
          inactiveColor: Color(0xFFE0E0E0),
        ),
      ),
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
