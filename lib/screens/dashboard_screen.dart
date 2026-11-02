part of '../app.dart';

typedef _DashboardTotals = ({
  int initiated,
  int delivered,
  int read,
  int failed,
});

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String channel = 'RCS';
  String period = 'This Month';
  int selectedTab = 0;

  static const _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  DateTime? _parseReportDate(String value) {
    final parts = value.split(' ');
    if (parts.length != 3) return null;

    final day = int.tryParse(parts[0]);
    final month = _monthNames.indexOf(parts[1]) + 1;
    final year = int.tryParse(parts[2]);
    if (day == null || month == 0 || year == null) return null;

    return DateTime(year, month, day);
  }

  List<List<String>> _filteredReportRows() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = switch (period) {
      'Today' => today,
      'This Week' => today.subtract(Duration(days: today.weekday - 1)),
      'This Year' => DateTime(today.year),
      _ => DateTime(today.year, today.month),
    };
    final channelKey = channel == 'WhatsApp' ? 'Whatsapp' : channel;
    final rows =
        dashboardReportRowsByChannel[channelKey] ?? const <List<String>>[];

    return rows.where((row) {
      if (row.length < 9) {
        throw const FormatException('A dashboard report row is incomplete.');
      }
      final date = _parseReportDate(row[2]);
      return date != null && !date.isBefore(start) && !date.isAfter(today);
    }).toList();
  }

  _DashboardTotals _reportTotals() {
    var initiated = 0;
    var delivered = 0;
    var read = 0;
    var failed = 0;

    for (final row in _filteredReportRows()) {
      initiated += int.parse(row[4]);
      delivered += int.parse(row[6]);
      read += int.parse(row[7]);
      failed += int.parse(row[8]);
    }

    return (
      initiated: initiated,
      delivered: delivered,
      read: read,
      failed: failed,
    );
  }

  ({
    List<int> initiated,
    List<int> delivered,
    List<int> failed,
    List<String> labels,
  })
  _trafficChartData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    late final DateTime start;
    late final int bucketCount;
    late final List<String> labels;

    switch (period) {
      case 'Today':
        start = today;
        bucketCount = 1;
        labels = ['${today.day} ${_monthNames[today.month - 1]}'];
      case 'This Week':
        start = today.subtract(Duration(days: today.weekday - 1));
        bucketCount = today.weekday;
        labels = _weekDays.take(bucketCount).toList();
      case 'This Year':
        start = DateTime(today.year);
        bucketCount = today.month;
        labels = _monthNames.take(bucketCount).toList();
      default:
        start = DateTime(today.year, today.month);
        bucketCount = ((today.day - 1) ~/ 7) + 1;
        final daysInMonth = DateTime(today.year, today.month + 1, 0).day;
        labels = List.generate(bucketCount, (index) {
          final firstDay = index * 7 + 1;
          final lastDay = math.min(firstDay + 6, daysInMonth);
          return '$firstDay-$lastDay';
        });
    }

    final initiated = List<int>.filled(bucketCount, 0);
    final delivered = List<int>.filled(bucketCount, 0);
    final failed = List<int>.filled(bucketCount, 0);
    for (final row in _filteredReportRows()) {
      final date = _parseReportDate(row[2]);
      if (date == null) continue;

      final bucket = switch (period) {
        'Today' => 0,
        'This Week' => date.difference(start).inDays,
        'This Year' => date.month - 1,
        _ => (date.day - 1) ~/ 7,
      };
      if (bucket < 0 || bucket >= bucketCount) continue;

      initiated[bucket] += int.parse(row[4]);
      delivered[bucket] += int.parse(row[6]);
      failed[bucket] += int.parse(row[8]);
    }

    return (
      initiated: initiated,
      delivered: delivered,
      failed: failed,
      labels: labels,
    );
  }

  @override
  Widget build(BuildContext context) {
    final totals = _reportTotals();

    return Scaffold(
      drawer: const DashboardDrawer(),
      appBar: buildCpxBoatAppBar(context),
      body: DecoratedBox(
        decoration: const BoxDecoration(color: pageColor),
        child: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 1000;
              final pagePadding = constraints.maxWidth >= 700
                  ? const EdgeInsets.fromLTRB(32, 30, 32, 36)
                  : const EdgeInsets.fromLTRB(16, 20, 16, 28);

              return SingleChildScrollView(
                padding: pagePadding,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1440),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _pageHeading(),
                        const SizedBox(height: 26),
                        _channelSelector(),
                        const SizedBox(height: 26),
                        _sectionHeading(
                          'Performance at a glance',
                          'A real-time snapshot for $channel',
                          Icons.bolt_rounded,
                        ),
                        const SizedBox(height: 14),
                        _statsGrid(totals),
                        const SizedBox(height: 26),
                        _sectionHeading(
                          'Delivery analytics',
                          'Understand how your messages are performing',
                          Icons.insights_rounded,
                        ),
                        const SizedBox(height: 14),
                        if (wide)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 4, child: _statusCard(totals)),
                              const SizedBox(width: 16),
                              Expanded(flex: 7, child: _trafficCard()),
                            ],
                          )
                        else ...[
                          _statusCard(totals),
                          const SizedBox(height: 14),
                          _trafficCard(),
                        ],
                        const SizedBox(height: 22),
                        _sampleDataNote(),
                        const SizedBox(height: 18),
                        _bottomNote(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _pageHeading() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = switch (period) {
      'Today' => today,
      'This Week' => today.subtract(Duration(days: today.weekday - 1)),
      'This Year' => DateTime(today.year),
      _ => DateTime(today.year, today.month),
    };
    final dateRange = period == 'Today'
        ? '${today.day} ${_monthNames[today.month - 1]}, ${today.year}'
        : '${_monthNames[start.month - 1]} ${start.day}'
              '${start.year != today.year ? ', ${start.year}' : ''} - '
              '${_monthNames[today.month - 1]} ${today.day}, ${today.year}';

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 620;
        final periodBadge = Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          decoration: BoxDecoration(
            color: panelMidBackground(panelAccent(context)),
            border: Border.all(color: panelThemeBorder(panelAccent(context))),
            borderRadius: BorderRadius.circular(13),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0710192D),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: panelAccent(context).withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.calendar_today_rounded,
                  size: 15,
                  color: panelAccentStrong(context),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    period,
                    style: const TextStyle(
                      color: navy,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateRange,
                    style: const TextStyle(fontSize: 10, color: muted),
                  ),
                ],
              ),
            ],
          ),
        );

        final title = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: const Color(0xFF18A879),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF18A879).withValues(alpha: .25),
                        blurRadius: 7,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'MESSAGING OVERVIEW',
                  style: TextStyle(
                    color: panelAccentStrong(context),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.25,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Smart Dashboard',
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(fontSize: compact ? 27 : 32, letterSpacing: -1),
            ),
            const SizedBox(height: 5),
            Text(
              'Track delivery performance across your messaging channels.',
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: muted),
            ),
          ],
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [title, const SizedBox(height: 16), periodBadge],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: title),
            const SizedBox(width: 16),
            periodBadge,
          ],
        );
      },
    );
  }

  Widget _sectionHeading(String title, String subtitle, IconData icon) => Row(
    children: [
      Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: panelMidBackground(panelAccent(context)),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: panelThemeBorder(panelAccent(context))),
        ),
        child: Icon(icon, size: 17, color: panelAccentStrong(context)),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: navy,
                fontSize: 15,
                fontWeight: FontWeight.w800,
                letterSpacing: -.2,
              ),
            ),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(color: muted, fontSize: 11)),
          ],
        ),
      ),
    ],
  );

  Widget _channelSelector() {
    final channels = ['RCS', 'WhatsApp', 'SMS', 'Fallback'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: panelMidBackground(panelAccent(context)),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: panelThemeBorder(panelAccent(context))),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0710192D),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 550;
              final channelControls = Wrap(
                spacing: 7,
                runSpacing: 7,
                children: channels.map((item) {
                  final active = channel == item;
                  return ChoiceChip(
                    label: Text(item),
                    selected: active,
                    onSelected: (_) => setState(() => channel = item),
                    showCheckmark: false,
                    labelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: active
                          ? cpxBoatLogoColorForBackground(
                              panelAccentStrong(context),
                            )
                          : panelTextSecondary(panelAccent(context)),
                    ),
                    backgroundColor: panelFieldBackground(panelAccent(context)),
                    selectedColor: panelAccentStrong(context),
                    side: BorderSide(
                      color: active
                          ? panelAccentStrong(context)
                          : panelThemeBorder(panelAccent(context)),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              );

              final dateFilter = Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    color: panelAccentStrong(context),
                    size: 17,
                  ),
                  const SizedBox(width: 7),
                  const Text(
                    'Period',
                    style: TextStyle(
                      color: muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 124,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: period,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18,
                        ),
                        style: const TextStyle(
                          fontSize: 11,
                          color: navy,
                          fontWeight: FontWeight.w700,
                        ),
                        items: ['Today', 'This Week', 'This Month', 'This Year']
                            .map(
                              (value) => DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) setState(() => period = value);
                        },
                      ),
                    ),
                  ),
                ],
              );

              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CHANNEL',
                      style: TextStyle(
                        color: muted,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    channelControls,
                    const Divider(height: 20, color: premiumBorder),
                    dateFilter,
                  ],
                );
              }

              return Row(
                children: [
                  const Text(
                    'CHANNEL',
                    style: TextStyle(
                      color: muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: channelControls),
                  const SizedBox(width: 14),
                  Container(
                    width: 1,
                    height: 30,
                    color: panelThemeBorder(panelAccent(context)),
                  ),
                  const SizedBox(width: 14),
                  dateFilter,
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _statsGrid(_DashboardTotals totals) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 12.0;
        final columns = constraints.maxWidth >= 1000
            ? 4
            : constraints.maxWidth >= 760
            ? 3
            : constraints.maxWidth >= 360
            ? 2
            : 1;
        final cardWidth =
            (constraints.maxWidth - gap * (columns - 1)) / columns;
        final deliveryRate = totals.initiated == 0
            ? null
            : (totals.delivered * 100 / totals.initiated).toStringAsFixed(1);
        final readRate = totals.delivered == 0
            ? null
            : (totals.read * 100 / totals.delivered).toStringAsFixed(1);
        final failureRate = totals.initiated == 0
            ? null
            : (totals.failed * 100 / totals.initiated).toStringAsFixed(1);

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            SizedBox(
              width: cardWidth,
              height: 132,
              child: StatCard(
                key: const ValueKey('dashboard-stat-initiated'),
                label: 'INITIATED',
                value: totals.initiated,
                detail: 'Messages in selected period',
                color: const Color(0xFFE9A52A),
                icon: Icons.rocket_launch_outlined,
              ),
            ),
            SizedBox(
              width: cardWidth,
              height: 132,
              child: StatCard(
                key: const ValueKey('dashboard-stat-delivered'),
                label: 'DELIVERED',
                value: totals.delivered,
                detail: deliveryRate == null
                    ? 'No activity in this period'
                    : 'Delivery rate $deliveryRate%',
                color: const Color(0xFF16A878),
                icon: Icons.done_all_rounded,
              ),
            ),
            SizedBox(
              width: cardWidth,
              height: 132,
              child: StatCard(
                key: const ValueKey('dashboard-stat-read'),
                label: 'READ',
                value: totals.read,
                detail: readRate == null
                    ? 'No delivered messages'
                    : '$readRate% of delivered',
                color: const Color(0xFF3989D9),
                icon: Icons.visibility_outlined,
              ),
            ),
            SizedBox(
              width: cardWidth,
              height: 132,
              child: StatCard(
                key: const ValueKey('dashboard-stat-failed'),
                label: 'FAILED',
                value: totals.failed,
                detail: failureRate == null
                    ? 'No activity in this period'
                    : 'Failure rate $failureRate%',
                color: const Color(0xFFE45D61),
                icon: Icons.error_outline_rounded,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _statusCard(_DashboardTotals totals) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(radius: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Status distribution',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: navy,
                    letterSpacing: -.2,
                  ),
                ),
              ),
              Icon(
                Icons.more_horiz_rounded,
                color: muted.withValues(alpha: .8),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Share of messages by delivery status',
            style: TextStyle(fontSize: 10, color: muted),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 128,
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: CustomPaint(
                    painter: DonutPainter(
                      delivered: totals.delivered,
                      failed: totals.failed,
                      initiated: totals.initiated,
                      read: totals.read,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${totals.initiated}',
                            style: const TextStyle(
                              color: navy,
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'INITIATED',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                              letterSpacing: .5,
                              color: muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Legend(color: Color(0xFF16A878), label: 'Delivered'),
                      Legend(color: Color(0xFFE45D61), label: 'Failed'),
                      Legend(color: Color(0xFFE9A52A), label: 'Initiated'),
                      Legend(color: Color(0xFF3989D9), label: 'Read'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _trafficCard() {
    final chartData = _trafficChartData();
    final hasActivity = [
      ...chartData.initiated,
      ...chartData.delivered,
      ...chartData.failed,
    ].any((value) => value > 0);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(radius: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Traffic trends',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: navy,
                    letterSpacing: -.2,
                  ),
                ),
              ),
              Icon(
                Icons.more_horiz_rounded,
                color: muted.withValues(alpha: .8),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Message volume by status for the selected period',
            style: TextStyle(fontSize: 10, color: muted),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 144,
            width: double.infinity,
            child: hasActivity
                ? CustomPaint(
                    painter: _DashboardTrafficPainter(
                      initiated: chartData.initiated,
                      delivered: chartData.delivered,
                      failed: chartData.failed,
                      labels: chartData.labels,
                    ),
                  )
                : const Center(
                    child: Text(
                      'No message activity in this period',
                      style: TextStyle(fontSize: 12, color: muted),
                    ),
                  ),
          ),
          const SizedBox(height: 10),
          const Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              Legend(color: Color(0xFF16A878), label: 'Delivered'),
              Legend(color: Color(0xFFE45D61), label: 'Failed'),
              Legend(color: Color(0xFFE9A52A), label: 'Initiated'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomNote() => const Center(
    child: Padding(
      padding: EdgeInsets.only(top: 2, bottom: 2),

      child: Text(
        'CPXBOAT • Messaging Analytics',

        style: TextStyle(fontSize: 10, color: muted),
      ),
    ),
  );

  Widget _sampleDataNote() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: panelFieldBackground(panelAccent(context)),
      borderRadius: BorderRadius.circular(13),
      border: Border.all(color: panelThemeBorder(panelAccent(context))),
    ),
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline_rounded, size: 18, color: Color(0xFFB8C7DB)),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            'Sample report data is shown here. Connect your messaging channels to view live performance.',
            style: TextStyle(
              color: Color(0xFFD2DDEC),
              fontSize: 11,
              height: 1.4,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _bottomNavigation() {
    const labels = [
      'Dashboard',

      'Channels',

      'Analytics',

      'AI Assistant',

      'Settings',
    ];

    const icons = [
      Icons.grid_view_rounded,

      Icons.apps_rounded,

      Icons.analytics_outlined,

      Icons.auto_awesome_outlined,

      Icons.settings_outlined,
    ];

    return Container(
      decoration: const BoxDecoration(
        color: brandNavy,

        boxShadow: [
          BoxShadow(
            color: Color(0x18000000),

            blurRadius: 10,

            offset: Offset(0, -3),
          ),
        ],
      ),

      child: SafeArea(
        top: false,

        child: SizedBox(
          height: 57,

          child: Row(
            children: List.generate(labels.length, (i) {
              final active = selectedTab == i;

              return Expanded(
                child: InkWell(
                  onTap: () => setState(() => selectedTab = i),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Icon(
                        icons[i],

                        size: 19,

                        color: active ? panelAccent(context) : Colors.white70,
                      ),

                      const SizedBox(height: 3),

                      Text(
                        labels[i],

                        maxLines: 1,

                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(
                          fontSize: 8,

                          color: active ? panelAccent(context) : Colors.white70,

                          fontWeight: active
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _DashboardTrafficPainter extends CustomPainter {
  const _DashboardTrafficPainter({
    required this.initiated,
    required this.delivered,
    required this.failed,
    required this.labels,
  });

  final List<int> initiated;
  final List<int> delivered;
  final List<int> failed;
  final List<String> labels;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 28.0;
    const top = 8.0;
    final right = size.width - 5;
    final bottom = size.height - 20;
    final maxValue = <int>[
      ...initiated,
      ...delivered,
      ...failed,
    ].fold<int>(0, math.max);
    final axisMax = math.max(4, ((maxValue + 3) ~/ 4) * 4);
    final gridPaint = Paint()
      ..color = const Color(0xFFE4E8EF)
      ..strokeWidth = 1;

    for (var index = 0; index <= 4; index++) {
      final y = top + (bottom - top) * index / 4;
      final value = axisMax - (axisMax * index ~/ 4);
      canvas.drawLine(Offset(left, y), Offset(right, y), gridPaint);
      final text = TextPainter(
        text: TextSpan(
          text: '$value',
          style: const TextStyle(fontSize: 8, color: muted),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      text.paint(canvas, Offset(0, y - 5));
    }

    final series = <(Color, List<int>)>[
      (const Color(0xFFE9A52A), initiated),
      (const Color(0xFF16A878), delivered),
      (const Color(0xFFE45D61), failed),
    ];

    for (final (color, values) in series) {
      if (values.isEmpty) continue;
      final points = List.generate(values.length, (index) {
        final x = values.length == 1
            ? (left + right) / 2
            : left + (right - left) * index / (values.length - 1);
        final y = bottom - (bottom - top) * values[index] / axisMax;
        return Offset(x, y);
      });

      final line = Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      if (points.length > 1) {
        final path = Path()..moveTo(points.first.dx, points.first.dy);
        for (final point in points.skip(1)) {
          path.lineTo(point.dx, point.dy);
        }
        canvas.drawPath(path, line);
      }

      final dotPaint = Paint()..color = color;
      for (final point in points) {
        canvas.drawCircle(point, 2, dotPaint);
      }
    }

    for (var index = 0; index < labels.length; index++) {
      final x = labels.length == 1
          ? (left + right) / 2
          : left + (right - left) * index / (labels.length - 1);
      final text = TextPainter(
        text: TextSpan(
          text: labels[index],
          style: const TextStyle(fontSize: 8, color: muted),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: 42);
      text.paint(canvas, Offset(x - text.width / 2, size.height - 12));
    }
  }

  @override
  bool shouldRepaint(covariant _DashboardTrafficPainter oldDelegate) => true;
}
