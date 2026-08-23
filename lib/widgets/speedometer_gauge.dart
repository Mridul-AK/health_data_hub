import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SpeedometerGauge extends StatefulWidget {
  final double fraction;
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
        builder: (context, _) => CustomPaint(
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
    Color(0xFFEF4444),
    Color(0xFFF87171),
    Color(0xFFEAB308),
    Color(0xFFA3E635),
    Color(0xFF4ADE80),
    Color(0xFF22C55E),
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
    final center = Offset(size.width / 2, size.height * 0.88);
    final radius = size.width * 0.37;
    final stroke = size.width * 0.082;
    const start = math.pi;
    const total = math.pi;
    const seg = total / 6;

    final bgArcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke + 4
      ..color = const Color(0xFF0D0F0D);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start,
      total,
      false,
      bgArcPaint,
    );

    for (int i = 0; i < 6; i++) {
      final a0 = start + seg * i + 0.016;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.butt
        ..color = _segColors[i];

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        a0,
        seg - 0.032,
        false,
        paint,
      );

      final mid = start + seg * (i + 0.5);
      final double distanceMultiplier = (i == 0 || i == 5)
          ? 1.58
          : ((i == 1 || i == 4) ? 1.42 : 1.30);
      final lp = center +
          Offset(math.cos(mid), math.sin(mid)) * (radius + stroke * distanceMultiplier);
      final tp = TextPainter(
        text: TextSpan(
          text: _labels[i],
          style: const TextStyle(
            color: Color(0xFF8A8D8B),
            fontSize: 8,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, lp - Offset(tp.width / 2, tp.height / 2));
    }

    final na = start + total * frac.clamp(0.0, 1.0);
    final tip = center + Offset(math.cos(na), math.sin(na)) * (radius + 4);

    final needlePath = Path();
    final perpAngle = na + math.pi / 2;
    final baseOffset1 = center + Offset(math.cos(perpAngle), math.sin(perpAngle)) * 3.5;
    final baseOffset2 = center - Offset(math.cos(perpAngle), math.sin(perpAngle)) * 3.5;

    needlePath.moveTo(baseOffset1.dx, baseOffset1.dy);
    needlePath.lineTo(tip.dx, tip.dy);
    needlePath.lineTo(baseOffset2.dx, baseOffset2.dy);
    needlePath.close();

    final needlePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF4A4D4B),
          Colors.white,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ).createShader(Rect.fromPoints(center, tip));

    canvas.drawPath(needlePath, needlePaint);
    canvas.drawCircle(
      center,
      13,
      Paint()..color = Colors.black.withValues(alpha: 0.5),
    );
    canvas.drawCircle(
      center,
      9.5,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant _SpeedoPainter old) => old.frac != frac;
}
