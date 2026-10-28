part of '../app.dart';

class CRMLeadsScreen extends StatefulWidget {
  const CRMLeadsScreen({super.key});

  @override
  State<CRMLeadsScreen> createState() => _CRMLeadsScreenState();
}

class _CRMLeadsScreenState extends State<CRMLeadsScreen> {
  static const Color _ink = Color(0xFF17243B);
  static const Color _muted = Color(0xFF667892);
  Color get _teal => PanelThemeController.instance.accentColor;
  static const Color _line = Color(0xFFDCE3EE);
  static const Color _canvas = Color(0xFFF4F6FB);

  final TextEditingController _searchController = TextEditingController();
  String _source = 'All sources';
  String _tag = 'All tags';
  String _owner = 'Any owner';
  bool _boardView = false;
  final Set<int> _selected = <int>{};
  final List<Map<String, String>> _leads = [
    {
      'name': 'Ajay Live Test',
      'phone': '+91 73375 22120',
      'source': 'Test',
      'status': 'Converted',
      'owner': 'Unassigned',
      'tags': 'test',
      'activity': '4 d ago',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _exportLeads() => saveCsvFile(
    context,
    fileName: 'crm_leads',
    headers: const [
      'Name',
      'Phone',
      'Source',
      'Status',
      'Owner',
      'Tags',
      'Last Activity',
    ],
    rows: _visibleLeads.map((entry) {
      final lead = entry.value;
      return [
        lead['name'],
        lead['phone'],
        lead['source'],
        lead['status'],
        lead['owner'],
        lead['tags'],
        lead['activity'],
      ];
    }),
  );

  List<MapEntry<int, Map<String, String>>> get _visibleLeads {
    final q = _searchController.text.trim().toLowerCase();
    return _leads.asMap().entries.where((entry) {
      final lead = entry.value;
      final matchesSearch =
          q.isEmpty ||
          [
            'name',
            'phone',
            'source',
            'tags',
          ].any((k) => (lead[k] ?? '').toLowerCase().contains(q));
      final matchesSource =
          _source == 'All sources' || lead['source'] == _source;
      final matchesTag =
          _tag == 'All tags' ||
          (lead['tags'] ?? '').split(',').map((e) => e.trim()).contains(_tag);
      final matchesOwner = _owner == 'Any owner' || lead['owner'] == _owner;
      return matchesSearch && matchesSource && matchesTag && matchesOwner;
    }).toList();
  }

  Widget _card({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(12),
  }) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _line),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0A17243B),
          blurRadius: 3,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: child,
  );

  Widget _stat(
    String title,
    String value, {
    Color? dot,
    bool active = false,
    String? note,
  }) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: active ? _teal : _line,
        width: active ? 1.5 : 1,
      ),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0A17243B),
          blurRadius: 3,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            if (dot != null) ...[
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
            ],
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10, color: _muted),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: _ink,
          ),
        ),
        if (note != null) ...[
          const SizedBox(height: 2),
          Text(note, style: const TextStyle(fontSize: 9, color: _muted)),
        ],
      ],
    ),
  );

  Widget _filter(
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) => SizedBox(
    height: 38,
    child: DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      iconSize: 18,
      style: const TextStyle(fontSize: 11, color: _ink),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        filled: true,
        fillColor: const Color(0xFFF8FAFD),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _line),
        ),
      ),
      items: options
          .map(
            (s) => DropdownMenuItem(
              value: s,
              child: Text(s, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: onChanged,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final leads = _visibleLeads;
    final counts = <String, int>{
      'New': 0,
      'Contacted': 0,
      'Interested': 0,
      'Qualified': 0,
      'Converted': 0,
      'Lost': 0,
    };
    for (final lead in _leads) {
      final status = lead['status'] ?? '';
      if (counts.containsKey(status)) counts[status] = counts[status]! + 1;
    }
    final width = MediaQuery.of(context).size.width;
    final compact = width < 900;
    return Scaffold(
      backgroundColor: _canvas,
      drawer: const DashboardDrawer(currentPage: 'Leads'),
      appBar: buildCpxBoatAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(compact ? 12 : 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [panelAccent(context), Color(0xFF7859E8)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.assignment_ind_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Leads',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: _ink,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Every lead from your ads, website, API and imports — follow up, assign and track until they convert.',
                          style: TextStyle(fontSize: 11, color: _muted),
                        ),
                      ],
                    ),
                  ),
                  if (!compact) ...[
                    OutlinedButton.icon(
                      onPressed: _exportLeads,
                      icon: const Icon(Icons.download_outlined, size: 15),
                      label: const Text(
                        'Export',
                        style: TextStyle(fontSize: 11),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _ink,
                        side: const BorderSide(color: _line),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () =>
                          showApiPendingMessage(context, 'lead CSV import'),
                      icon: const Icon(Icons.upload_file_outlined, size: 15),
                      label: const Text(
                        'Import CSV',
                        style: TextStyle(fontSize: 11),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _ink,
                        side: const BorderSide(color: _line),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: _addLead,
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text(
                        'Add lead',
                        style: TextStyle(fontSize: 11),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: _teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (compact) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _exportLeads,
                      icon: const Icon(Icons.download_outlined, size: 15),
                      label: const Text('Export'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () =>
                          showApiPendingMessage(context, 'lead CSV import'),
                      icon: const Icon(Icons.upload_file_outlined, size: 15),
                      label: const Text('Import CSV'),
                    ),
                    FilledButton.icon(
                      onPressed: _addLead,
                      icon: const Icon(Icons.add, size: 15),
                      label: const Text('Add lead'),
                      style: FilledButton.styleFrom(backgroundColor: _teal),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (context, c) {
                  final columns = c.maxWidth >= 1050
                      ? 7
                      : c.maxWidth >= 650
                      ? 4
                      : 2;
                  final stats = <Widget>[
                    _stat(
                      'All leads',
                      '${_leads.length}',
                      active: true,
                      note: '+0 in 24 h',
                    ),
                    _stat('New', '${counts['New']}', dot: panelAccent(context)),
                    _stat(
                      'Contacted',
                      '${counts['Contacted']}',
                      dot: const Color(0xFF655BFF),
                    ),
                    _stat(
                      'Interested',
                      '${counts['Interested']}',
                      dot: const Color(0xFFFF9800),
                    ),
                    _stat(
                      'Qualified',
                      '${counts['Qualified']}',
                      dot: const Color(0xFF9855FF),
                    ),
                    _stat(
                      'Converted',
                      '${counts['Converted']}',
                      dot: const Color(0xFF00B982),
                    ),
                    _stat(
                      'Lost',
                      '${counts['Lost']}',
                      dot: const Color(0xFFFF285D),
                    ),
                  ];
                  return GridView.count(
                    crossAxisCount: columns,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: columns == 2 ? 2.4 : 1.65,
                    children: stats,
                  );
                },
              ),
              const SizedBox(height: 12),
              _card(
                padding: const EdgeInsets.all(8),
                child: LayoutBuilder(
                  builder: (context, c) {
                    final small = c.maxWidth < 850;
                    return Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        SizedBox(
                          width: small ? c.maxWidth : c.maxWidth - 600,
                          height: 38,
                          child: TextField(
                            controller: _searchController,
                            onChanged: (_) => setState(() {}),
                            style: const TextStyle(fontSize: 11, color: _ink),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.search,
                                size: 17,
                                color: _muted,
                              ),
                              hintText:
                                  'Search name, phone, email, campaign...',
                              hintStyle: const TextStyle(
                                fontSize: 11,
                                color: _muted,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF8FAFD),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: _line),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: _line),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: small ? 145 : 130,
                          child: _filter(
                            _source,
                            [
                              'All sources',
                              ..._leads.map((e) => e['source']!).toSet(),
                            ],
                            (v) => setState(() => _source = v ?? 'All sources'),
                          ),
                        ),
                        SizedBox(
                          width: 125,
                          child: _filter(_tag, [
                            'All tags',
                            ..._leads
                                .expand(
                                  (e) => (e['tags'] ?? '')
                                      .split(',')
                                      .map((x) => x.trim()),
                                )
                                .where((x) => x.isNotEmpty)
                                .toSet(),
                          ], (v) => setState(() => _tag = v ?? 'All tags')),
                        ),
                        SizedBox(
                          width: 140,
                          child: _filter(_owner, [
                            'Any owner',
                            ..._leads.map((e) => e['owner']!).toSet(),
                          ], (v) => setState(() => _owner = v ?? 'Any owner')),
                        ),
                        SegmentedButton<bool>(
                          segments: const [
                            ButtonSegment(
                              value: false,
                              label: Text(
                                'List',
                                style: TextStyle(fontSize: 10),
                              ),
                              icon: Icon(Icons.list_alt, size: 14),
                            ),
                            ButtonSegment(
                              value: true,
                              label: Text(
                                'Board',
                                style: TextStyle(fontSize: 10),
                              ),
                              icon: Icon(Icons.view_column_outlined, size: 14),
                            ),
                          ],
                          selected: {_boardView},
                          onSelectionChanged: (s) =>
                              setState(() => _boardView = s.first),
                          showSelectedIcon: false,
                          style: ButtonStyle(
                            visualDensity: VisualDensity.compact,
                            padding: const WidgetStatePropertyAll(
                              EdgeInsets.symmetric(horizontal: 8),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              if (!_boardView)
                _card(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: compact ? 1050 : double.infinity,
                          child: Column(
                            children: [
                              Container(
                                height: 38,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF8FAFD),
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 30,
                                      child: Checkbox(
                                        value:
                                            leads.isNotEmpty &&
                                            leads.every(
                                              (e) => _selected.contains(e.key),
                                            ),
                                        tristate: true,
                                        onChanged: (v) => setState(() {
                                          if (v == true) {
                                            _selected.addAll(
                                              leads.map((e) => e.key),
                                            );
                                          } else {
                                            _selected.removeAll(
                                              leads.map((e) => e.key),
                                            );
                                          }
                                        }),
                                        activeColor: _teal,
                                      ),
                                    ),
                                    _header('LEAD', flex: 3),
                                    _header('SOURCE', flex: 1),
                                    _header('STATUS', flex: 2),
                                    _header('OWNER', flex: 2),
                                    _header('TAGS', flex: 1),
                                    _header('LAST ACTIVITY', flex: 2),
                                  ],
                                ),
                              ),
                              const Divider(height: 1, color: _line),
                              if (leads.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.all(28),
                                  child: Text(
                                    'No leads found.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _muted,
                                    ),
                                  ),
                                )
                              else
                                ...leads.map((entry) {
                                  final i = entry.key;
                                  final lead = entry.value;
                                  final status = lead['status'] ?? 'New';
                                  final statusColor = status == 'Converted'
                                      ? const Color(0xFF00A879)
                                      : status == 'Lost'
                                      ? const Color(0xFFFF285D)
                                      : panelAccent(context);
                                  return Column(
                                    children: [
                                      Container(
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 30,
                                              child: Checkbox(
                                                value: _selected.contains(i),
                                                onChanged: (v) => setState(() {
                                                  if (v == true) {
                                                    _selected.add(i);
                                                  } else {
                                                    _selected.remove(i);
                                                  }
                                                }),
                                                activeColor: _teal,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    alignment: Alignment.center,
                                                    decoration:
                                                        const BoxDecoration(
                                                          color: Color(
                                                            0xFFE1F3F7,
                                                          ),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                    child: Text(
                                                      (lead['name'] ?? '?')
                                                          .substring(0, 1)
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                        color: _teal,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          lead['name'] ?? '',
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 11,
                                                                color: _ink,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                        ),
                                                        Text(
                                                          lead['phone'] ?? '',
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 10,
                                                                color: _muted,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: _pill(
                                                  lead['source'] ?? '—',
                                                  const Color(0xFFEFF2F7),
                                                  _muted,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: _pill(
                                                  status,
                                                  statusColor.withValues(alpha: .12),
                                                  statusColor,
                                                  dot: true,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                lead['owner'] ?? '—',
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: _muted,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: _pill(
                                                  lead['tags'] ?? '—',
                                                  const Color(0xFFEFF2F7),
                                                  _muted,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                lead['activity'] ?? '—',
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: _muted,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(height: 1, color: _line),
                                    ],
                                  );
                                }),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${leads.length} lead${leads.length == 1 ? '' : 's'}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: _muted,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.chevron_left,
                              size: 18,
                              color: Color(0xFFB7C1D0),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Page 1 of 1',
                              style: const TextStyle(
                                fontSize: 10,
                                color: _muted,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.chevron_right,
                              size: 18,
                              color: Color(0xFFB7C1D0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              else
                _board(leads),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(String text, {int flex = 1}) => Expanded(
    flex: flex,
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w800,
        color: _muted,
      ),
    ),
  );

  Widget _pill(
    String text,
    Color background,
    Color foreground, {
    bool dot = false,
  }) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (dot) ...[
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: foreground,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
        ],
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              color: foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _board(List<MapEntry<int, Map<String, String>>> leads) {
    const stages = [
      'New',
      'Contacted',
      'Interested',
      'Qualified',
      'Converted',
      'Lost',
    ];
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 1100
          ? 3
          : MediaQuery.of(context).size.width > 700
          ? 2
          : 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.5,
      children: stages
          .map(
            (stage) => _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stage,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: _ink,
                    ),
                  ),
                  const Divider(),
                  ...leads
                      .where((e) => e.value['status'] == stage)
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _canvas,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.value['name'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: _ink,
                                  ),
                                ),
                                Text(
                                  e.value['phone'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: _muted,
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
          )
          .toList(),
    );
  }

  Future<void> _addLead() async {
    final name = TextEditingController();
    final phone = TextEditingController();
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add lead'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: phone,
              decoration: const InputDecoration(labelText: 'Phone number'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (name.text.trim().isNotEmpty) {
                Navigator.pop(context, {
                  'name': name.text.trim(),
                  'phone': phone.text.trim(),
                });
              }
            },
            child: const Text('Add lead'),
          ),
        ],
      ),
    );
    if (result != null && mounted) {
      setState(
        () => _leads.add({
          ...result,
          'source': 'Manual',
          'status': 'New',
          'owner': 'Unassigned',
          'tags': '',
          'activity': 'Just now',
        }),
      );
    }
  }
}
