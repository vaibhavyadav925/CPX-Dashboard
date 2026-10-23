part of '../app.dart';

class WhatsAppFlowsScreen extends StatelessWidget {
  const WhatsAppFlowsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 850;

    return Scaffold(
      drawer: const DashboardDrawer(currentPage: 'Flows'),
      appBar: buildCpxBoatAppBar(context),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(wide ? 22 : 13),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.account_tree_outlined,
                    color: teal,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Flows',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: navy,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Interactive WhatsApp forms — sign-ups, bookings, surveys — that open right inside the chat.',
                        style: TextStyle(
                          fontSize: 12,
                          color: muted,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Container(
              padding: EdgeInsets.all(wide ? 22 : 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFDCE2EC)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A101828),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4E5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.account_tree_outlined,
                      color: Color(0xFFF59E0B),
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 13),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Flows aren't available for this account",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: navy,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "This WhatsApp account isn't set up for Flows yet — it needs to complete Meta's Joint Solution setup.",
                          style: TextStyle(
                            fontSize: 12,
                            color: muted,
                            height: 1.5,
                          ),
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
}
