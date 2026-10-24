part of '../app.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});
  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController _key = TextEditingController();
  bool _visible = false;
  bool _stepsOpen = true;

  @override
  void dispose() {
    _key.dispose();
    super.dispose();
  }

  void _showKeyDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 410,
            maxHeight: MediaQuery.of(ctx).size.height * .9,
          ),
          child: StatefulBuilder(
            builder: (ctx, refresh) => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.key_outlined, size: 19, color: navy),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Claude AI API key',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: navy,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close, size: 18),
                      ),
                    ],
                  ),
                  const Text(
                    'AI chatbots and “Generate flow with AI” run on Claude using your own Anthropic API key. Anthropic bills your own account directly for what your bots use.',
                    style: TextStyle(
                      fontSize: 11.5,
                      height: 1.45,
                      color: muted,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7E8),
                      border: Border.all(color: const Color(0xFFFFD18A)),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 16,
                          color: Color(0xFFFF9800),
                        ),
                        SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            'Not connected — AI chatbots won’t reply until you add a key',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: navy,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFD8DFEA)),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => refresh(() => _stepsOpen = !_stepsOpen),
                          child: Padding(
                            padding: const EdgeInsets.all(11),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'How to get your Claude API key (5 steps)',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: navy,
                                    ),
                                  ),
                                ),
                                Icon(
                                  _stepsOpen
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_stepsOpen) const Divider(height: 1),
                        if (_stepsOpen)
                          const Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 2),
                            child: Column(
                              children: [
                                _KeyStep(
                                  n: '1',
                                  title: 'Create an Anthropic account.',
                                  body: 'Open console.anthropic.com and sign up (or log in — a Claude subscription does not include API use).',
                                ),
                                _KeyStep(
                                  n: '2',
                                  title: 'Add credits.',
                                  body: 'Go to Settings → Billing and buy credits (start with \$5–\$10). Without credits the key won’t work.',
                                ),
                                _KeyStep(
                                  n: '3',
                                  title: 'Create the key.',
                                  body: 'Go to API Keys → Create Key, choose the Default workspace, name it e.g. “whatsapp-app”, and click Create.',
                                ),
                                _KeyStep(
                                  n: '4',
                                  title: 'Copy it.',
                                  body: 'Copy the key — it starts with sk-ant-api03-. It is shown only once.',
                                ),
                                _KeyStep(
                                  n: '5',
                                  title: 'Paste it here.',
                                  body: 'Paste it below and click Save & verify. Verification and secure storage require a backend.',
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tip: in console.anthropic.com → Settings → Limits you can set a monthly spend limit so costs never surprise you.',
                    style: TextStyle(fontSize: 10, height: 1.4, color: muted),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your Claude API key',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _key,
                    obscureText: !_visible,
                    style: const TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'sk-ant-api03-...',
                      isDense: true,
                      filled: true,
                      fillColor: const Color(0xFFF7F8FC),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () => refresh(() => _visible = !_visible),
                        icon: Icon(
                          _visible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 17,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Stored encrypted. It’s never shown again — only its last 4 characters.',
                    style: TextStyle(fontSize: 10, color: muted),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      FilledButton.icon(
                        onPressed: _key.text.trim().isEmpty
                            ? null
                            : () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Connect a secure backend to verify and save the API key.',
                                    ),
                                  ),
                                );
                              },
                        icon: const Icon(Icons.key_outlined, size: 15),
                        label: const Text(
                          'Save & verify',
                          style: TextStyle(fontSize: 11.5),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: panelAccent(context),
                          foregroundColor: Colors.white,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => showApiPendingMessage(
                          context,
                          'the external AI provider console',
                        ),
                        icon: const Icon(Icons.open_in_new, size: 13),
                        label: const Text(
                          'Open Anthropic console',
                          style: TextStyle(fontSize: 11.5),
                        ),
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    final chatPanel = Column(
      children: [
        Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFD8DFEA))),
          ),
          child: const Row(
            children: [
              Icon(Icons.chat_bubble_outline, size: 13),
              SizedBox(width: 8),
              Text('New chat', style: TextStyle(fontSize: 11)),
              Spacer(),
              Text('+ New', style: TextStyle(fontSize: 11)),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [panelAccent(context), Color(0xFF8B5CF6)],
                        ),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'How can I help you today?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: navy,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Pick a starting point, or type anything below.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, color: muted),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        _PromptCard(
                          Icons.chat_bubble_outline,
                          'WhatsApp template',
                          'Meta JSON with variables & buttons',
                        ),
                        _PromptCard(
                          Icons.sms_outlined,
                          'SMS DLT template',
                          'Under 160 chars with variables',
                        ),
                        _PromptCard(
                          Icons.sensors_rounded,
                          'RCS rich card',
                          'Title, image & suggested replies',
                        ),
                        _PromptCard(
                          Icons.hub_outlined,
                          'Chatbot flow',
                          'JSON flow chart in one click',
                        ),
                        _PromptCard(
                          Icons.campaign_outlined,
                          'Campaign message',
                          '3 catchy options',
                        ),
                        _PromptCard(
                          Icons.reply_rounded,
                          'Reply to a customer',
                          'Polite, professional reply',
                        ),
                        _PromptCard(
                          Icons.translate_rounded,
                          'Translate',
                          'Hindi & English versions',
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Fast is quick and low-cost for everyday writing. Smart gives better results for long or complex work. Always review templates before submitting them to Meta / DLT.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 9, color: muted),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xFFD8DFEA))),
          ),
          child: TextField(
            minLines: 1,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Connect your Claude API key to start',
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      drawer: const DashboardDrawer(currentPage: 'AI Assistant'),
      appBar: buildCpxBoatAppBar(context),
      body: Container(
        color: pageColor,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 12 : 20,
                14,
                isMobile ? 12 : 20,
                10,
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [panelAccent(context), Color(0xFF8B5CF6)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Assistant',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: navy,
                          ),
                        ),
                        Text(
                          'Templates, messages, chatbot flows and any question — for WhatsApp, RCS and SMS.',
                          style: TextStyle(fontSize: 11, color: muted),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  OutlinedButton.icon(
                    onPressed: _showKeyDialog,
                    icon: const Icon(Icons.key_outlined, size: 13),
                    label: Text(
                      isMobile ? 'API key' : 'AI API key',
                      style: const TextStyle(fontSize: 11),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 8,
                      ),
                      minimumSize: Size.zero,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                isMobile ? 10 : 18,
                0,
                isMobile ? 10 : 18,
                10,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7E8),
                border: Border.all(color: const Color(0xFFFFD18A)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 15,
                    color: Color(0xFFFF9800),
                  ),
                  const SizedBox(width: 7),
                  const Expanded(
                    child: Text(
                      'Connect your Claude AI API key to use the AI Assistant. Anthropic bills your own account for what you use.',
                      style: TextStyle(
                        fontSize: 10,
                        color: navy,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _showKeyDialog,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      minimumSize: Size.zero,
                    ),
                    child: const Text(
                      'Connect key',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  isMobile ? 10 : 18,
                  0,
                  isMobile ? 10 : 18,
                  10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFD8DFEA)),
                  borderRadius: BorderRadius.circular(9),
                ),
                clipBehavior: Clip.antiAlias,
                child: isMobile
                    ? chatPanel
                    : Row(
                        children: [
                          Container(
                            width: 150,
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Color(0xFFD8DFEA)),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                FilledButton.icon(
                                  onPressed: () => showApiPendingMessage(
                                    context,
                                    'AI chat creation',
                                  ),
                                  icon: const Icon(Icons.add, size: 15),
                                  label: const Text('New chat'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: panelAccent(context),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                const Text(
                                  'Your chats will appear here.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 10, color: muted),
                                ),
                              ],
                            ),
                          ),
                          Expanded(child: chatPanel),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
