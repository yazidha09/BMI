// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:bmi/main.dart';

void main() {
  testWidgets('BMI Calculator smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BMICalculatorApp());

    // Verify that the BMI Calculator title is present
    expect(find.text('BMI Calculator'), findsOneWidget);

    // Verify that input fields are present
    expect(find.text('Height (cm)'), findsOneWidget);
    expect(find.text('Weight (kg)'), findsOneWidget);
    expect(find.text('Age (years)'), findsOneWidget);
  });
}
