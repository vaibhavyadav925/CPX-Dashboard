part of '../app.dart';

class CRMLeadsScreen extends StatefulWidget {
  const CRMLeadsScreen({super.key});

  @override
  State<CRMLeadsScreen> createState() => _CRMLeadsScreenState();
}

class _CRMLeadsScreenState extends State<CRMLeadsScreen> {
  static const String _storageKey = 'crm_leads_v1';
  static const int _pageSize = 25;
  static const Color _ink = navy;
  static const Color _muted = muted;
  Color get _teal => PanelThemeController.instance.accentColor;
  static const Color _line = Color(0xFFDCE3EE);
  Color get _canvas => pageColor;

  final TextEditingController _searchController = TextEditingController();
  String _source = 'All sources';
  String _tag = 'All tags';
  String _owner = 'Any owner';
  bool _boardView = false;
  bool _isImportingLeads = false;
  bool _isLoadingLeads = true;
  String? _leadLoadError;
  String _sortField = 'name';
  bool _sortAscending = true;
  int _currentPage = 0;
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

  @override
  void initState() {
    super.initState();
    _loadLeads();
  }

  Future<void> _loadLeads() async {
    if (mounted) {
      setState(() {
        _isLoadingLeads = true;
        _leadLoadError = null;
      });
    }
    try {
      final preferences = await SharedPreferences.getInstance();
      final saved = preferences.getString(_storageKey);
      if (saved != null) {
        final decoded = jsonDecode(saved);
        if (decoded is! List) {
          throw const FormatException('Saved lead data is not a list.');
        }
        final leads = decoded.map((record) {
          if (record is! Map) {
            throw const FormatException('A saved lead record is invalid.');
          }
          return <String, String>{
            for (final entry in record.entries)
              entry.key.toString(): entry.value?.toString() ?? '',
          };
        }).toList();
        if (!mounted) return;
        setState(() {
          _leads
            ..clear()
            ..addAll(leads);
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() => _leadLoadError = error.toString());
      }
    } finally {
      if (mounted) setState(() => _isLoadingLeads = false);
    }
  }

  Future<bool> _saveLeadSnapshot(List<Map<String, String>> leads) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final saved = await preferences.setString(_storageKey, jsonEncode(leads));
      if (!saved) {
        throw Exception('Lead data could not be saved on this device.');
      }
      if (mounted) {
        setState(() {
          _leads
            ..clear()
            ..addAll(leads);
          _selected.removeWhere((index) => index >= _leads.length);
        });
      }
      return true;
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not save leads: $error')));
      }
      return false;
    }
  }

  List<Map<String, String>> _copyLeads() =>
      _leads.map((lead) => Map<String, String>.of(lead)).toList();

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
    final visible = _leads.asMap().entries.where((entry) {
      final lead = entry.value;
      final matchesSearch =
          q.isEmpty ||
          [
            'name',
            'phone',
            'email',
            'source',
            'tags',
            'owner',
            'city',
            'product',
            'campaign_name',
          ].any((k) => (lead[k] ?? '').toLowerCase().contains(q));
      final matchesSource =
          _source == 'All sources' || lead['source'] == _source;
      final matchesTag =
          _tag == 'All tags' ||
          (lead['tags'] ?? '')
              .split(RegExp('[,;]'))
              .map((e) => e.trim())
              .contains(_tag);
      final matchesOwner = _owner == 'Any owner' || lead['owner'] == _owner;
      return matchesSearch && matchesSource && matchesTag && matchesOwner;
    }).toList();
    visible.sort((a, b) {
      final comparison = (a.value[_sortField] ?? '').toLowerCase().compareTo(
        (b.value[_sortField] ?? '').toLowerCase(),
      );
      return _sortAscending ? comparison : -comparison;
    });
    return visible;
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

  Widget _emptyLeadsState() => PremiumEmptyState(
    icon: _leads.isEmpty
        ? Icons.person_add_alt_1_outlined
        : Icons.search_off_rounded,
    title: _leads.isEmpty ? 'No leads yet' : 'No leads match your filters',
    message: _leads.isEmpty
        ? 'Add a lead or import a CSV to start building your pipeline.'
        : 'Try a different search or clear the active filters.',
    action: _leads.isEmpty
        ? FilledButton.icon(
            onPressed: _addLead,
            icon: const Icon(Icons.add),
            label: const Text('Add lead'),
          )
        : TextButton.icon(
            onPressed: () {
              _searchController.clear();
              setState(() {
                _source = 'All sources';
                _tag = 'All tags';
                _owner = 'Any owner';
                _currentPage = 0;
              });
            },
            icon: const Icon(Icons.filter_alt_off_rounded),
            label: const Text('Clear filters'),
          ),
  );

  Future<void> _changeLeadStatus(int index, String status) async {
    if (index < 0 ||
        index >= _leads.length ||
        _leads[index]['status'] == status) {
      return;
    }
    final updated = _copyLeads();
    updated[index]['status'] = status;
    updated[index]['activity'] = 'Just now';
    await _saveLeadSnapshot(updated);
  }

  Future<void> _changeSelectedStatus() async {
    final status = await showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Move selected leads'),
        children: [
          for (final option in _leadStatuses)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(dialogContext, option),
              child: Text(option),
            ),
        ],
      ),
    );
    if (status == null || !mounted) return;
    final updated = _copyLeads();
    for (final index in _selected) {
      if (index >= 0 && index < updated.length) {
        updated[index]['status'] = status;
        updated[index]['activity'] = 'Just now';
      }
    }
    await _saveLeadSnapshot(updated);
  }

  Future<void> _assignSelectedOwner() async {
    var owner = '';
    final selectedOwner = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Assign selected leads'),
        content: TextField(
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          onChanged: (value) => owner = value,
          decoration: const InputDecoration(
            labelText: 'Owner',
            hintText: 'Enter a team member name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, owner.trim()),
            child: const Text('Assign'),
          ),
        ],
      ),
    );
    if (selectedOwner == null || selectedOwner.isEmpty || !mounted) return;
    final updated = _copyLeads();
    for (final index in _selected) {
      if (index >= 0 && index < updated.length) {
        updated[index]['owner'] = selectedOwner;
        updated[index]['activity'] = 'Just now';
      }
    }
    await _saveLeadSnapshot(updated);
  }

  Future<void> _deleteSelectedLeads() async {
    final indexes = _selected.where((index) => index < _leads.length).toSet();
    if (indexes.isEmpty) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Delete ${indexes.length} selected leads?'),
        content: const Text(
          'This removes the selected leads from this device. You can undo immediately after deleting.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final previous = _copyLeads();
    final updated = [
      for (var index = 0; index < previous.length; index++)
        if (!indexes.contains(index)) previous[index],
    ];
    if (!await _saveLeadSnapshot(updated) || !mounted) return;
    setState(_selected.clear);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Deleted ${indexes.length} leads'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () => _saveLeadSnapshot(previous),
          ),
        ),
      );
  }

  Future<void> _deleteLead(int index) async {
    if (index < 0 || index >= _leads.length) return;
    final lead = Map<String, String>.of(_leads[index]);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete this lead?'),
        content: Text(
          '“${lead['name']?.isNotEmpty == true ? lead['name'] : lead['phone']}” will be removed from this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final previous = _copyLeads();
    final updated = _copyLeads()..removeAt(index);
    if (!await _saveLeadSnapshot(updated) || !mounted) return;
    setState(_selected.clear);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Lead deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () => _saveLeadSnapshot(previous),
          ),
        ),
      );
  }

  Widget _selectionActions() => _card(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        Text(
          '${_selected.length} selected',
          style: const TextStyle(
            color: _ink,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
        OutlinedButton.icon(
          onPressed: _changeSelectedStatus,
          icon: const Icon(Icons.swap_horiz, size: 16),
          label: const Text('Change status'),
        ),
        OutlinedButton.icon(
          onPressed: _assignSelectedOwner,
          icon: const Icon(Icons.person_outline, size: 16),
          label: const Text('Assign owner'),
        ),
        TextButton.icon(
          onPressed: _deleteSelectedLeads,
          icon: const Icon(Icons.delete_outline, size: 16),
          label: const Text('Delete'),
          style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
        ),
        TextButton(
          onPressed: () => setState(_selected.clear),
          child: const Text('Clear selection'),
        ),
      ],
    ),
  );

  String get _sortOption {
    if (_sortField == 'name') {
      return _sortAscending ? 'Name (A–Z)' : 'Name (Z–A)';
    }
    return switch (_sortField) {
      'source' => 'Source',
      'status' => 'Status',
      'owner' => 'Owner',
      'activity' => 'Last activity',
      _ => 'Name (A–Z)',
    };
  }

  void _setSortOption(String option) {
    setState(() {
      _sortField = switch (option) {
        'Source' => 'source',
        'Status' => 'status',
        'Owner' => 'owner',
        'Last activity' => 'activity',
        _ => 'name',
      };
      _sortAscending = option != 'Name (Z–A)';
      _currentPage = 0;
    });
  }

  Widget _leadActions(MapEntry<int, Map<String, String>> entry) =>
      PopupMenuButton<String>(
        tooltip: 'Lead actions',
        icon: const Icon(Icons.more_vert, size: 18),
        onSelected: (action) {
          if (action == 'edit') _addLead(editIndex: entry.key);
          if (action == 'delete') _deleteLead(entry.key);
        },
        itemBuilder: (context) => const [
          PopupMenuItem(value: 'edit', child: Text('Edit lead')),
          PopupMenuItem(value: 'delete', child: Text('Delete lead')),
        ],
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
    final filteredLeads = _visibleLeads;
    final pageCount = math.max(
      1,
      (filteredLeads.length + _pageSize - 1) ~/ _pageSize,
    );
    final pageIndex = _currentPage >= pageCount ? pageCount - 1 : _currentPage;
    final leads = _boardView
        ? filteredLeads
        : filteredLeads.skip(pageIndex * _pageSize).take(_pageSize).toList();
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
              PremiumPageHeader(
                title: 'Leads',
                subtitle: 'Every lead from your ads, website, API and imports — follow up, assign and track until they convert.',
                eyebrow: 'CRM & Automation',
                icon: Icons.assignment_ind_outlined,
                action: compact
                    ? null
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          OutlinedButton.icon(
                            onPressed: _exportLeads,
                            icon: const Icon(Icons.download_outlined, size: 16),
                            label: const Text('Export'),
                          ),
                          OutlinedButton.icon(
                            onPressed: _importLeads,
                            icon: const Icon(
                              Icons.upload_file_outlined,
                              size: 16,
                            ),
                            label: const Text('Import CSV'),
                          ),
                          FilledButton.icon(
                            onPressed: _addLead,
                            icon: const Icon(Icons.add, size: 17),
                            label: const Text('Add lead'),
                          ),
                        ],
                      ),
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
                      onPressed: _importLeads,
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
              const SizedBox(height: 10),
              _card(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: _teal, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Leads are saved on this device only. They are not synced to a team account or backend yet; the initial example lead is sample data.',
                        style: TextStyle(
                          color: _muted,
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_isImportingLeads || _isLoadingLeads) ...[
                const SizedBox(height: 8),
                _card(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isLoadingLeads
                            ? Icons.sync
                            : Icons.file_upload_outlined,
                        color: _teal,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isLoadingLeads
                            ? 'Loading saved leads…'
                            : 'Importing leads…',
                        style: const TextStyle(color: _muted, fontSize: 11),
                      ),
                    ],
                  ),
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
                    childAspectRatio: columns == 2 ? 1.95 : 1.65,
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
                            onChanged: (_) => setState(() => _currentPage = 0),
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
                            (v) => setState(() {
                              _source = v ?? 'All sources';
                              _currentPage = 0;
                            }),
                          ),
                        ),
                        SizedBox(
                          width: 125,
                          child: _filter(
                            _tag,
                            [
                              'All tags',
                              ..._leads
                                  .expand(
                                    (e) => (e['tags'] ?? '')
                                        .split(RegExp('[,;]'))
                                        .map((x) => x.trim()),
                                  )
                                  .where((x) => x.isNotEmpty)
                                  .toSet(),
                            ],
                            (v) => setState(() {
                              _tag = v ?? 'All tags';
                              _currentPage = 0;
                            }),
                          ),
                        ),
                        SizedBox(
                          width: 140,
                          child: _filter(
                            _owner,
                            [
                              'Any owner',
                              ..._leads.map((e) => e['owner']!).toSet(),
                            ],
                            (v) => setState(() {
                              _owner = v ?? 'Any owner';
                              _currentPage = 0;
                            }),
                          ),
                        ),
                        SizedBox(
                          width: 140,
                          child: _filter(_sortOption, const [
                            'Name (A–Z)',
                            'Name (Z–A)',
                            'Source',
                            'Status',
                            'Owner',
                            'Last activity',
                          ], (value) => _setSortOption(value ?? 'Name (A–Z)')),
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
              if (_selected.isNotEmpty) ...[
                _selectionActions(),
                const SizedBox(height: 10),
              ],
              if (_isLoadingLeads)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: PremiumLoadingState(message: 'Loading saved leads'),
                )
              else if (_leadLoadError != null)
                PremiumEmptyState(
                  icon: Icons.cloud_off_outlined,
                  title: 'Could not load saved leads',
                  message: _leadLoadError!,
                  action: FilledButton.icon(
                    onPressed: _loadLeads,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try again'),
                  ),
                )
              else if (!_boardView && width < 600)
                _mobileLeadList(
                  leads,
                  pageIndex,
                  pageCount,
                  filteredLeads.length,
                )
              else if (!_boardView)
                _card(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: width < 1094 ? 1050 : width - 44,
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
                                      child: Tooltip(
                                        message:
                                            'Select all leads on this page',
                                        child: Checkbox(
                                          value:
                                              leads.isNotEmpty &&
                                              leads.every(
                                                (e) =>
                                                    _selected.contains(e.key),
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
                                    ),
                                    _header('LEAD', sortField: 'name', flex: 3),
                                    _header(
                                      'SOURCE',
                                      sortField: 'source',
                                      flex: 1,
                                    ),
                                    _header(
                                      'STATUS',
                                      sortField: 'status',
                                      flex: 2,
                                    ),
                                    _header(
                                      'OWNER',
                                      sortField: 'owner',
                                      flex: 2,
                                    ),
                                    _header('TAGS', sortField: 'tags', flex: 1),
                                    _header(
                                      'LAST ACTIVITY',
                                      sortField: 'activity',
                                      flex: 2,
                                    ),
                                    _header('ACTIONS', flex: 1),
                                  ],
                                ),
                              ),
                              const Divider(height: 1, color: _line),
                              if (leads.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: _emptyLeadsState(),
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
                                  final leadName = (lead['name'] ?? '').trim();
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
                                              child: Tooltip(
                                                message: 'Select $leadName',
                                                child: Checkbox(
                                                  value: _selected.contains(i),
                                                  onChanged: (v) =>
                                                      setState(() {
                                                        if (v == true) {
                                                          _selected.add(i);
                                                        } else {
                                                          _selected.remove(i);
                                                        }
                                                      }),
                                                  activeColor: _teal,
                                                ),
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
                                                      leadName.isEmpty
                                                          ? '?'
                                                          : leadName[0]
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
                                                  statusColor.withValues(
                                                    alpha: .12,
                                                  ),
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
                                            Expanded(
                                              flex: 1,
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: _leadActions(entry),
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
                              'Showing ${filteredLeads.isEmpty ? 0 : pageIndex * _pageSize + 1}–${math.min(filteredLeads.length, (pageIndex + 1) * _pageSize)} of ${filteredLeads.length} leads',
                              style: const TextStyle(
                                fontSize: 10,
                                color: _muted,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              tooltip: 'Previous page',
                              onPressed: pageIndex == 0
                                  ? null
                                  : () => setState(
                                      () => _currentPage = pageIndex - 1,
                                    ),
                              icon: const Icon(Icons.chevron_left, size: 18),
                            ),
                            Text(
                              'Page ${pageIndex + 1} of $pageCount',
                              style: const TextStyle(
                                fontSize: 10,
                                color: _muted,
                              ),
                            ),
                            IconButton(
                              tooltip: 'Next page',
                              onPressed: pageIndex + 1 >= pageCount
                                  ? null
                                  : () => setState(
                                      () => _currentPage = pageIndex + 1,
                                    ),
                              icon: const Icon(Icons.chevron_right, size: 18),
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

  Widget _header(String text, {int flex = 1, String? sortField}) => Expanded(
    flex: flex,
    child: sortField == null
        ? Text(
            text,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: _muted,
            ),
          )
        : Tooltip(
            message: 'Sort by ${text.toLowerCase()}',
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () => setState(() {
                if (_sortField == sortField) {
                  _sortAscending = !_sortAscending;
                } else {
                  _sortField = sortField;
                  _sortAscending = true;
                }
                _currentPage = 0;
              }),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: _muted,
                      ),
                    ),
                  ),
                  Icon(
                    _sortField != sortField
                        ? Icons.unfold_more
                        : _sortAscending
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    size: 12,
                    color: _muted,
                  ),
                ],
              ),
            ),
          ),
  );

  Widget _mobileLeadList(
    List<MapEntry<int, Map<String, String>>> leads,
    int pageIndex,
    int pageCount,
    int totalCount,
  ) {
    return _card(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFD),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Tooltip(
                  message: 'Select all leads on this page',
                  child: Checkbox(
                    value:
                        leads.isNotEmpty &&
                        leads.every((lead) => _selected.contains(lead.key)),
                    tristate: true,
                    onChanged: (selected) => setState(() {
                      if (selected == true) {
                        _selected.addAll(leads.map((lead) => lead.key));
                      } else {
                        _selected.removeAll(leads.map((lead) => lead.key));
                      }
                    }),
                    activeColor: _teal,
                  ),
                ),
                const Text(
                  'Select leads',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  '${leads.length} lead${leads.length == 1 ? '' : 's'}',
                  style: const TextStyle(color: _muted, fontSize: 10),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: _line),
          if (leads.isEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: _emptyLeadsState(),
            )
          else
            ...leads.map(_mobileLeadCard),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Page ${pageIndex + 1} of $pageCount · $totalCount leads',
                    style: const TextStyle(color: _muted, fontSize: 10),
                  ),
                ),
                IconButton(
                  tooltip: 'Previous page',
                  onPressed: pageIndex == 0
                      ? null
                      : () => setState(() => _currentPage = pageIndex - 1),
                  icon: const Icon(Icons.chevron_left, size: 18),
                ),
                IconButton(
                  tooltip: 'Next page',
                  onPressed: pageIndex + 1 >= pageCount
                      ? null
                      : () => setState(() => _currentPage = pageIndex + 1),
                  icon: const Icon(Icons.chevron_right, size: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mobileLeadCard(MapEntry<int, Map<String, String>> entry) {
    final lead = entry.value;
    final leadName = (lead['name'] ?? '').trim();
    final status = lead['status'] ?? 'New';
    final statusColor = status == 'Converted'
        ? const Color(0xFF00A879)
        : status == 'Lost'
        ? const Color(0xFFFF285D)
        : panelAccent(context);
    final details = <(String, String)>[
      ('Source', lead['source'] ?? '—'),
      ('Owner', lead['owner'] ?? '—'),
      ('Tags', (lead['tags'] ?? '').isEmpty ? '—' : lead['tags']!),
      ('Last activity', lead['activity'] ?? '—'),
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Tooltip(
                    message: 'Select $leadName',
                    child: Checkbox(
                      value: _selected.contains(entry.key),
                      onChanged: (selected) => setState(() {
                        if (selected == true) {
                          _selected.add(entry.key);
                        } else {
                          _selected.remove(entry.key);
                        }
                      }),
                      activeColor: _teal,
                    ),
                  ),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFFE1F3F7),
                    child: Text(
                      leadName.isEmpty ? 'L' : leadName[0].toUpperCase(),
                      style: TextStyle(
                        color: _teal,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          leadName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _ink,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          lead['phone'] ?? '—',
                          style: const TextStyle(color: _muted, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  _pill(
                    status,
                    statusColor.withValues(alpha: .12),
                    statusColor,
                  ),
                  _leadActions(entry),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 48, top: 8),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: details.map((detail) {
                    return SizedBox(
                      width: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail.$1,
                            style: const TextStyle(color: _muted, fontSize: 9),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            detail.$2,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _ink,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: _line),
      ],
    );
  }

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
      children: stages.map((stage) {
        final stageLeads = leads
            .where((entry) => entry.value['status'] == stage)
            .toList();
        return DragTarget<int>(
          onWillAcceptWithDetails: (details) =>
              details.data >= 0 &&
              details.data < _leads.length &&
              _leads[details.data]['status'] != stage,
          onAcceptWithDetails: (details) =>
              _changeLeadStatus(details.data, stage),
          builder: (context, candidates, rejected) => _card(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                color: candidates.isEmpty
                    ? Colors.transparent
                    : _teal.withValues(alpha: .06),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          stage,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: _ink,
                          ),
                        ),
                      ),
                      _pill(
                        '${stageLeads.length}',
                        const Color(0xFFEFF2F7),
                        _muted,
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: stageLeads.isEmpty
                        ? Center(
                            child: Text(
                              candidates.isEmpty
                                  ? 'No leads in this stage'
                                  : 'Drop here to move to $stage',
                              style: const TextStyle(
                                color: _muted,
                                fontSize: 10,
                              ),
                            ),
                          )
                        : ListView(
                            padding: EdgeInsets.zero,
                            children: stageLeads
                                .map(
                                  (entry) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: LongPressDraggable<int>(
                                      data: entry.key,
                                      feedback: Material(
                                        color: Colors.transparent,
                                        child: SizedBox(
                                          width: 240,
                                          child: _leadBoardCard(entry, stage),
                                        ),
                                      ),
                                      childWhenDragging: Opacity(
                                        opacity: .35,
                                        child: _leadBoardCard(entry, stage),
                                      ),
                                      child: _leadBoardCard(entry, stage),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _leadBoardCard(
    MapEntry<int, Map<String, String>> entry,
    String stage,
  ) {
    final lead = entry.value;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _canvas,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _line),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lead['name'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _ink,
                  ),
                ),
                Text(
                  lead['phone'] ?? '',
                  style: const TextStyle(fontSize: 10, color: _muted),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Change status without dragging',
            icon: const Icon(Icons.more_horiz, size: 18),
            onSelected: (status) => _changeLeadStatus(entry.key, status),
            itemBuilder: (context) => [
              for (final status in _leadStatuses)
                PopupMenuItem(
                  value: status,
                  enabled: status != stage,
                  child: Text('Move to $status'),
                ),
            ],
          ),
          _leadActions(entry),
        ],
      ),
    );
  }

  Future<void> _addLead({int? editIndex}) async {
    final existing =
        editIndex != null && editIndex >= 0 && editIndex < _leads.length
        ? _leads[editIndex]
        : null;
    final fieldValues = {
      for (final field in [
        'name',
        'phone',
        'email',
        'city',
        'product',
        'campaign_name',
      ])
        field: existing?[field] ?? '',
    };
    var source = existing?['source'] ?? 'Manual';
    const sourceOptions = [
      'Manual',
      'Website',
      'Facebook',
      'Google Ads',
      'CSV import',
      'Referral',
      'Other',
    ];
    final availableSources = [...sourceOptions];
    if (!availableSources.contains(source)) availableSources.add(source);
    var marketingConsent = existing?['marketing_consent'] ?? 'Unknown';
    if (!const ['Unknown', 'Yes', 'No'].contains(marketingConsent)) {
      marketingConsent = 'Unknown';
    }
    var startAutomations = existing?['start_automations'] != 'false';
    var allowDialogClose = false;

    final result = await showDialog<Map<String, String>>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          Future<void> closeDialog([Map<String, String>? value]) async {
            final changed = existing == null
                ? fieldValues.values.any((field) => field.trim().isNotEmpty) ||
                      source != 'Manual' ||
                      marketingConsent != 'Unknown' ||
                      !startAutomations
                : fieldValues.entries.any(
                        (entry) =>
                            entry.value.trim() != (existing[entry.key] ?? ''),
                      ) ||
                      source != (existing['source'] ?? 'Manual') ||
                      marketingConsent !=
                          (existing['marketing_consent'] ?? 'Unknown') ||
                      startAutomations !=
                          (existing['start_automations'] != 'false');
            if (value == null && changed) {
              final discard = await showDialog<bool>(
                context: dialogContext,
                builder: (confirmContext) => AlertDialog(
                  title: const Text('Discard unsaved changes?'),
                  content: const Text(
                    'Your changes to this lead have not been saved.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(confirmContext, false),
                      child: const Text('Keep editing'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(confirmContext, true),
                      child: const Text('Discard'),
                    ),
                  ],
                ),
              );
              if (discard != true || !dialogContext.mounted) return;
            }
            setDialogState(() => allowDialogClose = true);
            await WidgetsBinding.instance.endOfFrame;
            if (dialogContext.mounted) {
              Navigator.pop(dialogContext, value);
            }
          }

          return PopScope<Map<String, String>>(
            canPop: allowDialogClose,
            onPopInvokedWithResult: (didPop, value) {
              if (!didPop) closeDialog();
            },
            child: Dialog(
              backgroundColor: premiumSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 480,
                  maxHeight: 700,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              existing == null ? 'Add lead' : 'Edit lead',
                              style: TextStyle(
                                color: _ink,
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Close',
                            visualDensity: VisualDensity.compact,
                            onPressed: closeDialog,
                            icon: const Icon(Icons.close, size: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final twoColumns = constraints.maxWidth >= 400;
                              final gap = 10.0;
                              final fieldWidth = twoColumns
                                  ? (constraints.maxWidth - gap) / 2
                                  : constraints.maxWidth;
                              final fields = <Widget>[
                                _leadDialogField(
                                  'Name',
                                  fieldValues['name']!,
                                  onChanged: (value) =>
                                      fieldValues['name'] = value,
                                  hint: 'Lead name',
                                ),
                                _leadDialogField(
                                  'Phone (WhatsApp) *',
                                  fieldValues['phone']!,
                                  onChanged: (value) =>
                                      fieldValues['phone'] = value,
                                  hint: '98XXXXXXXX',
                                  keyboardType: TextInputType.phone,
                                ),
                                _leadDialogField(
                                  'Email',
                                  fieldValues['email']!,
                                  onChanged: (value) =>
                                      fieldValues['email'] = value,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                _leadDialogField(
                                  'City',
                                  fieldValues['city']!,
                                  onChanged: (value) =>
                                      fieldValues['city'] = value,
                                ),
                                _leadDialogField(
                                  'Product / interest',
                                  fieldValues['product']!,
                                  onChanged: (value) =>
                                      fieldValues['product'] = value,
                                ),
                                _leadDialogField(
                                  'Campaign',
                                  fieldValues['campaign_name']!,
                                  onChanged: (value) =>
                                      fieldValues['campaign_name'] = value,
                                ),
                                _leadDialogDropdown(
                                  'Source',
                                  source,
                                  availableSources,
                                  (value) => setDialogState(
                                    () => source = value ?? source,
                                  ),
                                ),
                                _leadDialogDropdown(
                                  'Marketing consent',
                                  marketingConsent,
                                  const ['Unknown', 'Yes', 'No'],
                                  (value) => setDialogState(
                                    () => marketingConsent = value ?? 'Unknown',
                                  ),
                                ),
                              ];
                              return Wrap(
                                spacing: gap,
                                runSpacing: 10,
                                children: fields
                                    .map(
                                      (field) => SizedBox(
                                        width: fieldWidth,
                                        child: field,
                                      ),
                                    )
                                    .toList(),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text(
                          'Start matching “New lead” automations',
                          style: TextStyle(fontSize: 11, color: _ink),
                        ),
                        value: startAutomations,
                        onChanged: (value) => setDialogState(
                          () => startAutomations = value ?? false,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          key: const ValueKey('crm-lead-save'),
                          onPressed: () {
                            final phone = fieldValues['phone']!.trim();
                            if (phone.isEmpty) {
                              ScaffoldMessenger.of(dialogContext).showSnackBar(
                                const SnackBar(
                                  content: Text('Phone number is required.'),
                                ),
                              );
                              return;
                            }
                            closeDialog({
                              for (final entry in fieldValues.entries)
                                entry.key: entry.value.trim(),
                              'source': source,
                              'marketing_consent': marketingConsent,
                              'start_automations': '$startAutomations',
                            });
                          },
                          icon: const Icon(Icons.add, size: 17),
                          label: Text(
                            existing == null ? 'Add lead' : 'Save changes',
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: _teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    if (result == null || !mounted) return;

    final normalizedPhone = _normalizeLeadPhone(result['phone'] ?? '');
    final duplicate = _leads.asMap().entries.any(
      (entry) =>
          entry.key != editIndex &&
          _normalizeLeadPhone(entry.value['phone'] ?? '') == normalizedPhone,
    );
    if (duplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A lead with this phone number already exists.'),
        ),
      );
      return;
    }

    final updated = _copyLeads();
    if (existing == null) {
      updated.add({
        ...result,
        'status': 'New',
        'owner': 'Unassigned',
        'tags': '',
        'activity': 'Just now',
      });
    } else {
      updated[editIndex!] = {
        ...existing,
        ...result,
        'status': existing['status'] ?? 'New',
        'owner': existing['owner'] ?? 'Unassigned',
        'tags': existing['tags'] ?? '',
        'activity': 'Just now',
      };
    }
    await _saveLeadSnapshot(updated);
  }

  Widget _leadDialogField(
    String label,
    String initialValue, {
    String? hint,
    TextInputType? keyboardType,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            label,
            style: const TextStyle(
              color: _ink,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextFormField(
          key: ValueKey('crm-lead-field-$label'),
          initialValue: initialValue,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            filled: true,
            fillColor: const Color(0xFFF8FAFD),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: _line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: _line),
            ),
          ),
        ),
      ],
    );
  }

  Widget _leadDialogDropdown(
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            label,
            style: const TextStyle(
              color: _ink,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            filled: true,
            fillColor: const Color(0xFFF8FAFD),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: _line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: _line),
            ),
          ),
          items: options
              .map(
                (option) => DropdownMenuItem(
                  value: option,
                  child: Text(
                    option,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Future<void> _downloadLeadImportSample() => saveCsvFile(
    context,
    fileName: 'crm_leads_import_sample',
    headers: const [
      'phone',
      'name',
      'email',
      'city',
      'product',
      'source',
      'campaign_name',
      'status',
      'tags',
    ],
    rows: const [],
  );

  Future<void> _importLeads() async {
    if (_isImportingLeads) return;
    var sourceForMissing = 'CSV import';
    var startAutomations = false;
    PlatformFile? selectedFile;

    final shouldImport = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => Dialog(
          backgroundColor: premiumSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460, maxHeight: 640),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Import leads from CSV',
                          style: TextStyle(
                            color: _ink,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Close',
                        visualDensity: VisualDensity.compact,
                        onPressed: () => Navigator.pop(dialogContext, false),
                        icon: const Icon(Icons.close, size: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text.rich(
                    TextSpan(
                      style: TextStyle(
                        color: _muted,
                        fontSize: 11,
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(text: 'Columns: '),
                        TextSpan(
                          text: 'phone',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text: ' (required), name, email, city, product, source, campaign_name, status, tags (separate with “;”). Existing phone numbers are updated, not duplicated. ',
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: _downloadLeadImportSample,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Download a sample',
                        style: TextStyle(
                          color: Color(0xFF0097B5),
                          fontSize: 11,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () async {
                      try {
                        final file = await pickSpreadsheetFile();
                        if (file != null) {
                          setDialogState(() => selectedFile = file);
                        }
                      } on PlatformException catch (error) {
                        if (!dialogContext.mounted) return;
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Could not open the file picker: ${error.message ?? error.code}',
                            ),
                          ),
                        );
                      } on Exception catch (error) {
                        if (!dialogContext.mounted) return;
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          SnackBar(
                            content: Text('Could not choose a file: $error'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.upload_file_outlined, size: 17),
                    label: Text(
                      selectedFile?.name ?? 'Choose CSV or Excel file',
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(42),
                      alignment: Alignment.centerLeft,
                      foregroundColor: _ink,
                      side: const BorderSide(color: _line),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Source for rows without one',
                    style: TextStyle(
                      color: _ink,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  DropdownButtonFormField<String>(
                    initialValue: sourceForMissing,
                    isExpanded: true,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFD),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(color: _line),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(color: _line),
                      ),
                    ),
                    items:
                        const [
                              'CSV import',
                              'Website',
                              'Facebook',
                              'Google Ads',
                              'Referral',
                              'Other',
                            ]
                            .map(
                              (option) => DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              ),
                            )
                            .toList(),
                    onChanged: (value) => setDialogState(
                      () => sourceForMissing = value ?? 'CSV import',
                    ),
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text(
                      'Start matching “New lead” automations for new rows',
                      style: TextStyle(color: _ink, fontSize: 11),
                    ),
                    subtitle: const Text(
                      'Leave off for old lists to avoid sending welcome messages again.',
                      style: TextStyle(color: _muted, fontSize: 9),
                    ),
                    value: startAutomations,
                    onChanged: (value) =>
                        setDialogState(() => startAutomations = value ?? false),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: selectedFile == null
                          ? null
                          : () => Navigator.pop(dialogContext, true),
                      icon: const Icon(Icons.file_upload_outlined, size: 17),
                      label: const Text('Import'),
                      style: FilledButton.styleFrom(
                        backgroundColor: _teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (shouldImport != true || selectedFile == null || !mounted) return;
    setState(() => _isImportingLeads = true);
    try {
      final parsedRows = parseCrmLeadsRows(
        await readSpreadsheetRows(selectedFile!),
      );
      final updatedLeads = _copyLeads();
      final existingByPhone = <String, Map<String, String>>{
        for (final lead in updatedLeads)
          _normalizeLeadPhone(lead['phone'] ?? ''): lead,
      };
      var invalidRows = 0;
      var addedRows = 0;
      var updatedRows = 0;

      for (final row in parsedRows) {
        final phone = (row['phone'] ?? '').trim();
        if (phone.isEmpty) {
          invalidRows++;
          continue;
        }
        final key = _normalizeLeadPhone(phone);
        final lead = existingByPhone[key];
        if (lead == null) {
          final newLead = <String, String>{
            'name': (row['name'] ?? '').trim(),
            'phone': phone,
            'email': (row['email'] ?? '').trim(),
            'city': (row['city'] ?? '').trim(),
            'product': (row['product'] ?? '').trim(),
            'source': (row['source'] ?? '').trim().isEmpty
                ? sourceForMissing
                : row['source']!.trim(),
            'campaign_name': (row['campaign_name'] ?? '').trim(),
            'status': _leadStatuses.contains(row['status'])
                ? row['status']!
                : 'New',
            'owner': 'Unassigned',
            'tags': (row['tags'] ?? '').trim(),
            'activity': 'Just now',
            'marketing_consent': 'Unknown',
            'start_automations': '$startAutomations',
          };
          existingByPhone[key] = newLead;
          updatedLeads.add(newLead);
          addedRows++;
        } else {
          for (final field in [
            'name',
            'email',
            'city',
            'product',
            'campaign_name',
            'tags',
          ]) {
            final value = (row[field] ?? '').trim();
            if (value.isNotEmpty) lead[field] = value;
          }
          final source = (row['source'] ?? '').trim();
          lead['source'] = source.isEmpty ? sourceForMissing : source;
          final status = row['status'];
          if (_leadStatuses.contains(status)) lead['status'] = status!;
          lead['activity'] = 'Just now';
          updatedRows++;
        }
      }

      if (!mounted) return;
      if (!await _saveLeadSnapshot(updatedLeads)) return;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Imported $addedRows new, updated $updatedRows existing, skipped $invalidRows rows without a phone number.',
          ),
        ),
      );
    } on FormatException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not import file: ${error.message}')),
      );
    } on Exception catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not import file: $error')));
    } finally {
      if (mounted) setState(() => _isImportingLeads = false);
    }
  }
}

const _leadStatuses = [
  'New',
  'Contacted',
  'Interested',
  'Qualified',
  'Converted',
  'Lost',
];

String _normalizeLeadPhone(String phone) =>
    phone.replaceAll(RegExp(r'[^0-9+]'), '');
