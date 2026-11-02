part of '../app.dart';

class RCSCampaignComposerScreen extends StatefulWidget {
  const RCSCampaignComposerScreen({super.key});

  @override
  State<RCSCampaignComposerScreen> createState() =>
      _RCSCampaignComposerScreenState();
}

class _RCSCampaignComposerScreenState extends State<RCSCampaignComposerScreen> {
  final TextEditingController _campaignName = TextEditingController();
  final TextEditingController _recipients = TextEditingController();
  String _mode = 'Standard';
  String _templateType = 'All types';
  String? _template;
  String _recipientMode = 'Type numbers';
  String? _recipientFileName;
  String? _contactGroup;
  String _scheduleMode = 'Send now';
  DateTime? _scheduledDate;
  TimeOfDay? _scheduledTime;

  static const _templates = <({String name, String type, String preview})>[
    (name: 'test', type: 'PlainText', preview: 'test'),
    (
      name: 'webtech_carousel',
      type: 'Carousel',
      preview: 'Explore our latest offers and updates.',
    ),
    (
      name: 'real_webtech',
      type: 'RichCard',
      preview: 'Discover Webtechage CPaaS solutions.',
    ),
    (name: 'real', type: 'RichCard', preview: 'Welcome to Webtechage CPaaS.'),
    (
      name: 'Botmtjn3dj4',
      type: 'PlainText',
      preview: 'Welcome to Webtechage CPaaS.',
    ),
    (
      name: 'Botmtjn15tl',
      type: 'PlainText',
      preview: 'Hello, welcome to Webtechage.',
    ),
    (
      name: 'new_webtech_template',
      type: 'RichCard',
      preview: 'Webtechage CPaaS Solutions.',
    ),
    (name: 'ClaudeFixTest2', type: 'RichCard', preview: 'Fix Verify'),
  ];

  static const _contactGroups = <String, int>{
    'Ajay': 10,
    'Rohit': 9,
    'testing': 2,
    'rohit testing': 1,
  };

  List<({String name, String type, String preview})> get _availableTemplates =>
      _templates.where((template) {
        final matchesType =
            _templateType == 'All types' || template.type == _templateType;
        final hasPlaceholder = RegExp(r'\[[A-Z0-9_]+\]')
            .hasMatch(template.preview);
        return matchesType && (_mode == 'Standard' || hasPlaceholder);
      }).toList();

  int get _recipientCount {
    if (_recipientMode == 'Contact group') {
      return _contactGroups[_contactGroup] ?? 0;
    }
    return _recipients.text
        .split(RegExp(r'[,\n]'))
        .map((number) => number.trim())
        .where((number) => number.isNotEmpty)
        .toSet()
        .length;
  }

  bool get _canSubmit =>
      _campaignName.text.trim().isNotEmpty &&
      _template != null &&
      _recipientCount > 0 &&
      (_scheduleMode == 'Send now' ||
          (_scheduledDate != null && _scheduledTime != null));

  @override
  void dispose() {
    _campaignName.dispose();
    _recipients.dispose();
    super.dispose();
  }

  Future<void> _pickScheduleDate() async {
    final today = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledDate ?? today,
      firstDate: DateTime(today.year, today.month, today.day),
      lastDate: DateTime(2035),
    );
    if (date != null) setState(() => _scheduledDate = date);
  }

  Future<void> _pickRecipientFile({required bool dynamic}) async {
    try {
      final file = await pickSpreadsheetFile();
      if (file == null) return;
      final numbers = spreadsheetPhoneNumbers(
        await readSpreadsheetRows(file),
        requireCountryCodeAndMsisdn: dynamic,
      );
      if (!mounted) return;
      setState(() {
        _recipients.text = numbers.join('\n');
        _recipientFileName = file.name;
      });
    } on PlatformException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not open the file picker: ${error.message ?? error.code}',
          ),
        ),
      );
    } on Exception catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not import recipients: $error')),
      );
    }
  }

  Future<void> _pickScheduleTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _scheduledTime ?? const TimeOfDay(hour: 12, minute: 0),
    );
    if (time != null) setState(() => _scheduledTime = time);
  }

  Future<void> _downloadSampleFile() => saveCsvFile(
    context,
    fileName: 'rcs_dynamic_recipients_sample',
    headers: const ['CountryCode', 'MSISDN'],
    rows: const [],
  );

  InputDecoration _decoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(fontSize: 11, color: Color(0xFF929BAA)),
    filled: true,
    fillColor: const Color(0xFFF8F9FC),
    contentPadding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFDDE3ED)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFDDE3ED)),
    ),
  );

  Widget _section({
    required String title,
    String subtitle = '',
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFDCE5F3)),
        borderRadius: BorderRadius.circular(11),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080D2B55),
            blurRadius: 4,
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
              color: navy,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(subtitle, style: const TextStyle(color: muted, fontSize: 10)),
          ],
          const SizedBox(height: 13),
          child,
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Text(
      text,
      style: const TextStyle(
        color: navy,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _segments({
    required List<String> options,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFDCE3EE)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          for (final option in options)
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () => onChanged(option),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: value == option
                        ? panelAccent(context)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    option,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: value == option ? Colors.white : muted,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _campaignDetails() {
    final templates = _availableTemplates;
    return _section(
      title: 'Campaign details',
      subtitle: _mode == 'Standard'
          ? 'Name your campaign and choose an approved template.'
          : 'Choose a template with [PLACEHOLDER] tokens to fill per-recipient from your Excel file.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Campaign name'),
          TextField(
            controller: _campaignName,
            onChanged: (_) => setState(() {}),
            decoration: _decoration('e.g. summer_sale'),
          ),
          const SizedBox(height: 11),
          _label('Template Type'),
          DropdownButtonFormField<String>(
            initialValue: _templateType,
            isExpanded: true,
            decoration: _decoration('All types'),
            items: const ['All types', 'PlainText', 'RichCard', 'Carousel']
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (type) {
              if (type == null) return;
              final updatedTemplates = _templates.where((template) {
                final matchesType =
                    type == 'All types' || template.type == type;
                final hasPlaceholder = RegExp(r'\[[A-Z0-9_]+\]')
                    .hasMatch(template.preview);
                return matchesType && (_mode == 'Standard' || hasPlaceholder);
              });
              setState(() {
                _templateType = type;
                if (!updatedTemplates.any((item) => item.name == _template)) {
                  _template = null;
                }
              });
            },
          ),
          const SizedBox(height: 11),
          _label('Template'),
          DropdownButtonFormField<String>(
            key: ValueKey('$_mode-$_templateType-$_template'),
            initialValue: templates.any((item) => item.name == _template)
                ? _template
                : null,
            isExpanded: true,
            decoration: _decoration('Select a template'),
            hint: const Text('Select a template'),
            items: templates
                .map(
                  (item) => DropdownMenuItem(
                    value: item.name,
                    child: Text(item.name, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(),
            onChanged: templates.isEmpty
                ? null
                : (template) => setState(() => _template = template),
          ),
          if (templates.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 7),
              child: Text(
                'No templates with [PLACEHOLDER] variables yet — Dynamic needs at least one.',
                style: TextStyle(color: muted, fontSize: 10),
              ),
            ),
        ],
      ),
    );
  }

  Widget _uploadArea({required bool dynamic}) => Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      if (dynamic)
        TextButton.icon(
          onPressed: _downloadSampleFile,
          icon: const Icon(Icons.download_outlined, size: 14),
          label: const Text('Download Sample File'),
        ),
      InkWell(
        onTap: () => _pickRecipientFile(dynamic: dynamic),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          height: dynamic ? 112 : 126,
          decoration: BoxDecoration(
            color: const Color(0xFFF2FAFC),
            border: Border.all(color: const Color(0xFF9DD8E4)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_upload_outlined,
                color: panelAccent(context),
                size: 26,
              ),
              const SizedBox(height: 6),
              Text(
                _recipientFileName ??
                    (dynamic ? 'Upload File' : 'Upload Excel or CSV file'),
                style: const TextStyle(
                  color: navy,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _recipientFileName == null
                    ? 'Supported formats: CSV, XLSX & XLS'
                    : '$_recipientCount recipients loaded. Tap to choose another file.',
                style: TextStyle(color: muted, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 6),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          dynamic
              ? 'Excel/CSV with CountryCode and MSISDN columns, plus a column per placeholder. Up to 3,00,000 rows.'
              : 'Excel file size should be below 50MB.',
          style: const TextStyle(color: muted, fontSize: 10),
        ),
      ),
    ],
  );

  Widget _recipientSection() {
    if (_mode == 'Dynamic') {
      return _section(
        title: 'Recipient file',
        subtitle: 'Excel/CSV with CountryCode and MSISDN columns, plus one column per placeholder.',
        child: _uploadArea(dynamic: true),
      );
    }
    return _section(
      title: 'Recipients',
      subtitle: 'Type numbers manually, upload an Excel/CSV file, or choose a saved contact group.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _segments(
            options: const ['Type numbers', 'Excel/CSV', 'Contact group'],
            value: _recipientMode,
            onChanged: (value) => setState(() => _recipientMode = value),
          ),
          const SizedBox(height: 11),
          if (_recipientMode == 'Type numbers') ...[
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: () {
                  final numbers = _recipients.text
                      .split(RegExp(r'[,\n]'))
                      .map((number) => number.trim())
                      .where((number) => number.isNotEmpty)
                      .toSet()
                      .toList();
                  final value = numbers.join('\n');
                  setState(() {
                    _recipients.value = TextEditingValue(
                      text: value,
                      selection: TextSelection.collapsed(offset: value.length),
                    );
                  });
                },
                child: const Text('Remove Duplicate Numbers'),
              ),
            ),
            TextField(
              controller: _recipients,
              minLines: 5,
              maxLines: 8,
              onChanged: (_) => setState(() {}),
              decoration: _decoration(
                'Paste numbers here, one per line or comma-separated',
              ).copyWith(alignLabelWithHint: true),
            ),
            const SizedBox(height: 6),
            const Text(
              'Country code is required for every number (e.g. 91 for India)',
              style: TextStyle(color: muted, fontSize: 10),
            ),
          ] else if (_recipientMode == 'Excel/CSV')
            _uploadArea(dynamic: false)
          else
            DropdownButtonFormField<String>(
              initialValue: _contactGroup,
              isExpanded: true,
              decoration: _decoration('Select a contact group'),
              hint: const Text('Select a contact group'),
              items: _contactGroups.entries
                  .map(
                    (entry) => DropdownMenuItem(
                      value: entry.key,
                      child: Text('${entry.key} (${entry.value} contacts)'),
                    ),
                  )
                  .toList(),
              onChanged: (group) => setState(() => _contactGroup = group),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Copy-paste supports up to 1,50,000 numbers',
                  style: TextStyle(color: muted, fontSize: 10),
                ),
              ),
              Text(
                'Total Mobile Numbers: $_recipientCount',
                style: const TextStyle(color: navy, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _schedule() => _section(
    title: 'When to send',
    child: Column(
      children: [
        _segments(
          options: const ['Send now', 'Schedule for later'],
          value: _scheduleMode,
          onChanged: (value) => setState(() => _scheduleMode = value),
        ),
        if (_scheduleMode == 'Schedule for later') ...[
          const SizedBox(height: 11),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickScheduleDate,
                  icon: const Icon(Icons.calendar_month_outlined, size: 15),
                  label: Text(
                    _scheduledDate == null
                        ? 'Select date'
                        : '${_scheduledDate!.day}/${_scheduledDate!.month}/${_scheduledDate!.year}',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickScheduleTime,
                  icon: const Icon(Icons.access_time, size: 15),
                  label: Text(_scheduledTime?.format(context) ?? 'Select time'),
                ),
              ),
            ],
          ),
        ],
      ],
    ),
  );

  Widget _preview() {
    final matches = _templates.where((item) => item.name == _template);
    final selectedTemplate = matches.isEmpty ? null : matches.first;
    return _section(
      title: 'Preview',
      subtitle: _mode == 'Dynamic'
          ? 'Placeholders shown as mapped column values.'
          : 'What recipients will see on their device.',
      child: Center(
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: const Color(0xFF101010),
            borderRadius: BorderRadius.circular(32),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 18,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: Container(
            height: 350,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: const Color(0xFFE9EDF7),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Column(
              children: [
                Container(
                  color: const Color(0xFF1473E6),
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_back, size: 15, color: Colors.white),
                      SizedBox(width: 8),
                      CircleAvatar(
                        radius: 11,
                        backgroundColor: Color(0xFF5595ED),
                        child: Icon(
                          Icons.business,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 7),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Business',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'online',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.call_outlined, size: 14, color: Colors.white),
                      SizedBox(width: 7),
                      Icon(Icons.more_vert, size: 14, color: Colors.white),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(9),
                      constraints: const BoxConstraints(maxWidth: 175),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Text(
                        selectedTemplate?.preview ??
                            'Select a template to preview it here.',
                        style: const TextStyle(
                          color: Color(0xFF667085),
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 48,
                  height: 3,
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF555555),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _form() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _segments(
        options: const ['Standard', 'Dynamic'],
        value: _mode,
        onChanged: (value) => setState(() {
          _mode = value;
          _template = null;
          if (value == 'Dynamic') _recipientMode = 'Excel/CSV';
          if (value == 'Standard' && _recipientMode == 'Excel/CSV') {
            _recipientMode = 'Type numbers';
          }
        }),
      ),
      const SizedBox(height: 13),
      _campaignDetails(),
      const SizedBox(height: 13),
      _recipientSection(),
      const SizedBox(height: 13),
      _schedule(),
      const SizedBox(height: 13),
      Align(
        alignment: Alignment.centerLeft,
        child: FilledButton(
          onPressed: _canSubmit
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _scheduleMode == 'Send now'
                            ? 'Campaign details are ready. Connect your RCS sending service to send it.'
                            : 'Schedule details are ready. Connect your RCS sending service to schedule it.',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              : null,
          style: FilledButton.styleFrom(
            backgroundColor: panelAccent(context),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
          ),
          child: Text(
            _scheduleMode == 'Send now' ? 'Send campaign' : 'Schedule campaign',
          ),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 1000;
    return Scaffold(
      appBar: buildCpxBoatAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(wide ? 22 : 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 2,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, size: 17, color: muted),
                    tooltip: 'Back to campaigns',
                  ),
                  const Text(
                    'Campaigns',
                    style: TextStyle(color: muted, fontSize: 12),
                  ),
                  Text(
                    ' / ${_mode == 'Standard' ? 'Standard' : 'Dynamic'} Campaign',
                    style: const TextStyle(
                      color: navy,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Text(
                'New RCS campaign',
                style: TextStyle(
                  color: navy,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                'Send a template message to a list of recipients, now or scheduled.',
                style: TextStyle(color: muted, fontSize: 11),
              ),
              const SizedBox(height: 15),
              if (wide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _form()),
                    const SizedBox(width: 15),
                    SizedBox(width: 270, child: _preview()),
                  ],
                )
              else ...[
                _form(),
                const SizedBox(height: 13),
                _preview(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
