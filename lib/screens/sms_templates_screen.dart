part of '../app.dart';

class SMSTemplatesScreen extends StatefulWidget {
  const SMSTemplatesScreen({super.key});

  @override
  State<SMSTemplatesScreen> createState() => _SMSTemplatesScreenState();
}

class _SMSTemplatesScreenState extends State<SMSTemplatesScreen> {
  String _category = 'All';
  String _searchText = '';
  final TextEditingController _searchController = TextEditingController();

  final List<_SMSTemplateRecord> _templates = [
    _SMSTemplateRecord(
      'campaign_broadcast_alert',
      '1207162157525953129',
      'WBTCSL',
      'Service Implicit',
      'Dear Team, {{var#}}: has been broadcasted the campaign {{var#}}, please check reports for details.',
      'Promotional',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_SMSTemplateRecord> get _filteredTemplates {
    final query = _searchText.trim().toLowerCase();
    return _templates.where((template) {
      final matchesCategory =
          _category == 'All' ||
          template.category.toLowerCase() == _category.toLowerCase();
      final matchesSearch =
          query.isEmpty ||
          template.name.toLowerCase().contains(query) ||
          template.id.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 850;
    return Scaffold(
      drawer: const DashboardDrawer(
        currentPage: 'Templates',
        currentGroup: 'SMS-App',
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
                        'Templates',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: navy,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Manage your DLT-registered SMS templates.',
                        style: TextStyle(fontSize: 12, color: muted),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton.icon(
                  onPressed: _openNewTemplatePage,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Create template'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF0B91AD),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFD9E0EC)),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _categoryButton('All'),
                      _categoryButton('Promotional'),
                      _categoryButton('Transactional'),
                    ],
                  ),
                ),
                SizedBox(
                  width: wide ? 288 : 260,
                  height: 38,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchText = value),
                    style: const TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'Search by name or template ID',
                      hintStyle: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF718096),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 17,
                        color: Color(0xFF64748B),
                      ),
                      prefixIconConstraints: const BoxConstraints(minWidth: 34),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFD),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFD9E0EC)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFD9E0EC)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            if (wide)
              _buildDesktopTable()
            else
              ..._filteredTemplates.map(_buildMobileTemplateCard),
          ],
        ),
      ),
    );
  }

  Future<void> _openNewTemplatePage() async {
    final created = await Navigator.of(context).push<_SMSTemplateRecord>(
      MaterialPageRoute(
        builder: (_) => SMSNewTemplateScreen(
          onSave: (record) => Navigator.of(context).pop(record),
        ),
      ),
    );
    if (created != null && mounted) {
      setState(() => _templates.add(created));
    }
  }

  Widget _categoryButton(String label) {
    final active = _category == label;
    return InkWell(
      onTap: () => setState(() => _category = label),
      borderRadius: BorderRadius.circular(7),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF0B91AD) : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: active ? Colors.white : const Color(0xFF334155),
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopTable() {
    final templates = _filteredTemplates;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD9E0EC)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1010192D),
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            color: const Color(0xFF0B91AD),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: const Row(
              children: [
                Expanded(flex: 3, child: _SMSTableHeader('Template Name')),
                Expanded(flex: 3, child: _SMSTableHeader('Template ID')),
                Expanded(flex: 3, child: _SMSTableHeader('Sender ID')),
                Expanded(flex: 3, child: _SMSTableHeader('Category')),
                Expanded(flex: 3, child: _SMSTableHeader('Content')),
                SizedBox(width: 64, child: _SMSTableHeader('Actions')),
              ],
            ),
          ),
          if (templates.isEmpty)
            const Padding(
              padding: EdgeInsets.all(28),
              child: Text(
                'No templates found.',
                style: TextStyle(color: muted, fontSize: 13),
              ),
            )
          else
            ...templates.map((template) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFE6EBF2))),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        template.name,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF0F172A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        template.id,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        template.senderId,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF1F6),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            template.categoryLabel,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        template.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          height: 1.45,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 64,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            tooltip: 'View template',
                            visualDensity: VisualDensity.compact,
                            onPressed: () =>
                                _showTemplateDetails(context, template),
                            icon: const Icon(
                              Icons.visibility_outlined,
                              size: 16,
                              color: Color(0xFF334155),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Delete template',
                            visualDensity: VisualDensity.compact,
                            onPressed: () =>
                                setState(() => _templates.remove(template)),
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 16,
                              color: Color(0xFFEF4444),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildMobileTemplateCard(_SMSTemplateRecord template) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            template.name,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: navy,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Template ID: ${template.id}',
            style: const TextStyle(fontSize: 11, color: muted),
          ),
          Text(
            'Sender ID: ${template.senderId}',
            style: const TextStyle(fontSize: 11, color: muted),
          ),
          const SizedBox(height: 8),
          Text(
            template.content,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: muted),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _showTemplateDetails(context, template),
                  icon: const Icon(Icons.visibility_outlined),
                ),
                IconButton(
                  onPressed: () => setState(() => _templates.remove(template)),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTemplateDetails(BuildContext context, _SMSTemplateRecord template) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Template details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${template.name}'),
            const SizedBox(height: 8),
            Text('Template ID: ${template.id}'),
            const SizedBox(height: 8),
            Text('Sender ID: ${template.senderId}'),
            const SizedBox(height: 8),
            Text('Category: ${template.categoryLabel}'),
            const SizedBox(height: 8),
            Text('Content: ${template.content}'),
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

  void _showCreateTemplateDialog(BuildContext context) {
    final nameController = TextEditingController();
    final idController = TextEditingController();
    final senderController = TextEditingController();
    final contentController = TextEditingController();
    String category = 'Promotional';

    showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Create template'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Template name',
                    ),
                  ),
                  TextField(
                    controller: idController,
                    decoration: const InputDecoration(labelText: 'Template ID'),
                  ),
                  TextField(
                    controller: senderController,
                    decoration: const InputDecoration(labelText: 'Sender ID'),
                  ),
                  DropdownButtonFormField<String>(
                    value: category,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: const [
                      DropdownMenuItem(
                        value: 'Promotional',
                        child: Text('Promotional'),
                      ),
                      DropdownMenuItem(
                        value: 'Transactional',
                        child: Text('Transactional'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => category = value);
                      }
                    },
                  ),
                  TextField(
                    controller: contentController,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Content'),
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
                if (nameController.text.trim().isEmpty ||
                    idController.text.trim().isEmpty) {
                  return;
                }
                setState(() {
                  _templates.add(
                    _SMSTemplateRecord(
                      nameController.text.trim(),
                      idController.text.trim(),
                      senderController.text.trim(),
                      'Service Implicit',
                      contentController.text.trim(),
                      category,
                    ),
                  );
                });
                Navigator.pop(dialogContext);
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    ).whenComplete(() {
      nameController.dispose();
      idController.dispose();
      senderController.dispose();
      contentController.dispose();
    });
  }
}
