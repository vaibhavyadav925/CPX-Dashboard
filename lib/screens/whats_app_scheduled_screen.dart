part of '../app.dart';

class WhatsAppScheduledScreen extends StatelessWidget {
  const WhatsAppScheduledScreen({super.key});

  static const List<List<String>> _campaigns = [
    [
      'scheduled',
      'Standard',
      'wa_template',
      '1',
      'Sent',
      '3/9/2026, 4:44:00 am',
    ],
    [
      'claude_pause_test_renamed',
      'Standard',
      'webtechage_test_template',
      '1',
      'Canceled',
      '15/1/2027, 2:30:00 pm',
    ],
    [
      'claude_schedule_test',
      'Standard',
      'webtechage_test_template',
      '1',
      'Canceled',
      '31/12/2026, 3:30:00 pm',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 850;

    return Scaffold(
      drawer: const DashboardDrawer(currentPage: 'Scheduled'),
      appBar: buildCpxBoatAppBar(context),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(wide ? 22 : 13),
          children: [
            const Text(
              'Scheduled campaigns',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: navy,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Campaigns queued to send at a future time.',
              style: TextStyle(fontSize: 12, color: muted),
            ),
            const SizedBox(height: 22),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: _cardDecoration(radius: 13),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  horizontalMargin: 16,
                  columnSpacing: wide ? 30 : 20,
                  headingRowHeight: 43,
                  dataRowMinHeight: 43,
                  dataRowMaxHeight: 52,
                  dividerThickness: 0.7,
                  headingRowColor: WidgetStateProperty.all(teal),
                  headingTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  dataTextStyle: const TextStyle(
                    color: Color(0xFF526078),
                    fontSize: 12,
                  ),
                  columns: const [
                    DataColumn(
                      label: SizedBox(width: 190, child: Text('Campaign')),
                    ),
                    DataColumn(
                      label: SizedBox(width: 130, child: Text('Type')),
                    ),
                    DataColumn(
                      label: SizedBox(width: 190, child: Text('Template')),
                    ),
                    DataColumn(
                      label: SizedBox(width: 100, child: Text('Recipients')),
                    ),
                    DataColumn(
                      label: SizedBox(width: 140, child: Text('Status')),
                    ),
                    DataColumn(
                      label: SizedBox(width: 230, child: Text('Scheduled for')),
                    ),
                    DataColumn(
                      label: SizedBox(width: 80, child: Text('Actions')),
                    ),
                  ],
                  rows: _campaigns.map((campaign) {
                    final isSent = campaign[4] == 'Sent';
                    return DataRow(
                      cells: [
                        DataCell(Text(campaign[0])),
                        DataCell(Text(campaign[1])),
                        DataCell(Text(campaign[2])),
                        DataCell(Text(campaign[3])),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isSent
                                  ? const Color(0xFFE4F8ED)
                                  : const Color(0xFFFCE8E9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              campaign[4],
                              style: TextStyle(
                                color: isSent
                                    ? const Color(0xFF07945B)
                                    : const Color(0xFFE53945),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        DataCell(Text(campaign[5])),
                        const DataCell(
                          Icon(
                            Icons.more_horiz_rounded,
                            color: muted,
                            size: 19,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
