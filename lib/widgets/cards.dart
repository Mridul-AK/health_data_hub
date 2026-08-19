import 'package:flutter/material.dart';
import '../models/health_data.dart';
import '../theme/app_theme.dart';

/// Section heading like "Strengths :" / "Weakness :".
class MiniHeading extends StatelessWidget {
  final String text;
  const MiniHeading(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 10),
        child: Text(text, style: AppText.sectionTitle.copyWith(fontSize: 16)),
      );
}

/// 3x2 grid of small value chips (green for strengths, red for weakness).
class ValueChipGrid extends StatelessWidget {
  final List<String> values;
  final bool positive;
  const ValueChipGrid({super.key, required this.values, required this.positive});

  @override
  Widget build(BuildContext context) {
    final c = positive ? AppColors.green : AppColors.red;
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.3,
      children: values
          .map((v) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: c.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: c.withValues(alpha: 0.65)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(v,
                        style: TextStyle(
                            fontFamily: AppText.display,
                            fontSize: 12,
                            color: c)),
                    const SizedBox(height: 2),
                    const Text('HCV Antibody', style: AppText.chipLabel),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

/// The glowing recommendation card.
class RecommendationCard extends StatelessWidget {
  final String title;
  final String body;
  final List<String> bullets;
  final AccentTheme accent;
  final bool numbered;
  const RecommendationCard({
    super.key,
    required this.title,
    required this.body,
    required this.bullets,
    required this.accent,
    this.numbered = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = accent.color;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.glow,
            const Color(0xFF05100C),
          ],
        ),
        border: Border.all(color: c.withValues(alpha: 0.55), width: 1.2),
        boxShadow: [
          BoxShadow(
              color: c.withValues(alpha: 0.18),
              blurRadius: 22,
              spreadRadius: -6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppText.cardTitle.copyWith(
                  fontSize: numbered ? 15 : 16, height: 1.4)),
          if (body.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(body, style: AppText.body),
          ],
          const SizedBox(height: 10),
          ...List.generate(bullets.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                    child: Text(numbered ? '${i + 1}.' : '•',
                        style: AppText.body.copyWith(color: c)),
                  ),
                  Expanded(child: Text(bullets[i], style: AppText.body)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// A single "Chronic ... Risk Assessment" row.
class RiskRow extends StatelessWidget {
  final RiskMetric metric;
  final VoidCallback onTap;
  const RiskRow({super.key, required this.metric, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = metric.accent.color;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(colors: [
            c.withValues(alpha: 0.14),
            const Color(0xFF090C0B),
          ]),
          border: Border.all(color: c.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: c.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.verified_outlined, color: c, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(metric.name,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 3),
                  Text(metric.subtitle, style: AppText.bodyFaint),
                ],
              ),
            ),
            Text(
              metric.value.toStringAsFixed(1),
              style: TextStyle(
                  fontFamily: AppText.display,
                  fontSize: 26,
                  color: c,
                  shadows: [Shadow(color: c.withValues(alpha: .7), blurRadius: 14)]),
            ),
          ],
        ),
      ),
    );
  }
}

/// The DNA "score" card on the overview screen.
class DnaScoreCard extends StatelessWidget {
  const DnaScoreCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
        image: const DecorationImage(
          image: AssetImage('assets/images/dna.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: const AspectRatio(aspectRatio: 1.0, child: SizedBox()),
    );
  }
}
