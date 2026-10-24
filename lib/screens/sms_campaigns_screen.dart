part of '../app.dart';

class SMSCampaignsScreen extends StatefulWidget {
  const SMSCampaignsScreen({super.key});

  @override
  State<SMSCampaignsScreen> createState() => _SMSCampaignsScreenState();
}

class _SMSCampaignsScreenState extends State<SMSCampaignsScreen> {
  static const Color borderColor = Color(0xFFDCE2EC);
  final TextEditingController _searchController = TextEditingController();
  String _status = 'All statuses';
  DateTime? _fromDate;
  DateTime? _toDate;
  final Set<int> _selectedRows = {};

  final List<Map<String, String>> _campaigns = [
    {
      'name': '—',
      'template': '—',
      'recipients': '—',
      'amount': '—',
      'status': 'Unknown',
    },
    {
      'name': '—',
      'template': '—',
      'recipients': '—',
      'amount': '—',
      'status': 'Unknown',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool from}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (from ? _fromDate : _toDate) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        if (from) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  String _dateLabel(DateTime? date) => date == null
      ? 'dd-mm-yyyy'
      : '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';

  Widget _dateField(DateTime? date, VoidCallback onTap) => SizedBox(
    width: 124,
    height: 38,
    child: OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xFFF8F9FC),
        foregroundColor: navy,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        side: BorderSide(color: borderColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _dateLabel(date),
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.calendar_today_outlined, size: 14),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final compact = width < 900;
    final filtered = _campaigns.asMap().entries.where((entry) {
      final row = entry.value;
      final query = _searchController.text.trim().toLowerCase();
      final matchesSearch =
          query.isEmpty ||
          row.values.any((v) => v.toLowerCase().contains(query));
      final matchesStatus =
          _status == 'All statuses' || row['status'] == _status;
      return matchesSearch && matchesStatus;
    }).toList();

    return Scaffold(
      drawer: const DashboardDrawer(
        currentPage: 'Campaigns',
        currentGroup: 'SMS-App',
      ),
      appBar: buildCpxBoatAppBar(context),
      body: Padding(
        padding: EdgeInsets.all(compact ? 12 : 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Campaigns',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: navy,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Send and track your SMS campaigns.',
                        style: TextStyle(fontSize: 12, color: muted),
                      ),
                    ],
                  ),
                ),
                FilledButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('New campaign form can be connected next.'),
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: panelAccent(context),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 17),
                  label: const Text(
                    'New campaign',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                SizedBox(
                  width: compact ? double.infinity : 288,
                  height: 38,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search campaigns...',
                      hintStyle: const TextStyle(fontSize: 12, color: muted),
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 17,
                        color: muted,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8F9FC),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: borderColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 174,
                  height: 38,
                  child: DropdownButtonFormField<String>(
                    initialValue: _status,
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8F9FC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: borderColor),
                      ),
                    ),
                    items:
                        const [
                              'All statuses',
                              'Unknown',
                              'Completed',
                              'Scheduled',
                              'Failed',
                            ]
                            .map(
                              (v) => DropdownMenuItem(
                                value: v,
                                child: Text(
                                  v,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (v) =>
                        setState(() => _status = v ?? 'All statuses'),
                  ),
                ),
                _dateField(_fromDate, () => _pickDate(from: true)),
                _dateField(_toDate, () => _pickDate(from: false)),
              ],
            ),
            const SizedBox(height: 22),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: _cardDecoration(radius: 12),
                clipBehavior: Clip.antiAlias,
                child: SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: compact ? 950 : width - (compact ? 24 : 44),
                      ),
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(
                          panelAccent(context),
                        ),
                        headingRowHeight: 42,
                        dataRowMinHeight: 52,
                        dataRowMaxHeight: 62,
                        horizontalMargin: 12,
                        columnSpacing: compact ? 26 : 42,
                        headingTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                        dataTextStyle: const TextStyle(
                          color: muted,
                          fontSize: 12,
                        ),
                        columns: const [
                          DataColumn(label: Text('')),
                          DataColumn(label: Text('Campaign')),
                          DataColumn(label: Text('Template')),
                          DataColumn(label: Text('Recipients')),
                          DataColumn(label: Text('Amount')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: filtered.map((entry) {
                          final index = entry.key;
                          final row = entry.value;
                          return DataRow(
                            selected: _selectedRows.contains(index),
                            onSelectChanged: (selected) => setState(() {
                              if (selected == true) {
                                _selectedRows.add(index);
                              } else {
                                _selectedRows.remove(index);
                              }
                            }),
                            cells: [
                              DataCell(
                                Checkbox(
                                  value: _selectedRows.contains(index),
                                  activeColor: panelAccent(context),
                                  onChanged: (v) => setState(() {
                                    if (v == true) {
                                      _selectedRows.add(index);
                                    } else {
                                      _selectedRows.remove(index);
                                    }
                                  }),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 260,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 26,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE7F4F7),
                                          borderRadius: BorderRadius.circular(
                                            7,
                                          ),
                                        ),
                                        child: Text(
                                          row['name']!,
                                          style: TextStyle(
                                            color: muted,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              row['name']!,
                                              style: TextStyle(
                                                color: panelAccent(context),
                                                fontSize: 12,
                                              ),
                                            ),
                                            const Text(
                                              '—',
                                              style: TextStyle(
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
                              DataCell(Text(row['template']!)),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(row['recipients']!),
                                    const SizedBox(width: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F3F8),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 12,
                                            color: Color(0xFF20A36A),
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            'View',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: muted,
                                            ),
                                          ),
                                        ],
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
                                    color: const Color(0xFFF1F3F8),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    row['amount']!,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: muted,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F3F8),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    row['status']!,
                                    style: const TextStyle(
                                      fontSize: 11,
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
                                      tooltip: 'Download',
                                      onPressed: () =>
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Download is not connected yet.',
                                                  ),
                                                ),
                                              ),
                                      icon: const Icon(
                                        Icons.download_outlined,
                                        size: 17,
                                        color: navy,
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: 'Retry',
                                      onPressed: () =>
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Retry is not connected yet.',
                                              ),
                                            ),
                                          ),
                                      icon: const Icon(
                                        Icons.refresh_rounded,
                                        size: 17,
                                        color: navy,
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
