part of '../app.dart';

class RCSTemplatesScreen extends StatefulWidget {
  const RCSTemplatesScreen({super.key});

  @override
  State<RCSTemplatesScreen> createState() => _RCSTemplatesScreenState();
}

class _RCSTemplatesScreenState extends State<RCSTemplatesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _statusFilter = 'All statuses';
  String _typeFilter = 'All types';

  final List<_RCSTemplateRecord> _templates = [
    _RCSTemplateRecord(
      'test',
      'PlainText',
      'Promotional',
      'Approved',
      'test',
      '30/9/2026, 11:59:54 am',
    ),
    _RCSTemplateRecord(
      'webtech_carousel',
      'Carousel',
      'Promotional',
      'Approved',
      'CPaaS Service (RCS, SMS, ...)',
      '24/9/2026, 5:35:07 pm',
    ),
    _RCSTemplateRecord(
      'real_webtech',
      'RichCard',
      'Promotional',
      'Approved',
      'Webtechage CPaaS',
      '24/9/2026, 5:28:01 pm',
    ),
    _RCSTemplateRecord(
      'real',
      'RichCard',
      'Promotional',
      'Approved',
      'Webtechage CPaaS Solutions',
      '6/9/2026, 7:27:46 pm',
    ),
    _RCSTemplateRecord(
      'Botmtjn3dj4',
      'PlainText',
      'Promotional',
      'Approved',
      'Welcome to Webtechage CP...',
      '2/9/2026, 10:42:31 am',
    ),
    _RCSTemplateRecord(
      'Botmtjn15tl',
      'PlainText',
      'Promotional',
      'Approved',
      'Hello, welcome to Webtecha...',
      '2/9/2026, 10:40:49 am',
    ),
    _RCSTemplateRecord(
      'new_webtech_template',
      'RichCard',
      'Promotional',
      'Approved',
      'Webtechage CPaaS Solutions',
      '1/9/2026, 4:06:40 pm',
    ),
    _RCSTemplateRecord(
      'ClaudeFixTest2',
      'RichCard',
      'Promotional',
      'Approved',
      'Fix Verify',
      '1/9/2026, 4:03:49 pm',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_RCSTemplateRecord> get _filteredTemplates {
    final query = _searchController.text.trim().toLowerCase();
    return _templates.where((template) {
      final matchesSearch =
          query.isEmpty ||
          template.name.toLowerCase().contains(query) ||
          template.message.toLowerCase().contains(query);
      final matchesStatus =
          _statusFilter == 'All statuses' || template.status == _statusFilter;
      final matchesType =
          _typeFilter == 'All types' || template.type == _typeFilter;
      return matchesSearch && matchesStatus && matchesType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 900;
    return Scaffold(
      drawer: const DashboardDrawer(
        currentPage: 'Templates',
        currentGroup: 'RCS-App',
      ),
      appBar: buildCpxBoatAppBar(context),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 700;
            return ListView(
              padding: EdgeInsets.all(compact ? 13 : 22),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Templates',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                              color: navy,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Your RCS message templates.',
                            style: TextStyle(fontSize: 12, color: muted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    FilledButton.icon(
                      onPressed: _createTemplate,
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: Text(compact ? 'New' : 'New template'),
                      style: FilledButton.styleFrom(
                        backgroundColor: panelAccent(context),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: compact ? 12 : 18,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  decoration: _cardDecoration(radius: 15),
                  padding: EdgeInsets.all(compact ? 12 : 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 5,
                        children: [
                          Icon(
                            Icons.sensors_rounded,
                            color: panelAccent(context),
                            size: 15,
                          ),
                          Text(
                            'Templates',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: navy,
                            ),
                          ),
                          Text(
                            '— Pending ones are awaiting operator and admin approval; only Approved ones can be used to send.',
                            style: TextStyle(fontSize: 11, color: muted),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 10,
                        runSpacing: 9,
                        children: [
                          SizedBox(
                            width: compact ? constraints.maxWidth - 50 : 310,
                            child: TextField(
                              controller: _searchController,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                hintText: 'Search templates...',
                                prefixIcon: const Icon(
                                  Icons.search_rounded,
                                  size: 19,
                                  color: muted,
                                ),
                                isDense: true,
                                filled: true,
                                fillColor: const Color(0xFFF8F9FC),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
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
                            width: compact
                                ? (constraints.maxWidth - 50) / 2
                                : 155,
                            child: DropdownButtonFormField<String>(
                              initialValue: _statusFilter,
                              isExpanded: true,
                              decoration: _rcsTemplateFilterDecoration(),
                              items:
                                  const [
                                        'All statuses',
                                        'Approved',
                                        'Pending',
                                        'Rejected',
                                      ]
                                      .map(
                                        (v) => DropdownMenuItem(
                                          value: v,
                                          child: Text(
                                            v,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (v) => setState(
                                () => _statusFilter = v ?? 'All statuses',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: compact
                                ? (constraints.maxWidth - 50) / 2
                                : 155,
                            child: DropdownButtonFormField<String>(
                              initialValue: _typeFilter,
                              isExpanded: true,
                              decoration: _rcsTemplateFilterDecoration(),
                              items:
                                  const [
                                        'All types',
                                        'PlainText',
                                        'RichCard',
                                        'Carousel',
                                      ]
                                      .map(
                                        (v) => DropdownMenuItem(
                                          value: v,
                                          child: Text(
                                            v,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (v) => setState(
                                () => _typeFilter = v ?? 'All types',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (compact)
                        ..._filteredTemplates.map(_mobileTemplateCard)
                      else
                        ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              horizontalMargin: 16,
                              columnSpacing: 28,
                              headingRowHeight: 43,
                              dataRowMinHeight: 66,
                              dataRowMaxHeight: 66,
                              dividerThickness: .7,
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
                                  label: SizedBox(
                                    width: 190,
                                    child: Text('Name'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: 165,
                                    child: Text('Type'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: 190,
                                    child: Text('Bot Category'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: 165,
                                    child: Text('Status'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: 195,
                                    child: Text('Message'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: 235,
                                    child: Text('Created'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: 105,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text('Actions'),
                                    ),
                                  ),
                                ),
                              ],
                              rows: _filteredTemplates
                                  .map(
                                    (template) => DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                            template.name,
                                            style: const TextStyle(
                                              color: navy,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        DataCell(Text(template.type)),
                                        DataCell(Text(template.category)),
                                        DataCell(
                                          _rcsTemplateStatus(template.status),
                                        ),
                                        DataCell(
                                          SizedBox(
                                            width: 195,
                                            child: Text(
                                              template.message,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        DataCell(Text(template.created)),
                                        DataCell(
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                tooltip: 'View',
                                                onPressed: () =>
                                                    _viewTemplate(template),
                                                icon: const Icon(
                                                  Icons.visibility_outlined,
                                                  size: 17,
                                                  color: navy,
                                                ),
                                              ),
                                              IconButton(
                                                tooltip: 'Edit',
                                                onPressed: () =>
                                                    _editTemplate(template),
                                                icon: const Icon(
                                                  Icons.edit_outlined,
                                                  size: 17,
                                                  color: navy,
                                                ),
                                              ),
                                              IconButton(
                                                tooltip: 'Delete',
                                                onPressed: () =>
                                                    _deleteTemplate(template),
                                                icon: const Icon(
                                                  Icons.delete_outline_rounded,
                                                  size: 17,
                                                  color: Color(0xFFEF4444),
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
                      if (_filteredTemplates.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(
                            child: Text(
                              'No templates match your search.',
                              style: TextStyle(color: muted),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Center(
                  child: Text(
                    '© CPXBOAT • RCS-App',
                    style: TextStyle(fontSize: 10, color: muted),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _mobileTemplateCard(_RCSTemplateRecord template) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFC),
        border: Border.all(color: const Color(0xFFE1E6EF)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  template.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: navy,
                  ),
                ),
              ),
              _rcsTemplateStatus(template.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${template.type} • ${template.category}',
            style: const TextStyle(fontSize: 12, color: muted),
          ),
          const SizedBox(height: 5),
          Text(
            template.message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: navy),
          ),
          const SizedBox(height: 5),
          Text(
            'Created ${template.created}',
            style: const TextStyle(fontSize: 10, color: muted),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                tooltip: 'View',
                onPressed: () => _viewTemplate(template),
                icon: const Icon(Icons.visibility_outlined, size: 18),
              ),
              IconButton(
                tooltip: 'Edit',
                onPressed: () => _editTemplate(template),
                icon: const Icon(Icons.edit_outlined, size: 18),
              ),
              IconButton(
                tooltip: 'Delete',
                onPressed: () => _deleteTemplate(template),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFEF4444),
                  size: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rcsTemplateStatus(String status) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: status == 'Approved'
          ? const Color(0xFFE4F8EE)
          : const Color(0xFFFFF4D6),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Text(
      status,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: status == 'Approved'
            ? const Color(0xFF07945B)
            : const Color(0xFF9A6700),
      ),
    ),
  );

  InputDecoration _rcsTemplateFilterDecoration() => InputDecoration(
    isDense: true,
    filled: true,
    fillColor: const Color(0xFFF8F9FC),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: Color(0xFFDDE3ED)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: Color(0xFFDDE3ED)),
    ),
  );

  void _viewTemplate(_RCSTemplateRecord template) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(template.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${template.type}'),
            Text('Bot Category: ${template.category}'),
            Text('Status: ${template.status}'),
            const SizedBox(height: 12),
            Text('Message: ${template.message}'),
            const SizedBox(height: 8),
            Text(
              'Created: ${template.created}',
              style: const TextStyle(fontSize: 12, color: muted),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _editTemplate(_RCSTemplateRecord template) {
    final nameController = TextEditingController(text: template.name);
    final messageController = TextEditingController(text: template.message);
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit template'),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Template name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: messageController,
                decoration: const InputDecoration(labelText: 'Message'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                setState(() {
                  template.name = nameController.text.trim();
                  template.message = messageController.text.trim();
                });
              }
              Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ).then((_) {
      nameController.dispose();
      messageController.dispose();
    });
  }

  void _deleteTemplate(_RCSTemplateRecord template) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete template?'),
        content: Text('Delete "${template.name}" from this demo list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            onPressed: () {
              setState(() => _templates.remove(template));
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _createTemplate() {
    final nameController = TextEditingController();
    final messageController = TextEditingController();
    String type = 'PlainText';
    showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('New RCS template'),
          content: SizedBox(
            width: 440,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Template name',
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: type,
                    decoration: const InputDecoration(
                      labelText: 'Template type',
                    ),
                    items: const ['PlainText', 'RichCard', 'Carousel']
                        .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                        .toList(),
                    onChanged: (v) =>
                        setDialogState(() => type = v ?? 'PlainText'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: messageController,
                    minLines: 3,
                    maxLines: 5,
                    decoration: const InputDecoration(labelText: 'Message'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isEmpty) return;
                setState(
                  () => _templates.insert(
                    0,
                    _RCSTemplateRecord(
                      name,
                      type,
                      'Promotional',
                      'Pending',
                      messageController.text.trim(),
                      '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    ),
                  ),
                );
                Navigator.pop(dialogContext);
              },
              child: const Text('Create template'),
            ),
          ],
        ),
      ),
    ).then((_) {
      nameController.dispose();
      messageController.dispose();
    });
  }
}
