part of '../app.dart';

class RCSDashboardScreen extends StatelessWidget {
  const RCSDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final wide = width >= 1050;
    final medium = width >= 650;
    const metrics = <(String, String, String, IconData, Color)>[
      (
        'Wallet balance',
        '₹6.28',
        'Expires 21/8/2026',
        Icons.account_balance_wallet_outlined,
        teal,
      ),
      (
        'Delivery rate',
        '55%',
        '45,050 of 81,542 sent messages delivered',
        Icons.trending_up_rounded,
        Color(0xFF0B91AD),
      ),
      ('Total campaigns', '124', '', Icons.send_outlined, Color(0xFF0B91AD)),
      (
        'Approved templates',
        '12',
        '',
        Icons.check_circle_outline_rounded,
        Color(0xFF20A36A),
      ),
    ];
    return Scaffold(
      drawer: const DashboardDrawer(currentPage: 'Dashboard'),
      appBar: buildCpxBoatAppBar(context),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(wide ? 22 : 13),
          children: [
            const Text(
              'Hi, Vaibhav 👋',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: navy,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Here's what's happening with your RCS channel.",
              style: TextStyle(fontSize: 12, color: muted),
            ),
            const SizedBox(height: 22),
            LayoutBuilder(
              builder: (context, c) {
                final columns = c.maxWidth >= 1100
                    ? 4
                    : c.maxWidth >= 600
                    ? 2
                    : 1;
                const gap = 14.0;
                final cardWidth = (c.maxWidth - gap * (columns - 1)) / columns;
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: metrics
                      .map(
                        (m) => SizedBox(
                          width: cardWidth,
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 120),
                            padding: const EdgeInsets.all(20),
                            decoration: _cardDecoration(radius: 15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          fontSize: 23,
                                          fontWeight: FontWeight.w800,
                                          color: navy,
                                        ),
                                      ),
                                      if (m.$3.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          m.$3,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: muted,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: m.$5.withValues(alpha: .12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(m.$4, color: m.$5, size: 21),
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
            const SizedBox(height: 18),
            if (wide)
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 65, child: _RCSActivitySummaryCard()),
                  SizedBox(width: 14),
                  Expanded(flex: 35, child: _RCSDeliverySummaryCard()),
                ],
              )
            else ...[
              const _RCSActivitySummaryCard(),
              const SizedBox(height: 14),
              const _RCSDeliverySummaryCard(),
            ],
            const SizedBox(height: 18),
            _RCSRecentCampaignsCard(medium: medium),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                '© CPXBOAT • RCS-App',
                style: TextStyle(fontSize: 10, color: muted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
