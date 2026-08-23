import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Organ {
  final String id;
  final String name;
  final String asset;
  final AccentTheme accent;
  final String conditionTitle;
  final String gaugeLabel;
  final int score;
  final String heroAsset;
  final List<Callout> callouts;
  final String recommendationTitle;
  final String recommendationBody;
  final List<String> recommendationBullets;
  final String riskTitle;
  final List<RiskMetric> risks;

  const Organ({
    required this.id,
    required this.name,
    required this.asset,
    required this.accent,
    required this.conditionTitle,
    required this.gaugeLabel,
    required this.score,
    required this.heroAsset,
    required this.callouts,
    required this.recommendationTitle,
    required this.recommendationBody,
    required this.recommendationBullets,
    required this.riskTitle,
    required this.risks,
  });
}

class Callout {
  final String text;
  final bool positive;
  final bool link;
  final Alignment align;

  const Callout(
    this.text, {
    this.positive = true,
    this.link = false,
    this.align = Alignment.centerLeft,
  });
}

class RiskMetric {
  final String name;
  final String subtitle;
  final double value;
  final AccentTheme accent;

  const RiskMetric(this.name, this.subtitle, this.value, this.accent);
}

class RangeRow {
  final Color color;
  final String value;
  final String label;
  const RangeRow(this.color, this.value, this.label);
}

class MetricParameter {
  final String title;
  final String body;
  const MetricParameter(this.title, this.body);
}

class MetricDetail {
  final String name;
  final String unit;
  final String status;
  final double value;
  final String badgeLabel;
  final AccentTheme accent;
  final List<RangeRow> ranges;
  final String aboutTitle;
  final String aboutBody;
  final List<MetricParameter> parameters;

  const MetricDetail({
    required this.name,
    required this.unit,
    required this.status,
    required this.value,
    required this.badgeLabel,
    required this.accent,
    required this.ranges,
    required this.aboutTitle,
    required this.aboutBody,
    required this.parameters,
  });
}

class HealthData {
  HealthData._();

  static const List<RiskMetric> _heartRisks = [
    RiskMetric('Mentzer', '12.3 - 15.5 secs', 16.7, AccentTheme.gold),
    RiskMetric('HCV AntiBody', '< 0.389', 56.6, AccentTheme.green),
    RiskMetric('Apolipoprotine A1', '12.3 - 15.5 secs', 14.9, AccentTheme.red),
    RiskMetric('Prothorombine Time', '12.3 - 15.5 secs', 6.2, AccentTheme.gold),
    RiskMetric('HCV AntiBody', '< 0.389', 26.0, AccentTheme.green),
    RiskMetric('Immunoglobulim E2', '< 152.9 KUI/L', 6.9, AccentTheme.red),
  ];

  static const List<String> _heartBullets = [
    'Eating a heart-friendly diet rich in fruits, vegetables, whole grains, and lean proteins.',
    'Reducing salt, sugar, and unhealthy fats to help manage blood pressure and cholesterol.',
    'Staying active with regular cardiovascular exercise, such as any concerns early.',
    'Managing stress through relaxation techniques and maintaining.',
  ];

  static final List<Organ> organs = [
    Organ(
      id: 'heart',
      name: 'Heart',
      asset: 'assets/organs/heart.png',
      heroAsset: 'assets/organs/heart.png',
      accent: AccentTheme.green,
      conditionTitle: 'Heart Conditions Overview',
      gaugeLabel: 'Heart Condition',
      score: 76,
      callouts: const [
        Callout('Recovery phase with mild discomfort noted',
            positive: true, link: true, align: Alignment.topRight),
        Callout('Better Cardiac Condition than Past.',
            positive: true, align: Alignment.topLeft),
        Callout('Notice a minor blockage in the lower 4 th chamber.',
            positive: false, align: Alignment.bottomLeft),
      ],
      recommendationTitle: 'Heart Health Recommendation :',
      recommendationBody:
          'Maintaining a healthy heart is essential for overall well-being and longevity.',
      recommendationBullets: _heartBullets,
      riskTitle: 'Chronic Heart Disease Risk Assessment',
      risks: _heartRisks,
    ),
    Organ(
      id: 'lungs',
      name: 'Lungs',
      asset: 'assets/organs/lungs.png',
      heroAsset: 'assets/organs/lungs.png',
      accent: AccentTheme.gold,
      conditionTitle: 'Lungs Conditions Overview',
      gaugeLabel: 'Lungs Condition',
      score: 66,
      callouts: const [
        Callout('Recovery phase with better oxygen Supply',
            positive: true, link: true, align: Alignment.topRight),
        Callout('Better Respiration Condition than Past.',
            positive: true, align: Alignment.topLeft),
        Callout('Notice a minor blockage in the lower.',
            positive: false, align: Alignment.centerLeft),
      ],
      recommendationTitle: 'Lungs Health Recommendation :',
      recommendationBody:
          'Maintaining healthy lungs is essential for overall well-being and vitality.',
      recommendationBullets: const [
        'Eating a lung-friendly diet rich in fruits, whole grains, and antioxidants to support respiratory health.',
        'Avoiding smoking, air pollution, and harmful chemicals to protect lung function.',
        'Staying active with regular aerobic exercise, such as walking, swimming, or cycling, to strengthen lung capacity.',
        'Practicing deep breathing exercises and maintaining good.',
      ],
      riskTitle: 'Chronic lungs Disease Risk Assessment',
      risks: _heartRisks,
    ),
    Organ(
      id: 'kidneys',
      name: 'kidneys',
      asset: 'assets/organs/kidney.png',
      heroAsset: 'assets/organs/kidney.png',
      accent: AccentTheme.cyan,
      conditionTitle: 'Kidney Conditions Overview',
      gaugeLabel: 'Kidney Condition',
      score: 82,
      callouts: const [
        Callout('Filtration rate within healthy range',
            positive: true, link: true, align: Alignment.topRight),
        Callout('Good hydration balance.',
            positive: true, align: Alignment.centerLeft),
      ],
      recommendationTitle: 'Kidney Health Recommendation :',
      recommendationBody:
          'Healthy kidneys keep your blood clean and your fluids balanced.',
      recommendationBullets: const [
        'Staying well hydrated throughout the day.',
        'Limiting salt and processed foods to reduce strain.',
        'Keeping blood pressure and blood sugar in check.',
      ],
      riskTitle: 'Chronic Kidney Disease Risk Assessment',
      risks: _heartRisks,
    ),
    Organ(
      id: 'brain',
      name: 'Brain',
      asset: 'assets/organs/brain.png',
      heroAsset: 'assets/organs/brain.png',
      accent: AccentTheme.cyan,
      conditionTitle: 'Brain Conditions Overview',
      gaugeLabel: 'Cognitive Condition',
      score: 71,
      callouts: const [
        Callout('Focus and memory trending upward',
            positive: true, link: true, align: Alignment.topRight),
        Callout('Mild stress markers detected.',
            positive: false, align: Alignment.centerLeft),
      ],
      recommendationTitle: 'Brain Health Recommendation :',
      recommendationBody:
          'A healthy brain supports memory, focus and emotional balance.',
      recommendationBullets: const [
        'Prioritising 7-8 hours of quality sleep.',
        'Challenging your mind with new skills.',
        'Managing stress with mindfulness.',
      ],
      riskTitle: 'Neurological Risk Assessment',
      risks: _heartRisks,
    ),
    Organ(
      id: 'bones',
      name: 'Bones',
      asset: 'assets/organs/spine.png',
      heroAsset: 'assets/organs/spine.png',
      accent: AccentTheme.gold,
      conditionTitle: 'Bone Conditions Overview',
      gaugeLabel: 'Bone Density',
      score: 68,
      callouts: const [
        Callout('Density stable versus last scan',
            positive: true, link: true, align: Alignment.topRight),
      ],
      recommendationTitle: 'Bone Health Recommendation :',
      recommendationBody:
          'Strong bones keep you mobile and resilient as you age.',
      recommendationBullets: const [
        'Getting enough calcium and vitamin D.',
        'Doing weight-bearing exercise regularly.',
      ],
      riskTitle: 'Skeletal Risk Assessment',
      risks: _heartRisks,
    ),
    Organ(
      id: 'stomach',
      name: 'Stomach',
      asset: 'assets/organs/stomach.png',
      heroAsset: 'assets/organs/stomach.png',
      accent: AccentTheme.red,
      conditionTitle: 'Stomach Conditions Overview',
      gaugeLabel: 'Digestive Condition',
      score: 58,
      callouts: const [
        Callout('Occasional acidity noted',
            positive: false, link: true, align: Alignment.topRight),
      ],
      recommendationTitle: 'Digestive Health Recommendation :',
      recommendationBody:
          'A calm gut improves digestion, immunity and mood.',
      recommendationBullets: const [
        'Eating slowly and avoiding heavy late meals.',
        'Adding fibre and fermented foods.',
      ],
      riskTitle: 'Gastric Risk Assessment',
      risks: _heartRisks,
    ),
    Organ(
      id: 'intestine',
      name: 'Intestine',
      asset: 'assets/organs/intestine.png',
      heroAsset: 'assets/organs/intestine.png',
      accent: AccentTheme.green,
      conditionTitle: 'Intestine Conditions Overview',
      gaugeLabel: 'Gut Condition',
      score: 74,
      callouts: const [
        Callout('Microbiome diversity improving',
            positive: true, link: true, align: Alignment.topRight),
      ],
      recommendationTitle: 'Gut Health Recommendation :',
      recommendationBody:
          'Your gut drives digestion and a large part of immunity.',
      recommendationBullets: const [
        'Eating a wide range of plant fibres.',
        'Staying hydrated and active.',
      ],
      riskTitle: 'Intestinal Risk Assessment',
      risks: _heartRisks,
    ),
  ];

  static final Organ heartAttack = Organ(
    id: 'heart_attack',
    name: 'Heart',
    asset: 'assets/organs/heart.png',
    heroAsset: 'assets/organs/heart.png',
    accent: AccentTheme.red,
    conditionTitle: 'Heart Conditions Overview',
    gaugeLabel: 'Heart Attack (Myocardial Infarction)',
    score: 30,
    callouts: const [
      Callout('Recovery phase with mild discomfort noted',
          positive: true, link: true, align: Alignment.topRight),
      Callout('Better Cardiac Condition than Past.',
          positive: true, align: Alignment.centerLeft),
      Callout('Notice a minor blockage in the lower 4 th chamber.',
          positive: false, align: Alignment.bottomLeft),
    ],
    recommendationTitle: 'For individuals who have experienced '
        'a heart attack (myocardial infarction), it is crucial to follow '
        'these health recommendations:',
    recommendationBody: '',
    recommendationBullets: const [
      'Adopt a Heart-Healthy Diet – Eat more fruits, vegetables, whole grains, and lean proteins. Reduce salt, sugar, and unhealthy fats.',
      'Regular Exercise – Engage in at least 30 minutes of moderate exercise (walking, cycling, swimming) most days of the week.',
      'Manage Stress – Practice meditation, deep breathing, or yoga to keep stress levels in check.',
      'Quit Smoking & Limit Alcohol – Avoid tobacco and limit alcohol intake to protect your heart.',
      'Monitor Blood Pressure & Cholesterol – Regularly check your vitals and follow medical advice if needed.',
      'Take Prescribed Medications – Follow your doctor\'s recommendations for heart health management.',
      'Seek Immediate Help for Symptoms – If you experience chest pain, shortness of breath, or nausea, get medical help immediately.',
    ],
    riskTitle: 'Chronic Heart Disease Risk Assessment',
    risks: _heartRisks,
  );

  static MetricDetail getMetricDetail(RiskMetric risk) {
    String unit = 'mcg/dl';
    String status = 'optimal';
    String badgeLabel = '';

    if (risk.accent == AccentTheme.green) {
      status = 'optimal';
      badgeLabel = 'Optimal ${risk.value.toStringAsFixed(1)}';
    } else if (risk.accent == AccentTheme.gold) {
      status = 'moderate';
      badgeLabel = 'Moderate ${risk.value.toStringAsFixed(1)}';
    } else {
      status = 'high risk';
      badgeLabel = 'High ${risk.value.toStringAsFixed(1)}';
    }

    if (risk.name.toLowerCase().contains('hcv')) {
      unit = 'S/CO';
    } else if (risk.name.toLowerCase().contains('time') ||
        risk.name.toLowerCase().contains('mentzer')) {
      unit = 'secs';
    } else if (risk.name.toLowerCase().contains('immunoglobulin') ||
        risk.name.toLowerCase().contains('immunoglobulim')) {
      unit = 'KUI/L';
    } else if (risk.name.toLowerCase().contains('apolipoprotein') ||
        risk.name.toLowerCase().contains('apolipoprotine')) {
      unit = 'mg/dL';
    }

    List<RangeRow> ranges = const [
      RangeRow(Color(0xFFEF4444), '< 4.46 mcg/dL', 'VERY LOW'),
      RangeRow(Color(0xFFF87171), '< 8.46 mcg/dL', 'LOW'),
      RangeRow(Color(0xFFEAB308), '4.46 mcg/dL', 'MODERATE'),
      RangeRow(Color(0xFFA3E635), '< 6.46 mcg/dL', 'OPTIMAL'),
      RangeRow(Color(0xFF4ADE80), '88.46 -9.2 mcg/dL', 'HIGH'),
      RangeRow(Color(0xFF22C55E), '<10.46 -22.0  mg/dL', 'VERY HIGH'),
    ];

    List<MetricParameter> parameters = const [
      MetricParameter('Diet (saturated fat, sugar intake)',
          'Limit saturated fats and sugars to keep arteries clear and cholesterol in check.'),
      MetricParameter('Physical activity levels',
          'Regular exercise strengthens the heart and improves circulation'),
      MetricParameter('Body weight and waist circumference',
          'Maintaining a healthy weight reduces strain on the heart and lowers risk factors.'),
    ];

    return MetricDetail(
      name: risk.name,
      unit: unit,
      status: status,
      value: risk.value,
      badgeLabel: badgeLabel,
      accent: risk.accent,
      ranges: ranges,
      aboutTitle: 'ABOUT ${risk.name.toUpperCase()}',
      aboutBody:
          '${risk.name}, often referred to in comprehensive metabolic and cardiovascular screening, plays a key role in physiological function. Maintaining balanced levels within standard health target ranges is vital for reducing long-term health risk factors.',
      parameters: parameters,
    );
  }

  static MetricDetail get mentzer => getMetricDetail(
        const RiskMetric('Mentzer', '12.3 - 15.5 secs', 16.7, AccentTheme.gold),
      );

  static const List<Callout> bodyCallouts = [
    Callout('Recovery slight pain in the left side neck.',
        positive: true, link: true, align: Alignment.topRight),
    Callout('Chronics Lungs Problem', positive: false, align: Alignment.centerLeft),
    Callout('Knee Problem', positive: false, align: Alignment.bottomLeft),
  ];

  static const List<Offset> dopamine = [
    Offset(0, 62), Offset(12, 70), Offset(24, 88), Offset(36, 92),
    Offset(52, 60), Offset(60, 78), Offset(68, 65), Offset(74, 83),
    Offset(80, 52), Offset(96, 75), Offset(104, 91), Offset(120, 80),
  ];

  static const List<Offset> serotonin = [
    Offset(0, 77), Offset(12, 97), Offset(24, 80), Offset(36, 58),
    Offset(52, 82), Offset(60, 76), Offset(68, 84), Offset(74, 79),
    Offset(80, 58), Offset(96, 88), Offset(104, 51), Offset(120, 65),
  ];

  static const List<String> strengths = [
    '0.05', '0.05', '0.05', '0.05', '0.05', '0.05',
  ];
}
