import 'package:cpx_dasboard/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('logo color contrasts with the panel background', () {
    expect(cpxBoatLogoColorForBackground(Colors.black), Colors.white);
    expect(cpxBoatLogoColorForBackground(Colors.white), navy);
  });

  test('logo recolor matches the panel accent and preserves white details', () {
    const accents = [Color(0xFF5B4BC4), Color(0xFFDC2626)];
    for (final accent in accents) {
      final matrix = cpxBoatLogoColorMatrix(accent);
      expect(matrix, hasLength(20));

      double transform(int row, Color color) =>
          matrix[row * 5] * color.r +
          matrix[row * 5 + 1] * color.g +
          matrix[row * 5 + 2] * color.b +
          matrix[row * 5 + 3] * color.a +
          matrix[row * 5 + 4];

      expect(transform(0, defaultPanelAccent), closeTo(accent.r, .01));
      expect(transform(1, defaultPanelAccent), closeTo(accent.g, .01));
      expect(transform(2, defaultPanelAccent), closeTo(accent.b, .01));
      expect(transform(0, Colors.white), closeTo(1, .01));
      expect(transform(1, Colors.white), closeTo(1, .01));
      expect(transform(2, Colors.white), closeTo(1, .01));
    }
  });

  test('topbar logo tint is lighter than the selected panel accent', () {
    const accents = [Color(0xFF5B4BC4), Color(0xFFDC2626)];
    for (final accent in accents) {
      final logoTint = Color.lerp(accent, Colors.white, .5)!;
      final matrix = cpxBoatTopBarLogoColorMatrix(accent);

      for (var channel = 0; channel < 3; channel++) {
        final source = [
          defaultPanelAccent.r,
          defaultPanelAccent.g,
          defaultPanelAccent.b,
        ];
        final output =
            matrix[channel * 5] * source[0] +
            matrix[channel * 5 + 1] * source[1] +
            matrix[channel * 5 + 2] * source[2] +
            matrix[channel * 5 + 4];
        final target = [logoTint.r, logoTint.g, logoTint.b][channel];
        expect(output, closeTo(target, .01));
      }
    }
  });

  testWidgets('login colors update when the panel theme changes', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final controller = PanelThemeController.instance;
    const initialAccent = Color(0xFF5B4BC4);
    const selectedAccent = Color(0xFFEA580C);
    await controller.setAccentColor(initialAccent);
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final accent = controller.accentColor;
          return MaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: accent)
                  .copyWith(primary: accent),
            ),
            home: const AuthEntryScreen(),
          );
        },
      ),
    );

    final initialBackground = Color.lerp(initialAccent, Colors.black, .82)!;
    expect(
      tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor,
      initialBackground,
    );

    await controller.setAccentColor(selectedAccent);
    await tester.pumpAndSettle();

    final updatedBackground = Color.lerp(selectedAccent, Colors.black, .82)!;
    expect(
      tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor,
      updatedBackground,
    );
    expect(updatedBackground, isNot(initialBackground));
    expect(
      tester
          .widget<InputDecorator>(find.byType(InputDecorator).first)
          .decoration
          .fillColor,
      Color.lerp(selectedAccent, Colors.black, .72),
    );
  });

  testWidgets('panel theme updates across the app and is saved', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final controller = PanelThemeController.instance;
    await controller.setAccentColor(defaultPanelAccent);

    await tester.pumpWidget(
      AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final accent = controller.accentColor;
          return MaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: accent)
                  .copyWith(primary: accent),
            ),
            home: const PanelThemeScreen(),
          );
        },
      ),
    );

    const selectedColor = Color(0xFF5B4BC4);
    await tester.tap(find.byKey(const ValueKey('panel-theme-color-ff5b4bc4')));
    await tester.pumpAndSettle();

    final scaffold = tester.element(find.byType(Scaffold).first);
    expect(Theme.of(scaffold).colorScheme.primary, selectedColor);
    expect(
      tester.widget<AppBar>(find.byType(AppBar)).backgroundColor,
      selectedColor,
    );
    expect(find.text('Current: #5B4BC4'), findsOneWidget);

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getInt('panel_accent_color'), selectedColor.toARGB32());
  });
}
