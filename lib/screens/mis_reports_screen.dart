part of '../app.dart';

class MISReportsScreen extends StatefulWidget {
  const MISReportsScreen({super.key});

  @override
  State<MISReportsScreen> createState() => _MISReportsScreenState();
}

class _MISReportsScreenState extends State<MISReportsScreen> {
  String reportChannel = 'RCS';

  String userFilter = 'All users';

  String templateFilter = '';

  DateTime? fromDate = DateTime(2026, 10, 1);

  DateTime? toDate = DateTime(2026, 10, 31);

  bool applied = true;

  final rowsByChannel = const <String, List<List<String>>>{
    'RCS': [
      ['ajay', '—', '13 Oct 2026', '—', '22', '22', '0', '0', '0', '0'],

      ['ajay', '—', '12 Oct 2026', '—', '1', '0', '0', '0', '1', '0'],

      ['ajay', '—', '05 Oct 2026', '—', '1', '0', '1', '0', '0', '0'],
    ],

    'Whatsapp': [
      [
        'ajay',

        '—',

        '13 Oct 2026',

        'Promotional',
        '18',
        '18',
        '16',
        '12',
        '2',
        '4',
      ],
      ['ajay', '—', '11 Oct 2026', 'Utility', '6', '6', '5', '4', '1', '2'],
    ],
    'SMS': [
      ['ajay', '—', '13 Oct 2026', 'OTP', '24', '24', '23', '0', '1', '0'],
      [
        'ajay',
        '—',
        '09 Oct 2026',
        'Promotional',
        '12',
        '12',
        '11',
        '0',
        '1',
        '0',
      ],
    ],
  };

  Future<void> _pickDate({required bool start}) async {
    final initial = (start ? fromDate : toDate) ?? DateTime.now();

    final picked = await showDatePicker(
      context: context,

      initialDate: initial,

      firstDate: DateTime(2020),

      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        if (start) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select date';

    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final rows = rowsByChannel[reportChannel]!;

    final initiated = rows.fold<int>(0, (sum, row) => sum + int.parse(row[4]));

    final delivered = rows.fold<int>(0, (sum, row) => sum + int.parse(row[6]));

    final read = rows.fold<int>(0, (sum, row) => sum + int.parse(row[7]));

    final failed = rows.fold<int>(0, (sum, row) => sum + int.parse(row[8]));

    final reply = rows.fold<int>(0, (sum, row) => sum + int.parse(row[9]));

    return Scaffold(
      drawer: const DashboardDrawer(currentPage: 'MIS Reports'),

      appBar: buildCpxBoatAppBar(context),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 850;

            return ListView(
              padding: EdgeInsets.all(wide ? 22 : 13),

              children: [
                const Text(
                  'MIS Reports',

                  style: TextStyle(
                    fontSize: 22,

                    fontWeight: FontWeight.w800,

                    color: navy,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'Delivery performance by user, category & template, across WhatsApp, SMS and RCS.',

                  style: TextStyle(fontSize: 12, color: muted),
                ),

                const SizedBox(height: 18),

                _channelTabs(),

                const SizedBox(height: 16),

                _filterPanel(wide),

                const SizedBox(height: 16),

                _metricCards(wide, initiated, delivered, read, failed, reply),

                const SizedBox(height: 16),

                _reportTable(rows, wide),

                const SizedBox(height: 16),

                const Center(
                  child: Text(
                    '© CPXBOAT • MIS Reports',

                    style: TextStyle(color: muted, fontSize: 10),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _misBottomNavigation() {
    const labels = [
      'Dashboard',

      'Channels',

      'Analytics',

      'AI Assistant',

      'Settings',
    ];

    const icons = [
      Icons.grid_view_rounded,

      Icons.apps_rounded,

      Icons.analytics_outlined,

      Icons.auto_awesome_outlined,

      Icons.settings_outlined,
    ];

    return Container(
      decoration: const BoxDecoration(
        color: navy,

        boxShadow: [BoxShadow(color: Color(0x18000000), offset: Offset(0, 0))],
      ),

      child: SafeArea(
        top: false,

        child: SizedBox(
          height: 57,

          child: Row(
            children: List.generate(labels.length, (i) {
              final active = i == 0;

              return Expanded(
                child: InkWell(
                  onTap: () {
                    if (i == 0) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const DashboardScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${labels[i]} screen coming next'),

                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Icon(
                        icons[i],

                        size: 19,

                        color: active ? panelAccent(context) : Colors.white70,
                      ),

                      const SizedBox(height: 3),

                      Text(
                        labels[i],

                        maxLines: 1,

                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(
                          fontSize: 8,

                          color: active ? panelAccent(context) : Colors.white70,

                          fontWeight: active
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _channelTabs() {
    return Container(
      padding: const EdgeInsets.all(5),

      decoration: _cardDecoration(radius: 12),

      child: Row(
        children: ['RCS', 'Whatsapp', 'SMS'].map((tab) {
          final selected = reportChannel == tab;

          return Padding(
            padding: const EdgeInsets.only(right: 5),

            child: TextButton(
              onPressed: () => setState(() => reportChannel = tab),

              style: TextButton.styleFrom(
                backgroundColor: selected
                    ? panelAccent(context)
                    : Colors.transparent,

                foregroundColor: selected
                    ? Colors.white
                    : const Color(0xFF526078),

                padding: const EdgeInsets.symmetric(
                  horizontal: 16,

                  vertical: 10,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),

              child: Text(
                tab,

                style: const TextStyle(
                  fontSize: 12,

                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _filterPanel(bool wide) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: _cardDecoration(radius: 16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      '$reportChannel MIS Report',

                      style: const TextStyle(
                        fontSize: 15,

                        fontWeight: FontWeight.w800,

                        color: navy,
                      ),
                    ),

                    const SizedBox(height: 3),

                    const Text(
                      'Delivery performance by user, category & template',

                      style: TextStyle(fontSize: 11, color: muted),
                    ),
                  ],
                ),
              ),

              if (wide) ...[
                OutlinedButton.icon(
                  onPressed: _clearFilters,

                  icon: const Icon(Icons.refresh_rounded, size: 16),

                  label: const Text('Clear'),
                ),

                const SizedBox(width: 7),

                FilledButton.icon(
                  onPressed: () => setState(() => applied = true),

                  icon: const Icon(Icons.filter_alt_outlined, size: 16),

                  label: const Text('Apply'),
                ),
              ],
            ],
          ),

          const SizedBox(height: 14),

          LayoutBuilder(
            builder: (context, box) {
              final columns = box.maxWidth > 680 ? 4 : 2;

              final itemWidth = (box.maxWidth - (columns - 1) * 8) / columns;

              return Wrap(
                spacing: 8,

                runSpacing: 8,

                children: [
                  SizedBox(
                    width: itemWidth,

                    child: DropdownButtonFormField<String>(
                      initialValue: userFilter,

                      isExpanded: true,

                      decoration: _filterDecoration(),

                      items: const ['All users', 'ajay', 'Admin']
                          .map(
                            (v) => DropdownMenuItem(
                              value: v,

                              child: Text(v, overflow: TextOverflow.ellipsis),
                            ),
                          )
                          .toList(),

                      onChanged: (v) =>
                          setState(() => userFilter = v ?? 'All users'),
                    ),
                  ),

                  SizedBox(
                    width: itemWidth,

                    child: _dateButton(
                      _formatDate(fromDate),

                      () => _pickDate(start: true),
                    ),
                  ),

                  SizedBox(
                    width: itemWidth,

                    child: _dateButton(
                      _formatDate(toDate),

                      () => _pickDate(start: false),
                    ),
                  ),

                  SizedBox(
                    width: itemWidth,

                    child: TextField(
                      decoration: _filterDecoration(hint: 'Template name'),

                      onChanged: (v) => templateFilter = v,
                    ),
                  ),
                ],
              );
            },
          ),

          if (!wide) ...[
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _clearFilters,

                    icon: const Icon(Icons.refresh_rounded, size: 16),

                    label: const Text('Clear'),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => setState(() => applied = true),

                    icon: const Icon(Icons.filter_alt_outlined, size: 16),

                    label: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  InputDecoration _filterDecoration({String? hint}) => InputDecoration(
    hintText: hint,

    isDense: true,

    filled: true,

    fillColor: const Color(0xFFF8F9FC),

    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),

      borderSide: const BorderSide(color: Color(0xFFDDE3ED)),
    ),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),

      borderSide: const BorderSide(color: Color(0xFFDDE3ED)),
    ),
  );

  Widget _dateButton(String label, VoidCallback onTap) => InkWell(
    onTap: onTap,

    borderRadius: BorderRadius.circular(9),

    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),

      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FC),

        border: Border.all(color: const Color(0xFFDDE3ED)),

        borderRadius: BorderRadius.circular(9),
      ),

      child: Row(
        children: [
          Expanded(
            child: Text(
              label,

              style: const TextStyle(fontSize: 11, color: navy),

              overflow: TextOverflow.ellipsis,
            ),
          ),

          const Icon(Icons.calendar_month_outlined, size: 16),
        ],
      ),
    ),
  );

  void _clearFilters() {
    setState(() {
      userFilter = 'All users';

      templateFilter = '';

      fromDate = null;

      toDate = null;

      applied = false;
    });
  }

  Widget _metricCards(
    bool wide,

    int initiated,

    int delivered,

    int read,

    int failed,

    int reply,
  ) {
    final metrics = [
      (
        'Initiated',

        initiated,

        const Color(0xFFF59E0B),

        Icons.rocket_launch_outlined,
      ),

      ('Delivered', delivered, const Color(0xFF16A878), Icons.done_all_rounded),

      ('Read', read, panelAccent(context), Icons.visibility_outlined),

      ('Failed', failed, const Color(0xFFEF4444), Icons.error_outline_rounded),

      ('Reply', reply, const Color(0xFF8B5CF6), Icons.reply_rounded),
    ];

    return LayoutBuilder(
      builder: (context, box) {
        final columns = box.maxWidth > 1100
            ? 5
            : box.maxWidth > 700
            ? 3
            : 2;

        final gap = 10.0;

        final width = (box.maxWidth - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,

          runSpacing: gap,

          children: metrics
              .map(
                (metric) => SizedBox(
                  width: width,

                  child: Container(
                    padding: const EdgeInsets.all(14),

                    decoration: _cardDecoration(radius: 14),

                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                metric.$1,

                                style: const TextStyle(
                                  fontSize: 11,

                                  color: muted,
                                ),
                              ),

                              const SizedBox(height: 7),

                              Text(
                                '${metric.$2}',

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
                          width: 38,

                          height: 38,

                          decoration: BoxDecoration(
                            color: metric.$3.withValues(alpha: .11),

                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: Icon(metric.$4, color: metric.$3, size: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _reportTable(List<List<String>> rows, bool wide) {
    const headers = [
      'User',

      'Parent',

      'Sent Date',

      'Category',

      'Initiated',

      'Sent',

      'Delivered',

      'Read',

      'Failed',

      'Reply',
    ];

    return Container(
      decoration: _cardDecoration(radius: 14),

      clipBehavior: Clip.antiAlias,

      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,

        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: wide ? 950 : 920),

          child: DataTable(
            headingRowColor: WidgetStateProperty.all(panelAccent(context)),

            headingTextStyle: const TextStyle(
              color: Colors.white,

              fontWeight: FontWeight.w700,

              fontSize: 11,
            ),

            dataTextStyle: const TextStyle(color: navy, fontSize: 11),

            horizontalMargin: 14,

            columnSpacing: 20,

            headingRowHeight: 42,

            dataRowMinHeight: 40,

            dataRowMaxHeight: 46,

            columns: headers.map((h) => DataColumn(label: Text(h))).toList(),

            rows: rows
                .map(
                  (row) => DataRow(
                    cells: row.asMap().entries.map((entry) {
                      final i = entry.key;

                      final value = entry.value;

                      if (i >= 4) {
                        final color = i == 4
                            ? const Color(0xFFF59E0B)
                            : i == 6
                            ? const Color(0xFF16A878)
                            : i == 7
                            ? panelAccent(context)
                            : i == 8
                            ? const Color(0xFFEF4444)
                            : i == 9
                            ? const Color(0xFF8B5CF6)
                            : panelAccent(context);

                        return DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,

                              vertical: 4,
                            ),

                            decoration: BoxDecoration(
                              color: color.withValues(alpha: .12),

                              borderRadius: BorderRadius.circular(7),
                            ),

                            child: Text(
                              value,

                              style: TextStyle(
                                color: color,

                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        );
                      }

                      return DataCell(Text(value));
                    }).toList(),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
