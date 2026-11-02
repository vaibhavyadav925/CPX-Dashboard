import 'dart:convert';
import 'dart:typed_data';

import 'package:cpx_dasboard/app.dart';
import 'package:excel_plus/excel_plus.dart' as spreadsheet;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('CSV export quotes fields and protects spreadsheet formulas', () {
    expect(
      encodeCsv(
        ['Name', 'Note', 'Formula'],
        [
          ['Ajay', 'Said "hello"\nagain', ' =1+1'],
        ],
      ),
      '"Name","Note","Formula"\r\n"Ajay","Said ""hello""\nagain","\' =1+1"',
    );
  });

  test('CRM CSV import parses quoted fields and requires phone header', () {
    final leads = parseCrmLeadsCsv(
      'phone,name,email,city,product,source,campaign_name,status,tags\r\n'
      ' +91 98765 43210 ,"Ajay, Test",ajay@example.com,Pune,Widget,Website,Spring,New,"lead;web"\r\n'
      '919999999999,"Say ""hello""",,,,,,,',
    );

    expect(leads, hasLength(2));
    expect(leads.first['name'], 'Ajay, Test');
    expect(leads.first['phone'], '+91 98765 43210');
    expect(leads.first['tags'], 'lead;web');
    expect(leads.last['name'], 'Say "hello"');
    expect(
      () => parseCrmLeadsCsv('name,email\nAjay,ajay@example.com'),
      throwsFormatException,
    );
    expect(
      () => parseCrmLeadsCsv('phone,name\n"broken'),
      throwsFormatException,
    );
  });

  test('recipient imports read CSV and Excel files', () async {
    final csvRows = await parseSpreadsheetFile(
      'recipients.csv',
      utf8.encode('phone_number,name\r\n+1 (555) 010-0200,"Jamie, Smith"\r\n'),
    );
    expect(spreadsheetPhoneNumbers(csvRows), ['+15550100200']);
    expect(spreadsheetContactsFromRows(csvRows).single['name'], 'Jamie, Smith');

    final workbook = spreadsheet.Excel.createExcel();
    workbook['Sheet1'].appendRow([
      spreadsheet.TextCellValue('CountryCode'),
      spreadsheet.TextCellValue('MSISDN'),
      spreadsheet.TextCellValue('Name'),
    ]);
    workbook['Sheet1'].appendRow([
      spreadsheet.TextCellValue('91'),
      spreadsheet.TextCellValue('9876543210'),
      spreadsheet.TextCellValue('Priya'),
    ]);
    final excelBytes = workbook.encode()!;
    final excelRows = await parseSpreadsheetFile(
      'recipients.xlsx',
      Uint8List.fromList(excelBytes),
    );
    expect(
      spreadsheetPhoneNumbers(excelRows, requireCountryCodeAndMsisdn: true),
      ['919876543210'],
    );
    expect(spreadsheetContactsFromRows(excelRows).single['name'], 'Priya');
  });

  test('logo color contrasts with the panel background', () {
    expect(cpxBoatLogoColorForBackground(Colors.black), Colors.white);
    expect(cpxBoatLogoColorForBackground(Colors.white), brandNavy);
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

  test('workspace surfaces keep their original light colors', () async {
    SharedPreferences.setMockInitialValues({});
    final controller = PanelThemeController.instance;
    const firstAccent = Color(0xFF5B4BC4);
    const secondAccent = Color(0xFFEA580C);

    await controller.setAccentColor(firstAccent);
    expect(pageColor, const Color(0xFFF5F7FB));
    expect(premiumSurface, Colors.white);
    expect(panelFieldBackground(firstAccent), const Color(0xFFF8FAFD));

    await controller.setAccentColor(secondAccent);
    expect(pageColor, const Color(0xFFF5F7FB));
    expect(premiumSurface, Colors.white);
    expect(panelFieldBackground(secondAccent), const Color(0xFFF8FAFD));
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
    expect(pageColor, const Color(0xFFF5F7FB));
    final appBar = tester.widget<AppBar>(find.byType(AppBar));
    final appBarDecoration =
        (appBar.flexibleSpace as DecoratedBox).decoration as BoxDecoration;
    final appBarGradient = appBarDecoration.gradient! as LinearGradient;
    expect(appBarGradient.colors.first, selectedColor);
    expect(
      appBarGradient.colors.last,
      Color.lerp(selectedColor, brandNavy, .22),
    );
    expect(appBar.foregroundColor, Colors.white);
    expect(find.text('Current: #5B4BC4'), findsOneWidget);

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getInt('panel_accent_color'), selectedColor.toARGB32());
  });

  testWidgets('top bar follows the panel accent with readable contrast', (
    tester,
  ) async {
    const lightAccent = Color(0xFFBDEAF2);
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: lightAccent)
              .copyWith(primary: lightAccent),
        ),
        home: Builder(
          builder: (context) => Scaffold(
            appBar: buildCpxBoatAppBar(context),
            body: const SizedBox(),
          ),
        ),
      ),
    );

    final appBar = tester.widget<AppBar>(find.byType(AppBar));
    final decoration =
        (appBar.flexibleSpace as DecoratedBox).decoration as BoxDecoration;
    final gradient = decoration.gradient! as LinearGradient;
    expect(gradient.colors.first, lightAccent);
    expect(gradient.colors.last, Color.lerp(lightAccent, brandNavy, .22));
    expect(appBar.backgroundColor, lightAccent);
    expect(appBar.foregroundColor, brandNavy);
  });

  testWidgets('top bar notifications open the center and settings', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            appBar: buildCpxBoatAppBar(context),
            body: const SizedBox(),
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Notifications'));
    await tester.pumpAndSettle();
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text("You're all caught up"), findsOneWidget);

    await tester.tap(find.text('Notification settings'));
    await tester.pumpAndSettle();
    expect(find.text('Panel Theme'), findsOneWidget);
  });

  testWidgets('CRM overview guide can be hidden and shown', (tester) async {
    tester.view.physicalSize = const Size(900, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: CRMOverviewScreen()));

    expect(find.text('Step 1. Set up your CRM'), findsOneWidget);
    await tester.ensureVisible(find.textContaining('Hide guide'));
    await tester.tap(find.textContaining('Hide guide'));
    await tester.pumpAndSettle();

    expect(find.text('Step 1. Set up your CRM'), findsNothing);
    expect(find.textContaining('Show guide'), findsOneWidget);

    await tester.tap(find.textContaining('Show guide'));
    await tester.pumpAndSettle();

    expect(find.text('Step 1. Set up your CRM'), findsOneWidget);
  });

  testWidgets('billing controls fit phone, tablet, and web widths', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    for (final width in [360.0, 800.0, 1024.0, 1440.0]) {
      tester.view.physicalSize = Size(width, 900);
      await tester.pumpWidget(const MaterialApp(home: ManageBillingScreen()));
      await tester.pumpAndSettle();

      final exception = tester.takeException();
      expect(exception, isNull, reason: 'Viewport width $width');
    }
  });

  testWidgets('SMS Sender IDs page renders responsively and removes an ID', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    for (final width in [360.0, 1440.0]) {
      tester.view.physicalSize = Size(width, 900);
      await tester.pumpWidget(const MaterialApp(home: SMSSenderIdsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Sender IDs'), findsOneWidget);
      expect(find.text('WBTCSL'), findsOneWidget);
      expect(tester.takeException(), isNull, reason: 'Viewport width $width');
    }

    await tester.tap(find.byTooltip('Remove sender ID'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    expect(find.text('WBTCSL'), findsNothing);
    expect(find.text('No sender IDs are available.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('CRM Leads page renders responsively across screen widths', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    for (final width in [360.0, 800.0, 1024.0, 1440.0]) {
      tester.view.physicalSize = Size(width, 900);
      await tester.pumpWidget(const MaterialApp(home: CRMLeadsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Leads'), findsOneWidget);
      expect(find.text('Ajay Live Test'), findsOneWidget);
      if (width < 600) {
        expect(find.text('Source'), findsOneWidget);
        expect(find.text('Owner'), findsOneWidget);
        expect(find.text('Last activity'), findsOneWidget);
      }
      expect(tester.takeException(), isNull, reason: 'Viewport width $width');
    }
  });

  testWidgets('CRM Add lead dialog follows the reference form', (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: CRMLeadsScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add lead').first);
    await tester.pumpAndSettle();

    expect(find.text('Phone (WhatsApp) *'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Product / interest'), findsOneWidget);
    expect(find.text('Marketing consent'), findsOneWidget);
    expect(find.text('Start matching “New lead” automations'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, '98XXXXXXXX'),
      '+91 98765 43210',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Add lead').last);
    await tester.pumpAndSettle();
    expect(find.text('+91 98765 43210'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('CRM Import CSV dialog follows the reference layout', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: CRMLeadsScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Import CSV'));
    await tester.pumpAndSettle();

    expect(find.text('Import leads from CSV'), findsOneWidget);
    expect(find.text('Download a sample'), findsOneWidget);
    expect(find.text('Choose CSV or Excel file'), findsOneWidget);
    expect(find.text('Source for rows without one'), findsOneWidget);
    expect(
      find.text('Start matching “New lead” automations for new rows'),
      findsOneWidget,
    );
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Import'))
          .onPressed,
      isNull,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('CRM lead dialogs fit a phone screen', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: CRMLeadsScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add lead').first);
    await tester.pumpAndSettle();
    expect(find.text('Phone (WhatsApp) *'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Import CSV'));
    await tester.pumpAndSettle();
    expect(find.text('Import leads from CSV'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('RCS campaign checkboxes select rows and all visible campaigns', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: RCSCampaignsScreen()));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.byType(Checkbox).at(1));
    await tester.pumpAndSettle();
    expect(find.text('1 selected'), findsOneWidget);

    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    expect(find.text('7 selected'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('RCS New campaign matches the standard composer flow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: RCSCampaignsScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New campaign').first);
    await tester.pumpAndSettle();

    expect(find.text('New RCS campaign'), findsOneWidget);
    expect(find.text('When to send'), findsOneWidget);
    expect(find.text('Preview'), findsOneWidget);
    final sendCampaign = find.widgetWithText(FilledButton, 'Send campaign');
    expect(tester.widget<FilledButton>(sendCampaign).onPressed, isNull);

    await tester.enterText(find.byType(TextField).first, 'Product launch');
    await tester.enterText(
      find.byType(TextField).last,
      '919876543210, 919876543211',
    );
    await tester.pump();
    expect(tester.widget<FilledButton>(sendCampaign).onPressed, isNull);

    await tester.tap(find.byType(DropdownButtonFormField<String>).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('webtech_carousel').last);
    await tester.pumpAndSettle();
    expect(tester.widget<FilledButton>(sendCampaign).onPressed, isNotNull);

    await tester.ensureVisible(sendCampaign);
    await tester.pumpAndSettle();
    await tester.tap(sendCampaign);
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Campaign details are ready. Connect your RCS sending service to send it.',
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'RCS Dynamic campaign shows upload and missing-placeholder state',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(home: RCSCampaignComposerScreen()),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Dynamic'));
      await tester.pumpAndSettle();

      expect(find.text('Recipient file'), findsOneWidget);
      expect(find.text('Upload File'), findsOneWidget);
      expect(
        find.text(
          'No templates with [PLACEHOLDER] variables yet — Dynamic needs at least one.',
        ),
        findsOneWidget,
      );
      final sendCampaign = find.widgetWithText(FilledButton, 'Send campaign');
      expect(tester.widget<FilledButton>(sendCampaign).onPressed, isNull);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('RCS campaign composer adapts to a phone viewport', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: RCSCampaignComposerScreen()),
    );
    await tester.pumpAndSettle();
    expect(find.text('New RCS campaign'), findsOneWidget);
    expect(find.text('Recipients'), findsOneWidget);
    expect(find.text('Preview'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Dynamic'));
    await tester.pumpAndSettle();
    expect(find.text('Recipient file'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
