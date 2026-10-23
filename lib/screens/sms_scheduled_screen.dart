part of '../app.dart';

class SMSScheduledScreen extends StatelessWidget {
  const SMSScheduledScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 850;

    return Scaffold(
      drawer: const DashboardDrawer(currentPage: 'Scheduled'),
      appBar: buildCpxBoatAppBar(context),
      body: Container(
        color: const Color(0xFFF4F6FB),
        child: ListView(
          padding: EdgeInsets.all(wide ? 22 : 13),
          children: [
            const Text(
              'Scheduled SMS Campaigns',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: navy,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'Campaigns queued to send at a future date/time.',
              style: TextStyle(fontSize: 12, color: muted),
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: _cardDecoration(radius: 13),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFD9E0EC)),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 41,
                        color: teal,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: const Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Text(
                                'Campaign Name',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Scheduled For',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 68,
                              child: Text(
                                'Actions',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 103,
                        child: Center(
                          child: Text(
                            'No scheduled campaigns.',
                            style: TextStyle(color: muted, fontSize: 12),
                          ),
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
    );
  }
}
