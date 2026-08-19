import 'package:flutter_test/flutter_test.dart';

import 'package:health_data_hub/main.dart';

void main() {
  testWidgets('App boots to the overview screen', (tester) async {
    await tester.pumpWidget(const HealthDataHubApp());
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Health Conditions Overview'), findsOneWidget);
  });
}
