import 'package:cpx_dasboard/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('dashboard adapts to phone, tablet, and desktop widths', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final size in [
      const Size(390, 844),
      const Size(820, 1180),
      const Size(1440, 1000),
    ]) {
      tester.view.physicalSize = size;
      await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Smart Dashboard'), findsOneWidget);
      expect(tester.takeException(), isNull, reason: 'Viewport: $size');
    }

    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('dashboard metrics update from the selected channel report', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));
    await tester.tap(find.widgetWithText(ChoiceChip, 'Fallback'));
    await tester.pumpAndSettle();

    final initiatedCard = find.byKey(
      const ValueKey('dashboard-stat-initiated'),
    );
    expect(
      find.descendant(of: initiatedCard, matching: find.text('0')),
      findsOneWidget,
    );
    expect(find.text('No activity in this period'), findsNWidgets(2));
  });
}
