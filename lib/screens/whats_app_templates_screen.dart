part of '../app.dart';

class WhatsAppTemplatesScreen extends StatefulWidget {
  const WhatsAppTemplatesScreen({super.key});

  @override
  State<WhatsAppTemplatesScreen> createState() =>
      _WhatsAppTemplatesScreenState();
}

class _WhatsAppTemplatesScreenState extends State<WhatsAppTemplatesScreen> {
  String _category = 'All';
  String _account = 'Webtechage Pvt Ltd — +1 555 944 0081';
  String _searchText = '';
  bool _creating = false;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController(
    text: 'Hi {{1}}, your order #{{2}} has shipped!',
  );
  final TextEditingController _footerController = TextEditingController();
  final TextEditingController _headerTextController = TextEditingController();

  String _language = 'English';
  String _templateCategory = 'Marketing';
  String _templateType = 'Custom Message';
  String _headerType = 'None';
  String _buttonLabel = '';

  final List<_WhatsAppTemplateRecord> _templates = [
    _WhatsAppTemplateRecord('new_one', 'Marketing', 'en', 'Approved'),
    _WhatsAppTemplateRecord('info_update_new', 'Utility', 'en', 'Approved'),
    _WhatsAppTemplateRecord('wa_template', 'Marketing', 'en', 'Approved'),
    _WhatsAppTemplateRecord('claude_lto_final', 'Marketing', 'en', 'Approved'),
    _WhatsAppTemplateRecord('webtechage', 'Marketing', 'en', 'Approved'),
    _WhatsAppTemplateRecord(
      'claude_media_preview_test',
      'Marketing',
      'en',
      'Approved',
    ),
    _WhatsAppTemplateRecord('special_offer', 'Marketing', 'en_US', 'Approved'),
    _WhatsAppTemplateRecord('test123', 'Marketing', 'en_US', 'Approved'),
    _WhatsAppTemplateRecord(
      'webtechage_campaign_launch',
      'Marketing',
      'en',
      'Approved',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _bodyController.dispose();
    _footerController.dispose();
    _headerTextController.dispose();
    super.dispose();
  }

  List<_WhatsAppTemplateRecord> get _filteredTemplates {
    final query = _searchText.trim().toLowerCase();
    return _templates.where((template) {
      final matchesCategory =
          _category == 'All' || template.category == _category;
      final matchesQuery =
          query.isEmpty || template.name.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DashboardDrawer(
        currentPage: 'Templates',
        currentGroup: 'WhatsApp-App',
      ),
      appBar: buildCpxBoatAppBar(context),
      body: SafeArea(
        child: _creating ? _buildCreateTemplatePage() : _buildTemplatesList(),
      ),
    );
  }

  Widget _buildTemplatesList() {
    final wide = MediaQuery.of(context).size.width >= 850;
    return ListView(
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
                    'Manage your WhatsApp message templates.',
                    style: TextStyle(fontSize: 12, color: muted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            FilledButton.icon(
              onPressed: () => setState(() => _creating = true),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Create template'),
              style: FilledButton.styleFrom(
                backgroundColor: panelAccent(context),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final filters = Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFDDE3ED)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: ['All', 'Marketing', 'Utility', 'Authentication']
                        .map((item) {
                          final active = _category == item;
                          return Padding(
                            padding: const EdgeInsets.only(right: 2),
                            child: TextButton(
                              onPressed: () => setState(() => _category = item),
                              style: TextButton.styleFrom(
                                backgroundColor: active
                                    ? panelAccent(context)
                                    : Colors.transparent,
                                foregroundColor: active
                                    ? Colors.white
                                    : const Color(0xFF526078),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                minimumSize: const Size(0, 36),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        })
                        .toList(),
                  ),
                ),
                SizedBox(
                  width: constraints.maxWidth > 1050
                      ? 305
                      : constraints.maxWidth,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchText = value),
                    decoration: InputDecoration(
                      hintText: 'Search templates...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
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
                  width: constraints.maxWidth > 1050
                      ? 245
                      : constraints.maxWidth,
                  child: DropdownButtonFormField<String>(
                    initialValue: _account,
                    isExpanded: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: Color(0xFFDDE3ED)),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Webtechage Pvt Ltd — +1 555 944 0081',
                        child: Text(
                          'Webtechage Pvt Ltd — +1 555 9…',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    onChanged: (value) =>
                        setState(() => _account = value ?? _account),
                  ),
                ),
              ],
            );
            return filters;
          },
        ),
        const SizedBox(height: 22),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: const Color(0xFFDCE5F3)),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              horizontalMargin: 16,
              columnSpacing: wide ? 45 : 26,
              headingRowHeight: 43,
              dataRowMinHeight: 64,
              dataRowMaxHeight: 64,
              dividerThickness: .7,
              headingRowColor: WidgetStateProperty.all(panelAccent(context)),
              headingTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              dataTextStyle: const TextStyle(color: navy, fontSize: 12),
              columns: const [
                DataColumn(label: SizedBox(width: 260, child: Text('Name'))),
                DataColumn(
                  label: SizedBox(width: 230, child: Text('Category')),
                ),
                DataColumn(
                  label: SizedBox(width: 230, child: Text('Language')),
                ),
                DataColumn(label: SizedBox(width: 230, child: Text('Status'))),
                DataColumn(
                  label: SizedBox(
                    width: 120,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text('Actions'),
                    ),
                  ),
                ),
              ],
              rows: _filteredTemplates.map((template) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        template.name,
                        style: const TextStyle(
                          color: Color(0xFF17233C),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        template.category,
                        style: const TextStyle(color: muted),
                      ),
                    ),
                    DataCell(
                      Text(
                        template.language,
                        style: const TextStyle(color: muted),
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
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          template.status,
                          style: const TextStyle(
                            color: Color(0xFF07945B),
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Refresh status',
                            onPressed: () => _message(
                              'Status refreshed for ${template.name}',
                            ),
                            icon: const Icon(Icons.sync, size: 17),
                          ),
                          IconButton(
                            tooltip: 'Preview',
                            onPressed: () => _showTemplatePreview(template),
                            icon: const Icon(
                              Icons.visibility_outlined,
                              size: 17,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Edit',
                            onPressed: () {
                              _nameController.text = template.name;
                              _templateCategory = template.category;
                              _language = template.language == 'en_US'
                                  ? 'English (US)'
                                  : 'English';
                              setState(() => _creating = true);
                            },
                            icon: const Icon(Icons.edit_outlined, size: 17),
                          ),
                          IconButton(
                            tooltip: 'Delete',
                            onPressed: () => _confirmDelete(template),
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Color(0xFFFF4D55),
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
      ],
    );
  }

  Widget _buildCreateTemplatePage() {
    final wide = MediaQuery.of(context).size.width >= 1000;
    final form = ListView(
      padding: EdgeInsets.all(wide ? 22 : 13),
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => setState(() => _creating = false),
              icon: const Icon(Icons.arrow_back, size: 20),
            ),
            const Text(
              'Templates',
              style: TextStyle(color: muted, fontSize: 13),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('/', style: TextStyle(color: muted)),
            ),
            const Text(
              'New Template',
              style: TextStyle(
                color: navy,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Create template',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: navy,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Standard, Carousel, and Authentication templates are all supported.',
          style: TextStyle(fontSize: 12, color: muted),
        ),
        const SizedBox(height: 20),
        _templateSection(
          title: 'WhatsApp number',
          subtitle:
              'Which connected number should this template be created under?',
          child: DropdownButtonFormField<String>(
            initialValue: _account,
            isExpanded: true,
            decoration: _templateInputDecoration(),
            items: const [
              DropdownMenuItem(
                value: 'Webtechage Pvt Ltd — +1 555 944 0081',
                child: Text('Webtechage Pvt Ltd — +1 555 944 0081 (default)'),
              ),
            ],
            onChanged: (value) => setState(() => _account = value ?? _account),
          ),
        ),
        const SizedBox(height: 18),
        _templateSection(
          title: 'Basics',
          child: LayoutBuilder(
            builder: (context, constraints) {
              final twoColumns = constraints.maxWidth >= 560;
              final fieldWidth = twoColumns
                  ? (constraints.maxWidth - 14) / 2
                  : constraints.maxWidth;
              return Wrap(
                spacing: 14,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: fieldWidth,
                    child: _labeledField(
                      'Template name',
                      TextField(
                        controller: _nameController,
                        decoration: _templateInputDecoration(
                          hint: 'order_confirmation',
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: _labeledField(
                      'Language',
                      DropdownButtonFormField<String>(
                        initialValue: _language,
                        isExpanded: true,
                        decoration: _templateInputDecoration(),
                        items:
                            const [
                                  'English',
                                  'English (US)',
                                  'Hindi',
                                  'Spanish',
                                  'French',
                                  'Portuguese',
                                ]
                                .map(
                                  (v) => DropdownMenuItem(
                                    value: v,
                                    child: Text(v),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) =>
                            setState(() => _language = v ?? _language),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: _labeledField(
                      'Template Category',
                      DropdownButtonFormField<String>(
                        initialValue: _templateCategory,
                        isExpanded: true,
                        decoration: _templateInputDecoration(),
                        items: const ['Marketing', 'Utility', 'Authentication']
                            .map(
                              (v) => DropdownMenuItem(value: v, child: Text(v)),
                            )
                            .toList(),
                        onChanged: (v) => setState(
                          () => _templateCategory = v ?? _templateCategory,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: _labeledField(
                      'Template Type',
                      DropdownButtonFormField<String>(
                        initialValue: _templateType,
                        isExpanded: true,
                        decoration: _templateInputDecoration(),
                        items:
                            const [
                                  'Custom Message',
                                  'Standard',
                                  'Carousel',
                                  'Authentication',
                                ]
                                .map(
                                  (v) => DropdownMenuItem(
                                    value: v,
                                    child: Text(v),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) =>
                            setState(() => _templateType = v ?? _templateType),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 18),
        _templateSection(
          title: 'Header',
          subtitle: 'Optional. Text, image, video, or document.',
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                initialValue: _headerType,
                isExpanded: true,
                decoration: _templateInputDecoration(),
                items: const ['None', 'Text', 'Image', 'Video', 'Document']
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: (v) =>
                    setState(() => _headerType = v ?? _headerType),
              ),
              if (_headerType == 'Text') ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _headerTextController,
                  onChanged: (_) => setState(() {}),
                  decoration: _templateInputDecoration(hint: 'Header text'),
                ),
              ],
              if (['Image', 'Video', 'Document'].contains(_headerType)) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _message(
                    'Connect a media upload service to attach a $_headerType.',
                  ),
                  icon: const Icon(Icons.upload_file),
                  label: Text('Upload $_headerType'),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 18),
        _templateSection(
          title: 'Body',
          subtitle: 'Use {{1}}, {{2}}, etc. for variables — filled in per-campaign when you send.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F5F8),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  'We recommend keeping your message within 550 characters and using up to 10 emojis to align with Meta’s latest approval guidelines.',
                  style: TextStyle(color: panelAccent(context), fontSize: 12),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _bodyController,
                minLines: 5,
                maxLines: 8,
                onChanged: (_) => setState(() {}),
                decoration: _templateInputDecoration(
                  hint: 'Write your message body...',
                ).copyWith(alignLabelWithHint: true),
              ),
              const SizedBox(height: 14),
              _labeledField(
                'Footer (optional)',
                TextField(
                  controller: _footerController,
                  onChanged: (_) => setState(() {}),
                  decoration: _templateInputDecoration(hint: 'Footer text'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _templateSection(
          title: 'Buttons',
          subtitle: 'Up to 2 URL buttons, 1 phone number button, and 10 quick reply buttons — or a single Flow button on its own.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_buttonLabel.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(text: _buttonLabel),
                          onChanged: (v) => setState(() => _buttonLabel = v),
                          decoration: _templateInputDecoration(
                            hint: 'Button label',
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => setState(() => _buttonLabel = ''),
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              OutlinedButton.icon(
                onPressed: () => setState(
                  () =>
                      _buttonLabel = _buttonLabel.isEmpty ? 'Quick reply' : '',
                ),
                icon: const Icon(Icons.add, size: 17),
                label: Text(
                  _buttonLabel.isEmpty ? 'Add button' : 'Remove button',
                ),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            FilledButton(
              onPressed: _submitTemplate,
              style: FilledButton.styleFrom(
                backgroundColor: panelAccent(context),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Submit for review'),
            ),
            TextButton(
              onPressed: () => setState(() => _creating = false),
              child: const Text('Cancel', style: TextStyle(color: navy)),
            ),
          ],
        ),
      ],
    );

    if (!wide) {
      return form;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(flex: 7, child: form),
        Container(
          width: 340,
          color: const Color(0xFFF3F5FA),
          padding: const EdgeInsets.fromLTRB(8, 34, 18, 18),
          child: _phonePreview(),
        ),
      ],
    );
  }

  Widget _phonePreview() {
    final body = _bodyController.text.trim().isEmpty
        ? 'Message body preview...'
        : _bodyController.text;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Live preview',
            style: TextStyle(
              color: muted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 286,
          height: 540,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF171717),
            borderRadius: BorderRadius.circular(42),
            boxShadow: const [
              BoxShadow(
                color: Color(0x16000000),
                blurRadius: 18,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Column(
              children: [
                Container(
                  height: 68,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  color: const Color(0xFF075E54),
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_back, color: Colors.white, size: 18),
                      SizedBox(width: 12),
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Color(0xFF128C7E),
                        child: Icon(
                          Icons.storefront,
                          color: Colors.white,
                          size: 17,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Business',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'online',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.call_outlined, color: Colors.white, size: 17),
                      SizedBox(width: 8),
                      Icon(Icons.more_vert, color: Colors.white, size: 17),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: const Color(0xFFE8DED2),
                    padding: const EdgeInsets.all(12),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 230),
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_headerType == 'Text' &&
                                _headerTextController.text.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  _headerTextController.text,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            if (_headerType != 'None' && _headerType != 'Text')
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Icon(
                                  _headerType == 'Image'
                                      ? Icons.image_outlined
                                      : _headerType == 'Video'
                                      ? Icons.videocam_outlined
                                      : Icons.description_outlined,
                                  color: muted,
                                  size: 32,
                                ),
                              ),
                            Text(
                              body,
                              style: const TextStyle(
                                color: Color(0xFF344054),
                                fontSize: 12,
                              ),
                            ),
                            if (_footerController.text.trim().isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  _footerController.text,
                                  style: const TextStyle(
                                    color: muted,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            if (_buttonLabel.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Center(
                                  child: Text(
                                    _buttonLabel,
                                    style: const TextStyle(
                                      color: Color(0xFF168DCE),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            const Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                '02:45 PM',
                                style: TextStyle(color: muted, fontSize: 9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => _message('Update your business profile details.'),
          icon: const Icon(Icons.business_outlined, size: 14),
          label: const Text(
            'Update your business profile details',
            style: TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }

  Widget _templateSection({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDCE2ED)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: navy,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: muted)),
          ],
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }

  Widget _labeledField(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: navy,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  InputDecoration _templateInputDecoration({String? hint}) => InputDecoration(
    hintText: hint,
    isDense: true,
    filled: true,
    fillColor: const Color(0xFFF8F9FC),
    contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: Color(0xFFDDE3ED)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: Color(0xFFDDE3ED)),
    ),
  );

  void _submitTemplate() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _message('Please enter a template name.');
      return;
    }
    setState(() {
      final languageCode = _language == 'English (US)'
          ? 'en_US'
          : _language == 'Hindi'
          ? 'hi'
          : _language == 'Spanish'
          ? 'es'
          : _language == 'French'
          ? 'fr'
          : _language == 'Portuguese'
          ? 'pt'
          : 'en';
      _templates.removeWhere((template) => template.name == name);
      _templates.insert(
        0,
        _WhatsAppTemplateRecord(
          name,
          _templateCategory,
          languageCode,
          'Pending',
        ),
      );
      _category = 'All';
      _searchText = '';
      _searchController.clear();
      _creating = false;
    });
    _message(
      'Template added locally. Connect your WhatsApp Business API to submit it for review.',
    );
  }

  void _showTemplatePreview(_WhatsAppTemplateRecord template) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(template.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${template.category}'),
            const SizedBox(height: 6),
            Text('Language: ${template.language}'),
            const SizedBox(height: 6),
            Text('Status: ${template.status}'),
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

  void _confirmDelete(_WhatsAppTemplateRecord template) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete template?'),
        content: Text(
          'Do you want to remove "${template.name}" from this local preview?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _templates.remove(template));
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _message(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
