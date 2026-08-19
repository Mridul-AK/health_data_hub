import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Smooth gradient line chart for "Dopamine Levels During Physical Activity".
class HealthLineChart extends StatefulWidget {
  final List<Offset> points; // x:0..120  y:50..100
  const HealthLineChart({super.key, required this.points});

  @override
  State<HealthLineChart> createState() => _HealthLineChartState();
}

class _HealthLineChartState extends State<HealthLineChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.55,
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) => CustomPaint(
          painter: _ChartPainter(widget.points, _c.value),
        ),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<Offset> pts;
  final double progress;
  _ChartPainter(this.pts, this.progress);

  static const double minX = 0, maxX = 120, minY = 50, maxY = 100;

  Offset _map(Offset p, Size s, Rect plot) {
    final dx = plot.left + (p.dx - minX) / (maxX - minX) * plot.width;
    final dy = plot.bottom - (p.dy - minY) / (maxY - minY) * plot.height;
    return Offset(dx, dy);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final plot = Rect.fromLTRB(38, 8, size.width - 6, size.height - 24);

    // Grid + Y labels (50..100).
    final gridPaint = Paint()
      ..color = AppColors.line.withValues(alpha: 0.8)
      ..strokeWidth = 1;
    for (int y = 50; y <= 100; y += 10) {
      final yy = plot.bottom - (y - minY) / (maxY - minY) * plot.height;
      _dashLine(canvas, Offset(plot.left, yy), Offset(plot.right, yy),
          gridPaint, 5, 5);
      final tp = TextPainter(
        text: TextSpan(
            text: '$y',
            style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 9,
                fontFamily: AppText.mono)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(plot.left - tp.width - 6, yy - tp.height / 2));
    }
    // X labels 0..120.
    for (int x = 0; x <= 120; x += 20) {
      final xx = plot.left + (x - minX) / (maxX - minX) * plot.width;
      final tp = TextPainter(
        text: TextSpan(
            text: '$x',
            style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 9,
                fontFamily: AppText.mono)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(xx - tp.width / 2, plot.bottom + 6));
    }

    // Dotted reference line ~80.
    final refY = plot.bottom - (80 - minY) / (maxY - minY) * plot.height;
    _dashLine(canvas, Offset(plot.left, refY), Offset(plot.right, refY),
        Paint()..color = Colors.white54..strokeWidth = 1, 2, 4);

    // Build smooth path (Catmull-Rom -> cubic).
    final mapped = pts.map((p) => _map(p, size, plot)).toList();
    final path = _smooth(mapped);

    // Animated trim.
    final metric = path.computeMetrics().first;
    final drawn = metric.extractPath(0, metric.length * progress);

    // Area fill.
    final fill = Path.from(drawn)
      ..lineTo(mapped.last.dx * progress + plot.left * (1 - progress),
          plot.bottom)
      ..lineTo(plot.left, plot.bottom)
      ..close();
    canvas.save();
    canvas.clipRect(plot);
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.green.withValues(alpha: 0.28),
            AppColors.gold.withValues(alpha: 0.06),
            AppColors.red.withValues(alpha: 0.12),
          ],
        ).createShader(plot),
    );
    canvas.restore();

    // Gradient stroke (green -> gold -> red across x).
    canvas.drawPath(
      drawn,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..shader = const LinearGradient(colors: [
          AppColors.green,
          Color(0xFFC9D63A),
          AppColors.gold,
          AppColors.red,
        ]).createShader(plot),
    );

    // Data-point dots (revealed with progress).
    for (int i = 0; i < mapped.length; i++) {
      if (i / (mapped.length - 1) > progress) break;
      canvas.drawCircle(mapped[i], 4, Paint()..color = AppColors.cyan);
      canvas.drawCircle(mapped[i], 4,
          Paint()..color = AppColors.cyan.withValues(alpha: .4)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
    }
  }

  Path _smooth(List<Offset> p) {
    final path = Path()..moveTo(p.first.dx, p.first.dy);
    for (int i = 0; i < p.length - 1; i++) {
      final p0 = i == 0 ? p[i] : p[i - 1];
      final p1 = p[i];
      final p2 = p[i + 1];
      final p3 = i + 2 < p.length ? p[i + 2] : p2;
      final c1 = Offset(p1.dx + (p2.dx - p0.dx) / 6, p1.dy + (p2.dy - p0.dy) / 6);
      final c2 = Offset(p2.dx - (p3.dx - p1.dx) / 6, p2.dy - (p3.dy - p1.dy) / 6);
      path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p2.dx, p2.dy);
    }
    return path;
  }

  void _dashLine(Canvas c, Offset a, Offset b, Paint p, double dash, double gap) {
    final total = (b - a).distance;
    final dir = (b - a) / total;
    double d = 0;
    while (d < total) {
      final s = a + dir * d;
      final e = a + dir * math.min(d + dash, total);
      c.drawLine(s, e, p);
      d += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter old) =>
      old.progress != progress || old.pts != pts;
}
