part of '../app.dart';

class RCSCampaignsScreen extends StatefulWidget {
  const RCSCampaignsScreen({super.key});

  @override
  State<RCSCampaignsScreen> createState() => _RCSCampaignsScreenState();
}

class _RCSCampaignsScreenState extends State<RCSCampaignsScreen> {
  final TextEditingController _search = TextEditingController();
  String _status = 'All statuses';
  DateTime? _fromDate;
  DateTime? _toDate;
  final Set<int> _selected = {};

  final List<CampaignRecord> _campaigns = const [
    CampaignRecord(
      name: 'real camp',
      template: 'webtech_carousel',
      count: '1',
      date: '10/14/2026',
      time: '01:15 pm',
      amount: '₹0.28',
      total: 1,
      read: 0,
      delivered: 0,
      sent: 0,
      failed: 1,
    ),
    CampaignRecord(
      name: 'fvf',
      template: 'webtech_carousel',
      count: '19',
      date: '10/13/2026',
      time: '12:15 pm',
      amount: '₹5.29',
      total: 19,
      read: 0,
      delivered: 0,
      sent: 0,
      failed: 19,
    ),
    CampaignRecord(
      name: 'dfd',
      template: 'real',
      count: '2',
      date: '10/13/2026',
      time: '11:52 am',
      amount: '₹0.56',
      total: 2,
      read: 0,
      delivered: 0,
      sent: 0,
      failed: 2,
    ),
    CampaignRecord(
      name: 'wede',
      template: 'ClaudeTest1',
      count: '1',
      date: '10/13/2026',
      time: '11:05 am',
      amount: '₹0.28',
      total: 1,
      read: 0,
      delivered: 0,
      sent: 0,
      failed: 1,
    ),
    CampaignRecord(
      name: 'CRM_A33_E48',
      template: 'ClaudeTest1',
      count: '1',
      date: '10/12/2026',
      time: '12:33 pm',
      amount: '₹0.25',
      total: 1,
      read: 0,
      delivered: 0,
      sent: 0,
      failed: 1,
    ),
    CampaignRecord(
      name: 'scllldd',
      template: 'Webtechage',
      count: '1',
      date: '10/05/2026',
      time: '01:11 pm',
      amount: '₹0.25',
      total: 1,
      read: 0,
      delivered: 0,
      sent: 0,
      failed: 1,
    ),
    CampaignRecord(
      name: 'tetsing 1',
      template: 'webtech_carousel',
      count: '20',
      date: '10/01/2026',
      time: '03:29 pm',
      amount: '₹0.00',
      total: 20,
      read: 0,
      delivered: 0,
      sent: 0,
      failed: 20,
    ),
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<CampaignRecord> get _filtered => _campaigns.where((c) {
    final q = _search.text.trim().toLowerCase();
    final matchText =
        q.isEmpty ||
        c.name.toLowerCase().contains(q) ||
        c.template.toLowerCase().contains(q);
    final matchStatus = _status == 'All statuses' || _status == 'Completed';
    DateTime? date;
    try {
      date = DateTime.parse(c.date.split('/').reversed.join('-'));
    } catch (_) {}
    final matchFrom =
        _fromDate == null || date == null || !date.isBefore(_fromDate!);
    final matchTo = _toDate == null || date == null || !date.isAfter(_toDate!);
    return matchText && matchStatus && matchFrom && matchTo;
  }).toList();

  String _dateLabel(DateTime? d) => d == null
      ? 'dd-mm-yyyy'
      : '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';

  Future<void> _pickDate(bool start) async {
    final d = await showDatePicker(
      context: context,
      initialDate: start
          ? (_fromDate ?? DateTime(2026, 10, 1))
          : (_toDate ?? DateTime(2026, 10, 31)),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (d != null) {
      setState(() {
        if (start) {
          _fromDate = d;
        } else {
          _toDate = d;
        }
      });
    }
  }

  CampaignRecord _combined(List<CampaignRecord> list) {
    final total = list.fold<int>(0, (s, c) => s + c.total);
    return CampaignRecord(
      name: list.length == 1
          ? list.first.name
          : '${list.length} campaigns selected',
      template: list.length == 1
          ? list.first.template
          : list.map((c) => c.template).toSet().join(', '),
      count: '$total',
      date: list.first.date,
      time: list.first.time,
      amount: list
          .map(
            (c) =>
                double.tryParse(c.amount.replaceAll(RegExp(r'[^0-9.]'), '')) ??
                0,
          )
          .fold<double>(0, (s, v) => s + v)
          .toStringAsFixed(2),
      total: total,
      read: list.fold<int>(0, (s, c) => s + c.read),
      delivered: list.fold<int>(0, (s, c) => s + c.delivered),
      sent: list.fold<int>(0, (s, c) => s + c.sent),
      failed: list.fold<int>(0, (s, c) => s + c.failed),
    );
  }

  void _showDeliveryDialog(CampaignRecord c) {
    // Open the same full-height Campaign Report panel used by the WhatsApp
    // campaigns report, instead of the old circular Delivery Status dialog.
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
              child: SafeArea(
                child: _CampaignReportSidePanel(
                  campaign: c,
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

  Widget _statusRing(CampaignRecord c) => SizedBox(
    height: 190,
    child: Center(
      child: SizedBox(
        width: 170,
        height: 170,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFEF4444), width: 9),
              ),
            ),
            Container(
              width: 135,
              height: 135,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE9ECF2), width: 9),
              ),
            ),
            Container(
              width: 105,
              height: 105,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE9ECF2), width: 9),
              ),
            ),
            Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE9ECF2), width: 9),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(color: muted, fontSize: 11),
                ),
                Text(
                  '${c.total}',
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    color: navy,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  Widget _statusRows(CampaignRecord c) {
    final rows = <(String, int, Color, IconData)>[
      ('Sent', c.sent, const Color(0xFFF59E0B), Icons.check),
      ('Delivered', c.delivered, const Color(0xFF3989FF), Icons.done_all),
      ('Read', c.read, const Color(0xFF16B86A), Icons.done_all),
      (
        'Failed',
        c.failed,
        const Color(0xFFEF4444),
        Icons.warning_amber_rounded,
      ),
      (
        'Unread',
        c.total - c.read - c.delivered - c.sent - c.failed < 0
            ? 0
            : c.total - c.read - c.delivered - c.sent - c.failed,
        const Color(0xFF8B5CF6),
        Icons.chat_bubble_outline,
      ),
      ('Click Count', 0, muted, Icons.auto_awesome_outlined),
    ];
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E9F0)),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5EF),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  '${c.total}',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          for (final r in rows)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
              child: Row(
                children: [
                  Icon(r.$4, size: 15, color: r.$3),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(r.$1, style: const TextStyle(fontSize: 12)),
                  ),
                  Text(
                    '${r.$2}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 18),
                  Text(
                    c.total == 0
                        ? '0.00%'
                        : '${(r.$2 * 100 / c.total).toStringAsFixed(2)}%',
                    style: const TextStyle(fontSize: 11, color: muted),
                  ),
                ],
              ),
            ),
          if (c.failed > 0)
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 8, bottom: 5),
                child: Text(
                  '▤ Failure Summary',
                  style: TextStyle(color: Color(0xFFEF4444), fontSize: 11),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showCombinedPanel(List<CampaignRecord> selected) {
    final c = _combined(selected);
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close campaign report',
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (ctx, a, b) => Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: Colors.white,
          child: SizedBox(
            width: MediaQuery.of(ctx).size.width < 440
                ? MediaQuery.of(ctx).size.width
                : 414,
            height: double.infinity,
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    color: const Color(0xFF0B91AD),
                    padding: const EdgeInsets.fromLTRB(20, 16, 12, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(Icons.chat, color: Color(0xFF2879E8)),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'Campaign Report',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(ctx),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          c.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '14/10/2026, 1:15:41 pm · ${c.total} contacts',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 13,
                            horizontal: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFDDE3ED)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x10000000),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _miniMetric('${c.total}', 'TOTAL', navy),
                              _miniMetric(
                                '${c.read}',
                                'READ',
                                const Color(0xFF16A878),
                              ),
                              _miniMetric(
                                '${c.delivered}',
                                'DELIVERED',
                                const Color(0xFF3989FF),
                              ),
                              _miniMetric(
                                '${c.sent}',
                                'SENT',
                                const Color(0xFFF59E0B),
                              ),
                              _miniMetric(
                                '${c.failed}',
                                'FAILED',
                                const Color(0xFFEF4444),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6F5F8),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 15,
                                color: Color(0xFF0B91AD),
                              ),
                              SizedBox(width: 7),
                              Expanded(
                                child: Text(
                                  'The analytics will be updated after 15 minutes. For detailed reports, please click on Download Reports.',
                                  style: TextStyle(fontSize: 11, color: muted),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        for (final item in [
                          ('Delivered', c.delivered, const Color(0xFF3989FF)),
                          ('Read', c.read, const Color(0xFF16A878)),
                          ('Sent', c.sent, const Color(0xFFF59E0B)),
                          ('Failed', c.failed, const Color(0xFFEF4444)),
                        ])
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: item.$3,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        item.$1,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${item.$2}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: c.total == 0 ? 0 : item.$2 / c.total,
                                    minHeight: 7,
                                    backgroundColor: const Color(0xFFE9ECF2),
                                    color: item.$3,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${c.total == 0 ? 0 : (item.$2 * 100 / c.total).round()}% of total messages',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const Divider(),
                        const SizedBox(height: 8),
                        const Text(
                          'CAMPAIGN DETAILS',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                            color: navy,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _detailRow('Template', c.template),
                        _detailRow('Campaign Name', c.name),
                        _detailRow('Channel', 'rcs'),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Download Report is not connected yet.',
                                        ),
                                      ),
                                    ),
                                child: const Text('Download Report'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Download Stats is not connected yet.',
                                        ),
                                      ),
                                    ),
                                child: const Text('Download Stats'),
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
          ),
        ),
      ),
      transitionBuilder: (ctx, animation, secondary, child) => SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
        child: child,
      ),
    );
  }

  Widget _miniMetric(String value, String label, Color color) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        value,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(fontSize: 8, color: muted)),
    ],
  );
  Widget _detailRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: muted, fontSize: 12),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: navy,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
  Widget _dateField(String label, VoidCallback onTap) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FC),
        border: Border.all(color: const Color(0xFFDDE3ED)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: navy)),
          const SizedBox(width: 8),
          const Icon(Icons.calendar_today_outlined, size: 13),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 850;
    final rows = _filtered;
    return Scaffold(
      drawer: const DashboardDrawer(currentPage: 'Campaigns'),
      appBar: buildCpxBoatAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(wide ? 22 : 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Campaigns',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            color: navy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Send and track your RCS campaigns.',
                          style: TextStyle(fontSize: 12, color: muted),
                        ),
                      ],
                    ),
                  ),
                  if (wide) ...[
                    OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const RCSNewTemplateScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.add, size: 17),
                      label: const Text('New template'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: teal,
                        side: const BorderSide(color: teal),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: () => ScaffoldMessenger.of(context)
                          .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'New campaign creation is not connected yet.',
                              ),
                            ),
                          ),
                      icon: const Icon(Icons.add, size: 17),
                      label: const Text('New campaign'),
                      style: FilledButton.styleFrom(
                        backgroundColor: teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 15,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: wide ? 306 : MediaQuery.of(context).size.width - 48,
                    child: TextField(
                      controller: _search,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search, size: 18),
                        hintText: 'Search campaigns...',
                        filled: true,
                        fillColor: const Color(0xFFF8F9FC),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 11,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: const BorderSide(
                            color: Color(0xFFDDE3ED),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: const BorderSide(
                            color: Color(0xFFDDE3ED),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: wide ? 185 : 160,
                    child: DropdownButtonFormField<String>(
                      initialValue: _status,
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: const Color(0xFFF8F9FC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      items: const ['All statuses', 'Completed']
                          .map(
                            (s) => DropdownMenuItem(
                              value: s,
                              child: Text(
                                s,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _status = v ?? 'All statuses'),
                    ),
                  ),
                  _dateField(_dateLabel(_fromDate), () => _pickDate(true)),
                  _dateField(_dateLabel(_toDate), () => _pickDate(false)),
                  if (!wide) ...[
                    OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const RCSNewTemplateScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('New template'),
                    ),
                    FilledButton.icon(
                      onPressed: () => ScaffoldMessenger.of(context)
                          .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'New campaign creation is not connected yet.',
                              ),
                            ),
                          ),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('New campaign'),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFDCE3ED)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      Container(
                        color: const Color(0xFF0B91AD),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 13,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 30,
                              child: Checkbox(
                                value:
                                    rows.isNotEmpty &&
                                    rows.every(
                                      (c) => _selected.contains(
                                        _campaigns.indexOf(c),
                                      ),
                                    ),
                                side: const BorderSide(color: Colors.white),
                                activeColor: navy,
                                onChanged: (v) => setState(() {
                                  if (v == true) {
                                    _selected.addAll(
                                      rows.map((c) => _campaigns.indexOf(c)),
                                    );
                                  } else {
                                    _selected.removeAll(
                                      rows.map((c) => _campaigns.indexOf(c)),
                                    );
                                  }
                                }),
                              ),
                            ),
                            const Expanded(
                              flex: 3,
                              child: Text(
                                'Campaign',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            if (wide)
                              const Expanded(
                                flex: 3,
                                child: Text(
                                  'Template',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            if (wide)
                              const Expanded(
                                flex: 3,
                                child: Text(
                                  'Bot Category',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            const Expanded(
                              flex: 2,
                              child: Text(
                                'Recipients',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            if (wide)
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  'Amount',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            const Expanded(
                              flex: 1,
                              child: Text(
                                'Status',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 44),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: rows.length,
                          itemBuilder: (context, index) {
                            final c = rows[index];
                            final realIndex = _campaigns.indexOf(c);
                            final checked = _selected.contains(realIndex);
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: index.isEven
                                    ? Colors.white
                                    : const Color(0xFFF8F9FC),
                                border: const Border(
                                  bottom: BorderSide(color: Color(0xFFDCE3ED)),
                                ),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 30,
                                    child: Checkbox(
                                      value: checked,
                                      activeColor: const Color(0xFF0B91AD),
                                      onChanged: (v) => setState(() {
                                        if (v == true) {
                                          _selected.add(realIndex);
                                        } else {
                                          _selected.remove(realIndex);
                                        }
                                      }),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 44,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 7,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE4F3F6),
                                            borderRadius: BorderRadius.circular(
                                              9,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                c.date.split('/')[0] == '10'
                                                    ? 'OCT'
                                                    : c.date.split('/')[0],
                                                style: const TextStyle(
                                                  fontSize: 9,
                                                  color: teal,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Text(
                                                c.date.split('/')[1],
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: teal,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              Text(
                                                c.date.split('/')[2],
                                                style: const TextStyle(
                                                  fontSize: 9,
                                                  color: teal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                c.name,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF0B91AD),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                c.time,
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
                                  if (wide)
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        c.template,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: muted,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  if (wide)
                                    const Expanded(
                                      flex: 3,
                                      child: Text(
                                        'Promotional',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: muted,
                                        ),
                                      ),
                                    ),
                                  Expanded(
                                    flex: 2,
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      spacing: 5,
                                      children: [
                                        Text(
                                          '${c.count} Contacts',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: navy,
                                          ),
                                        ),
                                        OutlinedButton.icon(
                                          onPressed: () =>
                                              _showCombinedPanel([c]),
                                          icon: const Icon(
                                            Icons.timelapse_rounded,
                                            size: 13,
                                            color: Color(0xFF20B85A),
                                          ),
                                          label: const Text(
                                            'View',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 7,
                                            ),
                                            minimumSize: const Size(0, 28),
                                            visualDensity:
                                                VisualDensity.compact,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (wide)
                                    Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE5F4F7),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            c.amount,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: teal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8F5EF),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        'Completed',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFF07945B),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 44,
                                    child: IconButton(
                                      tooltip: 'Campaign report',
                                      onPressed: () => _showCombinedPanel([c]),
                                      icon: const Icon(
                                        Icons.download_outlined,
                                        size: 17,
                                        color: navy,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_selected.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Text(
                        '${_selected.length} selected',
                        style: const TextStyle(color: muted, fontSize: 12),
                      ),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: () => _showCombinedPanel(
                          _selected.map((i) => _campaigns[i]).toList(),
                        ),
                        icon: const Icon(Icons.analytics_outlined, size: 16),
                        label: const Text('View combined report'),
                        style: FilledButton.styleFrom(
                          backgroundColor: teal,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
