part of '../app.dart';

class RCSNewTemplateScreen extends StatefulWidget {
  const RCSNewTemplateScreen({super.key});
  @override
  State<RCSNewTemplateScreen> createState() => _RCSNewTemplateScreenState();
}

class _RCSNewTemplateScreenState extends State<RCSNewTemplateScreen> {
  String _type = 'Rich card';
  String _category = 'Promotional';
  String _orientation = 'Vertical';
  String _height = 'Short';
  String _width = 'Small';
  final _name = TextEditingController();
  final _message = TextEditingController();
  final _title = TextEditingController();
  final _description = TextEditingController(
    text: 'Hi [Name], your order #[OrderId] is on its way.',
  );
  final _additional = TextEditingController();
  final List<_RCSCardDraft> _cards = [_RCSCardDraft(), _RCSCardDraft()];

  @override
  void dispose() {
    _name.dispose();
    _message.dispose();
    _title.dispose();
    _description.dispose();
    _additional.dispose();
    for (final card in _cards) {
      card.dispose();
    }
    super.dispose();
  }

  InputDecoration _input(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: const Color(0xFFF8F9FC),
    contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFDDE3ED)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFDDE3ED)),
    ),
  );

  Widget _section(String title, Widget child, {String? subtitle}) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 16),
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
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: navy,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: muted)),
        ],
        const SizedBox(height: 16),
        child,
      ],
    ),
  );

  Widget _fieldLabel(String label, Widget child) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: navy,
        ),
      ),
      const SizedBox(height: 7),
      child,
    ],
  );

  Widget _typeSelector() => Row(
    children: ['Rich card', 'Carousel', 'Text only']
        .map(
          (type) => Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: FilledButton(
                onPressed: () => setState(() => _type = type),
                style: FilledButton.styleFrom(
                  backgroundColor: _type == type
                      ? const Color(0xFF0B91AD)
                      : Colors.white,
                  foregroundColor: _type == type ? Colors.white : muted,
                  elevation: 0,
                  side: const BorderSide(color: Color(0xFFDCE3ED)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: Text(type, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ),
          ),
        )
        .toList(),
  );

  Widget _preview() => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFDCE3ED)),
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
        const SizedBox(height: 16),
        Center(
          child: Container(
            width: 280,
            height: 500,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF171717),
              borderRadius: BorderRadius.circular(35),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x18000000),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(27),
              child: Column(
                children: [
                  Container(
                    height: 76,
                    color: const Color(0xFF1675E8),
                    padding: const EdgeInsets.all(12),
                    child: const Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white24,
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Your Business',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
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
                        Icon(
                          Icons.call_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.more_vert, color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: const Color(0xFFE9ECF8),
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: _type == 'Text only'
                            ? Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _message.text.isEmpty
                                      ? 'Message body...'
                                      : _message.text,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: navy,
                                  ),
                                ),
                              )
                            : _type == 'Carousel'
                            ? SizedBox(
                                height: 200,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: _cards
                                      .map(
                                        (card) => Container(
                                          width: 160,
                                          margin: const EdgeInsets.only(
                                            right: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 95,
                                                color: const Color(0xFFF1F2F5),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.image_outlined,
                                                    color: muted,
                                                    size: 28,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  9,
                                                ),
                                                child: Text(
                                                  card.title.text.isEmpty
                                                      ? 'Card title'
                                                      : card.title.text,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 9,
                                                    ),
                                                child: Text(
                                                  card.description.text.isEmpty
                                                      ? 'Card description...'
                                                      : card.description.text,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    color: muted,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              )
                            : Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: _orientation == 'Vertical'
                                          ? 140
                                          : 90,
                                      color: const Color(0xFFF1F2F5),
                                      width: double.infinity,
                                      child: const Center(
                                        child: Icon(
                                          Icons.image_outlined,
                                          color: muted,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        _title.text.isEmpty
                                            ? 'Card title'
                                            : _title.text,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Text(
                                        _description.text.isEmpty
                                            ? 'Card description...'
                                            : _description.text,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: muted,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ),
                  Container(
                    height: 5,
                    width: 75,
                    margin: const EdgeInsets.only(bottom: 7, top: 3),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _cardDraft(int index) {
    final card = _cards[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCFE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDCE3ED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Card ${index + 1}',
            style: const TextStyle(fontWeight: FontWeight.w700, color: navy),
          ),
          const SizedBox(height: 14),
          _fieldLabel(
            'Card media',
            OutlinedButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Media picker can be connected next.'),
                ),
              ),
              icon: const Icon(Icons.upload_outlined, size: 17),
              label: const Text(
                'Image (2MB) or PDF (10MB) — video isn’t supported yet',
              ),
              style: OutlinedButton.styleFrom(
                alignment: Alignment.centerLeft,
                minimumSize: const Size(double.infinity, 48),
                side: const BorderSide(color: Color(0xFFDCE3ED)),
              ),
            ),
          ),
          const SizedBox(height: 14),
          _fieldLabel(
            'Card title',
            TextField(
              controller: card.title,
              onChanged: (_) => setState(() {}),
              decoration: _input('e.g. Product A'),
            ),
          ),
          const SizedBox(height: 14),
          _fieldLabel(
            'Card description',
            TextField(
              controller: card.description,
              onChanged: (_) => setState(() {}),
              maxLines: 3,
              decoration: _input('Enter card description'),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => setState(() => card.suggestions++),
            icon: const Icon(Icons.add, size: 16),
            label: Text(
              'Add suggestion${card.suggestions == 0 ? '' : ' (${card.suggestions})'}',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 1000;
    final form = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, size: 19),
            ),
            const Text(
              'Templates',
              style: TextStyle(color: muted, fontSize: 13),
            ),
            const Text(
              '  /  New Template',
              style: TextStyle(
                color: navy,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          'New RCS template',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: navy,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Rich cards and carousels get the best engagement — a text-only fallback is also available.',
          style: TextStyle(color: muted, fontSize: 12),
        ),
        const SizedBox(height: 18),
        _section('Template type', _typeSelector()),
        _section(
          'Template details',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This name is submitted to the provider as-is — 1–20 characters, letters/numbers/underscores only.',
                style: TextStyle(color: muted, fontSize: 12),
              ),
              const SizedBox(height: 18),
              _fieldLabel(
                'Template name',
                TextField(
                  controller: _name,
                  decoration: _input('e.g. order_confirmation'),
                ),
              ),
              const SizedBox(height: 16),
              _fieldLabel(
                'Bot category',
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  isExpanded: true,
                  decoration: _input(''),
                  items: const ['Promotional', 'Transactional', 'OTP']
                      .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                      .toList(),
                  onChanged: (v) => setState(() => _category = v ?? _category),
                ),
              ),
              if (_type != 'Text only') ...[
                const SizedBox(height: 16),
                if (_type == 'Rich card') ...[
                  _fieldLabel(
                    'Orientation',
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'Vertical',
                          label: Text('Vertical'),
                        ),
                        ButtonSegment(
                          value: 'Horizontal',
                          label: Text('Horizontal'),
                        ),
                      ],
                      selected: {_orientation},
                      onSelectionChanged: (s) =>
                          setState(() => _orientation = s.first),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (_type == 'Carousel')
                  Row(
                    children: [
                      Expanded(
                        child: _fieldLabel(
                          'Card width',
                          DropdownButtonFormField<String>(
                            initialValue: _width,
                            decoration: _input(''),
                            items: const ['Small', 'Medium', 'Large']
                                .map(
                                  (v) => DropdownMenuItem(
                                    value: v,
                                    child: Text(v),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) =>
                                setState(() => _width = v ?? _width),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _fieldLabel(
                          'Card height',
                          DropdownButtonFormField<String>(
                            initialValue: _height,
                            decoration: _input(''),
                            items: const ['Short', 'Medium', 'Tall']
                                .map(
                                  (v) => DropdownMenuItem(
                                    value: v,
                                    child: Text(v),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) =>
                                setState(() => _height = v ?? _height),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ],
          ),
        ),
        if (_type == 'Text only')
          _section(
            'Message',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel(
                  'Message',
                  TextField(
                    controller: _message,
                    onChanged: (_) => setState(() {}),
                    maxLines: 5,
                    maxLength: 2000,
                    decoration: _input(
                      'Hi [Name], your order #[OrderId] has shipped!',
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      final c = _message.text;
                      final pos = c.length;
                      _message.text = '$c[Name]';
                      _message.selection = TextSelection.collapsed(
                        offset: pos + 6,
                      );
                      setState(() {});
                    },
                    icon: const Icon(Icons.add, size: 15),
                    label: const Text('Add variable'),
                  ),
                ),
              ],
            ),
          )
        else if (_type == 'Rich card')
          _section(
            'Card content',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel(
                  'Card media',
                  OutlinedButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Media picker can be connected next.'),
                      ),
                    ),
                    icon: const Icon(Icons.upload_outlined),
                    label: const Text(
                      'Image (2MB) or PDF (10MB) — video isn’t supported yet',
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _fieldLabel(
                  'Card title',
                  TextField(
                    controller: _title,
                    onChanged: (_) => setState(() {}),
                    maxLength: 120,
                    decoration: _input('e.g. Your order has shipped'),
                  ),
                ),
                const SizedBox(height: 12),
                _fieldLabel(
                  'Card description',
                  TextField(
                    controller: _description,
                    onChanged: (_) => setState(() {}),
                    maxLines: 3,
                    maxLength: 2000,
                    decoration: _input(
                      'Hi [Name], your order #[OrderId] is on its way.',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _fieldLabel(
                  'Card height',
                  DropdownButtonFormField<String>(
                    initialValue: _height,
                    decoration: _input(''),
                    items: const ['Short', 'Medium', 'Tall']
                        .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                        .toList(),
                    onChanged: (v) => setState(() => _height = v ?? _height),
                  ),
                ),
                const SizedBox(height: 12),
                _fieldLabel(
                  'Additional message (optional)',
                  TextField(
                    controller: _additional,
                    maxLines: 2,
                    decoration: _input(
                      'Sent as a follow-up text bubble below the card.',
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          _section(
            'Cards',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'At least 2 cards, each swiped through horizontally on the recipient’s phone.',
                  style: const TextStyle(color: muted, fontSize: 12),
                ),
                const SizedBox(height: 14),
                for (var i = 0; i < _cards.length; i++) _cardDraft(i),
                OutlinedButton.icon(
                  onPressed: () => setState(() => _cards.add(_RCSCardDraft())),
                  icon: const Icon(Icons.add),
                  label: const Text('Add card'),
                ),
              ],
            ),
          ),
        _section(
          'Suggestions',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Buttons shown below the message — quick replies, links, or a call action.',
                style: TextStyle(color: muted, fontSize: 12),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Suggestion editor can be connected next.'),
                  ),
                ),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add suggestion'),
              ),
            ],
          ),
        ),
        Wrap(
          spacing: 10,
          children: [
            FilledButton(
              onPressed: () {
                if (_name.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a template name.'),
                    ),
                  );
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Template form is ready. Connect your RCS provider to submit it.',
                    ),
                  ),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF0B91AD),
                foregroundColor: Colors.white,
              ),
              child: const Text('Submit template'),
            ),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ],
    );
    return Scaffold(
      drawer: const DashboardDrawer(currentPage: 'Templates'),
      appBar: buildCpxBoatAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(wide ? 22 : 13),
          child: wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 7, child: form),
                    const SizedBox(width: 20),
                    Expanded(flex: 3, child: _preview()),
                  ],
                )
              : Column(
                  children: [form, const SizedBox(height: 18), _preview()],
                ),
        ),
      ),
    );
  }
}
