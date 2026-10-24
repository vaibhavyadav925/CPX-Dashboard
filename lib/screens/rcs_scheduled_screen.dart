part of '../app.dart';

class RCSScheduledScreen extends StatelessWidget {
  const RCSScheduledScreen({super.key});

  static const List<List<String>> _campaigns = [
    [
      'scllldd',
      'Standard',
      'Webtechage',
      '1 Contacts',
      '2/9/2026, 11:27:00 pm',
      'Sent',
    ],
    [
      'test sched',
      'Standard',
      'Webtechage',
      '1 Contacts',
      '2/9/2026, 11:17:00 pm',
      'Canceled',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 850;

    return Scaffold(
      drawer: const DashboardDrawer(
        currentPage: 'Scheduled',
        currentGroup: 'RCS-App',
      ),
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
                  headingRowColor: WidgetStateProperty.all(
                    panelAccent(context),
                  ),
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
                      label: SizedBox(width: 180, child: Text('Recipients')),
                    ),
                    DataColumn(
                      label: SizedBox(width: 220, child: Text('Scheduled for')),
                    ),
                    DataColumn(
                      label: SizedBox(width: 120, child: Text('Status')),
                    ),
                    DataColumn(
                      label: SizedBox(width: 80, child: Text('Actions')),
                    ),
                  ],
                  rows: _campaigns.map((campaign) {
                    final isSent = campaign[5] == 'Sent';
                    return DataRow(
                      cells: [
                        DataCell(Text(campaign[0])),
                        DataCell(Text(campaign[1])),
                        DataCell(Text(campaign[2])),
                        DataCell(Text(campaign[3])),
                        DataCell(Text(campaign[4])),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isSent
                                  ? const Color(0xFFE4F8EC)
                                  : const Color(0xFFFBE9EB),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              campaign[5],
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
