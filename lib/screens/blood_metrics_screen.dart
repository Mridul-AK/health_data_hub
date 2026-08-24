import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/organ_metrics_panel.dart';
import 'organ_detail_screen.dart';

class BloodMetricsScreen extends StatefulWidget {
  final int initialTab;
  const BloodMetricsScreen({super.key, this.initialTab = 0});

  @override
  State<BloodMetricsScreen> createState() => _BloodMetricsScreenState();
}

class _BloodMetricsScreenState extends State<BloodMetricsScreen> {
  late int _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  void _openPanel(BuildContext context) {
    showOrganMetrics(
      context,
      selectedId: 'blood',
      onSelect: (o) => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => OrganDetailScreen(organ: o)),
        (route) => route.isFirst,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isGenotype = _selectedTab == 0;
    return Scaffold(
      body: _BloodGlowBackground(
        isGenotype: isGenotype,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              AppHeader(
                title: isGenotype ? 'Genotype' : 'Phenotype',
                showBack: true,
                onRobotTap: () => _openPanel(context),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: SegmentedToggle(
                  options: const ['Genotype', 'Phenotype'],
                  selected: _selectedTab,
                  onChanged: (i) {
                    setState(() => _selectedTab = i);
                  },
                ),
              ),
              const SizedBox(height: 14),
              if (isGenotype) ...[
                const _GenotypeHero(),
                Transform.translate(
                  offset: const Offset(0, -25),
                  child: Column(
                    children: [
                      const Center(
                        child: Column(
                          children: [
                            Text(
                              'SLC6A4',
                              style: TextStyle(
                                fontFamily: AppText.display,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Genotype Score',
                              style: TextStyle(
                                fontFamily: AppText.display,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -22),
                        child: const Center(
                          child: _GenotypeGauge66(),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -79),
                        child: const _BottomYellowHorizonArc(),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -55),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: _GenotypeDetailsSection(),
                        ),
                      ),
                      const SizedBox(height: 0),
                    ],
                  ),
                ),
              ] else ...[
                const _BloodHero(),
                Transform.translate(
                  offset: const Offset(0, -30),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                        Expanded(
                          child: _BloodSugarCard(),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: _BloodPressureCard(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: NeonTitle('Overall Blood Quality'),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: _OverallBloodQualityGauge(value: 73),
                ),
                Transform.translate(
                  offset: const Offset(0, -35),
                  child: const _BottomGreenHorizonArc(),
                ),
                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        child: Text(
                          'RANGES',
                          style: TextStyle(
                            fontFamily: AppText.display,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      SizedBox(height: 18),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        child: _BloodRangesGrid(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: _BloodHealthOverviewTable(),
                ),
                const SizedBox(height: 32),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: _BloodRecommendationsCard(),
                ),
                const SizedBox(height: 40),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BloodGlowBackground extends StatelessWidget {
  final bool isGenotype;
  final Widget child;
  const _BloodGlowBackground({required this.child, this.isGenotype = false});

  @override
  Widget build(BuildContext context) {
    final topColor = isGenotype ? const Color(0xFF0F472A) : const Color(0xFF0D4466);
    final midColor = isGenotype ? const Color(0xFF082B1B) : const Color(0xFF082033);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF040A10),
        gradient: RadialGradient(
          center: const Alignment(0, -0.82),
          radius: 1.15,
          colors: [
            topColor,
            midColor,
            const Color(0xFF040A10),
          ],
          stops: const [0.0, 0.50, 0.90],
        ),
      ),
      child: child,
    );
  }
}

class _GenotypeHero extends StatelessWidget {
  const _GenotypeHero();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 475,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Gene-to-Health Overview',
                  style: TextStyle(
                    fontFamily: AppText.display,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
              ],
            ),
          ),

          Positioned(
            bottom: 10,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF22C55E).withValues(alpha: 0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -12,
            child: Image.asset(
              'assets/images/stand.png',
              width: 350,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 30,
            child: Image.asset(
              'assets/images/layer.png',
              width: 270,
              height: 330,
              fit: BoxFit.contain,
            ),
          ),

          Positioned(
            top: 120,
            left: 120,
            child: const TargetDot(color: Color(0xFF22C55E), size: 44),
          ),
          Positioned(
            top: 175,
            left: 125,
            child: const TargetDot(color: Colors.white, size: 44),
          ),
          Positioned(
            top: 235,
            left: 115,
            child: const TargetDot(color: Color(0xFF22C55E), size: 44),
          ),
          Positioned(
            top: 215,
            right: 125,
            child: const TargetDot(color: Color(0xFF22C55E), size: 48),
          ),

          Positioned(
            top: 85,
            left: 14,
            child: const _GenePillBadge(
              title: 'DRD4',
              subtitle: '(Dopamine\nReceptor D4)',
            ),
          ),

          Positioned(
            top: 165,
            left: 14,
            child: const CustomCalloutBubble(
              title: 'Blood Oxygen\nSaturation (SpO2)',
              value: '98%',
              maxWidth: 140,
            ),
          ),

          Positioned(
            top: 240,
            left: 14,
            child: const _GenePillBadge(
              title: 'COMT',
              subtitle: '(Catechol-O-\nMethyltransferase)',
            ),
          ),

          Positioned(
            top: 195,
            right: 14,
            child: const _GenePillBadge(
              title: 'SLC6A4',
              subtitle: '(Serotonin\nTransporter Gene)',
            ),
          ),

          Positioned(
            top: 75,
            right: 75,
            child: const _SmallGeneTag('OXTR'),
          ),
          Positioned(
            top: 310,
            left: 110,
            child: const _SmallGeneTag('OXTR'),
          ),
        ],
      ),
    );
  }
}

class _GenePillBadge extends StatelessWidget {
  final String title;
  final String subtitle;
  const _GenePillBadge({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xE60A1D2B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1B4E6B), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0C3147).withValues(alpha: 0.4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppText.display,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 9.5,
              color: Color(0xFF94A3B8),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallGeneTag extends StatelessWidget {
  final String label;
  const _SmallGeneTag(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xCC092638),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF164461), width: 0.8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 8.5,
          fontWeight: FontWeight.bold,
          color: Color(0xFF7DD3FC),
        ),
      ),
    );
  }
}

class _GenotypeGauge66 extends StatelessWidget {
  const _GenotypeGauge66();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/gauge_66.png',
      width: 290,
      height: 290,
      fit: BoxFit.contain,
    );
  }
}

class _BottomYellowHorizonArc extends StatelessWidget {
  const _BottomYellowHorizonArc();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      width: double.infinity,
      child: CustomPaint(
        painter: _HorizonArcPainter(),
      ),
    );
  }
}

class _HorizonArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();

    path.moveTo(w * 0.1, h);
    path.quadraticBezierTo(w * 0.5, -h * 0.4, w * 0.9, h);

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.0
        ..color = const Color(0xFFFBD009).withValues(alpha: 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..color = const Color(0xFFFBD009),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BottomGreenHorizonArc extends StatelessWidget {
  const _BottomGreenHorizonArc();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      width: double.infinity,
      child: CustomPaint(
        painter: _GreenHorizonArcPainter(),
      ),
    );
  }
}

class _GreenHorizonArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();

    path.moveTo(w * 0.1, h);
    path.quadraticBezierTo(w * 0.5, -h * 0.4, w * 0.9, h);

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.0
        ..color = const Color(0xFF22C55E).withValues(alpha: 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..color = const Color(0xFF22C55E),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GenotypeDetailsSection extends StatelessWidget {
  const _GenotypeDetailsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF1B4368), width: 1.2),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF0C243B),
                Color(0xFF071726),
                Color(0xFF040A12),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'SLC6A4\n(Serotonin Transporter Gene)',
                style: TextStyle(
                  fontFamily: AppText.display,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.25,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Genotype Score - 66%',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFBD009),
                ),
              ),
              SizedBox(height: 14),
              Text(
                'Your SLC6A4 genotype score of 66% indicates a moderate efficiency in serotonin transport. This gene plays a key role in regulating serotonin levels in the brain, influencing mood, emotional balance, and how you respond to stress.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF94A3B8),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'A moderate score suggests that while your serotonin system is functional, you may experience mild sensitivity to stress or fluctuating moods under challenging circumstances. Supporting your mental wellness through stress management techniques, mindfulness, and a balanced lifestyle can help optimize your serotonin function.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF94A3B8),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'ABOUT SLC6A4 Serotonin Transporter Gene',
              style: TextStyle(
                fontFamily: AppText.display,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'SLC6A4 is a gene that encodes the serotonin transporter protein. This protein helps transport serotonin from the synaptic cleft back into the presynaptic neuron, regulating serotonin levels in the brain. It plays an important role in mood regulation, emotional stability, stress response, and overall mental well-being.',
              style: TextStyle(
                fontSize: 12.5,
                color: Color(0xFF8EA1B4),
                height: 1.45,
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'SLC6A4 Organwise Score',
              style: TextStyle(
                fontFamily: AppText.display,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Strengths :',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3CC44B),
              ),
            ),
            SizedBox(height: 10),
            _OrganScoreGrid(
              color: Color(0xFF3CC44B),
              items: [
                _ScoreItem('78.89 %', 'heart'),
                _ScoreItem('68.57 %', 'kidney'),
                _ScoreItem('8.00 %', 'serum'),
                _ScoreItem('78.89 %', 'brain/alpha'),
                _ScoreItem('84.89 %', 'WBC Count'),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Weakness :',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF4A1C),
              ),
            ),
            SizedBox(height: 10),
            _OrganScoreGrid(
              color: Color(0xFFFF4A1C),
              items: [
                _ScoreItem('22.09 %', 'insulin'),
                _ScoreItem('14.09 %', 'bone'),
                _ScoreItem('28.09 %', 'eye'),
                _ScoreItem('22.09 %', 'WBC (Immune)'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _ScoreItem {
  final String score;
  final String label;
  const _ScoreItem(this.score, this.label);
}

class _OrganScoreGrid extends StatelessWidget {
  final Color color;
  final List<_ScoreItem> items;
  const _OrganScoreGrid({required this.color, required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((item) {
        return Container(
          width: 105,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.6), width: 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.score,
                style: TextStyle(
                  fontFamily: AppText.display,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.label,
                style: const TextStyle(
                  fontSize: 9.5,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _BloodHero extends StatelessWidget {
  const _BloodHero();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 30,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF1E88E5).withValues(alpha: 0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Image.asset(
              'assets/images/stand.png',
              width: 350,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 40,
            child: Image.asset(
              'assets/images/red_blood_cell.png',
              width: 300,
              height: 230,
              fit: BoxFit.contain,
            ),
          ),

          Positioned(
            top: 8,
            left: 132,
            child: Image.asset(
              'assets/images/imkgqtun.png',
              width: 62,
              height: 62,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 105,
            left: 90,
            child: Image.asset(
              'assets/images/imkgqtun.png',
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 110,
            right: 146,
            child: Image.asset(
              'assets/images/imkgqtun.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 172,
            right: 64,
            child: Image.asset(
              'assets/images/imkgqtun.png',
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 195,
            right: 18,
            child: Image.asset(
              'assets/images/imkgqtun.png',
              width: 48,
              height: 48,
              fit: BoxFit.contain,
            ),
          ),

          Positioned(
            top: 16,
            left: 10,
            child: CustomCalloutBubble(
              title: 'Red Blood Cell (RBC)\nCount',
              value: '4.8 million/µL',
              maxWidth: 140,
            ),
          ),
          Positioned(
            top: 45,
            left: 118,
            child: const TargetDot(color: Colors.white, size: 44),
          ),

          Positioned(
            top: 18,
            right: 10,
            child: CustomCalloutBubble(
              title: 'Blood Oxygen\nSaturation (SpO2)',
              value: '98%',
              maxWidth: 140,
            ),
          ),
          Positioned(
            top: 52,
            right: 122,
            child: const TargetDot(color: Colors.white, size: 44),
          ),

          Positioned(
            top: 165,
            left: 140,
            child: CustomCalloutBubble(
              title: 'White Blood Cell\n(WBC) Count',
              value: '6,500 /µL',
              maxWidth: 145,
            ),
          ),
          Positioned(
            top: 195,
            right: 112,
            child: const TargetDot(color: Colors.white, size: 44),
          ),
        ],
      ),
    );
  }
}

class CustomCalloutBubble extends StatelessWidget {
  final String title;
  final String value;
  final double maxWidth;

  const CustomCalloutBubble({
    super.key,
    required this.title,
    required this.value,
    this.maxWidth = 150,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xC21A1E0D),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 10.5,
                color: Color(0xFFC0C7C4),
                height: 1.25,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BloodSugarCard extends StatelessWidget {
  const _BloodSugarCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 205,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF8A631B), width: 1.2),
        gradient: const RadialGradient(
          center: Alignment(0.6, -0.6),
          radius: 1.2,
          colors: [
            Color(0xFF3D2A0E),
            Color(0xFF1B1309),
            Color(0xFF0C0905),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3D2A0E).withValues(alpha: 0.3),
            blurRadius: 16,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: const Color(0xFF33230C),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset('assets/images/blood_sugar.png', fit: BoxFit.contain),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Blood Sugar',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: '80 ',
                        style: TextStyle(
                          fontFamily: AppText.display,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const TextSpan(
                        text: 'mg / dL',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C1F0A),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF5E4314), width: 0.8),
                  ),
                  child: const Text(
                    'Normal',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFD99B26),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 85,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              child: CustomPaint(
                painter: _WavePainter(
                  color: const Color(0xFFF5A623),
                  isBloodSugar: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BloodPressureCard extends StatelessWidget {
  const _BloodPressureCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 205,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF124B54), width: 1.2),
        gradient: const RadialGradient(
          center: Alignment(0.6, -0.6),
          radius: 1.2,
          colors: [
            Color(0xFF0C3138),
            Color(0xFF07191C),
            Color(0xFF040C0E),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0C3138).withValues(alpha: 0.3),
            blurRadius: 16,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A2B31),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset('assets/images/blood_pressure.png', fit: BoxFit.contain),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Blood\nPressure',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: '102 ',
                        style: TextStyle(
                          fontFamily: AppText.display,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const TextSpan(
                        text: '/ 72 mmhg',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF09262C),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF104F5B), width: 0.8),
                  ),
                  child: const Text(
                    'Normal',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2BB0BF),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 85,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              child: CustomPaint(
                painter: _WavePainter(
                  color: const Color(0xFF3FD8E8),
                  isBloodSugar: false,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final Color color;
  final bool isBloodSugar;
  _WavePainter({required this.color, this.isBloodSugar = true});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();

    if (isBloodSugar) {
      path.moveTo(0, h * 0.72);
      path.cubicTo(w * 0.18, h * 0.65, w * 0.32, h * 0.78, w * 0.48, h * 0.62);
      path.cubicTo(w * 0.60, h * 0.48, w * 0.66, h * 0.10, w * 0.78, h * 0.22);
      path.cubicTo(w * 0.86, h * 0.32, w * 0.94, h * 0.50, w, h * 0.48);
    } else {
      path.moveTo(0, h * 0.70);
      path.cubicTo(w * 0.18, h * 0.55, w * 0.28, h * 0.28, w * 0.40, h * 0.38);
      path.cubicTo(w * 0.52, h * 0.48, w * 0.68, h * 0.15, w * 0.82, h * 0.22);
      path.cubicTo(w * 0.90, h * 0.28, w * 0.96, h * 0.52, w, h * 0.50);
    }

    final fillPath = Path.from(path)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withValues(alpha: 0.55),
          color.withValues(alpha: 0.25),
          color.withValues(alpha: 0.02),
        ],
        stops: const [0.0, 0.5, 1.0],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.isBloodSugar != isBloodSugar;
}

class _OverallBloodQualityGauge extends StatelessWidget {
  final double value;
  const _OverallBloodQualityGauge({required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 310,
      height: 310,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(310, 310),
            painter: _BloodGaugePainter(value: value),
          ),
          Text(
            '${value.toInt()}%',
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _BloodGaugePainter extends CustomPainter {
  final double value;
  _BloodGaugePainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width * 0.36;
    const startAngle = 0.75 * math.pi;
    const sweepAngle = 1.5 * math.pi;

    final tickRadius = outerRadius + 8;
    for (int i = 0; i < 120; i++) {
      final angle = (i * 2 * math.pi) / 120;
      final isMajor = i % 12 == 0;
      final len = isMajor ? 8.0 : 4.0;
      final p1 = center + Offset(math.cos(angle), math.sin(angle)) * tickRadius;
      final p2 = center + Offset(math.cos(angle), math.sin(angle)) * (tickRadius + len);

      final tickPaint = Paint()
        ..color = isMajor ? const Color(0xFF2A5580) : const Color(0xFF132B45)
        ..strokeWidth = isMajor ? 1.5 : 1.0;

      canvas.drawLine(p1, p2, tickPaint);
    }

    final labelRadius = outerRadius + 28;
    final textStyle = const TextStyle(
      color: Color(0xFFB0C4DE),
      fontSize: 11,
      fontFamily: AppText.display,
      fontWeight: FontWeight.bold,
    );

    for (int i = 0; i <= 10; i++) {
      final percent = i * 10;
      final angle = startAngle + (sweepAngle * (i / 10.0));
      final labelOffset = center + Offset(math.cos(angle), math.sin(angle)) * labelRadius;

      final tp = TextPainter(
        text: TextSpan(text: '$percent%', style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, labelOffset - Offset(tp.width / 2, tp.height / 2));
    }

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..color = const Color(0xFF0A1824);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius),
      startAngle,
      sweepAngle,
      false,
      trackPaint,
    );

    final progressSweep = sweepAngle * (value / 100.0);
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF4ADE80).withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius),
      startAngle,
      progressSweep,
      false,
      glowPaint,
    );

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..shader = const SweepGradient(
        colors: [Color(0xFF56F53D), Color(0xFF22C55E), Color(0xFF56F53D)],
        transform: GradientRotation(startAngle),
      ).createShader(Rect.fromCircle(center: center, radius: outerRadius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius),
      startAngle,
      progressSweep,
      false,
      progressPaint,
    );

    final tipAngle = startAngle + progressSweep;
    final knobCenter = center + Offset(math.cos(tipAngle), math.sin(tipAngle)) * outerRadius;

    canvas.drawCircle(
      knobCenter,
      13,
      Paint()
        ..color = const Color(0xFF15803D).withValues(alpha: 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    final knobPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.4),
        radius: 0.8,
        colors: const [
          Color(0xFF90FF66),
          Color(0xFF4ADE80),
          Color(0xFF15803D),
        ],
      ).createShader(Rect.fromCircle(center: knobCenter, radius: 12));

    canvas.drawCircle(knobCenter, 12, knobPaint);

    final innerRadius = outerRadius * 0.72;
    canvas.drawCircle(
      center,
      innerRadius,
      Paint()..color = const Color(0xFF041009),
    );

    final innerGlowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..color = const Color(0xFF22C55E).withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawCircle(center, innerRadius, innerGlowPaint);

    final innerRingPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..color = const Color(0xFF22C55E);

    canvas.drawCircle(center, innerRadius, innerRingPaint);

    const combStart = 1.25 * math.pi;
    const combSweep = 0.50 * math.pi;
    const combCount = 28;

    for (int i = 0; i < combCount; i++) {
      final a = combStart + (combSweep * (i / (combCount - 1)));
      final p1 = center + Offset(math.cos(a), math.sin(a)) * (innerRadius - 4);
      final p2 = center + Offset(math.cos(a), math.sin(a)) * (innerRadius - 14);

      final combPaint = Paint()
        ..color = const Color(0xFF4ADE80)
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(p1, p2, combPaint);
    }

    final cyanBeamCenter = center + Offset(0, innerRadius - 4);
    canvas.drawCircle(
      cyanBeamCenter,
      10,
      Paint()
        ..color = const Color(0xFF3FD8E8).withValues(alpha: 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
  }

  @override
  bool shouldRepaint(covariant _BloodGaugePainter oldDelegate) => oldDelegate.value != value;
}

class _BloodRangesGrid extends StatelessWidget {
  const _BloodRangesGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Expanded(
              child: _RangeItem(
                color: Color(0xFF3CC44B),
                title: 'High (80% – 100%)',
                description:
                    'You may naturally feel more motivated, focused, and reward-driven.',
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: _RangeItem(
                color: Color(0xFFFBD009),
                title: 'Moderate (50% – 79%)',
                description:
                    'You may benefit from lifestyle habits that help boost and stabilize dopamine levels.',
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        const _RangeItem(
          color: Color(0xFFFF4A1C),
          title: 'Low (Below 50%)',
          description:
              'You may be prone to low motivation or mood dips; consistent routines and dopamine-supportive habits can help maintain balance.',
        ),
      ],
    );
  }
}

class _RangeItem extends StatelessWidget {
  final Color color;
  final String title;
  final String description;

  const _RangeItem({
    required this.color,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.75),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF8EA1B4),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BloodHealthOverviewTable extends StatelessWidget {
  const _BloodHealthOverviewTable();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1B4368), width: 1.2),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0C243B),
            Color(0xFF071726),
            Color(0xFF040A12),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0C243B).withValues(alpha: 0.25),
            blurRadius: 20,
            spreadRadius: -4,
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Blood Health Overview',
            style: TextStyle(
              fontFamily: AppText.display,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'A detailed look at key blood metrics influencing your energy, immunity, and overall well-being.',
            style: TextStyle(
              fontSize: 11.5,
              color: Color(0xFF8BA5BD),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: const [
              Expanded(
                flex: 36,
                child: Text(
                  'METRICS',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontFamily: AppText.mono,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8BA5BD),
                  ),
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                flex: 22,
                child: Text(
                  'VALUES',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontFamily: AppText.mono,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8BA5BD),
                  ),
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                flex: 25,
                child: Text(
                  'HEALTHY RANGE',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontFamily: AppText.mono,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8BA5BD),
                  ),
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                flex: 18,
                child: Text(
                  'STATUS',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontFamily: AppText.mono,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8BA5BD),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: Color(0xFF1B4368), height: 1),

          _tableRow(
            name: 'Hemoglobin (Hb)',
            subtext:
                'Hemoglobin is a protein in red blood cells that carries oxygen throughout your body.',
            value: '14.5 g/dL',
            range: '13.5 - 17.5 g/dL',
            status: 'Optimal',
            statusColor: const Color(0xFF22C55E),
          ),
          _tableRow(
            name: 'Glucose (Fasting)',
            subtext:
                'Blood sugar levels affect metabolism and energy. Well-regulated glucose helps prevent fatigue.',
            value: '88 mg/dL',
            range: '70 - 99 mg/dL',
            status: 'Optimal',
            statusColor: const Color(0xFF22C55E),
          ),
          _tableRow(
            name: 'Platelet Count',
            subtext:
                'Platelets are essential for blood clotting and wound healing. Balanced levels prevent excessive bleeding or clotting issues.',
            value: '250,000/µL',
            range: '150,000-450,000/µL',
            status: 'Optimal',
            statusColor: const Color(0xFF22C55E),
          ),
          _tableRow(
            name: 'WBC Count',
            subtext:
                'WBCs are the body\'s defense system, fighting infections and inflammation. A strong count ensures a resilient immune response.',
            value: '5,500/µL',
            range: '4,500-11,000/µL',
            status: 'Moderate',
            statusColor: const Color(0xFFEAB308),
          ),
          _tableRow(
            name: 'LDL Cholesterol',
            subtext:
                '"Bad" cholesterol can build up in arteries, increasing heart disease risk. Maintaining healthy levels is key for cardiovascular health.',
            value: '50 mg/dL',
            range: '<100 mg/dL',
            status: 'Moderate',
            statusColor: const Color(0xFFEAB308),
          ),
          _tableRow(
            name: 'Triglycerides',
            subtext:
                'These fats store unused calories for energy. Normal levels indicate good heart and metabolic health.',
            value: '20 mg/dL',
            range: '<150 mg/dL',
            status: 'Low',
            statusColor: const Color(0xFFEF4444),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _tableRow({
    required String name,
    required String subtext,
    required String value,
    required String range,
    required String status,
    required Color statusColor,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 36,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtext,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF6B7F94),
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                flex: 22,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                flex: 25,
                child: Text(
                  range,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFFA2B4C7),
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                flex: 18,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: statusColor, width: 1.2),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(color: Color(0xFF162436), height: 1),
      ],
    );
  }
}

class _BloodRecommendationsCard extends StatelessWidget {
  const _BloodRecommendationsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1B4368), width: 1.2),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0C243B),
            Color(0xFF071726),
            Color(0xFF040A12),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Our Recommendations',
            style: TextStyle(
              fontFamily: AppText.display,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 140,
            height: 2.5,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3FD8E8), Color(0xFF1B4368)],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Oxygen & Circulation',
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('  •  ', style: TextStyle(color: Color(0xFFA2B4C7), fontSize: 13)),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Hemoglobin & RBC (Normal): ',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: 'Eat iron-rich foods like spinach and lean meats, and stay hydrated.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFA2B4C7),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Cardiovascular Health',
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('  •  ', style: TextStyle(color: Color(0xFFA2B4C7), fontSize: 13)),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'LDL Cholesterol (Slightly Elevated): ',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: 'Reduce fried foods, increase soluble fiber intake, and exercise regularly.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFA2B4C7),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
