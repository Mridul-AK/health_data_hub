import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/health_data.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/callout_bubble.dart';
import '../widgets/cards.dart';
import '../widgets/common.dart';
import '../widgets/health_line_chart.dart';
import '../widgets/organ_metrics_panel.dart';
import '../widgets/radial_gauge.dart';
import 'organ_detail_screen.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  void _openPanel(BuildContext context) {
    showOrganMetrics(
      context,
      onSelect: (o) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => OrganDetailScreen(organ: o)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      body: GlowBackground(
        glow: AppColors.green.withValues(alpha: 0.10),
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
            AppHeader(
                title: 'Phenotype',
                showBack: false,
                onRobotTap: () => _openPanel(context)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: SegmentedToggle(
                options: const ['Genotype', 'Phenotype'],
                selected: state.tab == OverviewTab.genotype ? 0 : 1,
                onChanged: (i) {
                  context.read<AppState>().tab =
                      i == 0 ? OverviewTab.genotype : OverviewTab.phenotype;
                  if (i == 0) _openPanel(context);
                },
              ),
            ),
            const SizedBox(height: 26),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: NeonTitle('Health Conditions Overview'),
            ),
            const SizedBox(height: 8),
            _BodyHero(onDetails: () => _openPanel(context)),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SegmentedToggle(
                options: const ['Dopamine', 'Serotonin'],
                selected: state.neuro == NeuroToggle.dopamine ? 0 : 1,
                solidSelected: true,
                onChanged: (i) => context.read<AppState>().neuro =
                    i == 0 ? NeuroToggle.dopamine : NeuroToggle.serotonin,
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: _DopamineChartCard(),
            ),
            const SizedBox(height: 18),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: _AboutDnaRow(),
            ),
            const SizedBox(height: 26),
            const NeonTitle('Immune system strength'),
            const SizedBox(height: 18),
            const Center(
                child: RadialGauge(value: 30, accent: AppColors.red, size: 230)),
            const SizedBox(height: 26),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: RecommendationCard(
                accent: AccentTheme.cyan,
                title: 'Immune System Recommendation:',
                body:
                    'Maintaining a strong immune system is essential for overall health and protection against illness. We recommend:',
                bullets: [
                  'Eating a balanced diet rich in fruits, vegetables, and proteins.',
                  'Staying hydrated and getting enough sleep (7–8 hours).',
                  'Regular exercise to boost immunity and reduce stress.',
                ],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MiniHeading('Strengths :'),
                    ValueChipGrid(values: HealthData.strengths, positive: true),
                    MiniHeading('Weakness :'),
                    ValueChipGrid(values: HealthData.strengths, positive: false),
                  ],
                ),
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

class _BodyHero extends StatelessWidget {
  final VoidCallback onDetails;
  const _BodyHero({required this.onDetails});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 300,
            child: Image.asset(
              'assets/images/stand.png',
              width: 400,
              height: 250,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 0,
            bottom: 60,
            child: Image.asset(
              'assets/images/body.png',
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            //top: 0,
            bottom: 20,
            child: Image.asset(
              'assets/images/shadow.png',
              width: 200,
              height: 150,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 51,
            right: 154,
            child: _targetDot(AppColors.green),
          ),
          Positioned(
            top: 76,
            left: 148,
            child: _targetDot(AppColors.red),
          ),
          Positioned(
            top: 286,
            left: 150,
            child: _targetDot(AppColors.red),
          ),
          Positioned(
            top: 10,
            right: 12,
            child: CalloutBubble(HealthData.bodyCallouts[0], maxWidth: 170),
          ),
          Positioned(
            top: 80,
            left: 12,
            child: CalloutBubble(HealthData.bodyCallouts[1], maxWidth: 145),
          ),
          Positioned(
            top: 295,
            left: 60,
            child: CalloutBubble(HealthData.bodyCallouts[2], maxWidth: 140),
          ),
        ],
      ),
    );
  }

  Widget _targetDot(Color color) {
    return TargetDot(color: color, size: 60);
  }
}

class _DopamineChartCard extends StatelessWidget {
  const _DopamineChartCard();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isDopamine = state.neuro == NeuroToggle.dopamine;
    final title = isDopamine
        ? 'Dopamine Levels During Physical Activity'
        : 'Serotonin Levels During Physical Activity';
    final points = isDopamine ? HealthData.dopamine : HealthData.serotonin;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 16, 16, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF080C0A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(
                  fontFamily: AppText.display,
                  fontSize: 13,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 14),
          Row(
            children: [
              const RotatedBox(
                quarterTurns: 3,
                child: Text('Meditation Stats',
                    style: TextStyle(
                        fontFamily: AppText.display,
                        fontSize: 11,
                        color: AppColors.textSecondary)),
              ),
              Expanded(
                  child: HealthLineChart(points: points)),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 14,
            runSpacing: 4,
            alignment: WrapAlignment.center,
            children: const [
              _LegendDot(AppColors.green, 'Warm Up Phase'),
              _LegendDot(AppColors.gold, 'Peak Activity'),
              _LegendDot(AppColors.red, 'Recovery Phase'),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot(this.color, this.label);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(label, style: AppText.mono10),
      ],
    );
  }
}

class _AboutDnaRow extends StatelessWidget {
  const _AboutDnaRow();
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DnaScoreCard(),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ABOUT Hyperprolactinemia',
                  style: AppText.sectionTitle.copyWith(fontSize: 14)),
              const SizedBox(height: 10),
              Text(
                'This condition is characterized by abnormally high levels of prolactin in the blood, which can result from various factors, including dopamine dysfunction, certain medications, or tumors of the pituitary gland (prolactinomas).',
                style: AppText.body.copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
