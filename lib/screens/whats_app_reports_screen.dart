part of '../app.dart';

class WhatsAppReportsScreen extends StatefulWidget {
  const WhatsAppReportsScreen({super.key});
  @override
  State<WhatsAppReportsScreen> createState() => _WhatsAppReportsScreenState();
}

class _WhatsAppReportsScreenState extends State<WhatsAppReportsScreen> {
  int _tab = 0;
  final TextEditingController _search = TextEditingController();
  final String _status = 'All';
  final String _number = 'All numbers';
  final String _chatbot = 'vdcxvd csc';
  DateTime? _from;
  DateTime? _to;

  final List<Map<String, String>> _campaigns = const [
    {
      'name': 'test_DLR',
      'template': 'wa_template',
      'account': 'Webtechage Pvt Ltd',
      'phone': '+1 555 944 0081',
      'status': 'Completed',
      'total': '19',
      'sent': '1',
      'delivered': '5',
      'read': '5',
      'failed': '8',
      'date': '9/9/2026',
      'time': '4:54:27 pm',
    },
    {
      'name': 'wa_testing',
      'template': 'wa_template',
      'account': 'Webtechage Pvt Ltd',
      'phone': '+1 555 944 0081',
      'status': 'Completed',
      'total': '13',
      'sent': '1',
      'delivered': '0',
      'read': '11',
      'failed': '1',
      'date': '8/9/2026',
      'time': '11:23:42 pm',
    },
    {
      'name': 'XAkzcnAPCIWJSCIPWK...',
      'template': 'wa_template',
      'account': 'Webtechage Pvt Ltd',
      'phone': '+1 555 944 0081',
      'status': 'Completed',
      'total': '5,000',
      'sent': '998',
      'delivered': '0',
      'read': '1',
      'failed': '4,001',
      'date': '4/9/2026',
      'time': '5:08:11 pm',
    },
    {
      'name': 'testnew',
      'template': 'wa_template',
      'account': 'Webtechage Pvt Ltd',
      'phone': '+1 555 944 0081',
      'status': 'Completed',
      'total': '1',
      'sent': '0',
      'delivered': '0',
      'read': '1',
      'failed': '0',
      'date': '3/9/2026',
      'time': '12:35:30 pm',
    },
    {
      'name': 'testnew1',
      'template': 'wa_template',
      'account': 'Webtechage Pvt Ltd',
      'phone': '+1 555 944 0081',
      'status': 'Completed',
      'total': '1',
      'sent': '0',
      'delivered': '0',
      'read': '0',
      'failed': '1',
      'date': '3/9/2026',
      'time': '12:30:57 pm',
    },
    {
      'name': 'test',
      'template': 'wa_template',
      'account': 'Webtechage Pvt Ltd',
      'phone': '+1 555 944 0081',
      'status': 'Completed',
      'total': '1',
      'sent': '0',
      'delivered': '0',
      'read': '0',
      'failed': '1',
      'date': '3/9/2026',
      'time': '11:20:53 am',
    },
    {
      'name': 'schdeled',
      'template': 'wa_template',
      'account': 'Webtechage Pvt Ltd',
      'phone': '+1 555 944 0081',
      'status': 'Completed',
      'total': '1',
      'sent': '0',
      'delivered': '0',
      'read': '1',
      'failed': '0',
      'date': '3/9/2026',
      'time': '10:58:10 am',
    },
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool from) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (from ? _from : _to) ?? DateTime(2026, 9, 9),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        if (from) {
          _from = picked;
        } else {
          _to = picked;
        }
      });
    }
  }

  String _dateText(DateTime? d) => d == null
      ? 'dd-mm-yyyy'
      : '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';

  Widget _panel({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(16),
  }) => Container(
    padding: padding,
    decoration: _cardDecoration(radius: 14),
    child: child,
  );

  Widget _heading() => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Reports',
        style: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w800,
          color: navy,
        ),
      ),
      SizedBox(height: 4),
      Text(
        'Delivery performance across your RCS campaigns.',
        style: TextStyle(fontSize: 12, color: muted),
      ),
    ],
  );

  Widget _tabs() {
    const labels = [
      'Campaigns',
      'Live Message Reports',
      'Conversation Reports',
      'Chatbot Reports',
      'API Reports',
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          labels.length,
          (i) => InkWell(
            onTap: () => setState(() => _tab = i),
            child: Container(
              padding: const EdgeInsets.fromLTRB(15, 12, 15, 11),
              margin: const EdgeInsets.only(right: 2),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: _tab == i
                        ? panelAccent(context)
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                labels[i],
                style: TextStyle(
                  fontSize: 12,
                  color: _tab == i
                      ? panelAccent(context)
                      : const Color(0xFF526078),
                  fontWeight: _tab == i ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _metric(String label, String value, IconData icon, Color color) =>
      Container(
        padding: const EdgeInsets.all(20),
        decoration: _cardDecoration(radius: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 12, color: muted),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                      color: navy,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: color, size: 21),
            ),
          ],
        ),
      );

  Widget _campaignReport() {
    final shown = _campaigns
        .where(
          (c) =>
              c['name']!.toLowerCase().contains(_search.text.toLowerCase()) &&
              (_status == 'All' || c['status'] == _status),
        )
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, box) {
            final cols = box.maxWidth > 1100
                ? 5
                : box.maxWidth > 700
                ? 3
                : 2;
            final w = (box.maxWidth - (cols - 1) * 14) / cols;
            final items = [
              (
                'Initiated',
                '3,13,467',
                Icons.rocket_launch_outlined,
                Color(0xFF202A40),
              ),
              (
                'Total Sent',
                '1,61,137',
                Icons.account_balance_wallet_outlined,
                panelAccent(context),
              ),
              (
                'Delivered',
                '45,050',
                Icons.check_circle_outline,
                Color(0xFF16A878),
              ),
              (
                'Read',
                '34,545',
                Icons.visibility_outlined,
                panelAccent(context),
              ),
              ('Failed', '1,52,330', Icons.highlight_off, Color(0xFFEF4444)),
            ];
            return Wrap(
              spacing: 14,
              runSpacing: 14,
              children: items
                  .map(
                    (m) => SizedBox(
                      width: w,
                      child: _metric(m.$1, m.$2, m.$3, m.$4),
                    ),
                  )
                  .toList(),
            );
          },
        ),
        const SizedBox(height: 18),
        Container(
          decoration: _cardDecoration(radius: 14),
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              horizontalMargin: 16,
              columnSpacing: 22,
              headingRowHeight: 42,
              dataRowMinHeight: 64,
              dataRowMaxHeight: 68,
              headingRowColor: WidgetStateProperty.all(panelAccent(context)),
              headingTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              dataTextStyle: const TextStyle(color: navy, fontSize: 12),
              columns: const [
                DataColumn(label: Text('Campaign')),
                DataColumn(label: Text('Account')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Total')),
                DataColumn(label: Text('Sent')),
                DataColumn(label: Text('Delivered')),
                DataColumn(label: Text('Read')),
                DataColumn(label: Text('Failed')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Actions')),
              ],
              rows: shown
                  .map(
                    (c) => DataRow(
                      cells: [
                        DataCell(
                          SizedBox(
                            width: 170,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c['name']!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: navy,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  c['template']!,
                                  style: const TextStyle(
                                    color: muted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            width: 125,
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF0F5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  c['account']!,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: navy,
                                  ),
                                ),
                                Text(
                                  c['phone']!,
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5EF),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              c['status']!,
                              style: const TextStyle(
                                color: Color(0xFF07945B),
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                        DataCell(Text(c['total']!)),
                        DataCell(
                          Text(
                            c['sent']!,
                            style: const TextStyle(color: Color(0xFFF59E0B)),
                          ),
                        ),
                        DataCell(
                          Text(
                            c['delivered']!,
                            style: TextStyle(color: panelAccent(context)),
                          ),
                        ),
                        DataCell(
                          Text(
                            c['read']!,
                            style: const TextStyle(color: Color(0xFF16A878)),
                          ),
                        ),
                        DataCell(
                          Text(
                            c['failed']!,
                            style: const TextStyle(color: Color(0xFFEF4444)),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF0F5),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Text(
                              '${c['date']}\n${c['time']}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: muted,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'View report',
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        WhatsAppCampaignReportDetail(
                                          campaign: c,
                                        ),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.visibility_outlined,
                                  size: 17,
                                  color: navy,
                                ),
                              ),
                              IconButton(
                                tooltip: 'Download report',
                                onPressed: () => ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Report download is a demo action.',
                                        ),
                                      ),
                                    ),
                                icon: const Icon(
                                  Icons.download_outlined,
                                  size: 17,
                                  color: navy,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dateField(String label, VoidCallback onTap) => InkWell(
    onTap: onTap,
    child: SizedBox(
      width: 135,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: navy)),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FC),
              border: Border.all(color: const Color(0xFFDDE3ED)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _dateText(label == 'From' ? _from : _to),
                    style: const TextStyle(fontSize: 11, color: navy),
                  ),
                ),
                const Icon(Icons.calendar_month_outlined, size: 15),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _getReportsButton({
    String label = 'Get Reports',
    VoidCallback? onPressed,
  }) => FilledButton(
    onPressed: onPressed ?? () => setState(() {}),
    style: FilledButton.styleFrom(
      backgroundColor: panelAccent(context),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
    ),
    child: Text(
      label,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
    ),
  );

  Widget _emptyState(String message) => _panel(
    padding: const EdgeInsets.symmetric(vertical: 44, horizontal: 18),
    child: SizedBox(
      width: double.infinity,
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: muted),
        ),
      ),
    ),
  );

  Widget _liveReports() => Column(
    children: [
      _panel(
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            _dateField('From', () => _pickDate(true)),
            _dateField('To', () => _pickDate(false)),
            _getReportsButton(),
          ],
        ),
      ),
      const SizedBox(height: 20),
      _emptyState(
        'Select a date range and click "Get Reports" to view message data.',
      ),
    ],
  );

  Widget _conversationReports() => Column(
    children: [
      _panel(
        child: Wrap(
          spacing: 10,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            _dateField('From', () => _pickDate(true)),
            _dateField('To', () => _pickDate(false)),
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text('or', style: TextStyle(color: muted, fontSize: 12)),
            ),
            SizedBox(
              width: 310,
              child: TextField(
                controller: _search,
                decoration: InputDecoration(
                  hintText: 'Search by number, contact, or message...',
                  prefixIcon: const Icon(Icons.search, size: 18),
                  isDense: true,
                  filled: true,
                  fillColor: const Color(0xFFF8F9FC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            _getReportsButton(),
            OutlinedButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Select a report to download chat.'),
                ),
              ),
              icon: const Icon(Icons.download_outlined, size: 16),
              label: const Text('Download Chat'),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      _emptyState('Click "Get Reports" to view inbox activity.'),
    ],
  );

  Widget _chatbotReports() => Column(
    children: [
      _panel(
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            _dateField('From', () => _pickDate(true)),
            _dateField('To', () => _pickDate(false)),
            _getReportsButton(),
            OutlinedButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Select a date range before downloading.'),
                ),
              ),
              icon: const Icon(Icons.download_outlined, size: 16),
              label: const Text('Download Report'),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      _emptyState('Click "Get Reports" to view chatbot activity.'),
    ],
  );

  Widget _apiReports() => Column(
    children: [
      _panel(
        child: LayoutBuilder(
          builder: (context, constraints) => Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.end,
            alignment: WrapAlignment.start,
            children: [
              _dateField('From', () => _pickDate(true)),
              _dateField('To', () => _pickDate(false)),
              _getReportsButton(),
              SizedBox(
                width: constraints.maxWidth > 900 ? 420 : 260,
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    '〈/〉  Messages sent through the Developer API',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 11, color: muted),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 20),
      _emptyState(
        'Select a date range and click "Get Reports" to see messages sent through the API.',
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 850;
    return Scaffold(
      drawer: const DashboardDrawer(
        currentPage: 'Reports',
        currentGroup: 'WhatsApp-App',
      ),
      appBar: buildCpxBoatAppBar(context),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(wide ? 22 : 13),
          children: [
            _heading(),
            const SizedBox(height: 16),
            _tabs(),
            const Divider(height: 1, color: Color(0xFFDCE2EC)),
            const SizedBox(height: 20),
            if (_tab == 0)
              _campaignReport()
            else if (_tab == 1)
              _liveReports()
            else if (_tab == 2)
              _conversationReports()
            else if (_tab == 3)
              _chatbotReports()
            else
              _apiReports(),
            const SizedBox(height: 18),
            const Center(
              child: Text(
                '© CPXBOAT • WhatsApp-App Reports',
                style: TextStyle(fontSize: 10, color: muted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
