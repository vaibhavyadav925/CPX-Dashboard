part of '../app.dart';

class SmartFallbackDashboardScreen extends StatelessWidget {
  const SmartFallbackDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 900;
    final medium = MediaQuery.of(context).size.width >= 620;
    final padding = wide ? 22.0 : 13.0;
    return Scaffold(
      drawer: const DashboardDrawer(
        currentPage: 'Dashboard',
        currentGroup: 'Smart Fallback',
      ),
      appBar: buildCpxBoatAppBar(context),
      body: Container(
        color: const Color(0xFFF3F5FA),
        child: ListView(
          padding: EdgeInsets.all(padding),
          children: [
            const Text(
              'Hi, ajay 👋',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF17233C),
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'Cross-channel fallback campaigns — cascading across your connected channels.',
              style: TextStyle(fontSize: 12, color: Color(0xFF60758F)),
            ),
            const SizedBox(height: 22),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 1050
                    ? 4
                    : constraints.maxWidth >= 570
                    ? 2
                    : 1;
                const gap = 12.0;
                final w =
                    (constraints.maxWidth - gap * (columns - 1)) / columns;
                final stats = <(String, String, IconData, Color, Color)>[
                  (
                    'Total campaigns',
                    '47',
                    Icons.device_hub_outlined,
                    panelAccent(context),
                    const Color(0xFFE6F5F8),
                  ),
                  (
                    'Total recipients',
                    '25,342',
                    Icons.send_outlined,
                    const Color(0xFFFF9800),
                    const Color(0xFFFFF5E6),
                  ),
                  (
                    'In progress',
                    '0',
                    Icons.schedule_rounded,
                    const Color(0xFFFF9800),
                    const Color(0xFFFFF5E6),
                  ),
                  (
                    'Completed',
                    '47',
                    Icons.check_circle_outline_rounded,
                    const Color(0xFF24A36A),
                    const Color(0xFFE8F6EF),
                  ),
                ];
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: stats
                      .map(
                        (item) => Container(
                          width: w,
                          height: 97,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 19,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFDCE3F0)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x140F2F60),
                                blurRadius: 4,
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
                                      item.$1,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF60758F),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item.$2,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        height: 1,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF101B31),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: item.$5,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(item.$3, color: item.$4, size: 21),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 20),
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: _fallbackActivityCard()),
                  const SizedBox(width: 14),
                  Expanded(flex: 3, child: _fallbackPerformanceCard()),
                ],
              )
            else ...[
              _fallbackActivityCard(),
              const SizedBox(height: 14),
              _fallbackPerformanceCard(),
            ],
            const SizedBox(height: 20),
            Container(
              decoration: _cardDecoration(radius: 14),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 17, 20, 15),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Recent campaigns',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF17233C),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              showApiPendingMessage(context, 'campaign list'),
                          child: Text(
                            'View all  ›',
                            style: TextStyle(
                              fontSize: 12,
                              color: panelAccent(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 36,
                    color: panelAccent(context),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: const Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Campaign Name',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Fallback Order',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Count',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Date & Time',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Status',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                      ],
                    ),
                  ),
                  _fallbackCampaignRow(
                    'Test_demo_cam',
                    '🟢  →  🔵  →  🟨',
                    '20',
                    '09 Sept, 05:10 pm',
                  ),
                  _fallbackCampaignRow(
                    'Smart_fallback_DRL',
                    '🔵  →  🟢  →  🟨',
                    '19',
                    '09 Sept, 04:58 pm',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallbackActivityCard() => Container(
    height: 342,
    padding: const EdgeInsets.all(20),
    decoration: _cardDecoration(radius: 14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Campaign activity — last 10 days',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF17233C),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFE),
                border: Border.all(color: const Color(0xFFDCE3EF)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Text(
                    'Last 10 days',
                    style: TextStyle(fontSize: 11, color: Color(0xFF25334B)),
                  ),
                  SizedBox(width: 18),
                  Icon(Icons.keyboard_arrow_down, size: 16),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        const Expanded(child: _FallbackLineChart()),
      ],
    ),
  );

  Widget _fallbackPerformanceCard() => Container(
    height: 342,
    padding: const EdgeInsets.all(20),
    decoration: _cardDecoration(radius: 14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Campaign performance',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF17233C),
          ),
        ),
        const SizedBox(height: 22),
        Expanded(
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _FallbackPerformanceLine(
                      'Total messages',
                      '0',
                      Color(0xFF17233C),
                    ),
                    SizedBox(height: 13),
                    _FallbackPerformanceLine(
                      'Sent',
                      '0%',
                      Color(0xFFFF9800),
                      dot: Color(0xFFFF9800),
                    ),
                    SizedBox(height: 12),
                    _FallbackPerformanceLine(
                      'Delivered',
                      '0%',
                      Color(0xFF4285FF),
                      dot: Color(0xFF4285FF),
                    ),
                    SizedBox(height: 12),
                    _FallbackPerformanceLine(
                      'Read',
                      '0%',
                      Color(0xFF24A36A),
                      dot: Color(0xFF24A36A),
                    ),
                    SizedBox(height: 12),
                    _FallbackPerformanceLine(
                      'Failed',
                      '0%',
                      Color(0xFFEF4444),
                      dot: Color(0xFFEF4444),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const SizedBox(
                width: 116,
                height: 116,
                child: CustomPaint(
                  painter: _FallbackDonutPainter(),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '0',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF17233C),
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Total Messages',
                          style: TextStyle(
                            fontSize: 7,
                            color: Color(0xFF60758F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F6EF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Icon(Icons.circle, size: 9, color: Color(0xFF24A36A)),
              SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Delivery rate',
                  style: TextStyle(fontSize: 11, color: Color(0xFF60758F)),
                ),
              ),
              Text(
                '0%',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF24A36A),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _fallbackCampaignRow(
    String name,
    String order,
    String count,
    String date,
  ) => Container(
    constraints: const BoxConstraints(minHeight: 55),
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: Color(0xFFDCE3EF))),
    ),
    child: Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6F5F8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.hub_rounded,
                  color: Color(0xFF24A36A),
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF17233C),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(order, style: const TextStyle(fontSize: 11)),
        ),
        Expanded(
          child: Text(
            count,
            style: const TextStyle(fontSize: 11, color: Color(0xFF60758F)),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            date,
            style: const TextStyle(fontSize: 10, color: Color(0xFF60758F)),
          ),
        ),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE7F9EF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Completed',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF169B5B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const Icon(Icons.chevron_right, size: 17, color: Color(0xFF718096)),
      ],
    ),
  );
}
