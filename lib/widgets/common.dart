import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// iOS-style status bar (9:41 + notch + signal/wifi/battery) to match the Figma.
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
          // Dynamic island / notch.
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

/// Back arrow + centered title + the little "anatomy robot" glyph on the right.
class AppHeader extends StatelessWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onRobotTap;
  const AppHeader(
      {super.key,
      this.title = 'Phenotype',
      this.showBack = true,
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

    // 1. Draw brackets (scanning frame)
    final bracketLen = h * 0.25;
    // Left bracket
    canvas.drawPath(
      Path()
        ..moveTo(bracketLen, 0)
        ..lineTo(0, 0)
        ..lineTo(0, h)
        ..lineTo(bracketLen, h),
      paint,
    );
    // Right bracket
    canvas.drawPath(
      Path()
        ..moveTo(w - bracketLen, 0)
        ..lineTo(w, 0)
        ..lineTo(w, h)
        ..lineTo(w - bracketLen, h),
      paint,
    );

    // 2. Draw anatomy wireframe (inside the brackets)
    final cx = w / 2;
    // Head (circle)
    final headRadius = h * 0.12;
    final headY = h * 0.20;
    canvas.drawCircle(Offset(cx, headY), headRadius, paint);

    // Spine
    final spineTop = headY + headRadius;
    final spineBottom = h * 0.70;
    canvas.drawLine(Offset(cx, spineTop), Offset(cx, spineBottom), paint);

    // Shoulders
    final shoulderY = headY + headRadius + 3;
    final shoulderWidth = w * 0.22;
    canvas.drawLine(Offset(cx - shoulderWidth, shoulderY),
        Offset(cx + shoulderWidth, shoulderY), paint);

    // Ribs (horizontal lines across spine)
    canvas.drawLine(Offset(cx - shoulderWidth * 0.8, shoulderY + 4),
        Offset(cx + shoulderWidth * 0.8, shoulderY + 4), paint);
    canvas.drawLine(Offset(cx - shoulderWidth * 0.6, shoulderY + 8),
        Offset(cx + shoulderWidth * 0.6, shoulderY + 8), paint);

    // Hips
    final hipWidth = w * 0.18;
    canvas.drawLine(Offset(cx - hipWidth, spineBottom),
        Offset(cx + hipWidth, spineBottom), paint);

    // Legs
    canvas.drawLine(Offset(cx - hipWidth, spineBottom), Offset(cx - hipWidth, h * 0.90), paint);
    canvas.drawLine(Offset(cx + hipWidth, spineBottom), Offset(cx + hipWidth, h * 0.90), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Radial glow behind the hero art, tinted by the active accent.
class GlowBackground extends StatelessWidget {
  final Color glow;
  final Widget child;
  const GlowBackground({super.key, required this.glow, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -0.55),
          radius: 1.0,
          colors: [glow, AppColors.bg],
          stops: const [0.0, 0.75],
        ),
      ),
      child: child,
    );
  }
}

/// Pill segmented control (Genotype/Phenotype, Dopamine/Serotonin).
class SegmentedToggle extends StatelessWidget {
  final List<String> options;
  final int selected;
  final ValueChanged<int> onChanged;
  final Color accent;
  final bool solidSelected; // solid green pill vs subtle grey pill

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
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFF10160F),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: List.generate(options.length, (i) {
          final bool on = i == selected;
          final Color pill = solidSelected
              ? (on ? accent : Colors.transparent)
              : (on ? const Color(0xFF2B322E) : Colors.transparent);
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: pill,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: (on && solidSelected)
                      ? [
                          BoxShadow(
                              color: accent.withValues(alpha: 0.5),
                              blurRadius: 18,
                              spreadRadius: -2),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  options[i],
                  style: TextStyle(
                    fontFamily: AppText.display,
                    fontSize: 13,
                    color: on
                        ? (solidSelected ? Colors.black : AppColors.textPrimary)
                        : AppColors.textFaint,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Image whose edges fade to transparent, so cropped hero art (with a baked
/// background) blends into the screen instead of showing a hard rectangle.
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

/// A soft neon section title used across screens.
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
