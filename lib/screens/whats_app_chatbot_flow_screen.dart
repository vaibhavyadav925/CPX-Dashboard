part of '../app.dart';

class WhatsAppChatbotFlowScreen extends StatefulWidget {
  const WhatsAppChatbotFlowScreen({super.key});

  @override
  State<WhatsAppChatbotFlowScreen> createState() =>
      _WhatsAppChatbotFlowScreenState();
}

class _WhatsAppChatbotFlowScreenState extends State<WhatsAppChatbotFlowScreen> {
  Color get _teal => PanelThemeController.instance.accentColor;
  static const Color _navy = Color(0xFF17243B);
  static const Color _muted = Color(0xFF64748B);
  static const Color _line = Color(0xFFDCE3EE);
  final TextEditingController _apiKey = TextEditingController();
  final TextEditingController _botName = TextEditingController(
    text: 'Support bot',
  );
  final TextEditingController _keywords = TextEditingController(
    text: 'hi, hello, start',
  );
  bool _keyConnected = false;
  bool _showKey = false;
  bool _infoExpanded = true;
  bool _replyAny = false;
  final String _botType = 'Flow chatbot';
  final List<Map<String, dynamic>> _bots = [
    {'name': 'ydcxvd csc', 'keyword': 'Sms', 'nodes': 1, 'active': true},
    {'name': 'hi', 'keyword': 'Hi  •  Start Now', 'nodes': 10, 'active': true},
  ];

  @override
  void dispose() {
    _apiKey.dispose();
    _botName.dispose();
    _keywords.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    isDense: true,
    filled: true,
    fillColor: const Color(0xFFF8FAFD),
    contentPadding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: _line),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: _line),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: _teal),
    ),
  );

  Widget _dialogTitle(String title, BuildContext ctx) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: _navy,
          ),
        ),
      ),
      IconButton(
        onPressed: () => Navigator.pop(ctx),
        icon: const Icon(Icons.close, size: 18, color: _muted),
      ),
    ],
  );

  Future<void> _showKeyDialog() async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, refresh) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 410,
              maxHeight: MediaQuery.of(ctx).size.height * .92,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dialogTitle('Claude AI API key', ctx),
                  const Text(
                    'AI chatbots and “Generate flow with AI” run on Claude using your own Anthropic API key. Anthropic bills your account directly for what your bots use.',
                    style: TextStyle(
                      fontSize: 11.5,
                      height: 1.45,
                      color: _muted,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _keyConnected
                          ? const Color(0xFFEAF7EF)
                          : const Color(0xFFFFF7E8),
                      border: Border.all(
                        color: _keyConnected
                            ? const Color(0xFFB7E4C7)
                            : const Color(0xFFFFD18A),
                      ),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _keyConnected
                              ? Icons.check_circle_outline
                              : Icons.warning_amber_rounded,
                          size: 16,
                          color: _keyConnected
                              ? Colors.green
                              : const Color(0xFFFF9800),
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            _keyConnected
                                ? 'Connected — API key saved in this session'
                                : 'Not connected — AI chatbots won’t reply until you add a key',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _navy,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: _line),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: ExpansionTile(
                      title: const Text(
                        'How to get your Claude API key (5 steps)',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: _navy,
                        ),
                      ),
                      initiallyExpanded: true,
                      tilePadding: const EdgeInsets.symmetric(horizontal: 10),
                      childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      children: const [
                        _ChatbotKeyStep(
                          number: '1',
                          title: 'Create an Anthropic account.',
                          detail: 'Open console.anthropic.com and sign up (or log in). A Claude.ai login alone does not include API use.',
                        ),
                        _ChatbotKeyStep(
                          number: '2',
                          title: 'Add credits.',
                          detail: 'Go to Settings → Billing and buy credits. Without credits, the key may not work.',
                        ),
                        _ChatbotKeyStep(
                          number: '3',
                          title: 'Create the key.',
                          detail: 'Go to API Keys → Create Key, choose the Default workspace, name it, and click Create.',
                        ),
                        _ChatbotKeyStep(
                          number: '4',
                          title: 'Copy it.',
                          detail: 'Copy the key; it is shown only once.',
                        ),
                        _ChatbotKeyStep(
                          number: '5',
                          title: 'Paste it here.',
                          detail: 'Paste it below and click Save & verify. Keep your key private.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 13),
                  const Text(
                    'Your Claude API key',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: _navy,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _apiKey,
                    obscureText: !_showKey,
                    decoration: _inputDecoration('sk-ant-api03-...').copyWith(
                      suffixIcon: IconButton(
                        onPressed: () => refresh(() => _showKey = !_showKey),
                        icon: Icon(
                          _showKey
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'For this demo, the key is not sent to a server or stored securely.',
                    style: TextStyle(fontSize: 10, color: _muted),
                  ),
                  const SizedBox(height: 13),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _apiKey.text.trim().isEmpty
                            ? null
                            : () {
                                setState(() => _keyConnected = true);
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Key saved for this session. Server verification is not configured yet.',
                                    ),
                                  ),
                                );
                              },
                        icon: const Icon(Icons.key, size: 14),
                        label: const Text('Save & verify'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _teal,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => showApiPendingMessage(
                          context,
                          'the external AI provider console',
                        ),
                        icon: const Icon(Icons.open_in_new, size: 13),
                        label: const Text('Open Anthropic console'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showNewBotDialog() async {
    String selected = 'Flow chatbot';
    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, refresh) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _dialogTitle('New chatbot', ctx),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: _typeCard(
                          'Flow chatbot',
                          'Build the flow yourself: messages, buttons, questions.',
                          Icons.account_tree_outlined,
                          selected == 'Flow chatbot',
                          () => refresh(() => selected = 'Flow chatbot'),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: _typeCard(
                          'Generate flow with AI',
                          'Describe it, add your website / files — AI builds the flow, you edit it.',
                          Icons.auto_awesome,
                          selected == 'Generate flow with AI',
                          () =>
                              refresh(() => selected = 'Generate flow with AI'),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: _typeCard(
                          'AI chatbot',
                          'AI answers any question from your business knowledge.',
                          Icons.auto_awesome_outlined,
                          selected == 'AI chatbot',
                          () => refresh(() => selected = 'AI chatbot'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (selected == 'Generate flow with AI')
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7E8),
                        border: Border.all(color: const Color(0xFFFFD18A)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.key_outlined,
                            color: Colors.orange,
                            size: 16,
                          ),
                          const SizedBox(width: 7),
                          const Expanded(
                            child: Text(
                              'Generating a flow with AI needs your Claude API key.',
                              style: TextStyle(fontSize: 11, color: _navy),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              _showKeyDialog();
                            },
                            child: const Text('Connect key'),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    const Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: _navy,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _botName,
                      decoration: _inputDecoration('Support bot'),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Trigger keywords',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: _navy,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _keywords,
                      decoration: _inputDecoration('hi, hello, start'),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selected == 'AI chatbot'
                          ? 'Comma-separated. A matching message starts this AI chat.'
                          : 'Comma-separated. A message matching any of these starts this flow.',
                      style: const TextStyle(fontSize: 10, color: _muted),
                    ),
                    if (selected == 'AI chatbot')
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        value: _replyAny,
                        onChanged: (v) => refresh(() => _replyAny = v ?? false),
                        title: const Text(
                          'Reply to any message (no keyword needed)',
                          style: TextStyle(fontSize: 11, color: _navy),
                        ),
                        subtitle: const Text(
                          'Only one bot can do this — any other “any message” bot will be paused.',
                          style: TextStyle(fontSize: 9.5, color: _muted),
                        ),
                      ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (selected == 'AI chatbot' && !_keyConnected) {
                            Navigator.pop(ctx);
                            _showKeyDialog();
                            return;
                          }
                          setState(
                            () => _bots.add({
                              'name': _botName.text.trim().isEmpty
                                  ? 'Support bot'
                                  : _botName.text.trim(),
                              'keyword': _keywords.text.trim(),
                              'nodes': selected == 'AI chatbot' ? 1 : 1,
                              'active': true,
                            }),
                          );
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Chatbot added to this session. Connect your backend to activate it.',
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          selected == 'AI chatbot'
                              ? Icons.auto_awesome
                              : Icons.add,
                          size: 15,
                        ),
                        label: Text(
                          selected == 'AI chatbot'
                              ? 'Create AI chatbot'
                              : 'Create and open editor',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _typeCard(
    String title,
    String desc,
    IconData icon,
    bool selected,
    VoidCallback onTap,
  ) => Expanded(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF1FAFC) : Colors.white,
          border: Border.all(
            color: selected ? panelAccent(context) : _line,
            width: selected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: selected ? _teal : _muted, size: 16),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: _navy,
              ),
            ),
            const SizedBox(height: 3),
            Expanded(
              child: Text(
                desc,
                style: const TextStyle(
                  fontSize: 9.5,
                  height: 1.25,
                  color: _muted,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _sectionHeader(String title, String desc) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: _navy,
        ),
      ),
      const SizedBox(height: 3),
      Text(desc, style: const TextStyle(fontSize: 11.5, color: _muted)),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 700;
    return Scaffold(
      drawer: const DashboardDrawer(currentPage: 'Chatbot Flow'),
      appBar: buildCpxBoatAppBar(context),
      backgroundColor: const Color(0xFFF4F6FA),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(mobile ? 12 : 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _sectionHeader(
                    'Chatbot flows',
                    'Automated replies triggered by keywords in an incoming WhatsApp message — step-by-step flows, or an AI chatbot that answers from your business knowledge.',
                  ),
                ),
                if (!mobile) ...[
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: _showKeyDialog,
                    icon: const Icon(Icons.key_outlined, size: 14),
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('AI API key'),
                        const SizedBox(width: 8),
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: _keyConnected ? Colors.green : Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Import flow is not connected to a backend yet.',
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.upload_file_outlined, size: 14),
                    label: const Text('Import flow'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _showNewBotDialog,
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('New chatbot'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 13,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (mobile)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _showKeyDialog,
                      icon: const Icon(Icons.key_outlined, size: 14),
                      label: const Text('AI API key'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => ScaffoldMessenger.of(context)
                          .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Import flow is not connected to a backend yet.',
                              ),
                            ),
                          ),
                      icon: const Icon(Icons.upload_file_outlined, size: 14),
                      label: const Text('Import flow'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _showNewBotDialog,
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('New chatbot'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _teal,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3F9),
                border: Border.all(color: const Color(0xFFA8D9EA)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => setState(() => _infoExpanded = !_infoExpanded),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 13, 14, 12),
                      child: Row(
                        children: [
                          Icon(Icons.auto_awesome, color: _teal, size: 17),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AI on your WhatsApp chatbots — what it does',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: _navy,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'Connect your Claude API key to use the AI features.',
                                  style: TextStyle(fontSize: 10, color: _muted),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            _infoExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 17,
                            color: _navy,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_infoExpanded)
                    Divider(height: 1, color: const Color(0xFFA8D9EA)),
                  if (_infoExpanded)
                    Padding(
                      padding: const EdgeInsets.all(13),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LayoutBuilder(
                            builder: (context, c) {
                              final wide = c.maxWidth > 800;
                              final blocks = [
                                _infoItem(
                                  Icons.auto_awesome,
                                  'AI chatbot — answers customers for you',
                                  'Replies to your customers’ WhatsApp questions automatically, 24×7, using only your business information (Knowledge base: typed text, PDFs, website pages). It replies in the customer’s own language, including Hinglish.',
                                ),
                                _infoItem(
                                  Icons.headset_mic_outlined,
                                  'Hands over to your team',
                                  'When it can’t answer, or the customer asks for a person, it sends your handover message and moves the chat to your Inbox for an agent.',
                                ),
                                _infoItem(
                                  Icons.auto_awesome,
                                  'Generate flow with AI — builds a menu bot',
                                  'Describe your business and add website / PDFs / images — AI builds a complete step-by-step chatbot flow (welcome, menu, answers, questions, talk-to-agent) in seconds. Then you edit it in the flow builder.',
                                ),
                                _infoItem(
                                  Icons.key_outlined,
                                  'Needs your own Claude API key',
                                  'Both features run on Claude using your own API key. Anthropic bills you directly per use; you can set a monthly spend limit in the Anthropic console.',
                                ),
                                _infoItem(
                                  Icons.verified_user_outlined,
                                  'Safe by design',
                                  'It never invents prices, offers or timings that aren’t in your Knowledge base, never asks customers for OTPs or passwords, and you can pause the bot any time.',
                                ),
                              ];
                              return Wrap(
                                spacing: 16,
                                runSpacing: 13,
                                children: blocks
                                    .map(
                                      (b) => SizedBox(
                                        width: wide
                                            ? (c.maxWidth - 16) / 2
                                            : c.maxWidth,
                                        child: b,
                                      ),
                                    )
                                    .toList(),
                              );
                            },
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F9FC),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Get started in 4 steps',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w800,
                                    color: _navy,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  '1. Click “AI API key” and connect your Claude key.\n2. New chatbot → AI chatbot (or Generate flow with AI).\n3. Add your business info to the Knowledge base, write instructions, then use Test chat.\n4. Send the trigger keyword from your phone to your WhatsApp number to try it live.',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    height: 1.55,
                                    color: _muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton.icon(
                              onPressed: _showKeyDialog,
                              icon: const Icon(Icons.key_outlined, size: 14),
                              label: const Text('Connect your Claude API key'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _teal,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 13,
                                  vertical: 11,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, c) {
                final columns = c.maxWidth > 850 ? 2 : 1;
                final width = columns == 2 ? (c.maxWidth - 14) / 2 : c.maxWidth;
                return Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: _bots
                      .map(
                        (bot) => SizedBox(
                          width: width,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: _line),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x10000000),
                                  blurRadius: 3,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        bot['name'].toString(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: _navy,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${bot['nodes']}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: _navy,
                                      ),
                                    ),
                                    const SizedBox(width: 7),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE6F8EF),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Text(
                                        bot['active'] == true
                                            ? 'Active'
                                            : 'Paused',
                                        style: const TextStyle(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF18A66A),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEEF1F6),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    bot['keyword'].toString(),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: _muted,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${bot['nodes']} node${bot['nodes'] == 1 ? '' : 's'}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: _muted,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 7,
                                  runSpacing: 7,
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: () =>
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Flow editor is not connected to a backend yet.',
                                                  ),
                                                ),
                                              ),
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        size: 13,
                                      ),
                                      label: const Text('Edit flow'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: _navy,
                                        side: const BorderSide(color: _line),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 9,
                                        ),
                                      ),
                                    ),
                                    OutlinedButton.icon(
                                      onPressed: () => setState(
                                        () => bot['active'] =
                                            !(bot['active'] == true),
                                      ),
                                      icon: Icon(
                                        bot['active'] == true
                                            ? Icons.power_settings_new
                                            : Icons.play_arrow,
                                        size: 13,
                                      ),
                                      label: Text(
                                        bot['active'] == true
                                            ? 'Pause'
                                            : 'Activate',
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: _navy,
                                        side: const BorderSide(color: _line),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 9,
                                        ),
                                      ),
                                    ),
                                    OutlinedButton(
                                      onPressed: () => saveCsvFile(
                                        context,
                                        fileName:
                                            'whatsapp_chatbot_${bot['name']}_flow',
                                        headers: const [
                                          'Name',
                                          'Keyword',
                                          'Nodes',
                                          'Active',
                                        ],
                                        rows: [
                                          [
                                            bot['name'],
                                            bot['keyword'],
                                            bot['nodes'],
                                            bot['active'],
                                          ],
                                        ],
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: _navy,
                                        side: const BorderSide(color: _line),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 9,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.download_outlined,
                                        size: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    IconButton(
                                      onPressed: () =>
                                          setState(() => _bots.remove(bot)),
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        size: 17,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String title, String description) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 14, color: _teal),
      const SizedBox(width: 8),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: _navy,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              description,
              style: const TextStyle(fontSize: 10, height: 1.4, color: _muted),
            ),
          ],
        ),
      ),
    ],
  );
}
