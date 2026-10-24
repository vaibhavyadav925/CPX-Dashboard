part of '../app.dart';

class SmartFallbackReportsScreen extends StatefulWidget {
  const SmartFallbackReportsScreen({super.key});

  @override
  State<SmartFallbackReportsScreen> createState() =>
      _SmartFallbackReportsScreenState();
}

class _SmartFallbackReportsScreenState
    extends State<SmartFallbackReportsScreen> {
  String _activeTab = 'Campaigns';
  String _status = 'All statuses';
  String _search = '';
  String _reportType = 'Compose (Standard)';
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final compact = width < 850;
    const line = Color(0xFFDCE2ED);
    final cyan = panelAccent(context);

    return Scaffold(
      drawer: const DashboardDrawer(
        currentPage: 'Reports',
        currentGroup: 'Smart Fallback',
      ),
      appBar: buildCpxBoatAppBar(context),
      body: Container(
        color: const Color(0xFFF4F6FB),
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            compact ? 14 : 22,
            20,
            compact ? 14 : 22,
            24,
          ),
          children: [
            const Text(
              'Reports',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: navy,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'Fallback campaign delivery and per-channel breakdown.',
              style: TextStyle(fontSize: 12, color: muted),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _reportTab('Campaigns', cyan),
                  _reportTab('Live Message Reports', cyan),
                  _reportTab('API Reports', cyan),
                ],
              ),
            ),
            const Divider(height: 1, color: line),
            const SizedBox(height: 20),
            if (_activeTab == 'Campaigns') ...[
              LayoutBuilder(
                builder: (context, box) {
                  final columns = box.maxWidth < 650
                      ? 1
                      : (box.maxWidth < 1100 ? 2 : 4);
                  final cardWidth =
                      (box.maxWidth - (columns - 1) * 14) / columns;
                  return Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    children: [
                      _metricCard(
                        'Initiated',
                        '13,786',
                        Icons.rocket_launch_outlined,
                        const Color(0xFF273449),
                        const Color(0xFFE9ECF2),
                        cardWidth,
                      ),
                      _metricCard(
                        'Total Sent',
                        '848',
                        Icons.account_balance_wallet_outlined,
                        cyan,
                        const Color(0xFFE4F5F8),
                        cardWidth,
                      ),
                      _metricCard(
                        'Delivered',
                        '307',
                        Icons.check_circle_outline_rounded,
                        const Color(0xFF1BA76B),
                        const Color(0xFFE8F6EF),
                        cardWidth,
                      ),
                      _metricCard(
                        'Failed',
                        '0',
                        Icons.cancel_outlined,
                        const Color(0xFFFF4F59),
                        const Color(0xFFFCECEE),
                        cardWidth,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 26),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  SizedBox(
                    width: compact ? 250 : 288,
                    child: TextField(
                      onChanged: (value) => setState(() => _search = value),
                      decoration: InputDecoration(
                        hintText: 'Search campaigns...',
                        hintStyle: const TextStyle(fontSize: 12, color: muted),
                        isDense: true,
                        filled: true,
                        fillColor: const Color(0xFFF9FAFD),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: line),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: line),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 174,
                    child: DropdownButtonFormField<String>(
                      initialValue: _status,
                      isDense: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF9FAFD),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: line),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: line),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'All statuses',
                          child: Text(
                            'All statuses',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Delivered',
                          child: Text(
                            'Delivered',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Failed',
                          child: Text('Failed', style: TextStyle(fontSize: 12)),
                        ),
                        DropdownMenuItem(
                          value: 'Unknown',
                          child: Text(
                            'Unknown',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                      onChanged: (value) =>
                          setState(() => _status = value ?? 'All statuses'),
                    ),
                  ),
                  _dateField('From', _fromController, line),
                  _dateField('To', _toController, line),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: line),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x100D2B55),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: compact
                          ? 900
                          : boxWidth(context) - (compact ? 28 : 44),
                    ),
                    child: DataTable(
                      horizontalMargin: 14,
                      columnSpacing: 20,
                      headingRowHeight: 40,
                      dataRowMinHeight: 62,
                      dataRowMaxHeight: 62,
                      dividerThickness: 0.7,
                      headingRowColor: WidgetStateProperty.all(cyan),
                      headingTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      dataTextStyle: const TextStyle(color: navy, fontSize: 12),
                      columns: const [
                        DataColumn(
                          label: SizedBox(width: 225, child: Text('Campaign')),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: 225,
                            child: Text('Recipients'),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(width: 225, child: Text('Delivered')),
                        ),
                        DataColumn(
                          label: SizedBox(width: 225, child: Text('Failed')),
                        ),
                        DataColumn(
                          label: SizedBox(width: 100, child: Text('Status')),
                        ),
                        DataColumn(
                          label: SizedBox(width: 110, child: Text('Date')),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: 65,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text('Actions'),
                            ),
                          ),
                        ),
                      ],
                      rows: List.generate(2, (index) {
                        final show =
                            _search.isEmpty ||
                            '—'.toLowerCase().contains(_search.toLowerCase());
                        if (!show ||
                            (_status != 'All statuses' &&
                                _status != 'Unknown')) {
                          return DataRow(
                            cells: List.generate(
                              7,
                              (_) => const DataCell(SizedBox.shrink()),
                            ),
                          );
                        }
                        return DataRow(
                          color: WidgetStateProperty.resolveWith(
                            (states) => index.isOdd
                                ? const Color(0xFFF8FAFD)
                                : Colors.white,
                          ),
                          cells: [
                            const DataCell(Text('—')),
                            const DataCell(Text('—')),
                            const DataCell(
                              Text(
                                '—',
                                style: TextStyle(color: Color(0xFF27A96B)),
                              ),
                            ),
                            const DataCell(
                              Text(
                                '—',
                                style: TextStyle(color: Color(0xFFFF5361)),
                              ),
                            ),
                            const DataCell(_UnknownStatusChip()),
                            const DataCell(
                              Text('—', style: TextStyle(color: muted)),
                            ),
                            DataCell(
                              Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      tooltip: 'View report',
                                      onPressed: () => showDialog<void>(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Campaign report'),
                                          content: const Text(
                                            'No campaign report data is available yet.',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(ctx),
                                              child: const Text('Close'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.visibility_outlined,
                                        size: 16,
                                        color: Color(0xFF253047),
                                      ),
                                    ),
                                    const Text(
                                      '—',
                                      style: TextStyle(color: muted),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ] else if (_activeTab == 'Live Message Reports') ...[
              _liveMessageReportsPanel(line, cyan),
              const SizedBox(height: 22),
              _emptyReportsPanel(
                'Select a date range and click "Get Reports" to view message data.',
                line,
              ),
            ] else ...[
              _apiReportsPanel(line, cyan),
              const SizedBox(height: 22),
              _emptyReportsPanel(
                'Select a date range and click "Get Reports" to see messages sent through the API.',
                line,
              ),
            ],
          ],
        ),
      ),
    );
  }

  double boxWidth(BuildContext context) => MediaQuery.of(context).size.width;

  Widget _liveMessageReportsPanel(Color line, Color cyan) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x100D2B55),
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          _dateField('From', _fromController, line),
          _dateField('To', _toController, line),
          SizedBox(
            width: MediaQuery.of(context).size.width < 500 ? 152 : 162,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Report Type',
                  style: TextStyle(
                    fontSize: 12,
                    color: navy,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  initialValue: _reportType,
                  isDense: true,
                  isExpanded: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF9FAFD),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: line),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: line),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Compose (Standard)',
                      child: Text(
                        'Compose (Standard)',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Transactional',
                      child: Text(
                        'Transactional',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Promotional',
                      child: Text(
                        'Promotional',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                  onChanged: (value) => setState(
                    () => _reportType = value ?? 'Compose (Standard)',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: FilledButton.icon(
              onPressed: () => _showReportDateMessage(),
              icon: const Icon(Icons.search, size: 16),
              label: const Text('Get Reports'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF80C9D8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _apiReportsPanel(Color line, Color cyan) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x100D2B55),
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          _dateField('From', _fromController, line),
          _dateField('To', _toController, line),
          SizedBox(
            height: 40,
            child: FilledButton.icon(
              onPressed: () => _showReportDateMessage(),
              icon: const Icon(Icons.search, size: 16),
              label: const Text('Get Reports'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF80C9D8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Padding(
            padding: EdgeInsets.only(bottom: 7),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.code_rounded, size: 12, color: muted),
                SizedBox(width: 6),
                Text(
                  'Messages sent through the ',
                  style: TextStyle(fontSize: 10, color: muted),
                ),
                Text(
                  'Developer API',
                  style: TextStyle(
                    fontSize: 10,
                    color: panelAccent(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyReportsPanel(String message, Color line) {
    return Container(
      height: 106,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x100D2B55),
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12, color: muted),
      ),
    );
  }

  void _showReportDateMessage() {
    if (_fromController.text.isEmpty || _toController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a date range first.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No report data is available for this date range.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _reportTab(String label, Color accent) {
    final selected = _activeTab == label;
    return InkWell(
      onTap: () => setState(() => _activeTab = label),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? accent : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: selected ? accent : navy,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _metricCard(
    String label,
    String value,
    IconData icon,
    Color iconColor,
    Color iconBg,
    double width,
  ) {
    return Container(
      width: width,
      height: 96,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFDCE2ED)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x100D2B55),
            blurRadius: 3,
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
                Text(label, style: const TextStyle(fontSize: 12, color: muted)),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    height: 1,
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
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 19),
          ),
        ],
      ),
    );
  }

  Widget _dateField(
    String label,
    TextEditingController controller,
    Color line,
  ) {
    return SizedBox(
      width: 126,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: navy,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            readOnly: true,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2035),
              );
              if (picked != null) {
                controller.text =
                    '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
                setState(() {});
              }
            },
            decoration: InputDecoration(
              hintText: 'dd-mm-yyyy',
              hintStyle: const TextStyle(fontSize: 12),
              suffixIcon: const Icon(Icons.calendar_today_outlined, size: 14),
              isDense: true,
              filled: true,
              fillColor: const Color(0xFFF9FAFD),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 11,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: line),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: line),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
