import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 28),
              child: Text('9:41',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
            ),
          ),
          Container(
            width: 108,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                    color: Color(0xFF2A2E52), shape: BoxShape.circle),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.signal_cellular_alt,
                      size: 17, color: AppColors.textPrimary),
                  const SizedBox(width: 6),
                  Icon(Icons.wifi, size: 17, color: AppColors.textPrimary),
                  const SizedBox(width: 6),
                  Icon(Icons.battery_full,
                      size: 22, color: AppColors.textPrimary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppHeader extends StatelessWidget {
  final String title;
  final bool showBack;
  final bool showRobot;
  final VoidCallback? onRobotTap;
  const AppHeader(
      {super.key,
      this.title = 'Phenotype',
      this.showBack = true,
      this.showRobot = true,
      this.onRobotTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(child: Text(title, style: AppText.screenTitle)),
          Align(
            alignment: Alignment.centerLeft,
            child: showBack
                ? IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back,
                        color: AppColors.textPrimary),
                  )
                : const SizedBox(width: 48),
          ),
          if (showRobot)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  onPressed: onRobotTap,
                  icon: const ScannerIcon(
                      size: 24, color: AppColors.textSecondary),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ScannerIcon extends StatelessWidget {
  final Color color;
  final double size;
  const ScannerIcon({super.key, this.color = AppColors.textSecondary, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ScannerIconPainter(color),
    );
  }
}

class _ScannerIconPainter extends CustomPainter {
  final Color color;
  _ScannerIconPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    final bracketLen = h * 0.25;
    canvas.drawPath(
      Path()
        ..moveTo(bracketLen, 0)
        ..lineTo(0, 0)
        ..lineTo(0, h)
        ..lineTo(bracketLen, h),
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(w - bracketLen, 0)
        ..lineTo(w, 0)
        ..lineTo(w, h)
        ..lineTo(w - bracketLen, h),
      paint,
    );

    final cx = w / 2;
    final headRadius = h * 0.12;
    final headY = h * 0.20;
    canvas.drawCircle(Offset(cx, headY), headRadius, paint);

    final spineTop = headY + headRadius;
    final spineBottom = h * 0.70;
    canvas.drawLine(Offset(cx, spineTop), Offset(cx, spineBottom), paint);

    final shoulderY = headY + headRadius + 3;
    final shoulderWidth = w * 0.22;
    canvas.drawLine(Offset(cx - shoulderWidth, shoulderY),
        Offset(cx + shoulderWidth, shoulderY), paint);

    canvas.drawLine(Offset(cx - shoulderWidth * 0.8, shoulderY + 4),
        Offset(cx + shoulderWidth * 0.8, shoulderY + 4), paint);
    canvas.drawLine(Offset(cx - shoulderWidth * 0.6, shoulderY + 8),
        Offset(cx + shoulderWidth * 0.6, shoulderY + 8), paint);

    final hipWidth = w * 0.18;
    canvas.drawLine(Offset(cx - hipWidth, spineBottom),
        Offset(cx + hipWidth, spineBottom), paint);

    canvas.drawLine(Offset(cx - hipWidth, spineBottom), Offset(cx - hipWidth, h * 0.90), paint);
    canvas.drawLine(Offset(cx + hipWidth, spineBottom), Offset(cx + hipWidth, h * 0.90), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GlowBackground extends StatelessWidget {
  final Color glow;
  final Widget child;
  const GlowBackground({super.key, required this.glow, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -0.75),
          radius: 1.15,
          colors: [
            glow,
            glow.withValues(alpha: 0.35),
            AppColors.bg,
          ],
          stops: const [0.0, 0.45, 0.85],
        ),
      ),
      child: child,
    );
  }
}

class SegmentedToggle extends StatelessWidget {
  final List<String> options;
  final int selected;
  final ValueChanged<int> onChanged;
  final Color accent;
  final bool solidSelected;

  const SegmentedToggle({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.accent = AppColors.green,
    this.solidSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final double alignmentX = options.length > 1
        ? -1.0 + (2.0 * selected / (options.length - 1))
        : 0.0;

    final Color pillColor = solidSelected ? accent : const Color(0xFF2B322E);

    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF10160F),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: AppColors.line),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / options.length;
          return Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                alignment: Alignment(alignmentX, 0),
                child: Container(
                  width: itemWidth,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: pillColor,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: solidSelected
                        ? [
                            BoxShadow(
                              color: accent.withValues(alpha: 0.45),
                              blurRadius: 16,
                              spreadRadius: -2,
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
              Row(
                children: List.generate(options.length, (i) {
                  final bool on = i == selected;
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onChanged(i),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeInOut,
                          style: TextStyle(
                            fontFamily: AppText.display,
                            fontSize: 13,
                            fontWeight: on ? FontWeight.w600 : FontWeight.w400,
                            color: on
                                ? (solidSelected ? Colors.black : AppColors.textPrimary)
                                : AppColors.textFaint,
                          ),
                          child: Text(options[i]),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}

class VignetteImage extends StatelessWidget {
  final String asset;
  final double? width;
  final double? height;
  final Alignment radiusCenter;
  final double widthFactor;

  const VignetteImage({
    super.key,
    required this.asset,
    this.width,
    this.height,
    this.radiusCenter = Alignment.center,
    this.widthFactor = 0.58,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Align(
        alignment: Alignment.center,
        widthFactor: widthFactor,
        child: ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (rect) => RadialGradient(
            center: radiusCenter,
            radius: 0.72,
            colors: const [
              Colors.white,
              Colors.white,
              Colors.transparent,
            ],
            stops: const [0.0, 0.62, 1.0],
          ).createShader(rect),
          child: Image.asset(asset, width: width, height: height, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

class NeonTitle extends StatelessWidget {
  final String text;
  final TextAlign align;
  const NeonTitle(this.text, {super.key, this.align = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: align,
        style: AppText.sectionTitle.copyWith(shadows: const [
          Shadow(color: Color(0x66FFFFFF), blurRadius: 12),
        ]));
  }
}

class TargetDot extends StatelessWidget {
  final Color color;
  final double size;
  const TargetDot({super.key, required this.color, this.size = 60});

  @override
  Widget build(BuildContext context) {
    final double innerSize = size * 0.1875;
    final double midSize = size * 0.50;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withValues(alpha: 0.10),
                width: 1,
              ),
            ),
          ),
          Container(
            width: midSize,
            height: midSize,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.20),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: innerSize,
            height: innerSize,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.8),
                  blurRadius: 8,
                  spreadRadius: 1.5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
