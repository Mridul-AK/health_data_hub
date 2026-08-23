import 'package:flutter/material.dart';

import '../models/health_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/speedometer_gauge.dart';

class MetricDetailScreen extends StatelessWidget {
  const MetricDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final m = HealthData.mentzer;
    final accent = m.accent.color;
    return Scaffold(
      body: GlowBackground(
        glow: m.accent.glow,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
            AppHeader(title: m.name),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(TextSpan(children: [
                    TextSpan(
                        text: m.value.toStringAsFixed(1),
                        style: const TextStyle(
                            fontFamily: AppText.display,
                            fontSize: 26,
                            color: AppColors.textPrimary)),
                    TextSpan(
                        text: '  ${m.unit}',
                        style: const TextStyle(
                            fontSize: 15, color: AppColors.textSecondary)),
                  ])),
                  const SizedBox(height: 4),
                  Text(m.status, style: AppText.bodyFaint),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Center(child: SpeedometerGauge(fraction: m.value / 100, width: 320)),
            const SizedBox(height: 10),
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: accent),
                ),
                child: Text.rich(TextSpan(children: [
                  const TextSpan(
                      text: 'Moderate ',
                      style: TextStyle(color: AppColors.textPrimary, fontSize: 13)),
                  TextSpan(
                      text: m.value.toStringAsFixed(1),
                      style: TextStyle(
                          fontFamily: AppText.display,
                          fontSize: 15,
                          color: accent)),
                ])),
              ),
            ),
            const SizedBox(height: 26),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Text('RANGES',
                  style: AppText.sectionTitle.copyWith(fontSize: 20)),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: _RangesGrid(ranges: m.ranges),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                  'Parameters that are generally impacted by LDL Cholesterol:',
                  style: AppText.bodyFaint.copyWith(fontSize: 13)),
            ),
            const SizedBox(height: 12),
            ...m.parameters.map((p) => _ParamAccordion(param: p, accent: accent)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(m.aboutTitle,
                      style: AppText.sectionTitle.copyWith(fontSize: 16)),
                  const SizedBox(height: 10),
                  Text(m.aboutBody, style: AppText.body),
                ],
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

class _RangesGrid extends StatelessWidget {
  final List<RangeRow> ranges;
  const _RangesGrid({required this.ranges});

  @override
  Widget build(BuildContext context) {
    // Column-major: left column = first half, right column = second half.
    final half = (ranges.length / 2).ceil();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              for (int i = 0; i < half; i++)
                Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: _cell(ranges[i])),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              for (int i = half; i < ranges.length; i++)
                Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: _cell(ranges[i])),
            ],
          ),
        ),
      ],
    );
  }

  Widget _cell(RangeRow r) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: r.color,
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                  color: r.color.withValues(alpha: 0.6),
                  blurRadius: 12,
                  spreadRadius: -2),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(r.value,
                  style: const TextStyle(
                      fontSize: 14.5, color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text(r.label, style: AppText.chipLabel),
            ],
          ),
        ),
      ],
    );
  }
}

class _ParamAccordion extends StatefulWidget {
  final MetricParameter param;
  final Color accent;
  const _ParamAccordion({required this.param, required this.accent});

  @override
  State<_ParamAccordion> createState() => _ParamAccordionState();
}

class _ParamAccordionState extends State<_ParamAccordion> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(22, 0, 22, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0C100E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: widget.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(Icons.verified_outlined,
                    color: widget.accent, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.param.title,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                    if (_open) ...[
                      const SizedBox(height: 6),
                      Text(widget.param.body, style: AppText.bodyFaint),
                    ] else ...[
                      const SizedBox(height: 4),
                      Text(widget.param.body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.bodyFaint),
                    ],
                  ],
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _open = !_open),
                icon: Icon(_open ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
