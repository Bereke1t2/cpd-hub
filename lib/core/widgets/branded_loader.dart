import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lab_portal/core/ui_constants.dart';

/// CPD Hub branded loading spinner.
///
/// A dual-arc ring sweeping in green + white around a subtle `</>` glyph —
/// a unique, on-brand replacement for the stock [CircularProgressIndicator].
///
/// Use [BrandedLoader] anywhere a loading indicator is needed:
/// ```dart
/// const Center(child: BrandedLoader())
/// ```
class BrandedLoader extends StatefulWidget {
  /// Outer diameter of the ring.
  final double size;

  /// Stroke width of the sweeping arcs.
  final double stroke;

  /// Show the centered `</>` glyph. Off for very small sizes.
  final bool showGlyph;

  const BrandedLoader({
    super.key,
    this.size = 48,
    this.stroke = 4,
    this.showGlyph = true,
  });

  /// Compact variant for inline use (buttons, small cards).
  const BrandedLoader.small({super.key})
      : size = 20,
        stroke = 2.5,
        showGlyph = false;

  @override
  State<BrandedLoader> createState() => _BrandedLoaderState();
}

class _BrandedLoaderState extends State<BrandedLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => CustomPaint(
              size: Size.square(widget.size),
              painter: _BrandedLoaderPainter(
                turns: _controller.value,
                stroke: widget.stroke,
              ),
            ),
          ),
          if (widget.showGlyph)
            Text(
              '</>',
              style: TextStyle(
                color: UiConstants.primaryButtonColor.withValues(alpha: 0.9),
                fontSize: widget.size * 0.26,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
        ],
      ),
    );
  }
}

class _BrandedLoaderPainter extends CustomPainter {
  final double turns; // 0..1
  final double stroke;

  _BrandedLoaderPainter({required this.turns, required this.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.width - stroke) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final base = turns * 2 * math.pi;

    // Faint full track so the ring reads even between arcs.
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = UiConstants.primaryButtonColor.withValues(alpha: 0.12);
    canvas.drawCircle(center, radius, track);

    const sweep = math.pi * 0.55; // each arc spans ~100°

    // Green arc — leading.
    final green = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: 2 * math.pi,
        colors: const [
          UiConstants.primaryButtonColor,
          UiConstants.primaryDark,
        ],
        transform: GradientRotation(base),
      ).createShader(rect);
    canvas.drawArc(rect, base, sweep, false, green);

    // White arc — trailing, opposite side.
    final white = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke
      ..color = Colors.white.withValues(alpha: 0.92);
    canvas.drawArc(rect, base + math.pi, sweep, false, white);
  }

  @override
  bool shouldRepaint(_BrandedLoaderPainter old) =>
      old.turns != turns || old.stroke != stroke;
}
