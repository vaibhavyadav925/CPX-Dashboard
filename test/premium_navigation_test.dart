import 'dart:convert';

import 'package:cpx_dasboard/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('premium loading skeleton stays accessible on small screens', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              padding: EdgeInsets.all(12),
              child: PremiumLoadingState(message: 'Loading leads'),
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Loading leads'), findsOneWidget);
      expect(tester.takeException(), isNull);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('drawer search finds and opens a page', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final scaffoldKey = GlobalKey<ScaffoldState>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          drawer: const DashboardDrawer(),
          body: const SizedBox.expand(),
        ),
      ),
    );

    scaffoldKey.currentState!.openDrawer();
    await tester.pumpAndSettle();
    final drawerAccent = Theme.of(tester.element(find.byType(Drawer)))
        .colorScheme
        .primary;
    final drawer = tester.widget<Drawer>(find.byType(Drawer));
    expect(drawer.backgroundColor, Colors.transparent);
    final drawerContainer = tester.widget<Container>(
      find
          .descendant(of: find.byType(Drawer), matching: find.byType(Container))
          .first,
    );
    final drawerGradient =
        (drawerContainer.decoration as BoxDecoration).gradient!
            as LinearGradient;
    expect(
      drawerGradient.colors.first,
      Color.lerp(drawerAccent, Colors.black, .82),
    );
    expect(
      drawerGradient.colors.last,
      Color.lerp(drawerAccent, Colors.black, .62),
    );
    await tester.enterText(
      find.byKey(const ValueKey('drawer-navigation-search')),
      'leads',
    );
    await tester.pumpAndSettle();

    expect(find.text('Leads'), findsOneWidget);
    expect(find.text('Campaigns'), findsNothing);
    await tester.tap(find.text('Leads'));
    await tester.pumpAndSettle();
    expect(find.text('Ajay Live Test'), findsOneWidget);
  });

  testWidgets('campaign search offers a clear-filter empty state', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: WhatsAppCampaignsScreen()));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('whatsapp-campaign-search')),
      'no matching campaign',
    );
    await tester.pumpAndSettle();

    expect(find.text('No campaigns match these filters'), findsOneWidget);
    await tester.ensureVisible(find.text('Clear filters'));
    await tester.tap(find.text('Clear filters'));
    await tester.pumpAndSettle();
    expect(find.text('No campaigns match these filters'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('CRM leads persist and support bulk actions with undo', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1440, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: CRMLeadsScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add lead').first);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('crm-lead-field-Name')),
      'New Test Lead',
    );
    await tester.enterText(
      find.byKey(const ValueKey('crm-lead-field-Phone (WhatsApp) *')),
      '+1 555 010 0200',
    );
    await tester.tap(find.byTooltip('Close').last);
    await tester.pumpAndSettle();
    expect(find.text('Discard unsaved changes?'), findsOneWidget);
    await tester.tap(find.text('Keep editing'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('crm-lead-save')));
    await tester.pumpAndSettle();

    var preferences = await SharedPreferences.getInstance();
    var records = (jsonDecode(preferences.getString('crm_leads_v1')!) as List)
        .cast<Map<String, dynamic>>();
    expect(records, hasLength(2));
    expect(records.last['phone'], '+1 555 010 0200');

    await tester.ensureVisible(find.byType(Checkbox).last);
    await tester.tap(find.byType(Checkbox).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Change status'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Contacted').last);
    await tester.pumpAndSettle();

    preferences = await SharedPreferences.getInstance();
    records = (jsonDecode(preferences.getString('crm_leads_v1')!) as List)
        .cast<Map<String, dynamic>>();
    expect(records.last['status'], 'Contacted');

    await tester.tap(find.text('Assign owner'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Priya');
    await tester.tap(find.widgetWithText(FilledButton, 'Assign'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();

    preferences = await SharedPreferences.getInstance();
    records = (jsonDecode(preferences.getString('crm_leads_v1')!) as List)
        .cast<Map<String, dynamic>>();
    expect(records, hasLength(2));
    expect(records.last['owner'], 'Priya');

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.pumpWidget(const MaterialApp(home: CRMLeadsScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Ajay Live Test'), findsOneWidget);
    expect(find.text('+1 555 010 0200'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('CRM lead list sorts and paginates saved records', (
    tester,
  ) async {
    final leads = [
      for (var index = 0; index < 27; index++)
        {
          'name': 'Lead ${index.toString().padLeft(2, '0')}',
          'phone': '+1 555 ${index.toString().padLeft(7, '0')}',
          'source': 'Website',
          'status': 'New',
          'owner': 'Unassigned',
          'tags': '',
          'activity': 'Today',
        },
    ];
    SharedPreferences.setMockInitialValues({'crm_leads_v1': jsonEncode(leads)});
    tester.view.physicalSize = const Size(1440, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: CRMLeadsScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Page 1 of 2'), findsOneWidget);
    expect(find.text('Lead 00'), findsOneWidget);
    await tester.tap(find.text('LEAD'));
    await tester.pumpAndSettle();
    expect(find.text('Lead 26'), findsOneWidget);
    await tester.ensureVisible(find.byTooltip('Next page'));
    await tester.tap(find.byTooltip('Next page'));
    await tester.pumpAndSettle();
    expect(find.text('Page 2 of 2'), findsOneWidget);
    expect(find.text('Lead 00'), findsOneWidget);

    tester.view.physicalSize = const Size(400, 900);
    await tester.pumpWidget(
      MaterialApp(home: CRMLeadsScreen(key: const ValueKey('mobile-leads'))),
    );
    await tester.pumpAndSettle();
    expect(find.text('Page 1 of 2 · 27 leads'), findsOneWidget);
    await tester.ensureVisible(find.byTooltip('Next page'));
    await tester.tap(find.byTooltip('Next page'));
    await tester.pumpAndSettle();
    expect(find.text('Page 2 of 2 · 27 leads'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
