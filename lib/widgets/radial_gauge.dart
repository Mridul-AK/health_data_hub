import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RadialGauge extends StatefulWidget {
  final double value;
  final Color accent;
  final double size;

  const RadialGauge({
    super.key,
    required this.value,
    required this.accent,
    this.size = 250,
  });

  @override
  State<RadialGauge> createState() => _RadialGaugeState();
}

class _RadialGaugeState extends State<RadialGauge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400));
    _anim = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
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
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (context, _) {
          final double v = widget.value * _anim.value;
          return CustomPaint(
            painter: _RadialGaugePainter(value: v, accent: widget.accent),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    v.round().toString(),
                    style: TextStyle(
                      fontSize: widget.size * 0.23,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.0,
                      shadows: [
                        Shadow(
                          color: widget.accent.withValues(alpha: 0.8),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 2),
                  Transform.translate(
                    offset: Offset(0, -widget.size * 0.04),
                    child: Text(
                      '%',
                      style: TextStyle(
                        fontSize: widget.size * 0.10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RadialGaugePainter extends CustomPainter {
  final double value;
  final Color accent;

  _RadialGaugePainter({required this.value, required this.accent});

  static const double _start = 125 * math.pi / 180;
  static const double _sweep = 290 * math.pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final r = size.width / 2;
    final frac = (value / 100).clamp(0.0, 1.0);

    canvas.drawCircle(
      center,
      r,
      Paint()
        ..shader = RadialGradient(
          colors: [const Color(0xFF0A0F0D), const Color(0xFF05100A)],
        ).createShader(Rect.fromCircle(center: center, radius: r)),
    );

    const int ticks = 44;
    final tickOuter = r * 0.98;
    final tickInner = r * 0.90;
    final tickInnerMajor = r * 0.84;
    for (int i = 0; i <= ticks; i++) {
      final t = i / ticks;
      final a = _start + _sweep * t;
      final bool major = i % (ticks ~/ 4) == 0;
      final inner = major ? tickInnerMajor : tickInner;
      final p = Paint()
        ..color = accent.withValues(alpha: major ? 0.9 : 0.35)
        ..strokeWidth = major ? 2.4 : 1.2
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        center + Offset(math.cos(a), math.sin(a)) * inner,
        center + Offset(math.cos(a), math.sin(a)) * tickOuter,
        p,
      );
    }

    const labels = ['0', '20', '40', '60', '80'];
    for (int i = 0; i < labels.length; i++) {
      final t = i / (labels.length - 1);
      final a = _start + _sweep * t;
      final pos = center + Offset(math.cos(a), math.sin(a)) * (r * 0.72);
      final bool isMid = i == labels.length ~/ 2;
      final tp = TextPainter(
        text: TextSpan(
            text: labels[i],
            style: TextStyle(
                color: isMid ? accent : AppColors.textSecondary,
                fontSize: 11,
                fontWeight: isMid ? FontWeight.bold : FontWeight.normal,
                fontFamily: AppText.mono)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
    }

    const int segs = 60;
    final segOuter = r * 0.70;
    final segInner = r * 0.56;
    for (int i = 0; i < segs; i++) {
      final t = i / (segs - 1);
      final a = _start + _sweep * t;
      final bool filled = t <= frac;
      final Paint p = Paint()
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round
        ..color = filled
            ? accent
            : accent.withValues(alpha: 0.12);
      if (filled) {
        p.maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.2);
      }
      canvas.drawLine(
        center + Offset(math.cos(a), math.sin(a)) * segInner,
        center + Offset(math.cos(a), math.sin(a)) * segOuter,
        p,
      );
    }

    final glowRect = Rect.fromCircle(center: center, radius: r * 0.63);
    canvas.drawArc(
      glowRect,
      _start,
      _sweep * frac,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..color = accent.withValues(alpha: 0.55)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    canvas.drawCircle(
        center,
        r * 0.5,
        Paint()
          ..shader = RadialGradient(colors: [
            const Color(0xFF0B0E0D),
            const Color(0xFF010402),
          ]).createShader(Rect.fromCircle(center: center, radius: r * 0.5)));

    final na = _start + _sweep * frac;
    final needleTip =
        center + Offset(math.cos(na), math.sin(na)) * (r * 0.5);
    canvas.drawLine(
      center,
      needleTip,
      Paint()
        ..color = Colors.white
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(center, 4.5, Paint()..color = Colors.white);

    final ma = _start + _sweep * 0.5;
    final mp = center + Offset(math.cos(ma), math.sin(ma)) * (r * 0.80);
    final tri = Path()
      ..moveTo(mp.dx - 6, mp.dy - 8)
      ..lineTo(mp.dx + 6, mp.dy - 8)
      ..lineTo(mp.dx, mp.dy)
      ..close();
    canvas.drawPath(tri, Paint()..color = accent);
  }

  @override
  bool shouldRepaint(covariant _RadialGaugePainter old) =>
      old.value != value || old.accent != accent;
}
