part of '../app.dart';

class WhatsAppNewCampaignScreen extends StatefulWidget {
  const WhatsAppNewCampaignScreen({super.key});

  @override
  State<WhatsAppNewCampaignScreen> createState() =>
      _WhatsAppNewCampaignScreenState();
}

class _WhatsAppNewCampaignScreenState extends State<WhatsAppNewCampaignScreen> {
  final TextEditingController _campaignName = TextEditingController(
    text: 'Dussehra Offer',
  );
  final TextEditingController _recipients = TextEditingController();
  final TextEditingController _message = TextEditingController();
  String _mode = 'Standard';
  String _account = 'Webtechage Pvt Ltd — +1 555 944 0081 (default)';
  String _category = '';
  String _type = '';
  String _template = '';
  String _recipientMode = 'Manual';
  String _scheduleMode = 'Send now';
  bool _delay = false;
  DateTime? _scheduledDate;
  TimeOfDay? _scheduledTime;

  @override
  void dispose() {
    _campaignName.dispose();
    _recipients.dispose();
    _message.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF929BAA)),
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
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: BorderSide(color: panelAccent(context), width: 1.3),
    ),
  );

  Widget _sectionCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFDCE5F3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0D2B55),
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
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: muted)),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }

  Widget _label(String text, {bool required = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF303B50),
        ),
        children: [
          TextSpan(text: text),
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    ),
  );

  Widget _dropdown({
    required String hint,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool enabled = true,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value.isEmpty ? null : value,
      isExpanded: true,
      decoration: _fieldDecoration(hint),
      hint: Text(
        hint,
        style: const TextStyle(fontSize: 12, color: Color(0xFF929BAA)),
      ),
      items: items
          .map(
            (v) => DropdownMenuItem<String>(
              value: v,
              child: Text(
                v,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          )
          .toList(),
      onChanged: enabled ? onChanged : null,
    );
  }

  Future<void> _pickScheduleDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _scheduledDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );
    if (picked != null) setState(() => _scheduledDate = picked);
  }

  Future<void> _pickScheduleTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _scheduledTime ?? const TimeOfDay(hour: 12, minute: 0),
    );
    if (picked != null) setState(() => _scheduledTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 1050;
    final left = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionCard(
          title: 'Campaign type',
          subtitle: 'Choose how to personalize this campaign.',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _modeButton(
                'Standard',
                'Same message to a recipient list',
                Icons.checklist_rounded,
              ),
              _modeButton(
                'Dynamic',
                'Per-recipient variables via file upload',
                Icons.table_chart_outlined,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _sectionCard(
          title: 'WhatsApp number',
          subtitle: 'Which connected number should this campaign send from?',
          child: _dropdown(
            hint: 'Select WhatsApp number',
            value: _account,
            items: const [
              'Webtechage Pvt Ltd — +1 555 944 0081 (default)',
              'CPXBOAT Business — +91 98765 43210',
            ],
            onChanged: (v) => setState(() => _account = v ?? _account),
          ),
        ),
        const SizedBox(height: 18),
        _sectionCard(
          title: 'Campaign details',
          subtitle: '',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Campaign name'),
              TextField(
                controller: _campaignName,
                decoration: _fieldDecoration('Enter campaign name'),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, box) {
                  final twoColumns = box.maxWidth >= 500;
                  final width = twoColumns
                      ? (box.maxWidth - 12) / 2
                      : box.maxWidth;
                  return Wrap(
                    spacing: 12,
                    runSpacing: 14,
                    children: [
                      SizedBox(
                        width: width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Template Category', required: true),
                            _dropdown(
                              hint: 'Select Template Category',
                              value: _category,
                              items: const [
                                'Marketing',
                                'Utility',
                                'Authentication',
                              ],
                              onChanged: (v) => setState(() {
                                _category = v ?? '';
                                _type = '';
                                _template = '';
                              }),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Template Type', required: true),
                            _dropdown(
                              hint: 'Select Template Type',
                              value: _type,
                              items: const [
                                'Custom Message',
                                'Text',
                                'Image',
                                'Video',
                                'Document',
                              ],
                              enabled: _category.isNotEmpty,
                              onChanged: (v) => setState(() {
                                _type = v ?? '';
                                _template = '';
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              _label('Template'),
              _dropdown(
                hint: 'Select Template',
                value: _template,
                items: _category == 'Utility'
                    ? const ['info_update_new', 'wa_template']
                    : const [
                        'wa_template',
                        'new_one',
                        'special_offer',
                        'webtechage_campaign_launch',
                      ],
                enabled: _category.isNotEmpty && _type.isNotEmpty,
                onChanged: (v) => setState(() {
                  _template = v ?? '';
                  if (_message.text.isEmpty) {
                    _message.text = _template.isEmpty
                        ? ''
                        : 'Hello! We have an update for you.';
                  }
                }),
              ),
              if (_category.isEmpty || _type.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Please select template category and type first',
                    style: TextStyle(fontSize: 12, color: muted),
                  ),
                ),
              if (_template.isNotEmpty) ...[
                const SizedBox(height: 14),
                _label('Message body'),
                TextField(
                  controller: _message,
                  maxLines: 4,
                  decoration: _fieldDecoration('Enter the message body'),
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 18),
        _sectionCard(
          title: 'Recipients',
          subtitle:
              'Manual entry, an Excel/CSV upload, or a saved contact group.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFDCE3EE)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: ['Manual', 'Excel/CSV', 'Contact Group'].map((tab) {
                    final selected = _recipientMode == tab;
                    return Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(7),
                        onTap: () => setState(() => _recipientMode = tab),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 3,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? panelAccent(context)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            tab,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: selected ? Colors.white : muted,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 14),
              if (_recipientMode == 'Manual') ...[
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    onPressed: () {
                      final lines = _recipients.text
                          .split(RegExp(r'[,\n]'))
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toSet()
                          .toList();
                      setState(() => _recipients.text = lines.join('\n'));
                    },
                    child: const Text(
                      'Remove Duplicate Numbers',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                TextField(
                  controller: _recipients,
                  minLines: 5,
                  maxLines: 8,
                  decoration: _fieldDecoration(
                    'Paste numbers here, one per line or comma-separated',
                  ).copyWith(alignLabelWithHint: true),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Country code is required for every number (e.g. 91 for India)',
                  style: TextStyle(fontSize: 11, color: muted),
                ),
                const SizedBox(height: 3),
                Text(
                  'Copy-paste supports up to 1,50,000 numbers                                      Total Mobile Numbers: ${_recipientCount()}',
                  style: const TextStyle(fontSize: 11, color: muted),
                ),
              ] else if (_recipientMode == 'Excel/CSV') ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FC),
                    border: Border.all(color: const Color(0xFFDDE3ED)),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.upload_file_outlined,
                        size: 30,
                        color: panelAccent(context),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Upload Excel or CSV file',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: navy,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'File selection will be available when connected to a file upload service.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11, color: muted),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                _dropdown(
                  hint: 'Select contact group',
                  value: '',
                  items: const [
                    'All customers',
                    'Existing customers',
                    'New leads',
                  ],
                  onChanged: (v) => setState(() => _recipients.text = v ?? ''),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 18),
        _sectionCard(
          title: 'Schedule',
          subtitle: '',
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _scheduleButton('Send now', Icons.send_outlined),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _scheduleButton(
                      'Schedule for later',
                      Icons.schedule_rounded,
                    ),
                  ),
                ],
              ),
              if (_scheduleMode == 'Schedule for later') ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickScheduleDate,
                        icon: const Icon(
                          Icons.calendar_month_outlined,
                          size: 16,
                        ),
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
                        icon: const Icon(Icons.access_time, size: 16),
                        label: Text(
                          _scheduledTime?.format(context) ?? 'Select time',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFDCE3EE)),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: _delay,
                      onChanged: (v) => setState(() => _delay = v ?? false),
                      visualDensity: VisualDensity.compact,
                    ),
                    const Icon(Icons.timer_outlined, size: 18, color: muted),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delay between messages',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF303B50),
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Send one message at a time with a gap, instead of all numbers at once. Leave off for normal sending.',
                            style: TextStyle(fontSize: 11, color: muted),
                          ),
                        ],
                      ),
                    ),
                  ],
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
              onPressed: _canSubmit()
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _scheduleMode == 'Send now'
                                ? 'Campaign details are ready. Connect your sending service to send it.'
                                : 'Schedule details are ready. Connect your sending service to schedule it.',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  : null,
              style: FilledButton.styleFrom(
                backgroundColor: panelAccent(context),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 15,
                ),
              ),
              child: Text(
                _scheduleMode == 'Send now'
                    ? 'Send campaign'
                    : 'Schedule campaign',
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: navy)),
            ),
          ],
        ),
      ],
    );

    final preview = _previewPanel();
    return Scaffold(
      drawer: const DashboardDrawer(
        currentPage: 'Campaigns',
        currentGroup: 'WhatsApp-App',
      ),
      appBar: buildCpxBoatAppBar(context),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(constraints.maxWidth >= 1050 ? 22 : 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 18,
                          color: muted,
                        ),
                      ),
                      const Text(
                        'Campaigns',
                        style: TextStyle(
                          color: Color(0xFF53627A),
                          fontSize: 13,
                        ),
                      ),
                      const Text(
                        '  /  New Campaign',
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
                    'New campaign',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Send an approved template to a list of recipients.',
                    style: TextStyle(fontSize: 12, color: muted),
                  ),
                  const SizedBox(height: 20),
                  if (constraints.maxWidth >= 1050)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: left),
                        const SizedBox(width: 22),
                        SizedBox(width: 320, child: preview),
                      ],
                    )
                  else ...[
                    left,
                    const SizedBox(height: 18),
                    preview,
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _modeButton(String label, String description, IconData icon) {
    final selected = _mode == label;
    return InkWell(
      onTap: () => setState(() => _mode = label),
      borderRadius: BorderRadius.circular(9),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF2FAFC) : Colors.white,
          border: Border.all(
            color: selected ? panelAccent(context) : const Color(0xFFDCE3EE),
          ),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? panelAccent(context) : muted,
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected ? panelAccent(context) : muted,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              '— $description',
              style: const TextStyle(fontSize: 11, color: muted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _scheduleButton(String label, IconData icon) {
    final selected = _scheduleMode == label;
    return OutlinedButton.icon(
      onPressed: () => setState(() => _scheduleMode = label),
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: OutlinedButton.styleFrom(
        foregroundColor: selected ? panelAccent(context) : muted,
        backgroundColor: selected ? const Color(0xFFF2FAFC) : Colors.white,
        side: BorderSide(
          color: selected ? panelAccent(context) : const Color(0xFFDCE3EE),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      ),
    );
  }

  int _recipientCount() {
    if (_recipientMode == 'Contact Group') {
      return _recipients.text.isEmpty ? 0 : 1;
    }
    return _recipients.text
        .split(RegExp(r'[,\n]'))
        .where((e) => e.trim().isNotEmpty)
        .toSet()
        .length;
  }

  bool _canSubmit() =>
      _campaignName.text.trim().isNotEmpty &&
      _category.isNotEmpty &&
      _type.isNotEmpty &&
      _template.isNotEmpty &&
      _recipientCount() > 0 &&
      (_scheduleMode == 'Send now' ||
          (_scheduledDate != null && _scheduledTime != null));

  Widget _previewPanel() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Preview',
              style: TextStyle(
                fontSize: 13,
                color: muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF101010),
            borderRadius: BorderRadius.circular(38),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 24,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Container(
            height: 555,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: const Color(0xFFE9E1D7),
              borderRadius: BorderRadius.circular(29),
            ),
            child: Column(
              children: [
                Container(
                  color: const Color(0xFF075E54),
                  padding: const EdgeInsets.fromLTRB(13, 20, 13, 13),
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_back, size: 18, color: Colors.white),
                      SizedBox(width: 12),
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Color(0xFF3C8D82),
                        child: Icon(
                          Icons.business,
                          color: Colors.white,
                          size: 17,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
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
                      Icon(Icons.call_outlined, size: 17, color: Colors.white),
                      SizedBox(width: 9),
                      Icon(Icons.more_vert, size: 17, color: Colors.white),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.all(10),
                      constraints: const BoxConstraints(maxWidth: 250),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _message.text.isNotEmpty
                            ? _message.text
                            : 'Message body preview...',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6F7885),
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
        const Text(
          'Select a template to preview the message.',
          style: TextStyle(fontSize: 11, color: muted),
        ),
      ],
    );
  }
}
