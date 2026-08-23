import 'package:flutter/material.dart';

import '../models/health_data.dart';
import '../theme/app_theme.dart';
import '../widgets/callout_bubble.dart';
import '../widgets/cards.dart';
import '../widgets/common.dart';
import '../widgets/organ_metrics_panel.dart';
import '../widgets/radial_gauge.dart';
import 'metric_detail_screen.dart';

class OrganDetailScreen extends StatelessWidget {
  final Organ organ;
  const OrganDetailScreen({super.key, required this.organ});

  bool get _isAttack => organ.id == 'heart_attack';

  void _openPanel(BuildContext context) {
    showOrganMetrics(
      context,
      selectedId: organ.id,
      onSelect: (o) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => OrganDetailScreen(organ: o)),
      ),
    );
  }

  void _onCalloutTap(BuildContext context) {
    if (organ.id == 'heart') {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => OrganDetailScreen(organ: HealthData.heartAttack)));
    } else {
      _openPanel(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = organ.accent;
    return Scaffold(
      body: GlowBackground(
        glow: accent.glow,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
            AppHeader(onRobotTap: () => _openPanel(context)),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: NeonTitle(organ.conditionTitle),
            ),
            _OrganHero(organ: organ, onCalloutTap: () => _onCalloutTap(context)),
            const SizedBox(height: 8),
            NeonTitle(organ.gaugeLabel),
            const SizedBox(height: 18),
            Center(
                child: RadialGauge(
                    value: organ.score.toDouble(),
                    accent: accent.color,
                    size: 250)),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: RecommendationCard(
                accent: accent,
                title: organ.recommendationTitle,
                body: organ.recommendationBody,
                bullets: organ.recommendationBullets,
                numbered: _isAttack,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!_isAttack) ...[
                      const MiniHeading('Strengths :'),
                      ValueChipGrid(
                          values: HealthData.strengths, positive: true),
                    ],
                    const MiniHeading('Weakness :'),
                    ValueChipGrid(
                        values: HealthData.strengths, positive: false),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(organ.riskTitle,
                  style: AppText.sectionTitle.copyWith(fontSize: 16)),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: organ.risks
                    .map((m) => RiskRow(
                          metric: m,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const MetricDetailScreen()),
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      ),
    );
  }
}

class _OrganHero extends StatelessWidget {
  final Organ organ;
  final VoidCallback onCalloutTap;
  const _OrganHero({required this.organ, required this.onCalloutTap});

  @override
  Widget build(BuildContext context) {
    final lungs = organ.id == 'lungs';
    return SizedBox(
      height: 430,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (!lungs)
            Positioned(
              bottom: 20,
              child: Image.asset('assets/images/platform_heart.png',
                  width: 320, fit: BoxFit.contain),
            ),
          Align(
            alignment: lungs ? Alignment.center : const Alignment(0, -0.42),
            child: lungs
                ? const VignetteImage(
                    asset: 'assets/images/lungs_hero.png',
                    height: 380,
                    widthFactor: 0.60,
                  )
                : Image.asset(organ.heroAsset, height: 230, fit: BoxFit.contain),
          ),
          // Callouts
          for (final c in organ.callouts) _positioned(c),
        ],
      ),
    );
  }

  Widget _positioned(Callout c) {
    final bubble = c.link
        ? GestureDetector(onTap: onCalloutTap, child: CalloutBubble(c, maxWidth: 170))
        : CalloutBubble(c, maxWidth: 150);
    if (c.align == Alignment.topRight) {
      return Positioned(top: 40, right: 12, child: bubble);
    } else if (c.align == Alignment.topLeft) {
      return Positioned(top: 34, left: 10, child: bubble);
    } else if (c.align == Alignment.bottomLeft) {
      return Positioned(bottom: 140, left: 8, child: bubble);
    } else {
      return Positioned(top: 130, left: 8, child: bubble);
    }
  }
}
