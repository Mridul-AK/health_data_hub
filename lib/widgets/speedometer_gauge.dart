import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Semicircular multi-segment speedometer used on the metric detail screen.
class SpeedometerGauge extends StatefulWidget {
  final double fraction; // 0..1 needle position
  final double width;
  const SpeedometerGauge(
      {super.key, required this.fraction, this.width = 300});

  @override
  State<SpeedometerGauge> createState() => _SpeedometerGaugeState();
}

class _SpeedometerGaugeState extends State<SpeedometerGauge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1300));
    _a = CurvedAnimation(parent: _c, curve: Curves.easeOutBack);
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.width * 0.62,
      child: AnimatedBuilder(
        animation: _a,
        builder: (_, __) => CustomPaint(
          painter: _SpeedoPainter(
              (widget.fraction * _a.value.clamp(0.0, 1.0))),
        ),
      ),
    );
  }
}

class _SpeedoPainter extends CustomPainter {
  final double frac;
  _SpeedoPainter(this.frac);

  static const List<Color> _segColors = [
    AppColors.red,
    Color(0xFFF0774B),
    AppColors.gold,
    Color(0xFFC9D63A),
    Color(0xFF6FB63A),
    AppColors.green,
  ];
  static const List<String> _labels = [
    'VERY LOW',
    'LOW',
    'MODERATE',
    'OPTIMAL',
    'HIGH',
    'VERY HIGH',
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.86);
    final radius = size.width * 0.42;
    final stroke = size.width * 0.11;
    const start = math.pi; // west
    const total = math.pi; // 180 upper semicircle
    const seg = total / 6;

    for (int i = 0; i < 6; i++) {
      final a0 = start + seg * i + 0.012;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.butt
        ..color = _segColors[i]
        ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 0.6);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        a0,
        seg - 0.024,
        false,
        paint,
      );

      // label outside the mid-angle of the segment
      final mid = start + seg * (i + 0.5);
      final lp = center +
          Offset(math.cos(mid), math.sin(mid)) * (radius + stroke * 0.9);
      final tp = TextPainter(
        text: TextSpan(
            text: _labels[i],
            style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 9,
                fontFamily: AppText.mono)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, lp - Offset(tp.width / 2, tp.height / 2));
    }

    // Needle.
    final na = start + total * frac.clamp(0.0, 1.0);
    final tip = center + Offset(math.cos(na), math.sin(na)) * (radius + 2);
    canvas.drawLine(
      center,
      tip,
      Paint()
        ..shader = LinearGradient(colors: [
          Colors.white.withValues(alpha: 0.2),
          Colors.white,
        ]).createShader(Rect.fromPoints(center, tip))
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    // Pivot knob.
    canvas.drawCircle(center, 12, Paint()..color = const Color(0xFF14110B));
    canvas.drawCircle(center, 10, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _SpeedoPainter old) => old.frac != frac;
}
