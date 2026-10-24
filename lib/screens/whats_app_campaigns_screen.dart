part of '../app.dart';

class WhatsAppCampaignsScreen extends StatefulWidget {
  const WhatsAppCampaignsScreen({super.key});
  @override
  State<WhatsAppCampaignsScreen> createState() =>
      _WhatsAppCampaignsScreenState();
}

class _WhatsAppCampaignsScreenState extends State<WhatsAppCampaignsScreen> {
  final TextEditingController _search = TextEditingController();
  String _status = 'All statuses';
  DateTime? _from, _to;
  final Set<int> _selectedCampaigns = <int>{};
  final List<CampaignRecord> _campaigns = const [
    CampaignRecord(
      name: 'test_DLR',
      template: 'wa_template',
      count: '19 Contacts',
      date: '9/9/2026',
      time: '04:54 pm',
      amount: '₹10.35',
      total: 19,
      read: 5,
      delivered: 5,
      sent: 1,
      failed: 8,
    ),
    CampaignRecord(
      name: 'wa_testing',
      template: 'wa_template',
      count: '13 Contacts',
      date: '9/8/2026',
      time: '11:23 pm',
      amount: '₹11.29',
      total: 13,
      read: 4,
      delivered: 6,
      sent: 1,
      failed: 2,
    ),
    CampaignRecord(
      name: 'XAkzcnAPCIWJSCIPWKL',
      template: 'wa_template',
      count: '5,000 Contacts',
      date: '9/4/2026',
      time: '05:08 pm',
      amount: '₹939.86',
      total: 5000,
      read: 3200,
      delivered: 1600,
      sent: 100,
      failed: 100,
    ),
    CampaignRecord(
      name: 'testnew',
      template: 'wa_template',
      count: '1 Contacts',
      date: '9/3/2026',
      time: '12:35 pm',
      amount: '₹0.94',
      total: 1,
      read: 0,
      delivered: 1,
      sent: 0,
      failed: 0,
    ),
    CampaignRecord(
      name: 'testnew1',
      template: 'wa_template',
      count: '1 Contacts',
      date: '9/3/2026',
      time: '12:30 pm',
      amount: '₹0.00',
      total: 1,
      read: 0,
      delivered: 0,
      sent: 0,
      failed: 1,
    ),
    CampaignRecord(
      name: 'test',
      template: 'wa_template',
      count: '1 Contacts',
      date: '9/3/2026',
      time: '11:20 am',
      amount: '₹0.00',
      total: 1,
      read: 0,
      delivered: 0,
      sent: 0,
      failed: 1,
    ),
    CampaignRecord(
      name: 'schdeled',
      template: 'wa_template',
      count: '1 Contacts',
      date: '9/3/2026',
      time: '10:58 am',
      amount: '₹0.94',
      total: 1,
      read: 0,
      delivered: 1,
      sent: 0,
      failed: 0,
    ),
  ];
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<CampaignRecord> get _filtered => _campaigns.where((c) {
    final q = _search.text.trim().toLowerCase();
    final matchesSearch =
        q.isEmpty ||
        c.name.toLowerCase().contains(q) ||
        c.template.toLowerCase().contains(q);
    final matchesStatus = _status == 'All statuses' || _status == 'Completed';
    DateTime? date;
    try {
      final p = c.date.split('/');
      date = DateTime(int.parse(p[2]), int.parse(p[0]), int.parse(p[1]));
    } catch (_) {}
    final matchesFrom =
        _from == null ||
        (date != null &&
            !date.isBefore(DateTime(_from!.year, _from!.month, _from!.day)));
    final matchesTo =
        _to == null ||
        (date != null &&
            !date.isAfter(DateTime(_to!.year, _to!.month, _to!.day)));
    return matchesSearch && matchesStatus && matchesFrom && matchesTo;
  }).toList();

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

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 850;
    final filterWidth = wide ? 310.0 : MediaQuery.of(context).size.width - 52;

    return Scaffold(
      drawer: const DashboardDrawer(
        currentPage: 'Campaigns',
        currentGroup: 'WhatsApp-App',
      ),
      appBar: buildCpxBoatAppBar(context),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(wide ? 22 : 13),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Campaigns',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: navy,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Send and track your WhatsApp campaigns.',
                        style: TextStyle(fontSize: 12, color: muted),
                      ),
                    ],
                  ),
                ),
                if (wide)
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const WhatsAppNewCampaignScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('New campaign'),
                    style: FilledButton.styleFrom(
                      backgroundColor: panelAccent(context),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 15,
                      ),
                    ),
                  ),
              ],
            ),
            if (!wide)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const WhatsAppNewCampaignScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('New campaign'),
                    style: FilledButton.styleFrom(
                      backgroundColor: panelAccent(context),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: filterWidth,
                  child: TextField(
                    controller: _search,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search campaigns...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: Color(0xFFDDE3ED)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: Color(0xFFDDE3ED)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: wide ? 180 : 170,
                  child: DropdownButtonFormField<String>(
                    initialValue: _status,
                    isExpanded: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: Color(0xFFDDE3ED)),
                      ),
                    ),
                    items: const ['All statuses', 'Completed']
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(
                              status,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => _status = value ?? 'All statuses');
                    },
                  ),
                ),
                _dateFilter(
                  _from == null ? 'dd-mm-yyyy' : _fmt(_from!),
                  () => _pickDate(true),
                ),
                _dateFilter(
                  _to == null ? 'dd-mm-yyyy' : _fmt(_to!),
                  () => _pickDate(false),
                ),
              ],
            ),
            if (_selectedCampaigns.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Text(
                      '${_selectedCampaigns.length} selected',
                      style: const TextStyle(color: muted, fontSize: 12),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () =>
                          setState(() => _selectedCampaigns.clear()),
                      child: const Text('Clear selection'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: () => _showReport(
                        _combinedWhatsApp(
                          _selectedCampaigns.map((i) => _campaigns[i]).toList(),
                        ),
                      ),
                      icon: const Icon(Icons.analytics_outlined, size: 16),
                      label: const Text('View combined report'),
                      style: FilledButton.styleFrom(
                        backgroundColor: panelAccent(context),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 18),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFDCE5F3)),
              ),
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  horizontalMargin: 14,
                  columnSpacing: wide ? 24 : 18,
                  headingRowHeight: 44,
                  dataRowMinHeight: 72,
                  dataRowMaxHeight: 82,
                  dividerThickness: .7,
                  headingRowColor: WidgetStateProperty.all(
                    panelAccent(context),
                  ),
                  headingTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  dataTextStyle: const TextStyle(color: navy, fontSize: 12),
                  columns: const [
                    DataColumn(label: Text('')),
                    DataColumn(
                      label: SizedBox(width: 225, child: Text('Campaign')),
                    ),
                    DataColumn(
                      label: SizedBox(width: 140, child: Text('Template')),
                    ),
                    DataColumn(
                      label: SizedBox(width: 145, child: Text('Account')),
                    ),
                    DataColumn(
                      label: SizedBox(width: 145, child: Text('Recipients')),
                    ),
                    DataColumn(
                      label: SizedBox(width: 85, child: Text('Amount')),
                    ),
                    DataColumn(
                      label: SizedBox(width: 95, child: Text('Status')),
                    ),
                    DataColumn(
                      label: SizedBox(width: 60, child: Text('Actions')),
                    ),
                  ],
                  rows: _filtered.map((campaign) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Checkbox(
                            value: _selectedCampaigns.contains(
                              _campaigns.indexOf(campaign),
                            ),
                            onChanged: (checked) => setState(() {
                              final index = _campaigns.indexOf(campaign);
                              if (checked == true) {
                                _selectedCampaigns.add(index);
                              } else {
                                _selectedCampaigns.remove(index);
                              }
                            }),
                          ),
                        ),
                        DataCell(
                          InkWell(
                            onTap: () => _showCampaignReport(campaign),
                            child: SizedBox(
                              width: 225,
                              child: Row(
                                children: [
                                  Container(
                                    width: 54,
                                    height: 58,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE3F3F6),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _dateParts(campaign.date)[0],
                                          style: TextStyle(
                                            fontSize: 9,
                                            color: panelAccent(context),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          _dateParts(campaign.date)[1],
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: panelAccent(context),
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text(
                                          _dateParts(campaign.date)[2],
                                          style: TextStyle(
                                            fontSize: 9,
                                            color: panelAccent(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          campaign.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Color(0xFF0097B5),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          campaign.time,
                                          style: const TextStyle(
                                            color: muted,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        DataCell(Text(campaign.template)),
                        DataCell(
                          Container(
                            width: 112,
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF0F5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  campaign.account,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: navy,
                                  ),
                                ),
                                Text(
                                  campaign.phone,
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
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(campaign.count),
                              const SizedBox(width: 7),
                              OutlinedButton.icon(
                                onPressed: () => _showReport(campaign),
                                icon: const Icon(
                                  Icons.pie_chart_outline,
                                  size: 13,
                                  color: Color(0xFF16A878),
                                ),
                                label: const Text(
                                  'View',
                                  style: TextStyle(fontSize: 11),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 9,
                                  ),
                                  minimumSize: const Size(0, 28),
                                  foregroundColor: muted,
                                  side: const BorderSide(
                                    color: Color(0xFFDCE2EC),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE1F2F5),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              campaign.amount,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF008FA8),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5EF),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Text(
                              'Completed',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF07945B),
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                tooltip: 'Download report',
                                onPressed: () => _showReport(campaign),
                                icon: const Icon(
                                  Icons.download_outlined,
                                  size: 17,
                                ),
                              ),
                              IconButton(
                                tooltip: 'Campaign details',
                                onPressed: () => _showReport(campaign),
                                icon: const Icon(
                                  Icons.refresh_rounded,
                                  size: 17,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                '${_filtered.length} campaigns',
                style: const TextStyle(color: muted, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateFilter(String label, VoidCallback tap) => InkWell(
    onTap: tap,
    borderRadius: BorderRadius.circular(9),
    child: Container(
      width: 132,
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFDDE3ED)),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, color: navy),
            ),
          ),
          const Icon(Icons.calendar_today_outlined, size: 14),
        ],
      ),
    ),
  );
  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';
  List<String> _dateParts(String date) {
    final p = date.split('/');
    final m = int.tryParse(p[0]) ?? 1;
    final d = int.tryParse(p[1]) ?? 1;
    final y = p.length > 2 ? p[2] : '2026';
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    return [months[m - 1], '$d', y];
  }

  void _showCampaignReport(CampaignRecord campaign) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close campaign report',
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        final screenWidth = MediaQuery.of(dialogContext).size.width;
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: screenWidth < 440 ? screenWidth : 414,
              height: MediaQuery.of(dialogContext).size.height,
              child: _CampaignReportSidePanel(
                campaign: campaign,
                onClose: () => Navigator.of(dialogContext).pop(),
                onDownload: (label) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '$label is not connected to a report service yet.',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        );
      },
    );
  }

  CampaignRecord _combinedWhatsApp(List<CampaignRecord> list) {
    final total = list.fold<int>(0, (sum, c) => sum + c.total);
    final amount = list.fold<double>(0, (sum, c) {
      return sum +
          (double.tryParse(c.amount.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0);
    });
    return CampaignRecord(
      name: list.length == 1
          ? list.first.name
          : '${list.length} campaigns selected',
      template: list.map((c) => c.template).toSet().join(', '),
      count: '$total Contacts',
      date: list.first.date,
      time: list.first.time,
      amount: '₹${amount.toStringAsFixed(2)}',
      total: total,
      read: list.fold<int>(0, (sum, c) => sum + c.read),
      delivered: list.fold<int>(0, (sum, c) => sum + c.delivered),
      sent: list.fold<int>(0, (sum, c) => sum + c.sent),
      failed: list.fold<int>(0, (sum, c) => sum + c.failed),
      account: list.map((c) => c.account).toSet().join(', '),
      phone: list.map((c) => c.phone).toSet().join(', '),
    );
  }

  void _showReport(CampaignRecord c) {
    // Use the same full-height Campaign Report panel for combined selections
    // as the panel shown when opening an individual campaign report.
    _showCampaignReport(c);
  }
}
