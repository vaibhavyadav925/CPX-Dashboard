part of '../app.dart';

class WhatsAppDashboardScreen extends StatelessWidget {
  const WhatsAppDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 850;
    return Scaffold(
      drawer: const DashboardDrawer(
        currentPage: 'Dashboard',
        currentGroup: 'WhatsApp-App',
      ),
      appBar: buildCpxBoatAppBar(context),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(wide ? 22 : 13),
          children: [
            const Text(
              'WhatsApp-App Dashboard',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: navy,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Monitor your WhatsApp messaging performance at a glance.',
              style: TextStyle(fontSize: 12, color: muted),
            ),
            const SizedBox(height: 18),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 1000
                    ? 4
                    : constraints.maxWidth >= 560
                    ? 2
                    : 1;
                const gap = 12.0;
                final cardWidth =
                    (constraints.maxWidth - gap * (columns - 1)) / columns;
                final metrics = <(String, String, String, IconData, Color)>[
                  (
                    'Wallet Balance',
                    '₹6,278',
                    'Available balance',
                    Icons.account_balance_wallet_outlined,
                    teal,
                  ),
                  (
                    'Total Campaigns',
                    '40',
                    'All campaigns',
                    Icons.campaign_outlined,
                    const Color(0xFF3989D9),
                  ),
                  (
                    'Unique Users (24h)',
                    '0',
                    'Active users today',
                    Icons.people_outline_rounded,
                    const Color(0xFF8A63D2),
                  ),
                  (
                    'Account Quality',
                    'GREEN',
                    'Messaging quality',
                    Icons.verified_user_outlined,
                    const Color(0xFF16A878),
                  ),
                ];
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: metrics
                      .map(
                        (metric) => SizedBox(
                          width: cardWidth,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: _cardDecoration(radius: 14),
                            child: Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: metric.$5.withValues(alpha: .12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    metric.$4,
                                    color: metric.$5,
                                    size: 21,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        metric.$1,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: muted,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        metric.$2,
                                        style: const TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.w800,
                                          color: navy,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        metric.$3,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: muted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(radius: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Campaign Activity',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Messaging activity over the last 7 days',
                    style: TextStyle(fontSize: 11, color: muted),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 175,
                    width: double.infinity,
                    child: CustomPaint(painter: TrafficPainter()),
                  ),
                  const SizedBox(height: 8),
                  const Wrap(
                    spacing: 14,
                    runSpacing: 6,
                    children: [
                      Legend(color: Color(0xFF16A878), label: 'Delivered'),
                      Legend(color: Color(0xFFE45D61), label: 'Failed'),
                      Legend(color: Color(0xFFE9A52A), label: 'Initiated'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFDCE5F3)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x160D2B55),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 16, 16),
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
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'All campaigns screen coming next',
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: teal,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            minimumSize: const Size(0, 32),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('View all', style: TextStyle(fontSize: 12)),
                              SizedBox(width: 2),
                              Icon(Icons.chevron_right_rounded, size: 17),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      horizontalMargin: 18,
                      columnSpacing: 28,
                      headingRowHeight: 44,
                      dataRowMinHeight: 72,
                      dataRowMaxHeight: 72,
                      dividerThickness: 0.7,
                      headingRowColor: WidgetStateProperty.all(
                        const Color(0xFF0B91AD),
                      ),
                      headingTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      dataTextStyle: const TextStyle(
                        color: Color(0xFF4E607C),
                        fontSize: 12,
                      ),
                      columns: const [
                        DataColumn(
                          label: SizedBox(
                            width: 260,
                            child: Text('Campaign Name'),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: 160,
                            child: Text('Template Name'),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(width: 140, child: Text('Count')),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: 170,
                            child: Text('Date & Time'),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(width: 150, child: Text('Status')),
                        ),
                        DataColumn(label: SizedBox(width: 20, child: Text(''))),
                      ],
                      rows: const [
                        DataRow(
                          cells: [
                            DataCell(_CampaignName(name: 'test_DLR')),
                            DataCell(Text('wa_template')),
                            DataCell(_CampaignCount(count: '19')),
                            DataCell(Text('09 Sept, 04:54 pm')),
                            DataCell(_CampaignStatus(status: 'Completed')),
                            DataCell(
                              Icon(
                                Icons.chevron_right_rounded,
                                color: Color(0xFF718096),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(_CampaignName(name: 'wa_testing')),
                            DataCell(Text('wa_template')),
                            DataCell(_CampaignCount(count: '13')),
                            DataCell(Text('08 Sept, 11:23 pm')),
                            DataCell(_CampaignStatus(status: 'Completed')),
                            DataCell(
                              Icon(
                                Icons.chevron_right_rounded,
                                color: Color(0xFF718096),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(
                              _CampaignName(name: 'XAkzcnAPCIWJSCIPWKL'),
                            ),
                            DataCell(Text('wa_template')),
                            DataCell(_CampaignCount(count: '5000')),
                            DataCell(Text('04 Sept, 05:08 pm')),
                            DataCell(_CampaignStatus(status: 'Completed')),
                            DataCell(
                              Icon(
                                Icons.chevron_right_rounded,
                                color: Color(0xFF718096),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(_CampaignName(name: 'testnew')),
                            DataCell(Text('wa_template')),
                            DataCell(_CampaignCount(count: '1')),
                            DataCell(Text('03 Sept, 12:35 pm')),
                            DataCell(_CampaignStatus(status: 'Completed')),
                            DataCell(
                              Icon(
                                Icons.chevron_right_rounded,
                                color: Color(0xFF718096),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(_CampaignName(name: 'testnew1')),
                            DataCell(Text('wa_template')),
                            DataCell(_CampaignCount(count: '1')),
                            DataCell(Text('03 Sept, 12:30 pm')),
                            DataCell(_CampaignStatus(status: 'Completed')),
                            DataCell(
                              Icon(
                                Icons.chevron_right_rounded,
                                color: Color(0xFF718096),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                '© CPXBOAT • WhatsApp-App',
                style: TextStyle(fontSize: 10, color: muted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
