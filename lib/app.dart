import 'dart:convert';
import 'dart:math' as math;

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'screens/auth_entry_screen.dart';
part 'screens/dashboard_screen.dart';
part 'screens/whats_app_dashboard_screen.dart';
part 'screens/mis_reports_screen.dart';
part 'screens/whats_app_templates_screen.dart';
part 'screens/whats_app_commerce_screen.dart';
part 'screens/whats_app_campaigns_screen.dart';
part 'screens/whats_app_new_campaign_screen.dart';
part 'screens/whats_app_occasions_screen.dart';
part 'screens/rcs_occasions_screen.dart';
part 'screens/whats_app_flows_screen.dart';
part 'screens/whats_app_reports_screen.dart';
part 'screens/rcs_scheduled_screen.dart';
part 'screens/whats_app_scheduled_screen.dart';
part 'screens/whats_app_business_profile_screen.dart';
part 'screens/whats_app_quick_links_screen.dart';
part 'screens/sms_dashboard_screen.dart';
part 'screens/sms_campaigns_screen.dart';
part 'screens/rcs_dashboard_screen.dart';
part 'screens/rcs_new_template_screen.dart';
part 'screens/sms_templates_screen.dart';
part 'screens/sms_new_template_screen.dart';
part 'screens/rcs_templates_screen.dart';
part 'screens/rcs_campaigns_screen.dart';
part 'screens/rcs_reports_screen.dart';
part 'screens/rcs_chatbot_screen.dart';
part 'screens/sms_occasions_screen.dart';
part 'screens/smart_fallback_occasions_screen.dart';
part 'screens/smart_fallback_campaigns_screen.dart';
part 'screens/smart_fallback_dashboard_screen.dart';
part 'screens/rcs_inbox_screen.dart';
part 'screens/whats_app_inbox_screen.dart';
part 'screens/onboard_channels_screen.dart';
part 'screens/channels_info_screen.dart';
part 'screens/agent_roles_screen.dart';
part 'screens/contact_groups_screen.dart';
part 'screens/ai_assistant_screen.dart';
part 'screens/whats_app_tier_limit_screen.dart';
part 'screens/sms_scheduled_screen.dart';
part 'screens/sms_reports_screen.dart';
part 'screens/crm_overview_screen.dart';
part 'screens/smart_fallback_reports_screen.dart';
part 'screens/crm_leads_screen.dart';
part 'screens/crm_automations_screen.dart';
part 'screens/crm_settings_screen.dart';
part 'screens/crm_lead_sources_screen.dart';
part 'screens/manage_billing_screen.dart';
part 'screens/panel_theme_screen.dart';
part 'screens/security_screen.dart';
part 'screens/account_details_screen.dart';
part 'screens/whats_app_chatbot_flow_screen.dart';

const navy = Color(0xFF10192D);
const defaultPanelAccent = Color(0xFF0B91AD);
const pageColor = Color(0xFFF5F7FB);
const muted = Color(0xFF718096);
const premiumBorder = Color(0xFFE6EBF2);
const premiumSurface = Color(0xFFFFFFFF);

Color panelAccent(BuildContext context) =>
    Theme.of(context).colorScheme.primary;

Color cpxBoatLogoColorForBackground(Color backgroundColor) =>
    ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.light
    ? navy
    : Colors.white;

List<double> cpxBoatLogoColorMatrix(Color accent) {
  const neutralProjection = 1 / 3;
  final axisComponent = 1 / math.sqrt(3);
  final source = [
    defaultPanelAccent.r,
    defaultPanelAccent.g,
    defaultPanelAccent.b,
  ];
  final target = [accent.r, accent.g, accent.b];
  final sourceMean = source.reduce((a, b) => a + b) / 3;
  final targetMean = target.reduce((a, b) => a + b) / 3;
  final sourceChroma = source.map((channel) => channel - sourceMean).toList();
  final targetChroma = target.map((channel) => channel - targetMean).toList();
  final sourceMagnitude = math.sqrt(
    sourceChroma.fold<double>(0, (sum, channel) => sum + channel * channel),
  );
  final targetMagnitude = math.sqrt(
    targetChroma.fold<double>(0, (sum, channel) => sum + channel * channel),
  );

  if (targetMagnitude < 0.001) {
    return const [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
  }

  final sourceCrossTarget = [
    sourceChroma[1] * targetChroma[2] - sourceChroma[2] * targetChroma[1],
    sourceChroma[2] * targetChroma[0] - sourceChroma[0] * targetChroma[2],
    sourceChroma[0] * targetChroma[1] - sourceChroma[1] * targetChroma[0],
  ];
  final sine =
      sourceCrossTarget.fold<double>(
        0,
        (sum, channel) => sum + channel * axisComponent,
      ) /
      (sourceMagnitude * targetMagnitude);
  var chromaDotProduct = 0.0;
  for (var index = 0; index < 3; index++) {
    chromaDotProduct += sourceChroma[index] * targetChroma[index];
  }
  final cosine = chromaDotProduct / (sourceMagnitude * targetMagnitude);
  final chromaScale = targetMagnitude / sourceMagnitude;
  final crossProductMatrix = [
    [0.0, -axisComponent, axisComponent],
    [axisComponent, 0.0, -axisComponent],
    [-axisComponent, axisComponent, 0.0],
  ];
  final matrix = <double>[];

  for (var row = 0; row < 3; row++) {
    for (var column = 0; column < 3; column++) {
      final projection = neutralProjection;
      final identity = row == column ? 1.0 : 0.0;
      final rotation =
          projection +
          chromaScale *
              (cosine * (identity - projection) +
                  sine * crossProductMatrix[row][column]);
      final meanAdjustment =
          (targetMean - sourceMean) *
          sourceChroma[column] /
          (sourceMagnitude * sourceMagnitude);
      matrix.add(rotation + meanAdjustment);
    }
    matrix.addAll([0, 0]);
  }

  matrix.addAll(const [0, 0, 0, 1, 0]);
  return matrix;
}

List<double> cpxBoatTopBarLogoColorMatrix(Color accent) =>
    cpxBoatLogoColorMatrix(Color.lerp(accent, Colors.white, .5)!);

void showApiPendingMessage(BuildContext context, String action) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text('Connect the API to enable $action.')),
    );
}

String encodeCsv(List<String> headers, Iterable<Iterable<Object?>> rows) {
    String encodeField(Object? value) {
      final text = value?.toString() ?? '';
      final formulaLike =
          value is String && RegExp(r'^[\s]*[=+\-@]').hasMatch(text);
      final safeText = formulaLike ? "'$text" : text;
      return '"${safeText.replaceAll('"', '""')}"';
    }

    final table = <Iterable<Object?>>[headers, ...rows];
    return table.map((row) => row.map(encodeField).join(',')).join('\r\n');
}

Future<void> saveCsvFile(
    BuildContext context, {
    required String fileName,
    required List<String> headers,
    required Iterable<Iterable<Object?>> rows,
}) async {
    final safeName = fileName
        .replaceAll(RegExp(r'[^A-Za-z0-9_-]+'), '_')
        .replaceAll(RegExp(r'_+'), '_');
    final csv = '\uFEFF${encodeCsv(headers, rows)}';

    try {
      final savedPath = await FileSaver.instance.saveAs(
        name: safeName.isEmpty ? 'export' : safeName,
        bytes: Uint8List.fromList(utf8.encode(csv)),
        fileExtension: 'csv',
        mimeType: MimeType.custom,
        customMimeType: 'text/csv',
        dialogTitle: 'Save CSV file',
      );
      if (!context.mounted || savedPath == null) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('CSV file saved: $safeName.csv')),
        );
    } on Exception catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Could not save CSV file: $error')),
        );
    }
}

const campaignCsvHeaders = [
    'Campaign',
    'Template',
    'Account',
    'Phone',
    'Recipients',
    'Amount',
    'Total',
    'Sent',
    'Delivered',
    'Read',
    'Failed',
    'Date',
    'Time',
];

List<Object?> campaignCsvRow(CampaignRecord campaign) => [
    campaign.name,
    campaign.template,
    campaign.account,
    campaign.phone,
    campaign.count,
    campaign.amount,
    campaign.total,
    campaign.sent,
    campaign.delivered,
    campaign.read,
    campaign.failed,
    campaign.date,
    campaign.time,
];

Future<void> saveCampaignCsv(
    BuildContext context,
    String channel,
    Iterable<CampaignRecord> campaigns, {
    bool statsOnly = false,
}) {
    if (!statsOnly) {
      return saveCsvFile(
        context,
        fileName: '${channel}_campaign_report',
        headers: campaignCsvHeaders,
        rows: campaigns.map(campaignCsvRow),
      );
    }

    return saveCsvFile(
      context,
      fileName: '${channel}_campaign_stats',
      headers: const ['Campaign', 'Metric', 'Value'],
      rows: [
        for (final campaign in campaigns) ...[
          [campaign.name, 'Total', campaign.total],
          [campaign.name, 'Sent', campaign.sent],
          [campaign.name, 'Delivered', campaign.delivered],
          [campaign.name, 'Read', campaign.read],
          [campaign.name, 'Failed', campaign.failed],
        ],
      ],
    );
}

class PanelThemeController extends ChangeNotifier {
  PanelThemeController._();

  static final instance = PanelThemeController._();
  static const _preferenceKey = 'panel_accent_color';

  Color _accentColor = defaultPanelAccent;
  bool _hasUserSelection = false;

  Color get accentColor => _accentColor;

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    final savedColor = preferences.getInt(_preferenceKey);
    if (savedColor != null && !_hasUserSelection) {
      _accentColor = Color(savedColor);
      notifyListeners();
    }
  }

  Future<void> setAccentColor(Color color) async {
    _hasUserSelection = true;
    if (_accentColor != color) {
      _accentColor = color;
      notifyListeners();
    }

    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setInt(_preferenceKey, color.toARGB32());
    if (!saved) {
      throw Exception('The panel theme could not be saved on this device.');
    }
  }
}

class CPXBoatApp extends StatefulWidget {
  const CPXBoatApp({super.key});

  @override
  State<CPXBoatApp> createState() => _CPXBoatAppState();
}

class _CPXBoatAppState extends State<CPXBoatApp> {
  @override
  void initState() {
    super.initState();
    PanelThemeController.instance.load();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: PanelThemeController.instance,
      builder: (context, _) {
        final accent = PanelThemeController.instance.accentColor;
        return MaterialApp(
          // title: 'CPXBOAT Dashboard',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: pageColor,
            colorScheme: ColorScheme.fromSeed(
              seedColor: accent,
              brightness: Brightness.light,
              surface: Colors.white,
            ).copyWith(primary: accent),
            fontFamily: 'Roboto',
            visualDensity: VisualDensity.standard,
            primaryColor: accent,
            appBarTheme: AppBarTheme(
              backgroundColor: accent,
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: false,
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: .2,
              ),
              iconTheme: IconThemeData(color: Colors.white, size: 23),
            ),
            textTheme: const TextTheme(
              headlineLarge: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: navy,
                height: 1.2,
              ),
              headlineMedium: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: navy,
                height: 1.2,
              ),
              headlineSmall: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
                color: navy,
                height: 1.25,
              ),
              titleLarge: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: navy,
              ),
              titleMedium: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: navy,
              ),
              bodyLarge: TextStyle(
                fontSize: 14,
                color: Color(0xFF253047),
                height: 1.45,
              ),
              bodyMedium: TextStyle(
                fontSize: 13,
                color: Color(0xFF4F5D73),
                height: 1.4,
              ),
              bodySmall: TextStyle(fontSize: 12, color: muted, height: 1.35),
              labelLarge: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            cardTheme: CardThemeData(
              color: Colors.white,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: premiumBorder),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFFF8FAFD),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 13,
              ),
              hintStyle: const TextStyle(
                color: Color(0xFF98A3B5),
                fontSize: 13,
              ),
              labelStyle: const TextStyle(
                color: Color(0xFF526078),
                fontSize: 13,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFDCE3EE)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFDCE3EE)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: accent, width: 1.6),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE45D61)),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(46, 44),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor: navy,
                minimumSize: const Size(42, 40),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                side: const BorderSide(color: Color(0xFFD9E1EC)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: accent,
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
            dividerTheme: const DividerThemeData(
              color: Color(0xFFE5EAF2),
              thickness: 1,
              space: 1,
            ),
          ),
          home: const AuthEntryScreen(),
        );
      },
    );
  }
}

PreferredSizeWidget buildCpxBoatAppBar(BuildContext context) {
  final screenWidth = MediaQuery.sizeOf(context).width;
  // Keep the compact header close
  //to the supplied mobile reference while
  // retaining the same shared app bar on every page.
  final compact = screenWidth < 600;
  final toolbarHeight = screenWidth < 600
      ? 56.0
      : screenWidth < 900
      ? 60.0
      : 60.0;

  return AppBar(
    toolbarHeight: toolbarHeight,
    backgroundColor: panelAccent(context),
    foregroundColor: Colors.white,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    shadowColor: Colors.black26,
    leadingWidth: compact ? 42 : 46,
    titleSpacing: 0,
    leading: Builder(
      builder: (context) => IconButton(
        tooltip: 'Open navigation menu',
        constraints: const BoxConstraints(minWidth: 40, minHeight: 44),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        visualDensity: VisualDensity.compact,
        icon: Icon(Icons.menu_rounded, size: compact ? 22 : 22),
        onPressed: () {
          final scaffold = Scaffold.maybeOf(context);
          if (scaffold != null && scaffold.hasDrawer) {
            scaffold.openDrawer();
          }
        },
      ),
    ),
    title: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.matrix(
            cpxBoatTopBarLogoColorMatrix(panelAccent(context)),
          ),
          child: Image.asset(
            'assets/logo.png',
            width: 135,
            height: 70,
            fit: BoxFit.contain,
          ),
        ),
      ],
    ),
    actions: [
      InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ManageBillingScreen()),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: (toolbarHeight - 32) / 2),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .10),
            border: Border.all(color: Colors.white.withValues(alpha: .24)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.account_balance_wallet_outlined, size: 15),
              const SizedBox(width: 5),
              const Text(
                '10',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .1,
                ),
              ),
            ],
          ),
        ),
      ),
      IconButton(
        tooltip: 'Profile',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AccountDetailsScreen()),
          );
        },
        constraints: const BoxConstraints(minWidth: 36, minHeight: 40),
        padding: const EdgeInsets.all(5),
        visualDensity: VisualDensity.compact,
        icon: const Icon(
          Icons.account_circle_outlined,
          size: 21,
          color: Colors.white,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 1, right: 12),
        child: const Icon(Icons.notifications_none_rounded, size: 22),
      ),
    ],
  );
}

class StatCard extends StatelessWidget {
  final String label;

  final int value;

  final Color color;

  final IconData icon;

  const StatCard({
    super.key,

    required this.label,

    required this.value,

    required this.color,

    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),

      decoration: BoxDecoration(
        color: premiumSurface,

        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: premiumBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0810192D),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text(
                  label,

                  maxLines: 1,

                  style: const TextStyle(
                    fontSize: 11,

                    color: muted,

                    fontWeight: FontWeight.w700,

                    letterSpacing: .2,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  '$value',

                  style: const TextStyle(
                    fontSize: 23,

                    height: 1.05,

                    fontWeight: FontWeight.w800,

                    color: navy,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 34,

            height: 34,

            decoration: BoxDecoration(
              color: color.withValues(alpha: .13),

              borderRadius: BorderRadius.circular(10),
            ),

            child: Icon(icon, color: color, size: 19),
          ),
        ],
      ),
    );
  }
}

class Legend extends StatelessWidget {
  final Color color;

  final String label;

  const Legend({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9,
              color: Color.fromARGB(255, 97, 75, 101),
            ),
          ),
        ),
      ],
    ),
  );
}

class _CampaignName extends StatelessWidget {
  final String name;
  const _CampaignName({required this.name});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFE6F4F6),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(Icons.chat, color: panelAccent(context), size: 17),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF17233C),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CampaignCount extends StatelessWidget {
  final String count;
  const _CampaignCount({required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.people_outline_rounded, size: 14, color: muted),
        const SizedBox(width: 5),
        Text(count),
      ],
    );
  }
}

class _CampaignStatus extends StatelessWidget {
  final String status;
  const _CampaignStatus({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5EF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Color(0xFF07945B),
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _WhatsAppTemplateRecord {
  final String name;
  final String category;
  final String language;
  final String status;

  const _WhatsAppTemplateRecord(
    this.name,
    this.category,
    this.language,
    this.status,
  );
}

class _CommerceRecord {
  String name;
  String description;
  final String created;
  _CommerceRecord(this.name, this.description, this.created);
}

class CampaignRecord {
  final String name, template, account, phone, count, date, time, amount;
  final int total, read, delivered, sent, failed;
  const CampaignRecord({
    required this.name,
    required this.template,
    required this.count,
    required this.date,
    required this.time,
    required this.amount,
    required this.total,
    required this.read,
    required this.delivered,
    required this.sent,
    required this.failed,
    this.account = 'Webtechage Pvt Ltd',
    this.phone = '+1 555 944 0081',
  });
}

String _campaignNumber(int value) => value.toString().replaceAllMapped(
  RegExp(r'\B(?=(\d{3})+(?!\d))'),
  (_) => ',',
);

class _CampaignReportSidePanel extends StatelessWidget {
  final CampaignRecord campaign;
  final VoidCallback onClose;
  final ValueChanged<String> onDownload;

  const _CampaignReportSidePanel({
    required this.campaign,
    required this.onClose,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final total = campaign.total;
    final read = campaign.read;
    final delivered = campaign.delivered;
    final sent = campaign.sent;
    final failed = campaign.failed;
    final dateParts = campaign.date.split('/');
    final dateLabel = dateParts.length == 3
        ? '${dateParts[0]}/${dateParts[1]}/${dateParts[2]}'
        : campaign.date;

    return Material(
      color: const Color(0xFFF8FBFC),
      child: Column(
        children: [
          Container(
            color: panelAccent(context),
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chat,
                        color: Color(0xFF20B85A),
                        size: 23,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Campaign Report',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onClose,
                      tooltip: 'Close',
                      icon: const Icon(Icons.close, color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        campaign.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Completed',
                        style: TextStyle(
                          color: Color(0xFF07945B),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '$dateLabel, ${campaign.time} · ${_campaignNumber(total)} contacts',
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFDDE5EF)),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x08000000),
                        blurRadius: 7,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      _CampaignSummaryStat(
                        value: _campaignNumber(total),
                        label: 'TOTAL',
                        color: const Color(0xFF17233C),
                      ),
                      _CampaignSummaryStat(
                        value: _campaignNumber(read),
                        label: 'READ',
                        color: const Color(0xFF16A878),
                      ),
                      _CampaignSummaryStat(
                        value: _campaignNumber(delivered),
                        label: 'DELIVERED',
                        color: const Color(0xFF3989FF),
                      ),
                      _CampaignSummaryStat(
                        value: _campaignNumber(sent),
                        label: 'SENT',
                        color: const Color(0xFFF59E0B),
                      ),
                      _CampaignSummaryStat(
                        value: _campaignNumber(failed),
                        label: 'FAILED',
                        color: const Color(0xFFEF4444),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F4F7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: panelAccent(context),
                        size: 17,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'The analytics will be updated after 15 minutes. For detailed reports, please click on Download Reports.',
                          style: TextStyle(
                            color: Color(0xFF63758E),
                            fontSize: 11,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _CampaignProgressRow(
                  label: 'Delivered',
                  value: delivered,
                  total: total,
                  color: const Color(0xFF3989FF),
                ),
                _CampaignProgressRow(
                  label: 'Read',
                  value: read,
                  total: total,
                  color: const Color(0xFF279D67),
                ),
                _CampaignProgressRow(
                  label: 'Sent',
                  value: sent,
                  total: total,
                  color: const Color(0xFFF59E0B),
                  tag: 'Pending',
                  note: 'Report pending from operator',
                ),
                _CampaignProgressRow(
                  label: 'Failed',
                  value: failed,
                  total: total,
                  color: const Color(0xFFEF4444),
                ),
                const SizedBox(height: 14),
                const Divider(color: Color(0xFFD8E1ED)),
                const SizedBox(height: 5),
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'CAMPAIGN DETAILS',
                        style: TextStyle(
                          color: Color(0xFF17233C),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_up, color: Color(0xFF718096)),
                  ],
                ),
                const SizedBox(height: 14),
                _CampaignDetailRow(label: 'Template', value: campaign.template),
                const SizedBox(height: 12),
                _CampaignDetailRow(
                  label: 'Campaign Name',
                  value: campaign.name,
                ),
                const SizedBox(height: 12),
                const _CampaignDetailRow(label: 'Channel', value: 'whatsapp'),
                const SizedBox(height: 18),
                const Divider(color: Color(0xFFD8E1ED)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => onDownload('Download Report'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: panelAccent(context),
                          side: BorderSide(color: panelAccent(context)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Download Report',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => onDownload('Download Stats'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: panelAccent(context),
                          side: BorderSide(color: panelAccent(context)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Download Stats',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CampaignSummaryStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _CampaignSummaryStat({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF718096), fontSize: 8),
          ),
        ],
      ),
    );
  }
}

class _CampaignProgressRow extends StatelessWidget {
  final String label;
  final int value;
  final int total;
  final Color color;
  final String? tag;
  final String? note;

  const _CampaignProgressRow({
    required this.label,
    required this.value,
    required this.total,
    required this.color,
    this.tag,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total == 0 ? 0.0 : value / total;
    final percentLabel = '${(percentage * 100).round()}% of total messages';
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ), 
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Color(0xFF17233C),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (tag != null) ...[
                const SizedBox(width: 7),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3DB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tag!,
                    style: TextStyle(color: Color(0xFFF59E0B), fontSize: 8),
                  ),
                ),
              ],
              const Spacer(),
              Text(
                _campaignNumber(value),
                style: TextStyle(
                  color: Color(0xFF17233C),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: percentage.clamp(0.0, 1.0).toDouble(),
              minHeight: 7,
              backgroundColor: const Color(0xFFE9EDF3),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            note == null
                ? percentLabel
                : '$note · ${percentLabel.split(' ').first} of total',
            style: const TextStyle(color: Color(0xFF718096), fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _CampaignDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _CampaignDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFF718096), fontSize: 12),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF17233C),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _CampaignReportDialog extends StatelessWidget {
  final CampaignRecord campaign;
  final VoidCallback onClose;

  const _CampaignReportDialog({required this.campaign, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final total = campaign.total;
    final unread =
        (total -
                campaign.delivered -
                campaign.read -
                campaign.sent -
                campaign.failed)
            .clamp(0, total);
    final statuses = <(String, int, Color, IconData)>[
      ('Sent', campaign.sent, const Color(0xFFF59E0B), Icons.check_rounded),
      (
        'Delivered',
        campaign.delivered,
        const Color(0xFF3989FF),
        Icons.done_all_rounded,
      ),
      ('Read', campaign.read, const Color(0xFF16A878), Icons.done_all_rounded),
      (
        'Failed',
        campaign.failed,
        const Color(0xFFEF4444),
        Icons.warning_amber_rounded,
      ),
      (
        'Unread',
        unread,
        const Color(0xFF8B5CF6),
        Icons.chat_bubble_outline_rounded,
      ),
    ];

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 560;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 14, 12),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F8EE),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.query_stats_rounded,
                        color: Color(0xFF16B866),
                        size: 21,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery Status',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF263246),
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Campaign message breakdown',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF718096),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFDDE5EF)),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.sensors_rounded,
                            size: 12,
                            color: Color(0xFF16A878),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Live',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF718096),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      onPressed: onClose,
                      tooltip: 'Close',
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(
                        Icons.close,
                        size: 19,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
                child: compact
                    ? Column(
                        children: [
                          SizedBox(
                            height: 190,
                            child: _DeliveryRing(
                              total: total,
                              delivered: campaign.delivered,
                              read: campaign.read,
                              sent: campaign.sent,
                              failed: campaign.failed,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _statusList(statuses, total),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: SizedBox(
                              height: 290,
                              child: _DeliveryRing(
                                total: total,
                                delivered: campaign.delivered,
                                read: campaign.read,
                                sent: campaign.sent,
                                failed: campaign.failed,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 6,
                            child: _statusList(statuses, total),
                          ),
                        ],
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${campaign.name}  •  ${campaign.template}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF718096),
                        ),
                      ),
                    ),
                    TextButton(onPressed: onClose, child: const Text('Close')),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _statusList(List<(String, int, Color, IconData)> statuses, int total) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5EAF2)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE9F5EF),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF344054),
                    ),
                  ),
                ),
                Text(
                  _campaignNumber(total),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF344054),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          ...statuses.map((item) {
            final percent = total == 0 ? 0.0 : item.$2 / total * 100;
            return Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
              decoration: BoxDecoration(
                color: item.$1 == 'Sent' || item.$1 == 'Read'
                    ? Colors.white
                    : const Color(0xFFF7F8FA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(item.$4, size: 15, color: item.$3),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      item.$1,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF344054),
                      ),
                    ),
                  ),
                  Text(
                    _campaignNumber(item.$2),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF344054),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 48,
                    child: Text(
                      '${percent.toStringAsFixed(2)}%',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.ads_click_rounded,
                  size: 15,
                  color: Color(0xFF718096),
                ),
                SizedBox(width: 7),
                Expanded(
                  child: Text(
                    'Click Count',
                    style: TextStyle(fontSize: 11, color: Color(0xFF344054)),
                  ),
                ),
                Text(
                  '0',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF344054),
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.download_outlined,
                  size: 13,
                  color: Color(0xFF718096),
                ),
                SizedBox(width: 7),
                Icon(Icons.link_rounded, size: 13, color: Color(0xFF718096)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _number(int value) => value.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
}

class _DeliveryRing extends StatelessWidget {
  final int total, delivered, read, sent, failed;
  const _DeliveryRing({
    required this.total,
    required this.delivered,
    required this.read,
    required this.sent,
    required this.failed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DeliveryRingPainter(
        total: total,
        delivered: delivered,
        read: read,
        sent: sent,
        failed: failed,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.circle, size: 10, color: Color(0xFF16B866)),
            const SizedBox(height: 3),
            const Text(
              'Total',
              style: TextStyle(fontSize: 10, color: Color(0xFF718096)),
            ),
            const SizedBox(height: 3),
            Text(
              total.toString().replaceAllMapped(
                RegExp(r'\B(?=(\d{3})+(?!\d))'),
                (_) => ',',
              ),
              style: const TextStyle(
                fontSize: 23,
                height: 1.1,
                fontWeight: FontWeight.w800,
                color: Color(0xFF263246),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeliveryRingPainter extends CustomPainter {
  final int total, delivered, read, sent, failed;
  const _DeliveryRingPainter({
    required this.total,
    required this.delivered,
    required this.read,
    required this.sent,
    required this.failed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - 14;
    final values = <(int, Color)>[
      (failed, const Color(0xFFEF4444)),
      (sent, const Color(0xFFF59E0B)),
      (delivered, const Color(0xFF3989FF)),
      (read, const Color(0xFF16A878)),
    ];
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..color = const Color(0xFFE9EDF3);
    for (var i = 0; i < 4; i++) {
      final r = radius - i * 10;
      canvas.drawCircle(center, r, base);
      final value = values[i].$1;
      if (total > 0 && value > 0) {
        final arc = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 9
          ..strokeCap = StrokeCap.round
          ..color = values[i].$2;
        final sweep = (value / total).clamp(0.0, 1.0) * 2 * 3.141592653589793;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: r),
          -3.141592653589793 / 2,
          sweep,
          false,
          arc,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DeliveryRingPainter oldDelegate) =>
      total != oldDelegate.total ||
      delivered != oldDelegate.delivered ||
      read != oldDelegate.read ||
      sent != oldDelegate.sent ||
      failed != oldDelegate.failed;
}

class _WhatsAppOccasion {
  final String name;
  final DateTime date;
  final String region;
  final bool verifyDate;

  const _WhatsAppOccasion({
    required this.name,
    required this.date,
    required this.region,
    this.verifyDate = false,
  });
}

class WhatsAppCampaignReportDetail extends StatelessWidget {
  final Map<String, String> campaign;
  const WhatsAppCampaignReportDetail({super.key, required this.campaign});
  @override
  Widget build(BuildContext context) {
    final recipients = [
      ['919205067680', 'Delivered', '—', '9/9/2026\n4:54:30 pm', '—', '—'],
      [
        '919305011640',
        'Delivered',
        '9/9/2026\n4:54:29 pm',
        '9/9/2026\n4:54:30 pm',
        '—',
        '—',
      ],
      [
        '919990332999',
        'Un Delivered',
        '—',
        '—',
        '—',
        'This message was not delivered to maintain healthy ecosystem engagement.',
      ],
      [
        '917217283381',
        'Un Delivered',
        '—',
        '—',
        '—',
        'This message was not delivered to maintain healthy ecosystem engagement.',
      ],
      ['918448172887', 'Sent', '—', '—', '—', '—'],
      [
        '919198510510',
        'Un Delivered',
        '—',
        '—',
        '—',
        'This message was not delivered to maintain healthy ecosystem engagement.',
      ],
    ];
    return Scaffold(
      backgroundColor: pageColor,
      appBar: buildCpxBoatAppBar(context),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const Text(
              'Reports',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: navy,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Delivery performance across all your WhatsApp campaigns.',
              style: TextStyle(fontSize: 12, color: muted),
            ),
            const SizedBox(height: 18),
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, size: 16),
              label: const Text('Back to campaigns'),
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                foregroundColor: muted,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              campaign['name'] ?? '',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: navy,
              ),
            ),
            Text(
              '${campaign['total']} recipients · 2026-09-09',
              style: const TextStyle(fontSize: 12, color: muted),
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: _cardDecoration(radius: 14),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search phone number...',
                        prefixIcon: const Icon(Icons.search, size: 18),
                        isDense: true,
                        filled: true,
                        fillColor: const Color(0xFFF8F9FC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  ...[
                    'All',
                    'Sent',
                    'Delivered',
                    'Read',
                    'Un Delivered',
                    'Queue',
                  ].map(
                    (v) => OutlinedButton(
                      onPressed: () =>
                          showApiPendingMessage(context, 'report filtering'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        minimumSize: const Size(0, 34),
                      ),
                      child: Text(v, style: const TextStyle(fontSize: 11)),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => saveCsvFile(
                      context,
                      fileName: 'whatsapp_${campaign['name']}_report',
                      headers: campaign.keys.toList(),
                      rows: [campaign.values.toList()],
                    ),
                    icon: const Icon(Icons.download_outlined, size: 15),
                    label: Text('Download (${campaign['total']})'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: _cardDecoration(radius: 12),
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  horizontalMargin: 14,
                  columnSpacing: 30,
                  headingRowHeight: 42,
                  dataRowMinHeight: 60,
                  dataRowMaxHeight: 70,
                  headingRowColor: WidgetStateProperty.all(
                    panelAccent(context),
                  ),
                  headingTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                  dataTextStyle: const TextStyle(fontSize: 12, color: navy),
                  columns: const [
                    DataColumn(label: Text('Mobile Number')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Send Time')),
                    DataColumn(label: Text('Delivery Time')),
                    DataColumn(label: Text('Read Time')),
                    DataColumn(label: Text('Error')),
                  ],
                  rows: recipients
                      .map(
                        (r) => DataRow(
                          cells: [
                            DataCell(Text(r[0])),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: r[1] == 'Delivered'
                                      ? const Color(0xFFE5F4F8)
                                      : r[1] == 'Sent'
                                      ? const Color(0xFFFFF2E0)
                                      : const Color(0xFFFDEBEC),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  r[1],
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: r[1] == 'Delivered'
                                        ? panelAccent(context)
                                        : r[1] == 'Sent'
                                        ? const Color(0xFFEA8500)
                                        : const Color(0xFFEF4444),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(Text(r[2])),
                            DataCell(Text(r[3])),
                            DataCell(Text(r[4])),
                            DataCell(
                              SizedBox(
                                width: 260,
                                child: Text(
                                  r[5],
                                  style: TextStyle(
                                    color: r[5] == '—'
                                        ? muted
                                        : const Color(0xFFEF4444),
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 10, color: muted)),
    ],
  );
}

class _PerformanceLegend extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  const _PerformanceLegend({
    required this.color,
    required this.label,
    required this.value,
  });
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 7),
      Expanded(
        child: Text(label, style: const TextStyle(fontSize: 12, color: navy)),
      ),
      Text(value, style: const TextStyle(fontSize: 12, color: muted)),
    ],
  );
}

class _SMSActivityPainter extends CustomPainter {
  const _SMSActivityPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = const Color(0xFFDCE3EE)
      ..strokeWidth = 1;
    final baseline = Paint()
      ..color = const Color(0xFFEF5350)
      ..strokeWidth = 1.5;
    final labels = TextPainter(textDirection: TextDirection.ltr);
    const left = 28.0, bottom = 25.0, top = 8.0;
    final chartW = size.width - left - 4, chartH = size.height - bottom - top;
    for (var i = 0; i <= 4; i++) {
      final y = top + chartH * i / 4;
      canvas.drawLine(Offset(left, y), Offset(size.width - 2, y), grid);
      labels.text = TextSpan(
        text: '${4 - i}',
        style: const TextStyle(fontSize: 10, color: muted),
      );
      labels.layout();
      labels.paint(canvas, Offset(0, y - 6));
    }
    canvas.drawLine(
      Offset(left, top + chartH),
      Offset(size.width - 2, top + chartH),
      baseline,
    );
    for (var i = 0; i < 10; i++) {
      final x = left + chartW * i / 9;
      labels.text = TextSpan(
        text: '${7 + i}/10',
        style: const TextStyle(fontSize: 9, color: muted),
      );
      labels.layout();
      labels.paint(canvas, Offset(x - labels.width / 2, size.height - 16));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RCSActivitySummaryCard extends StatelessWidget {
  const _RCSActivitySummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(radius: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Campaign activity — last 10 days',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: navy,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFE),
                  border: Border.all(color: const Color(0xFFD9E2F1)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Last 10 days  ⌄',
                  style: TextStyle(fontSize: 11, color: navy),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const SizedBox(
            height: 235,
            width: double.infinity,
            child: CustomPaint(painter: RCSActivityPainter()),
          ),
        ],
      ),
    );
  }
}

class _RCSDeliverySummaryCard extends StatelessWidget {
  const _RCSDeliverySummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(radius: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivery performance',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: navy,
            ),
          ),
          const SizedBox(height: 48),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total messages',
                      style: TextStyle(fontSize: 12, color: muted),
                    ),
                    SizedBox(height: 14),
                    _RCSDeliveryLegend(
                      color: Color(0xFFE9A52A),
                      label: 'Sent',
                      value: '0%',
                    ),
                    _RCSDeliveryLegend(
                      color: Color(0xFF3989D9),
                      label: 'Delivered',
                      value: '0%',
                    ),
                    _RCSDeliveryLegend(
                      color: Color(0xFF20A36A),
                      label: 'Read',
                      value: '0%',
                    ),
                    _RCSDeliveryLegend(
                      color: Color(0xFFE94B50),
                      label: 'Failed',
                      value: '100%',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 132,
                height: 150,
                child: CustomPaint(
                  painter: RCSDeliveryDonutPainter(),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '24',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: navy,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Total RCS Sent',
                          style: TextStyle(fontSize: 9, color: muted),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5EF),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Row(
              children: [
                Icon(Icons.circle, color: Color(0xFF20A36A), size: 9),
                SizedBox(width: 7),
                Expanded(
                  child: Text(
                    'Delivery rate',
                    style: TextStyle(fontSize: 11, color: muted),
                  ),
                ),
                Text(
                  '0%',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF20A36A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RCSRecentCampaignsCard extends StatelessWidget {
  final bool medium;

  const _RCSRecentCampaignsCard({required this.medium});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: _cardDecoration(radius: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 16, 12),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Recent campaigns',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: navy,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      showApiPendingMessage(context, 'the full campaign list'),
                  child: Text(
                    'View all →',
                    style: TextStyle(color: panelAccent(context), fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              horizontalMargin: 20,
              columnSpacing: medium ? 34 : 18,
              headingRowHeight: 42,
              dataRowMinHeight: 58,
              dataRowMaxHeight: 58,
              headingRowColor: WidgetStateProperty.all(panelAccent(context)),
              headingTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              dataTextStyle: const TextStyle(color: muted, fontSize: 12),
              columns: const [
                DataColumn(
                  label: SizedBox(width: 180, child: Text('Campaign name')),
                ),
                DataColumn(
                  label: SizedBox(width: 150, child: Text('Template name')),
                ),
                DataColumn(label: SizedBox(width: 70, child: Text('Count'))),
                DataColumn(
                  label: SizedBox(width: 150, child: Text('Date & time')),
                ),
                DataColumn(label: SizedBox(width: 110, child: Text('Status'))),
              ],
              rows: const [
                DataRow(
                  cells: [
                    DataCell(Text('real camp')),
                    DataCell(Text('webtech_carousel')),
                    DataCell(Text('1')),
                    DataCell(Text('14 Oct, 01:15 pm')),
                    DataCell(Text('Completed')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('fvf')),
                    DataCell(Text('webtech_carousel')),
                    DataCell(Text('19')),
                    DataCell(Text('13 Oct, 12:15 pm')),
                    DataCell(Text('Completed')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('dfd')),
                    DataCell(Text('real')),
                    DataCell(Text('2')),
                    DataCell(Text('13 Oct, 11:52 am')),
                    DataCell(Text('Completed')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RCSDeliveryLegend extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  const _RCSDeliveryLegend({
    required this.color,
    required this.label,
    required this.value,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Icon(Icons.circle, color: color, size: 9),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label, style: const TextStyle(fontSize: 12, color: navy)),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    ),
  );
}

class RCSActivityPainter extends CustomPainter {
  const RCSActivityPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const left = 28.0, right = 8.0, top = 35.0, bottom = 28.0;
    final w = size.width - left - right;
    final h = size.height - top - bottom;
    final grid = Paint()
      ..color = const Color(0xFFE1E7F0)
      ..strokeWidth = 1;
    final text = TextPainter(textDirection: TextDirection.ltr);
    for (var i = 0; i <= 4; i++) {
      final y = top + h * i / 4;
      canvas.drawLine(Offset(left, y), Offset(size.width - right, y), grid);
      text.text = TextSpan(
        text: '${24 - i * 6}',
        style: const TextStyle(fontSize: 9, color: muted),
      );
      text.layout();
      text.paint(canvas, Offset(2, y - 6));
    }
    const labels = [
      '6/10',
      '7/10',
      '8/10',
      '9/10',
      '10/10',
      '11/10',
      '12/10',
      '13/10',
      '14/10',
      '15/10',
    ];
    for (var i = 0; i < labels.length; i++) {
      text.text = TextSpan(
        text: labels[i],
        style: const TextStyle(fontSize: 9, color: muted),
      );
      text.layout();
      text.paint(
        canvas,
        Offset(left + w * i / 9 - text.width / 2, top + h + 7),
      );
    }
    final legend = <(String, Color)>[
      ('Delivered', const Color(0xFF3989D9)),
      ('Failed', const Color(0xFFE94B50)),
      ('Read', const Color(0xFF20A36A)),
      ('Sent', const Color(0xFFE9A52A)),
    ];
    var lx = (size.width - 210) / 2;
    for (final item in legend) {
      canvas.drawCircle(Offset(lx, 15), 3.5, Paint()..color = item.$2);
      text.text = TextSpan(
        text: item.$1,
        style: const TextStyle(fontSize: 9, color: muted),
      );
      text.layout();
      text.paint(canvas, Offset(lx + 7, 9));
      lx += text.width + 24;
    }
    const vals = [0.0, 0, 0, 0, 0, 0, .01, .05, .10, .92, .36, .05, .02, 0];
    final points = <Offset>[];
    for (var i = 0; i < vals.length; i++) {
      points.add(
        Offset(left + w * i / (vals.length - 1), top + h * (1 - vals[i])),
      );
    }
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final prev = points[i - 1], cur = points[i], mid = (prev.dx + cur.dx) / 2;
      path.cubicTo(mid, prev.dy, mid, cur.dy, cur.dx, cur.dy);
    }
    final fill = Path.from(path)
      ..lineTo(points.last.dx, top + h)
      ..lineTo(points.first.dx, top + h)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0x33E94B50), Color(0x00E94B50)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(left, top, w, h)),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFFF343B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );
  }

  @override
  bool shouldRepaint(covariant RCSActivityPainter oldDelegate) => false;
}

class RCSDeliveryDonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * .39;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xFFE94B50)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12,
    );
  }

  @override
  bool shouldRepaint(covariant RCSDeliveryDonutPainter oldDelegate) => false;
}

class _RCSCardDraft {
  final title = TextEditingController();
  final description = TextEditingController();
  int suggestions = 0;
  void dispose() {
    title.dispose();
    description.dispose();
  }
}

class _SMSTemplateRecord {
  const _SMSTemplateRecord(
    this.name,
    this.id,
    this.senderId,
    this.categoryLabel,
    this.content,
    this.category,
  );

  final String name;
  final String id;
  final String senderId;
  final String categoryLabel;
  final String content;
  final String category;
}

class _SMSTableHeader extends StatelessWidget {
  const _SMSTableHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: TextStyle(
      color: Colors.white,
      fontSize: 11,
      fontWeight: FontWeight.w700,
    ),
  );
}

class _RCSTemplateRecord {
  String name;
  final String type;
  final String category;
  String status;
  String message;
  final String created;

  _RCSTemplateRecord(
    this.name,
    this.type,
    this.category,
    this.status,
    this.message,
    this.created,
  );
}

class _RCSChatbotReply {
  String keyword;
  String reply;
  _RCSChatbotReply(this.keyword, this.reply);
}

class _FallbackPerformanceLine extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color? dot;
  const _FallbackPerformanceLine(
    this.label,
    this.value,
    this.color, {
    this.dot,
  });
  @override
  Widget build(BuildContext context) => Row(
    children: [
      if (dot != null) ...[
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
        ),
        const SizedBox(width: 7),
      ],
      Expanded(
        child: Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF17233C)),
        ),
      ),
      Text(
        value,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    ],
  );
}

class _FallbackLineChart extends StatelessWidget {
  const _FallbackLineChart();
  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _FallbackChartPainter(),
    child: const SizedBox.expand(),
  );
}

class _FallbackChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const left = 28.0, right = 10.0, top = 32.0, bottom = 28.0;
    final w = size.width - left - right;
    final h = size.height - top - bottom;
    final grid = Paint()
      ..color = const Color(0xFFDCE3EF)
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final y = top + h * i / 4;
      canvas.drawLine(Offset(left, y), Offset(size.width - right, y), grid);
      final tp = TextPainter(
        text: TextSpan(
          text: '${4 - i}',
          style: const TextStyle(fontSize: 10, color: Color(0xFF60758F)),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(3, y - 6));
    }
    final legend = <(String, Color)>[
      ('Delivered', const Color(0xFF4285FF)),
      ('Failed', const Color(0xFFEF4444)),
      ('Read', const Color(0xFF24A36A)),
      ('Sent', const Color(0xFFFF9800)),
    ];
    var lx = (size.width - 350).clamp(0.0, size.width);
    for (final e in legend) {
      canvas.drawCircle(Offset(lx + 3, 12), 3, Paint()..color = e.$2);
      final tp = TextPainter(
        text: TextSpan(
          text: e.$1,
          style: const TextStyle(fontSize: 9, color: Color(0xFF60758F)),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(lx + 10, 7));
      lx += tp.width + 27;
    }
    final red = Paint()
      ..color = const Color(0xFFEF4444)
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(left, top + h),
      Offset(size.width - right, top + h),
      red,
    );
    const days = [
      '7/10',
      '8/10',
      '9/10',
      '10/10',
      '11/10',
      '12/10',
      '13/10',
      '14/10',
      '15/10',
      '16/10',
    ];
    for (var i = 0; i < days.length; i++) {
      final x = left + w * i / (days.length - 1);
      final tp = TextPainter(
        text: TextSpan(
          text: days[i],
          style: const TextStyle(fontSize: 9, color: Color(0xFF60758F)),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, size.height - 17));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FallbackDonutPainter extends CustomPainter {
  const _FallbackDonutPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFEAEDF3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2 - 7,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DashboardDrawer extends StatefulWidget {
  final String currentPage;
  final String? currentGroup;

  const DashboardDrawer({
    super.key,
    this.currentPage = 'Smart Home',
    this.currentGroup,
  });

  @override
  State<DashboardDrawer> createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends State<DashboardDrawer> {
  final Map<String, bool> expanded = {
    'Dashboard': true,

    'WhatsApp-App': false,

    'RCS-App': false,

    'SMS-App': false,

    'Smart Fallback': false,

    'CRM & Automation': false,

    'Groups & Roles': false,

    'Connectivity': false,

    'Manage Settings': false,
  };

  late String selectedItem;

  @override
  void initState() {
    super.initState();

    selectedItem = widget.currentPage;
    final currentGroup =
        widget.currentGroup ?? _groupForPage(widget.currentPage);
    if (currentGroup != null && expanded.containsKey(currentGroup)) {
      expanded[currentGroup] = true;
    }
  }

  String? _groupForPage(String page) {
    switch (page) {
      case 'Smart Home':
      case 'MIS Reports':
        return 'Dashboard';
      case 'Chatbot Flow':
      case 'Flows':
      case 'Commerce':
      case 'Business Profile':
      case 'Quick Links':
      case 'Tier Limit':
        return 'WhatsApp-App';
      case 'Chatbot':
        return 'RCS-App';
      case 'Sender IDs':
        return 'SMS-App';
      case 'Overview':
      case 'Leads':
      case 'Automations':
      case 'Lead Sources':
      case 'CRM Settings':
        return 'CRM & Automation';
      case 'Contact Groups':
      case 'Agent Roles':
        return 'Groups & Roles';
      case 'Channels Info':
      case 'Onboard Channels':
        return 'Connectivity';
      case 'Account Details':
      case 'Security':
      case 'Panel Theme':
        return 'Manage Settings';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width < 340
          ? MediaQuery.sizeOf(context).width - 20
          : 292,

      backgroundColor: Colors.transparent,

      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,

            end: Alignment.bottomRight,

            colors: [
              Color.lerp(panelAccent(context), Colors.black, .42)!,
              Color.lerp(panelAccent(context), Colors.black, .24)!,
              Color.lerp(panelAccent(context), Colors.black, .08)!,
            ],

            stops: [0.0, 0.58, 1.0],
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 16, 17),
                child: Row(
                  children: [
                    ColorFiltered(
                      colorFilter: ColorFilter.matrix(
                        cpxBoatLogoColorMatrix(panelAccent(context)),
                      ),
                      child: Image.asset(
                        'assets/logo.png',
                        width: 130,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white54,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.fromLTRB(21, 0, 18, 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'MESSAGING WORKSPACE',
                    style: TextStyle(
                      color: Color(0xFF8491AA),
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.25,
                    ),
                  ),
                ),
              ),
              const Divider(height: 1, color: Color(0xFF29334A)),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(10, 12, 10, 16),

                  children: [
                    _navGroup(
                      title: 'Dashboard',

                      icon: Icons.grid_view_rounded,

                      children: const ['Smart Home', 'MIS Reports'],
                    ),

                    _navGroup(
                      title: 'WhatsApp-App',

                      icon: Icons.chat_bubble_outline_rounded,

                      children: const [
                        'Dashboard',

                        'Inbox',

                        'Campaigns',

                        'Templates',

                        'Chatbot Flow',

                        'Flows',

                        'Commerce',

                        'Occasions',

                        'INSIGHTS',

                        'Reports',

                        'Scheduled',

                        'NEW FEATURES',

                        'Business Profile',

                        'Quick Links',

                        'Tier Limit',
                      ],
                    ),

                    _navGroup(
                      title: 'RCS-App',

                      icon: Icons.sensors_rounded,

                      children: const [
                        'Dashboard',

                        'Inbox',

                        'Campaigns',

                        'Templates',

                        'Chatbot',

                        'Occasions',

                        'INSIGHTS',

                        'Reports',

                        'Scheduled',
                      ],
                    ),

                    _navGroup(
                      title: 'SMS-App',

                      icon: Icons.sms_outlined,

                      children: const [
                        'Dashboard',

                        'Campaigns',

                        'Templates',

                        'Sender IDs',

                        'Occasions',

                        'INSIGHTS',

                        'Reports',

                        'Scheduled',
                      ],
                    ),

                    _navGroup(
                      title: 'Smart Fallback',

                      icon: Icons.shuffle_rounded,

                      children: const [
                        'Dashboard',

                        'Campaigns',

                        'Occasions',

                        'INSIGHTS',

                        'Reports',
                      ],
                    ),

                    _navGroup(
                      title: 'CRM & Automation',

                      icon: Icons.contact_page_outlined,

                      children: const [
                        'Overview',

                        'Leads',

                        'Automations',

                        'Lead Sources',

                        'CRM Settings',
                      ],
                    ),

                    _navGroup(
                      title: 'AI Assistant',

                      icon: Icons.auto_awesome_outlined,

                      children: const [],

                      isSingle: true,
                    ),

                    _navGroup(
                      title: 'Groups & Roles',

                      icon: Icons.people_outline_rounded,

                      children: const ['Contact Groups', 'Agent Roles'],
                    ),

                    _navGroup(
                      title: 'Manage Billings',

                      icon: Icons.account_balance_wallet_outlined,

                      children: const [],

                      isSingle: true,
                    ),

                    _navGroup(
                      title: 'Connectivity',

                      icon: Icons.power_outlined,

                      children: const ['Channels Info', 'Onboard Channels'],
                    ),

                    _navGroup(
                      title: 'Manage Settings',

                      icon: Icons.settings_outlined,

                      children: const [
                        'Account Details',

                        'Security',

                        'Panel Theme',
                      ],
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, color: Color(0xFF29334A)),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),

                child: Text(
                  '© CPXBOAT',

                  style: TextStyle(color: Color(0xFF8791A6), fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navGroup({
    required String title,

    required IconData icon,

    required List<String> children,

    bool isSingle = false,
  }) {
    final isExpanded = expanded[title] ?? false;

    final hasChildren = children.isNotEmpty;
    final isActive = isSingle && selectedItem == title;

    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(10),

          onTap: () {
            if (isSingle) {
              _select(title);
            } else {
              setState(() => expanded[title] = !isExpanded);
            }
          },

          child: Container(
            decoration: isActive
                ? BoxDecoration(
                    color: panelAccent(context),
                    borderRadius: BorderRadius.circular(10),
                  )
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 19,
                    color: isExpanded || isActive
                        ? Colors.white
                        : const Color(0xFFB5BED0),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: isExpanded || isActive
                            ? Colors.white
                            : const Color(0xFFD8DEEA),
                        fontSize: 12,
                        fontWeight: isExpanded || isActive
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                  if (hasChildren)
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: const Color(0xFF9AA5BA),
                      size: 18,
                    ),
                ],
              ),
            ),
          ),
        ),

        if (hasChildren && isExpanded)
          ...children.map((item) {
            final isLabel = item == 'INSIGHTS' || item == 'NEW FEATURES';

            if (isLabel) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(27, 10, 8, 6),

                child: Align(
                  alignment: Alignment.centerLeft,

                  child: Text(
                    item,

                    style: TextStyle(
                      color: Color(0xFF7D8AA4),

                      fontSize: 10,

                      fontWeight: FontWeight.w800,

                      letterSpacing: .7,
                    ),
                  ),
                ),
              );
            }

            final active =
                selectedItem == item &&
                (widget.currentGroup == null || widget.currentGroup == title);

            final childIcon = _childIcon(item);

            return Padding(
              padding: const EdgeInsets.only(left: 9, bottom: 3),

              child: Material(
                color: active ? panelAccent(context) : Colors.transparent,

                borderRadius: BorderRadius.circular(9),

                child: InkWell(
                  borderRadius: BorderRadius.circular(9),

                  onTap: () => _select(item, parentGroup: title),

                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,

                      vertical: 10,
                    ),

                    child: Row(
                      children: [
                        Icon(
                          childIcon,

                          size: 17,

                          color: active
                              ? Colors.white
                              : const Color(0xFFAEB8CB),
                        ),

                        const SizedBox(width: 11),

                        Expanded(
                          child: Text(
                            item,

                            style: TextStyle(
                              color: active
                                  ? Colors.white
                                  : const Color(0xFFD0D7E5),

                              fontSize: 12,

                              fontWeight: active
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

        const SizedBox(height: 2),
      ],
    );
  }

  IconData _childIcon(String item) {
    switch (item) {
      case 'Smart Home':
      case 'Dashboard':
      case 'Overview':
        return Icons.grid_view_rounded;

      case 'MIS Reports':
      case 'Reports':
        return Icons.bar_chart_rounded;

      case 'Inbox':
        return Icons.inbox_outlined;

      case 'Campaigns':
        return Icons.send_outlined;

      case 'Templates':
        return Icons.description_outlined;

      case 'Chatbot Flow':
      case 'Chatbot':
        return Icons.smart_toy_outlined;

      case 'Flows':
      case 'Automations':
        return Icons.account_tree_outlined;

      case 'Commerce':
        return Icons.shopping_bag_outlined;

      case 'Occasions':
        return Icons.celebration_outlined;

      case 'Scheduled':
        return Icons.schedule_rounded;

      case 'Business Profile':
      case 'Account Details':
        return Icons.business_outlined;

      case 'Quick Links':
        return Icons.qr_code_2_rounded;

      case 'Tier Limit':
        return Icons.speed_rounded;

      case 'Sender IDs':
        return Icons.tag_rounded;

      case 'Leads':
      case 'Contact Groups':
        return Icons.people_outline_rounded;

      case 'Lead Sources':
        return Icons.hub_outlined;

      case 'CRM Settings':
      case 'Panel Theme':
        return Icons.tune_rounded;

      case 'Agent Roles':
      case 'Security':
        return Icons.verified_user_outlined;

      case 'Channels Info':
        return Icons.sensors_rounded;

      case 'Onboard Channels':
        return Icons.power_outlined;

      default:
        return Icons.circle_outlined;
    }
  }

  void _select(String item, {String? parentGroup}) {
    setState(() => selectedItem = item);
    Navigator.pop(context);

    if (item == 'Onboard Channels') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardChannelsScreen()),
      );
      return;
    }

    if (item == 'Channels Info') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ChannelsInfoScreen()),
      );
      return;
    }

    if (item == 'Account Details') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AccountDetailsScreen()),
      );
      return;
    }

    if (item == 'Security') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SecurityScreen()),
      );
      return;
    }

    if (item == 'Panel Theme') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const PanelThemeScreen()),
      );
      return;
    }

    if (item == 'Manage Billings') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ManageBillingScreen()),
      );
      return;
    }

    if (item == 'Agent Roles') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AgentRolesScreen()),
      );
      return;
    }

    if (item == 'Contact Groups') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ContactGroupsScreen()),
      );
      return;
    }

    if (item == 'AI Assistant') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AIAssistantScreen()),
      );
      return;
    }

    if (item == 'MIS Reports') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MISReportsScreen()),
      );
      return;
    }

    if (item == 'Reports' && parentGroup == 'RCS-App') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RCSReportsScreen()),
      );
      return;
    }

    if (item == 'Reports' && parentGroup == 'WhatsApp-App') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WhatsAppReportsScreen()),
      );
      return;
    }

    if (item == 'Scheduled' && parentGroup == 'WhatsApp-App') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WhatsAppScheduledScreen()),
      );
      return;
    }

    if (item == 'Tier Limit' && parentGroup == 'WhatsApp-App') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WhatsAppTierLimitScreen()),
      );
      return;
    }

    if (item == 'Business Profile' && parentGroup == 'WhatsApp-App') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const WhatsAppBusinessProfileScreen(),
        ),
      );
      return;
    }

    if (item == 'Quick Links' && parentGroup == 'WhatsApp-App') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WhatsAppQuickLinksScreen()),
      );
      return;
    }

    if (item == 'Dashboard' && parentGroup == 'WhatsApp-App') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WhatsAppDashboardScreen()),
      );
      return;
    }

    if (item == 'Inbox' && parentGroup == 'WhatsApp-App') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WhatsAppInboxScreen()),
      );
      return;
    }

    if (item == 'Campaigns' && parentGroup == 'WhatsApp-App') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WhatsAppCampaignsScreen()),
      );
      return;
    }

    if (item == 'Chatbot Flow' && parentGroup == 'WhatsApp-App') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WhatsAppChatbotFlowScreen()),
      );
      return;
    }

    if (item == 'Templates' && parentGroup == 'WhatsApp-App') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WhatsAppTemplatesScreen()),
      );
      return;
    }

    if (item == 'Commerce' && parentGroup == 'WhatsApp-App') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WhatsAppCommerceScreen()),
      );
      return;
    }

    if (item == 'Flows' && parentGroup == 'WhatsApp-App') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WhatsAppFlowsScreen()),
      );
      return;
    }

    if (item == 'Occasions' && parentGroup == 'WhatsApp-App') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WhatsAppOccasionsScreen()),
      );
      return;
    }

    if (item == 'Occasions' && parentGroup == 'RCS-App') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RCSOccasionsScreen()),
      );
      return;
    }

    if (item == 'Inbox' && parentGroup == 'RCS-App') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RCSInboxScreen()),
      );
      return;
    }

    if (item == 'Campaigns' && parentGroup == 'RCS-App') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RCSCampaignsScreen()),
      );
      return;
    }

    if (item == 'Templates' && parentGroup == 'RCS-App') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RCSTemplatesScreen()),
      );
      return;
    }

    if (item == 'Chatbot' && parentGroup == 'RCS-App') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RCSChatbotScreen()),
      );
      return;
    }

    if (item == 'Scheduled' && parentGroup == 'RCS-App') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RCSScheduledScreen()),
      );
      return;
    }

    if (item == 'Dashboard' && parentGroup == 'RCS-App') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RCSDashboardScreen()),
      );
      return;
    }

    if (item == 'Dashboard' && parentGroup == 'SMS-App') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SMSDashboardScreen()),
      );
      return;
    }

    if (item == 'Overview' && parentGroup == 'CRM & Automation') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CRMOverviewScreen()),
      );
      return;
    }

    if (item == 'Leads' && parentGroup == 'CRM & Automation') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CRMLeadsScreen()),
      );
      return;
    }

    if (item == 'Automations' && parentGroup == 'CRM & Automation') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CRMAutomationsScreen()),
      );
      return;
    }

    if (item == 'Lead Sources' && parentGroup == 'CRM & Automation') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CRMLeadSourcesScreen()),
      );
      return;
    }

    if (item == 'CRM Settings' && parentGroup == 'CRM & Automation') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CRMSettingsScreen()),
      );
      return;
    }

    if (item == 'Dashboard' && parentGroup == 'Smart Fallback') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SmartFallbackDashboardScreen()),
      );
      return;
    }

    if (item == 'Occasions' && parentGroup == 'Smart Fallback') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SmartFallbackOccasionsScreen()),
      );
      return;
    }

    if (item == 'Campaigns' && parentGroup == 'Smart Fallback') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SmartFallbackCampaignsScreen()),
      );
      return;
    }

    if (item == 'Reports' && parentGroup == 'Smart Fallback') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SmartFallbackReportsScreen()),
      );
      return;
    }

    if (item == 'Templates' && parentGroup == 'SMS-App') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SMSTemplatesScreen()),
      );
      return;
    }

    if (item == 'Campaigns' && parentGroup == 'SMS-App') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SMSCampaignsScreen()),
      );
      return;
    }

    if (item == 'Occasions' && parentGroup == 'SMS-App') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SMSOccasionsScreen()),
      );
      return;
    }

    if (item == 'Reports' && parentGroup == 'SMS-App') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SMSReportsScreen()),
      );
      return;
    }

    if (item == 'Scheduled' && parentGroup == 'SMS-App') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SMSScheduledScreen()),
      );
      return;
    }

    if (item == 'Smart Home' || item == 'Dashboard') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$item selected'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

BoxDecoration _cardDecoration({double radius = 16}) => BoxDecoration(
  color: premiumSurface,
  borderRadius: BorderRadius.circular(radius),
  border: Border.all(color: premiumBorder),
  boxShadow: const [
    BoxShadow(
      color: Color(0x0A10192D),
      blurRadius: 16,
      spreadRadius: 0,
      offset: Offset(0, 5),
    ),
  ],
);

class _OnboardStep extends StatelessWidget {
  final IconData icon;
  final String label;
  const _OnboardStep({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: Colors.white70, size: 13),
      const SizedBox(width: 5),
      Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

class _OnboardChannelCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final String status;
  final bool connected;
  final bool completed;
  const _OnboardChannelCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.status,
    this.connected = false,
    this.completed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 138),
      padding: const EdgeInsets.fromLTRB(13, 12, 13, 11),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD8DFEA)),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 27,
                height: 27,
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Icon(icon, color: Colors.white, size: 17),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F4F8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.circle, color: Color(0xFF3FA56A), size: 5),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: const TextStyle(fontSize: 8, color: muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: navy,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: const TextStyle(color: muted, fontSize: 10, height: 1.35),
          ),
          const SizedBox(height: 10),
          if (connected)
            const Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF1AA66A),
                  size: 13,
                ),
                SizedBox(width: 5),
                Text(
                  'Connected',
                  style: TextStyle(
                    color: Color(0xFF1AA66A),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          if (connected) const SizedBox(height: 5),
          if (completed || connected)
            OutlinedButton(
              onPressed: connected
                  ? () => showApiPendingMessage(
                      context,
                      'connecting another account',
                    )
                  : null,
              style: OutlinedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                minimumSize: const Size(0, 25),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                side: const BorderSide(color: Color(0xFFD8DFEA)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text(
                connected ? 'Connect another account' : 'Completed',
                style: const TextStyle(
                  color: Color(0xFF344054),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            OutlinedButton(
              onPressed: () => showApiPendingMessage(context, 'channel setup'),
              style: OutlinedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                minimumSize: const Size(0, 25),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                side: const BorderSide(color: Color(0xFFD8DFEA)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                'Connect Channel',
                style: TextStyle(
                  color: Color(0xFF344054),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class DonutPainter extends CustomPainter {
  final int delivered;

  final int failed;

  final int initiated;

  final int read;

  DonutPainter({
    required this.delivered,

    required this.failed,

    required this.initiated,

    required this.read,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final radius = (size.height < size.width ? size.height : size.width) * .34;

    final rect = Rect.fromCircle(center: center, radius: radius);

    const colors = [
      Color(0xFF16A878),

      Color(0xFFE45D61),

      Color(0xFFE9A52A),

      Color(0xFF3989D9),
    ];

    final values = [delivered, failed, initiated, read];

    final total = values.fold<int>(0, (sum, value) => sum + value);

    final base = Paint()
      ..color = const Color(0xFFE8EDF5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13;

    canvas.drawCircle(center, radius, base);

    if (total == 0) return;

    var start = -1.5708;

    for (var i = 0; i < values.length; i++) {
      if (values[i] <= 0) continue;

      final sweep = 6.28318 * values[i] / total;

      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 13
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(rect, start, sweep, false, paint);

      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant DonutPainter oldDelegate) =>
      delivered != oldDelegate.delivered ||
      failed != oldDelegate.failed ||
      initiated != oldDelegate.initiated ||
      read != oldDelegate.read;
}

class TrafficPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const left = 20.0;
    const top = 8.0;

    final right = size.width - 5;
    final bottom = size.height - 20;

    final gridPaint = Paint()
      ..color = const Color(0xFFE4E8EF)
      ..strokeWidth = 1;

    for (var i = 0; i <= 4; i++) {
      final y = top + (bottom - top) * i / 4;

      canvas.drawLine(Offset(left, y), Offset(right, y), gridPaint);

      final text = TextPainter(
        text: TextSpan(
          text: '${20 - i * 5}',
          style: const TextStyle(fontSize: 8, color: muted),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      text.paint(canvas, Offset(0, y - 5));
    }

    final series = <Color, List<double>>{
      const Color(0xFFE9A52A): [20, 7, 9, 6, 8, 5, 12, 7, 16],
      const Color(0xFF16A878): [3, 6, 4, 3, 2, 4, 3, 9, 3],
    };

    for (final entry in series.entries) {
      final points = <Offset>[];

      for (var i = 0; i < entry.value.length; i++) {
        points.add(
          Offset(
            left + (right - left) * i / (entry.value.length - 1),
            bottom - (bottom - top) * entry.value[i] / 20,
          ),
        );
      }

      final path = Path()..moveTo(points.first.dx, points.first.dy);

      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }

      canvas.drawPath(
        path,
        Paint()
          ..color = entry.key
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );

      final dotPaint = Paint()..color = entry.key;

      for (final point in points) {
        canvas.drawCircle(point, 2, dotPaint);
      }
    }

    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    for (var i = 0; i < days.length; i++) {
      final x = left + (right - left) * i / (days.length - 1);

      final text = TextPainter(
        text: TextSpan(
          text: days[i],
          style: const TextStyle(fontSize: 8, color: muted),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      text.paint(canvas, Offset(x - text.width / 2, size.height - 12));
    }
  }

  @override
  bool shouldRepaint(covariant TrafficPainter oldDelegate) => false;
}

class _KeyStep extends StatelessWidget {
  final String n, title, body;
  const _KeyStep({required this.n, required this.title, required this.body});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 17,
          height: 17,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFFE4F4F8),
            shape: BoxShape.circle,
          ),
          child: Text(
            n,
            style: TextStyle(
              fontSize: 9,
              color: panelAccent(context),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 10.5,
                height: 1.35,
                color: Color(0xFF475267),
              ),
              children: [
                TextSpan(
                  text: title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                TextSpan(text: ' $body'),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _PromptCard extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  const _PromptCard(this.icon, this.title, this.subtitle);
  @override
  Widget build(BuildContext context) => Container(
    width: 145,
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xFFD8DFEA)),
      borderRadius: BorderRadius.circular(9),
      color: const Color(0xFFFAFBFE),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 23,
          height: 23,
          decoration: BoxDecoration(
            color: const Color(0xFFE4F4F8),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 13, color: panelAccent(context)),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  color: navy,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 8.5, color: muted),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _CRMOverviewChartPainter extends CustomPainter {
  final Color accent;

  const _CRMOverviewChartPainter({required this.accent});

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = const Color(0xFFDCE3EE)
      ..strokeWidth = 1;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    const left = 26.0;
    const bottom = 20.0;
    final chartHeight = size.height - bottom - 8;
    for (var i = 0; i <= 4; i++) {
      final y = 8 + chartHeight * i / 4;
      canvas.drawLine(Offset(left, y), Offset(size.width, y), grid);
      textPainter.text = TextSpan(
        text: '${4 - i}',
        style: const TextStyle(fontSize: 9, color: Color(0xFF667892)),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(2, y - 6));
    }
    final bar = Paint()..color = accent;
    final top = 8 + chartHeight * 3 / 4;
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(left + 40, top, size.width - left - 80, chartHeight / 4),
        topLeft: const Radius.circular(3),
        topRight: const Radius.circular(3),
      ),
      bar,
    );
    textPainter.text = const TextSpan(
      text: '12 Oct',
      style: TextStyle(fontSize: 9, color: Color(0xFF667892)),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((size.width - textPainter.width) / 2, size.height - 12),
    );
  }

  @override
  bool shouldRepaint(covariant _CRMOverviewChartPainter oldDelegate) =>
      accent != oldDelegate.accent;
}

class _UnknownStatusChip extends StatelessWidget {
  const _UnknownStatusChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF0F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Unknown',
        style: TextStyle(fontSize: 10, color: Color(0xFF718096)),
      ),
    );
  }
}

// Manage Billings page modeled on the supplied reference screenshots.

class _ChatbotKeyStep extends StatelessWidget {
  const _ChatbotKeyStep({
    required this.number,
    required this.title,
    required this.detail,
  });
  final String number;
  final String title;
  final String detail;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 18,
          height: 18,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFFE3F6FA),
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: panelAccent(context),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 10.5,
                height: 1.35,
                color: Color(0xFF334155),
              ),
              children: [
                TextSpan(
                  text: title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                TextSpan(text: ' $detail'),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
