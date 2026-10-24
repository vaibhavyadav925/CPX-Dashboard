part of '../app.dart';

class SMSNewTemplateScreen extends StatefulWidget {
  const SMSNewTemplateScreen({super.key, required this.onSave});

  final ValueChanged<_SMSTemplateRecord> onSave;

  @override
  State<SMSNewTemplateScreen> createState() => _SMSNewTemplateScreenState();
}

class _SMSNewTemplateScreenState extends State<SMSNewTemplateScreen> {
  final _name = TextEditingController();
  final _id = TextEditingController();
  final _sender = TextEditingController();
  final _content = TextEditingController();
  String _routeType = 'Transactional';
  final String _senderId = 'Select sender ID';
  String _category = 'Service Implicit';

  @override
  void dispose() {
    _name.dispose();
    _id.dispose();
    _sender.dispose();
    _content.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF8A94A6)),
    filled: true,
    fillColor: const Color(0xFFF8F9FC),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: const BorderSide(color: Color(0xFFD9E0EC)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: const BorderSide(color: Color(0xFFD9E0EC)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: BorderSide(color: panelAccent(context), width: 1.3),
    ),
  );

  Widget _field(String label, Widget child) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF263244),
        ),
      ),
      const SizedBox(height: 5),
      child,
    ],
  );

  Widget _select<T>(
    String label,
    T value,
    List<T> options,
    ValueChanged<T?> onChanged,
  ) => _field(
    label,
    DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      style: const TextStyle(fontSize: 12, color: Color(0xFF334155)),
      decoration: _fieldDecoration(''),
      items: options
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text('$item', overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: onChanged,
    ),
  );

  Widget _preview() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFDCE3ED)),
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
        const Text(
          'Preview',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: navy,
          ),
        ),
        const SizedBox(height: 22),
        Center(
          child: Container(
            width: 278,
            height: 558,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF171717),
              borderRadius: BorderRadius.circular(38),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x18000000),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(29),
              child: Container(
                color: const Color(0xFFFAFAFA),
                child: Column(
                  children: [
                    Container(
                      height: 25,
                      color: const Color(0xFFFAFAFA),
                      alignment: Alignment.center,
                      child: Container(
                        width: 100,
                        height: 18,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 9,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFE0E4EA)),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_back_ios_new,
                            size: 14,
                            color: Color(0xFF64748B),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 29,
                            height: 29,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE5E7EB),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 17,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _sender.text.trim().isEmpty
                                      ? 'SENDER'
                                      : _sender.text.trim(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Text(
                                  'SMS',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          constraints: const BoxConstraints(maxWidth: 205),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x08000000),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _content.text.trim().isEmpty
                                      ? 'Message content preview...'
                                      : _content.text.trim(),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    height: 1.4,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                '04:11 PM',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 4,
                      width: 86,
                      margin: const EdgeInsets.only(bottom: 5, top: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF666666),
                        borderRadius: BorderRadius.circular(4),
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
  );

  void _save() {
    if (_name.text.trim().isEmpty ||
        _id.text.trim().isEmpty ||
        _sender.text.trim().isEmpty ||
        _content.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields.')),
      );
      return;
    }
    widget.onSave(
      _SMSTemplateRecord(
        _name.text.trim(),
        _id.text.trim(),
        _sender.text.trim(),
        _category,
        _content.text.trim(),
        _routeType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 900;
    final form = Container(
      width: double.infinity,
      padding: EdgeInsets.all(wide ? 22 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDCE3ED)),
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
          const Text(
            'New SMS Template',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF263244),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Register a DLT-approved template exactly as it was approved on your DLT portal — content, template ID and sender ID must match the approved registration or the carrier will reject sends.',
            style: TextStyle(
              fontSize: 12,
              height: 1.45,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 24),
          if (wide) ...[
            Row(
              children: [
                Expanded(
                  child: _field(
                    'Template Name',
                    TextField(
                      controller: _name,
                      style: const TextStyle(fontSize: 12),
                      decoration: _fieldDecoration(''),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _field(
                    'DLT Template ID',
                    TextField(
                      controller: _id,
                      style: const TextStyle(fontSize: 12),
                      decoration: _fieldDecoration(
                        '19-digit ID from your DLT portal',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _select<String>('Route Type', _routeType, const [
                    'Transactional',
                    'Promotional',
                    'Service Implicit',
                    'Service Explicit',
                  ], (v) => setState(() => _routeType = v ?? _routeType)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _field(
                    'Sender ID',
                    TextField(
                      controller: _sender,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(fontSize: 12),
                      decoration: _fieldDecoration('Enter sender ID'),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            _field(
              'Template Name',
              TextField(
                controller: _name,
                style: const TextStyle(fontSize: 12),
                decoration: _fieldDecoration(''),
              ),
            ),
            const SizedBox(height: 14),
            _field(
              'DLT Template ID',
              TextField(
                controller: _id,
                style: const TextStyle(fontSize: 12),
                decoration: _fieldDecoration(
                  '19-digit ID from your DLT portal',
                ),
              ),
            ),
            const SizedBox(height: 14),
            _select<String>('Route Type', _routeType, const [
              'Transactional',
              'Promotional',
              'Service Implicit',
              'Service Explicit',
            ], (v) => setState(() => _routeType = v ?? _routeType)),
            const SizedBox(height: 14),
            _field(
              'Sender ID',
              TextField(
                controller: _sender,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(fontSize: 12),
                decoration: _fieldDecoration('Enter sender ID'),
              ),
            ),
          ],
          const SizedBox(height: 18),
          _select<String>('Template Category', _category, const [
            'Service Implicit',
            'Service Explicit',
            'Promotional',
            'Transactional',
          ], (v) => setState(() => _category = v ?? _category)),
          const SizedBox(height: 18),
          _field(
            'Template Content',
            TextField(
              controller: _content,
              onChanged: (_) => setState(() {}),
              minLines: 5,
              maxLines: 5,
              style: const TextStyle(fontSize: 12),
              decoration: _fieldDecoration(
                'Use {{var#}} exactly as approved on your DLT portal, e.g. Dear {{var#}}, your OTP is {{var#}}.',
              ),
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Must match the DLT-approved content character-for-character, including {{var#}} placeholders.',
            style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 15,
                  ),
                  side: const BorderSide(color: Color(0xFFD9E0EC)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(
                  backgroundColor: panelAccent(context),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: const Text('Save Template'),
              ),
            ],
          ),
        ],
      ),
    );
    return Scaffold(
      drawer: const DashboardDrawer(
        currentPage: 'Templates',
        currentGroup: 'SMS-App',
      ),
      appBar: buildCpxBoatAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(wide ? 22 : 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 18,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const Text(
                    'Templates',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '/',
                      style: TextStyle(color: Color(0xFFCBD5E1)),
                    ),
                  ),
                  const Text(
                    'New Template',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF334155),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (wide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 7, child: form),
                    const SizedBox(width: 20),
                    Expanded(flex: 2, child: _preview()),
                  ],
                )
              else
                Column(
                  children: [form, const SizedBox(height: 16), _preview()],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
