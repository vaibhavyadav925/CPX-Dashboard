part of '../app.dart';

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
      appBar: buildCpxBoatAppBar(context),
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
    );
  }

  Widget _pageHeading() {
    return Row(
      children: [
        Expanded(
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
                  Icon(Icons.circle, size: 6, color: panelAccent(context)),
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
                    backgroundColor: panelAccent(context),

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
