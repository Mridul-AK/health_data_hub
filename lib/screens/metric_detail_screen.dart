import 'package:flutter/material.dart';

import '../models/health_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/speedometer_gauge.dart';

class MetricDetailScreen extends StatelessWidget {
  final MetricDetail? metric;
  const MetricDetailScreen({super.key, this.metric});

  @override
  Widget build(BuildContext context) {
    final m = metric ?? HealthData.mentzer;
    final statusCapitalized = m.status.isNotEmpty
        ? '${m.status[0].toUpperCase()}${m.status.substring(1)}'
        : 'Moderate';

    return Scaffold(
      body: GlowBackground(
        glow: m.accent.glow,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              AppHeader(title: m.name, showRobot: false),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: m.value.toStringAsFixed(1),
                            style: const TextStyle(
                              fontFamily: AppText.display,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          TextSpan(
                            text: ' ${m.unit}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      m.status,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF8A8D8B),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Center(child: SpeedometerGauge(fraction: (m.value / 100).clamp(0.0, 1.0), width: 310)),
              const SizedBox(height: 14),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F0D0A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: m.accent.color, width: 1.2),
                  ),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '$statusCapitalized ',
                          style: TextStyle(
                            color: m.accent.color,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: m.value.toStringAsFixed(1),
                          style: TextStyle(
                            fontFamily: AppText.display,
                            fontSize: 15.5,
                            fontWeight: FontWeight.bold,
                            color: m.accent.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Text(
                  'RANGES',
                  style: const TextStyle(
                    fontFamily: AppText.display,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: _RangesGrid(ranges: m.ranges),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Text(
                  'Parameters that are generally impacted by LDL Cholesterol:',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8A8D8B),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              ...m.parameters.map((p) => _ParamAccordion(param: p)),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m.aboutTitle,
                      style: const TextStyle(
                        fontFamily: AppText.display,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      m.aboutBody,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF8A8D8B),
                        height: 1.45,
                      ),
                    ),
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
    final half = (ranges.length / 2).ceil();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              for (int i = 0; i < half; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _cell(ranges[i]),
                ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              for (int i = half; i < ranges.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _cell(ranges[i]),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _cell(RangeRow r) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: r.color,
            borderRadius: BorderRadius.circular(9),
            boxShadow: [
              BoxShadow(
                color: r.color.withValues(alpha: 0.45),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                r.value,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                r.label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF8A8D8B),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ParamAccordion extends StatefulWidget {
  final MetricParameter param;
  const _ParamAccordion({required this.param});

  @override
  State<_ParamAccordion> createState() => _ParamAccordionState();
}

class _ParamAccordionState extends State<_ParamAccordion> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(22, 0, 22, 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF131614),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1F2321)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF211D12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.stars_rounded,
                  color: Color(0xFFEAB308),
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.param.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.param.body,
                      maxLines: _open ? null : 2,
                      overflow: _open ? TextOverflow.visible : TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF8A8D8B),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() => _open = !_open),
                child: Icon(
                  _open ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: const Color(0xFF8A8D8B),
                  size: 26,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
