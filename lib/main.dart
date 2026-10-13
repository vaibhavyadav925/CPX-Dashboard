import 'package:flutter/material.dart';

void main() => runApp(const CPXBoatApp());

const navy = Color(0xFF11182B);
const teal = Color(0xFF09A6B8);
const pageColor = Color(0xFFF3F5FA);
const muted = Color(0xFF718096);

class CPXBoatApp extends StatelessWidget {
  const CPXBoatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CPXBOAT Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: pageColor,
        colorScheme: ColorScheme.fromSeed(seedColor: teal),
        fontFamily: 'Roboto',
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String channel = 'RCS';
  String period = 'This Month';
  int selectedTab = 0;
  int initiated = 3;
  int delivered = 2;
  int read = 0;
  int failed = 1;

  void applyFilters() {
    setState(() {
      switch (channel) {
        case 'WhatsApp':
          initiated = 20;
          delivered = 16;
          read = 12;
          failed = 4;
          break;
        case 'SMS':
          initiated = 12;
          delivered = 9;
          read = 0;
          failed = 3;
          break;
        case 'Fallback':
          initiated = 7;
          delivered = 5;
          read = 2;
          failed = 2;
          break;
        default:
          initiated = 3;
          delivered = 2;
          read = 0;
          failed = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DashboardDrawer(),
      appBar: AppBar(
        toolbarHeight: 58,
        backgroundColor: navy,
        foregroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 42,
        titleSpacing: 2,
        leading: Builder(
          builder: (context) => IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.menu_rounded, size: 22),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Row(
          children: [
            const Icon(Icons.sailing_rounded, color: Colors.white, size: 22),
            const SizedBox(width: 5),
            const Text(
              'CPXBOAT',
              style: TextStyle(
                fontSize: 17,
                letterSpacing: .6,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            padding: const EdgeInsets.symmetric(horizontal: 7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.account_balance_wallet_outlined, size: 13),
                SizedBox(width: 4),
                Text(
                  '20',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () {},
            icon: const Icon(Icons.account_circle_outlined, size: 21),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded, size: 21),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
          children: [
            _pageHeading(),
            const SizedBox(height: 12),
            _channelSelector(),
            const SizedBox(height: 12),
            _statsGrid(),
            const SizedBox(height: 12),
            _statusCard(),
            const SizedBox(height: 12),
            _trafficCard(),
            const SizedBox(height: 12),
            _bottomNote(),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavigation(),
    );
  }

  Widget _pageHeading() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Smart Dashboard',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: navy,
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.circle, size: 6, color: Color(0xFF56B86A)),
                  SizedBox(width: 5),
                  Text(
                    'This Month',
                    style: TextStyle(fontSize: 11, color: muted),
                  ),
                  SizedBox(width: 3),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 13,
                    color: Color(0xFF11182B),
                  ),
                ],
              ),
            ],
          ),
        ),
        Icon(
          Icons.more_horiz_rounded,
          color: muted.withValues(alpha: .8),
          size: 20,
        ),
      ],
    );
  }

  Widget _channelSelector() {
    final channels = ['RCS', 'WhatsApp', 'SMS', 'Fallback'];
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: _cardDecoration(radius: 15),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: channels.map((item) {
                final active = channel == item;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(item),
                    selected: active,
                    onSelected: (_) => setState(() => channel = item),
                    showCheckmark: false,
                    labelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: active ? Colors.white : const Color(0xFF4B5565),
                    ),
                    backgroundColor: Colors.white,
                    selectedColor: const Color(0xFF11182B),
                    side: BorderSide(
                      color: active ? navy : const Color(0xFFE2E7EF),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 0,
                    ),
                    visualDensity: const VisualDensity(
                      horizontal: -2,
                      vertical: -2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              const Icon(Icons.calendar_month_outlined, color: muted, size: 16),
              const SizedBox(width: 5),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: period,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down, size: 17),
                    style: const TextStyle(
                      fontSize: 11,
                      color: navy,
                      fontWeight: FontWeight.w600,
                    ),
                    items: ['Today', 'This Week', 'This Month', 'This Year']
                        .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => period = v);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 34,
                child: FilledButton(
                  onPressed: applyFilters,
                  style: FilledButton.styleFrom(
                    backgroundColor: teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = 10.0;
        final cardWidth = (constraints.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: 10,
          children: [
            SizedBox(
              width: cardWidth,
              height: 82,
              child: StatCard(
                label: 'INITIATED',
                value: initiated,
                color: const Color(0xFFE9A52A),
                icon: Icons.rocket_launch_outlined,
              ),
            ),
            SizedBox(
              width: cardWidth,
              height: 82,
              child: StatCard(
                label: 'DELIVERED',
                value: delivered,
                color: const Color(0xFF16A878),
                icon: Icons.done_all_rounded,
              ),
            ),
            SizedBox(
              width: cardWidth,
              height: 82,
              child: StatCard(
                label: 'READ',
                value: read,
                color: const Color(0xFF3989D9),
                icon: Icons.visibility_outlined,
              ),
            ),
            SizedBox(
              width: cardWidth,
              height: 82,
              child: StatCard(
                label: 'FAILED',
                value: failed,
                color: const Color(0xFFE45D61),
                icon: Icons.error_outline_rounded,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _statusCard() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status Distribution',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: navy,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'Share of messages by delivery status',
            style: TextStyle(fontSize: 10, color: muted),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 112,
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: CustomPaint(
                    painter: DonutPainter(
                      delivered: delivered,
                      failed: failed,
                      initiated: initiated,
                      read: read,
                    ),
                    child: const Center(
                      child: Text(
                        'STATUS',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: muted,
                        ),
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
                      Legend(color: Color(0xFF8A63D2), label: 'Sent'),
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
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Traffic Trends',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: navy,
                  ),
                ),
              ),
              Icon(Icons.download_for_offline_outlined, size: 17, color: muted),
            ],
          ),
          const SizedBox(height: 3),
          const Text(
            'Daily message volume by status',
            style: TextStyle(fontSize: 10, color: muted),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 135,
            width: double.infinity,
            child: CustomPaint(painter: TrafficPainter()),
          ),
          const SizedBox(height: 8),
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
        color: navy,
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
                        color: active ? teal : Colors.white70,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        labels[i],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 8,
                          color: active ? teal : Colors.white70,
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
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFE5E9F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
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
                    fontSize: 9,
                    color: muted,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$value',
                  style: const TextStyle(
                    fontSize: 22,
                    height: 1,
                    fontWeight: FontWeight.w800,
                    color: navy,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 27,
            height: 27,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .13),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 17),
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

class MISReportsScreen extends StatefulWidget {
  const MISReportsScreen({super.key});

  @override
  State<MISReportsScreen> createState() => _MISReportsScreenState();
}

class _MISReportsScreenState extends State<MISReportsScreen> {
  String reportChannel = 'RCS';
  String userFilter = 'All users';
  String templateFilter = '';
  DateTime? fromDate = DateTime(2026, 10, 1);
  DateTime? toDate = DateTime(2026, 10, 31);
  bool applied = true;

  final rowsByChannel = const <String, List<List<String>>>{
    'RCS': [
      ['ajay', '—', '13 Oct 2026', '—', '22', '22', '0', '0', '0', '0'],
      ['ajay', '—', '12 Oct 2026', '—', '1', '0', '0', '0', '1', '0'],
      ['ajay', '—', '05 Oct 2026', '—', '1', '0', '1', '0', '0', '0'],
    ],
    'Whatsapp': [
      [
        'ajay',
        '—',
        '13 Oct 2026',
        'Promotional',
        '18',
        '18',
        '16',
        '12',
        '2',
        '4',
      ],
      ['ajay', '—', '11 Oct 2026', 'Utility', '6', '6', '5', '4', '1', '2'],
    ],
    'SMS': [
      ['ajay', '—', '13 Oct 2026', 'OTP', '24', '24', '23', '0', '1', '0'],
      [
        'ajay',
        '—',
        '09 Oct 2026',
        'Promotional',
        '12',
        '12',
        '11',
        '0',
        '1',
        '0',
      ],
    ],
  };

  Future<void> _pickDate({required bool start}) async {
    final initial = (start ? fromDate : toDate) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        if (start) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final rows = rowsByChannel[reportChannel]!;
    final initiated = rows.fold<int>(0, (sum, row) => sum + int.parse(row[4]));
    final delivered = rows.fold<int>(0, (sum, row) => sum + int.parse(row[6]));
    final read = rows.fold<int>(0, (sum, row) => sum + int.parse(row[7]));
    final failed = rows.fold<int>(0, (sum, row) => sum + int.parse(row[8]));
    final reply = rows.fold<int>(0, (sum, row) => sum + int.parse(row[9]));

    return Scaffold(
      drawer: const DashboardDrawer(currentPage: 'MIS Reports'),
      appBar: AppBar(
        toolbarHeight: 58,
        backgroundColor: const Color(0xFF11182B),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.sailing_rounded, color: teal, size: 22),
            SizedBox(width: 7),
            Text(
              'CPXBOAT',
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: .4),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF11182B),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  color: teal,
                  size: 17,
                ),
                SizedBox(width: 5),
                Text(
                  '₹21',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            tooltip: 'Profile',
            icon: const Icon(Icons.account_circle_outlined, size: 21),
          ),
          IconButton(
            onPressed: () {},
            tooltip: 'Notifications',
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 850;
            return ListView(
              padding: EdgeInsets.all(wide ? 22 : 13),
              children: [
                const Text(
                  'MIS Reports',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: navy,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Delivery performance by user, category & template, across WhatsApp, SMS and RCS.',
                  style: TextStyle(fontSize: 12, color: muted),
                ),
                const SizedBox(height: 18),
                _channelTabs(),
                const SizedBox(height: 16),
                _filterPanel(wide),
                const SizedBox(height: 16),
                _metricCards(wide, initiated, delivered, read, failed, reply),
                const SizedBox(height: 16),
                _reportTable(rows, wide),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    '© CPXBOAT • MIS Reports',
                    style: TextStyle(color: muted, fontSize: 10),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _misBottomNavigation(),
    );
  }

  Widget _misBottomNavigation() {
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
        color: navy,
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
              final active = i == 0;
              return Expanded(
                child: InkWell(
                  onTap: () {
                    if (i == 0) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const DashboardScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${labels[i]} screen coming next'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icons[i],
                        size: 19,
                        color: active ? teal : Colors.white70,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        labels[i],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 8,
                          color: active ? teal : Colors.white70,
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

  Widget _channelTabs() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: _cardDecoration(radius: 12),
      child: Row(
        children: ['RCS', 'Whatsapp', 'SMS'].map((tab) {
          final selected = reportChannel == tab;
          return Padding(
            padding: const EdgeInsets.only(right: 5),
            child: TextButton(
              onPressed: () => setState(() => reportChannel = tab),
              style: TextButton.styleFrom(
                backgroundColor: selected ? teal : Colors.transparent,
                foregroundColor: selected
                    ? Colors.white
                    : const Color(0xFF526078),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              child: Text(
                tab,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _filterPanel(bool wide) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(radius: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$reportChannel MIS Report',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: navy,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Delivery performance by user, category & template',
                      style: TextStyle(fontSize: 11, color: muted),
                    ),
                  ],
                ),
              ),
              if (wide) ...[
                OutlinedButton.icon(
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text('Clear'),
                ),
                const SizedBox(width: 7),
                FilledButton.icon(
                  onPressed: () => setState(() => applied = true),
                  icon: const Icon(Icons.filter_alt_outlined, size: 16),
                  label: const Text('Apply'),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, box) {
              final columns = box.maxWidth > 680 ? 4 : 2;
              final itemWidth = (box.maxWidth - (columns - 1) * 8) / columns;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  SizedBox(
                    width: itemWidth,
                    child: DropdownButtonFormField<String>(
                      value: userFilter,
                      isExpanded: true,
                      decoration: _filterDecoration(),
                      items: const ['All users', 'ajay', 'Admin']
                          .map(
                            (v) => DropdownMenuItem(
                              value: v,
                              child: Text(v, overflow: TextOverflow.ellipsis),
                            ),
                          )
                          .toList(),
                      onChanged: (v) =>
                          setState(() => userFilter = v ?? 'All users'),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _dateButton(
                      _formatDate(fromDate),
                      () => _pickDate(start: true),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _dateButton(
                      _formatDate(toDate),
                      () => _pickDate(start: false),
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: TextField(
                      decoration: _filterDecoration(hint: 'Template name'),
                      onChanged: (v) => templateFilter = v,
                    ),
                  ),
                ],
              );
            },
          ),
          if (!wide) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _clearFilters,
                    icon: const Icon(Icons.refresh_rounded, size: 16),
                    label: const Text('Clear'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => setState(() => applied = true),
                    icon: const Icon(Icons.filter_alt_outlined, size: 16),
                    label: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  InputDecoration _filterDecoration({String? hint}) => InputDecoration(
    hintText: hint,
    isDense: true,
    filled: true,
    fillColor: const Color(0xFFF8F9FC),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: Color(0xFFDDE3ED)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: Color(0xFFDDE3ED)),
    ),
  );

  Widget _dateButton(String label, VoidCallback onTap) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(9),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FC),
        border: Border.all(color: const Color(0xFFDDE3ED)),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, color: navy),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.calendar_month_outlined, size: 16),
        ],
      ),
    ),
  );

  void _clearFilters() {
    setState(() {
      userFilter = 'All users';
      templateFilter = '';
      fromDate = null;
      toDate = null;
      applied = false;
    });
  }

  Widget _metricCards(
    bool wide,
    int initiated,
    int delivered,
    int read,
    int failed,
    int reply,
  ) {
    final metrics = [
      (
        'Initiated',
        initiated,
        const Color(0xFFF59E0B),
        Icons.rocket_launch_outlined,
      ),
      ('Delivered', delivered, const Color(0xFF16A878), Icons.done_all_rounded),
      ('Read', read, const Color(0xFF0891B2), Icons.visibility_outlined),
      ('Failed', failed, const Color(0xFFEF4444), Icons.error_outline_rounded),
      ('Reply', reply, const Color(0xFF8B5CF6), Icons.reply_rounded),
    ];
    return LayoutBuilder(
      builder: (context, box) {
        final columns = box.maxWidth > 1100
            ? 5
            : box.maxWidth > 700
            ? 3
            : 2;
        final gap = 10.0;
        final width = (box.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: metrics
              .map(
                (metric) => SizedBox(
                  width: width,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: _cardDecoration(radius: 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                metric.$1,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: muted,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                '${metric.$2}',
                                style: const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w800,
                                  color: navy,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: metric.$3.withValues(alpha: .11),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(metric.$4, color: metric.$3, size: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _reportTable(List<List<String>> rows, bool wide) {
    const headers = [
      'User',
      'Parent',
      'Sent Date',
      'Category',
      'Initiated',
      'Sent',
      'Delivered',
      'Read',
      'Failed',
      'Reply',
    ];
    return Container(
      decoration: _cardDecoration(radius: 14),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: wide ? 950 : 920),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(teal),
            headingTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
            dataTextStyle: const TextStyle(color: navy, fontSize: 11),
            horizontalMargin: 14,
            columnSpacing: 20,
            headingRowHeight: 42,
            dataRowMinHeight: 40,
            dataRowMaxHeight: 46,
            columns: headers.map((h) => DataColumn(label: Text(h))).toList(),
            rows: rows
                .map(
                  (row) => DataRow(
                    cells: row.asMap().entries.map((entry) {
                      final i = entry.key;
                      final value = entry.value;
                      if (i >= 4) {
                        final color = i == 4
                            ? const Color(0xFFF59E0B)
                            : i == 6
                            ? const Color(0xFF16A878)
                            : i == 7
                            ? const Color(0xFF0891B2)
                            : i == 8
                            ? const Color(0xFFEF4444)
                            : i == 9
                            ? const Color(0xFF8B5CF6)
                            : const Color(0xFF0891B2);
                        return DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: .12),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Text(
                              value,
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        );
                      }
                      return DataCell(Text(value));
                    }).toList(),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class DashboardDrawer extends StatefulWidget {
  final String currentPage;

  const DashboardDrawer({super.key, this.currentPage = 'Smart Home'});

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
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 292,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0B1224), Color(0xFF151F38), Color(0xFF202D4B)],
            stops: [0.0, 0.58, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 16, 20),
                child: Row(
                  children: [
                    const Icon(Icons.sailing_rounded, color: teal, size: 27),
                    const SizedBox(width: 9),
                    const Expanded(
                      child: Text(
                        'CPXBOAT',
                        style: TextStyle(
                          fontSize: 21,
                          letterSpacing: .3,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
              const Divider(height: 1, color: Color(0xFF29334A)),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(10, 12, 10, 14),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 19,
                  color: isExpanded ? Colors.white : const Color(0xFFB5BED0),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isExpanded
                          ? Colors.white
                          : const Color(0xFFD8DEEA),
                      fontSize: 12,
                      fontWeight: isExpanded
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
                    style: const TextStyle(
                      color: Color(0xFF7D8AA4),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .7,
                    ),
                  ),
                ),
              );
            }

            final active = selectedItem == item;
            final childIcon = _childIcon(item);
            return Padding(
              padding: const EdgeInsets.only(left: 9, bottom: 3),
              child: Material(
                color: active ? teal : Colors.transparent,
                borderRadius: BorderRadius.circular(9),
                child: InkWell(
                  borderRadius: BorderRadius.circular(9),
                  onTap: () => _select(item),
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

  void _select(String item) {
    setState(() => selectedItem = item);
    Navigator.pop(context);
    if (item == 'MIS Reports') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MISReportsScreen()),
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

BoxDecoration _cardDecoration({double radius = 15}) => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(radius),
  border: Border.all(color: const Color(0xFFE3E8F0)),
  boxShadow: const [
    BoxShadow(color: Color(0x08000000), blurRadius: 9, offset: Offset(0, 2)),
  ],
);

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
      const Color(0xFFE45D61): [0, 1, 0, 1, 0, 0, 2, 1, 0],
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
