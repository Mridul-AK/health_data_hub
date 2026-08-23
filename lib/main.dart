import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'models/health_data.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/overview_screen.dart';
import 'screens/organ_detail_screen.dart';
import 'screens/metric_detail_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const HealthDataHubApp());
}

class HealthDataHubApp extends StatelessWidget {
  const HealthDataHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Health Data Hub',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark(),
        home: _initialScreen(),
      ),
    );
  }

  Widget _initialScreen() {
    final s = Uri.base.queryParameters['screen'];
    switch (s) {
      case 'heart':
        return OrganDetailScreen(organ: HealthData.organs.first);
      case 'attack':
        return OrganDetailScreen(organ: HealthData.heartAttack);
      case 'lungs':
        return OrganDetailScreen(
            organ: HealthData.organs.firstWhere((o) => o.id == 'lungs'));
      case 'metric':
        return const MetricDetailScreen();
      default:
        return const OverviewScreen();
    }
  }
}
