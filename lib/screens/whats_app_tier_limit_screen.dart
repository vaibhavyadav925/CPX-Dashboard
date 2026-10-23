part of '../app.dart';

class WhatsAppTierLimitScreen extends StatelessWidget {
  const WhatsAppTierLimitScreen({super.key});

  static const _tiers = <(String, String)>[
    ('Tier 0', '250'),
    ('Tier 1', '1,000'),
    ('Tier 1.5', '2,000'),
    ('Tier 2', '10,000'),
    ('Tier 3', '1,00,000'),
    ('Tier 4 — Unlimited', 'Unlimited'),
  ];

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 850;

    return Scaffold(
      drawer: const DashboardDrawer(currentPage: 'Tier Limit'),
      appBar: buildCpxBoatAppBar(context),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(wide ? 22 : 13),
          children: [
            const Text(
              'Tier limit',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: navy,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Meta's 24-hour messaging tier — how many unique customers you can message in a rolling 24-hour window.",
              style: TextStyle(fontSize: 12, color: muted),
            ),
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(wide ? 22 : 16),
              decoration: _cardDecoration(radius: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current tier',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Meta raises this automatically as your account builds a track record of quality sending.',
                    style: TextStyle(fontSize: 12, color: muted),
                  ),
                  const SizedBox(height: 24),
                  const Row(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xFFE6F5F7),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: SizedBox(
                          width: 46,
                          height: 46,
                          child: Icon(
                            Icons.speed_rounded,
                            color: teal,
                            size: 25,
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tier 4 — Unlimited',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: navy,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'No daily limit',
                              style: TextStyle(fontSize: 12, color: muted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth >= 1050
                          ? 4
                          : constraints.maxWidth >= 620
                          ? 3
                          : 2;
                      const gap = 10.0;
                      final width =
                          (constraints.maxWidth - gap * (columns - 1)) /
                          columns;
                      return Wrap(
                        spacing: gap,
                        runSpacing: gap,
                        children: _tiers.map((tier) {
                          final current = tier.$1 == 'Tier 4 — Unlimited';
                          return Container(
                            width: width,
                            height: 64,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: current
                                  ? const Color(0xFFF1FAFC)
                                  : Colors.white,
                              border: Border.all(
                                color: current ? teal : const Color(0xFFDCE2ED),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  tier.$1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: current ? teal : muted,
                                    fontWeight: current
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  tier.$2,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: navy,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
