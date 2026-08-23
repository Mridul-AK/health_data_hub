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
      onSelect: (o) => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => OrganDetailScreen(organ: o)),
        (route) => route.isFirst,
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
            Transform.translate(
              offset: const Offset(0, -30),
              child: NeonTitle(organ.gaugeLabel),
            ),
            Transform.translate(
              offset: const Offset(0, -50),
              child: Center(
                child: organ.score == 76
                    ? Image.asset(
                        'assets/images/gauge_76.png',
                        width: 270,
                        height: 270,
                        fit: BoxFit.contain,
                      )
                    : RadialGauge(
                        value: organ.score.toDouble(),
                        accent: accent.color,
                        size: 250,
                      ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -30),
              child: Padding(
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
                                builder: (_) => MetricDetailScreen(
                                      metric: HealthData.getMetricDetail(m),
                                    )),
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
    return SizedBox(
      height: 430,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 6,
            child: Image.asset('assets/images/stand.png', width: 340, fit: BoxFit.contain),
          ),
          Align(
            alignment: const Alignment(0, -0.42),
            child: Image.asset(organ.heroAsset, height: 230, fit: BoxFit.contain),
          ),
          for (final c in organ.callouts) _dotPositioned(c),
          for (final c in organ.callouts) _positioned(c),
        ],
      ),
    );
  }

  Widget _dotPositioned(Callout c) {
    final Color color = c.positive ? AppColors.green : const Color(0xFFFF5252);
    const double size = 48;
    final double half = size / 2;

    if (c.align == Alignment.topRight) {
      return Positioned(
        top: 80 - half,
        right: 168 - half,
        child: TargetDot(color: color, size: size),
      );
    } else if (c.align == Alignment.topLeft) {
      return Positioned(
        top: 90 - half,
        left: 168 - half,
        child: TargetDot(color: color, size: size),
      );
    } else if (c.align == Alignment.bottomLeft) {
      return Positioned(
        top: 245 - half,
        left: 168 - half,
        child: TargetDot(color: color, size: size),
      );
    } else {
      return Positioned(
        top: 175 - half,
        left: 168 - half,
        child: TargetDot(color: color, size: size),
      );
    }
  }

  Widget _positioned(Callout c) {
    final bubble = CalloutBubble(c, maxWidth: 150);
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
