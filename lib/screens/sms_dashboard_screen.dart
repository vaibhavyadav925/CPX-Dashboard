part of '../app.dart';

class SMSDashboardScreen extends StatelessWidget {
  const SMSDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final compact = width < 900;
    const metrics = <(String, String, IconData, Color)>[
      ('Wallet balance', '₹2.648', Icons.account_balance_wallet_outlined, teal),
      ('DLT Templates', '1', Icons.description_outlined, Color(0xFF20A36A)),
      ('Total campaigns', '2', Icons.send_outlined, Color(0xFFFF9800)),
      ('Scheduled', '0', Icons.access_time_rounded, teal),
    ];
    return Scaffold(
      drawer: const DashboardDrawer(currentPage: 'Dashboard'),
      appBar: buildCpxBoatAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(compact ? 12 : 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hi, ajay 👋',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: navy,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              "Here's what's happening with your SMS channel.",
              style: TextStyle(fontSize: 12, color: muted),
            ),
            const SizedBox(height: 22),
            GridView.count(
              crossAxisCount: compact ? 2 : 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: compact ? 1.9 : 2.35,
              children: metrics
                  .map(
                    (m) => Container(
                      padding: const EdgeInsets.all(18),
                      decoration: _cardDecoration(radius: 14).copyWith(
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x16000000),
                            blurRadius: 5,
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
                                  m.$1,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: muted,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  m.$2,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: navy,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: m.$4.withValues(alpha: .11),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(m.$3, color: m.$4, size: 20),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 18),
            if (width >= 1050)
              SizedBox(
                height: 344,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(flex: 7, child: _smsActivityCard()),
                    const SizedBox(width: 14),
                    Expanded(flex: 3, child: _smsPerformanceCard()),
                  ],
                ),
              )
            else ...[
              SizedBox(height: 330, child: _smsActivityCard()),
              const SizedBox(height: 14),
              SizedBox(height: 330, child: _smsPerformanceCard()),
            ],
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              decoration: _cardDecoration(radius: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
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
                          onPressed: () => Navigator.of(context)
                              .pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const WhatsAppCampaignsScreen(),
                                ),
                              ),
                          child: const Text(
                            'View all  ›',
                            style: TextStyle(color: teal, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(teal),
                      headingTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                      dataTextStyle: const TextStyle(color: navy, fontSize: 12),
                      columns: const [
                        DataColumn(label: Text('Campaign Name')),
                        DataColumn(label: Text('Template Name')),
                        DataColumn(label: Text('Count')),
                        DataColumn(label: Text('Date & Time')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('')),
                      ],
                      rows: const [
                        DataRow(
                          cells: [
                            DataCell(Text('—')),
                            DataCell(Text('—')),
                            DataCell(Text('♧ 0')),
                            DataCell(Text('—')),
                            DataCell(Text('Unknown')),
                            DataCell(
                              Icon(Icons.chevron_right_rounded, size: 18),
                            ),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text('—')),
                            DataCell(Text('—')),
                            DataCell(Text('♧ 0')),
                            DataCell(Text('—')),
                            DataCell(Text('Unknown')),
                            DataCell(
                              Icon(Icons.chevron_right_rounded, size: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smsActivityCard() => Container(
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
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: navy,
                ),
              ),
            ),
            DropdownButton<String>(
              value: 'Last 10 days',
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(
                  value: 'Last 10 days',
                  child: Text('Last 10 days', style: TextStyle(fontSize: 12)),
                ),
              ],
              onChanged: (_) {},
            ),
          ],
        ),
        const SizedBox(height: 18),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendDot(color: Color(0xFF4285FF), label: 'Delivered'),
            SizedBox(width: 10),
            _LegendDot(color: Color(0xFFEF5350), label: 'Failed'),
            SizedBox(width: 10),
            _LegendDot(color: Color(0xFFFFA000), label: 'Sent'),
          ],
        ),
        const SizedBox(height: 12),
        const Expanded(
          child: CustomPaint(
            painter: _SMSActivityPainter(),
            child: SizedBox.expand(),
          ),
        ),
      ],
    ),
  );

  Widget _smsPerformanceCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: _cardDecoration(radius: 14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Campaign performance',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: navy,
          ),
        ),
        const SizedBox(height: 25),
        Expanded(
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total messages',
                      style: TextStyle(fontSize: 12, color: muted),
                    ),
                    SizedBox(height: 14),
                    _PerformanceLegend(
                      color: Color(0xFFFFA000),
                      label: 'Sent',
                      value: '0%',
                    ),
                    SizedBox(height: 12),
                    _PerformanceLegend(
                      color: Color(0xFF4285FF),
                      label: 'Delivered',
                      value: '0%',
                    ),
                    SizedBox(height: 12),
                    _PerformanceLegend(
                      color: Color(0xFFEF5350),
                      label: 'Failed',
                      value: '0%',
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 125,
                height: 125,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFEAEDF3),
                          width: 12,
                        ),
                      ),
                    ),
                    const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '0',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: navy,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Total SMS Sent',
                          style: TextStyle(fontSize: 9, color: muted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFE9F5EF),
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Row(
            children: [
              Icon(Icons.circle, color: Color(0xFF2C9B68), size: 10),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Delivery rate',
                  style: TextStyle(fontSize: 12, color: muted),
                ),
              ),
              Text(
                '0%',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF168B58),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
