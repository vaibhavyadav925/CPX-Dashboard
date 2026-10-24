part of '../app.dart';

class RCSChatbotScreen extends StatefulWidget {
  const RCSChatbotScreen({super.key});

  @override
  State<RCSChatbotScreen> createState() => _RCSChatbotScreenState();
}

class _RCSChatbotScreenState extends State<RCSChatbotScreen> {
  final _keywordController = TextEditingController();
  final _replyController = TextEditingController();
  final _suggestionController = TextEditingController();
  final List<String> _suggestions = [];
  int? _editingIndex;

  final List<_RCSChatbotReply> _replies = [
    _RCSChatbotReply(
      'FEEDBACK NO',
      'We are sorry to hear that. Our team will reach out to make things right.',
    ),
    _RCSChatbotReply(
      'FEEDBACK YES',
      'Thank you so much for the great feedback! We appreciate you.',
    ),
    _RCSChatbotReply('FEEDBACK', 'Were you satisfied with our service?'),
    _RCSChatbotReply('TEST', 'Testing works'),
    _RCSChatbotReply(
      '4',
      'Our support hours are Monday to Saturday, 9 AM to 7 PM.',
    ),
    _RCSChatbotReply(
      '3',
      'You can reach us anytime through this chat. Our team typically responds within a few hours.',
    ),
    _RCSChatbotReply(
      '2',
      'Our support team is here for you. Please describe your issue and we will assist you shortly.',
    ),
    _RCSChatbotReply(
      '1',
      'For pricing details, please share what product or service you are interested in and our team will get back to you shortly.',
    ),
    _RCSChatbotReply(
      'STOP',
      "You've been unsubscribed successfully. You will no longer receive messages from us. If you'd like to subscribe again in the future, simply reply START.",
    ),
    _RCSChatbotReply(
      'BYE',
      'Thank you for chatting with us! Have a great day.',
    ),
    _RCSChatbotReply(
      'MENU',
      'Welcome to Webtechage! How can we help you today?',
    ),
    _RCSChatbotReply(
      'INFO',
      'Please let us know what information you are looking for and we will assist you.',
    ),
    _RCSChatbotReply('OKAY', 'Great! Let us know if you need anything else.'),
    _RCSChatbotReply('OK', 'Great! Let us know if you need anything else.'),
    _RCSChatbotReply(
      'GOODBYE',
      'Thank you for chatting with us! Have a great day.',
    ),
    _RCSChatbotReply(
      'HOURS',
      'Our support hours are Monday to Saturday, 9 AM to 7 PM.',
    ),
    _RCSChatbotReply(
      'TIMING',
      'Our support hours are Monday to Saturday, 9 AM to 7 PM.',
    ),
    _RCSChatbotReply(
      'LOCATION',
      'Please share your query and our team will provide the address / location details you need.',
    ),
    _RCSChatbotReply(
      'ADDRESS',
      'Please share your query and our team will provide the address / location details you need.',
    ),
    _RCSChatbotReply(
      'CONTACT',
      'You can reach us anytime through this chat. Our team typically responds within a few hours.',
    ),
    _RCSChatbotReply(
      'SUPPORT',
      'Our support team is here for you. Please describe your issue and we will assist you shortly.',
    ),
    _RCSChatbotReply(
      'HELP',
      'We are here to help! Please tell us briefly what you need assistance with.',
    ),
    _RCSChatbotReply(
      'COST',
      'For cost details, please share what product or service you are interested in and our team will get back to you shortly.',
    ),
    _RCSChatbotReply(
      'PRICING',
      'For pricing details, please share what product or service you are interested in and our team will get back to you shortly.',
    ),
    _RCSChatbotReply(
      'PRICE',
      'For pricing details, please share what product or service you are interested in and our team will get back to you shortly.',
    ),
    _RCSChatbotReply(
      'GOOD MORNING',
      'Good morning! How can we assist you today?',
    ),
    _RCSChatbotReply(
      'HEY',
      'Welcome to Webtechage! How can we help you today?',
    ),
    _RCSChatbotReply(
      'HELLO',
      'Welcome to Webtechage! How can we help you today?',
    ),
    _RCSChatbotReply(
      'THANK YOU',
      'You are most welcome! Happy to help anytime.',
    ),
    _RCSChatbotReply('HI', 'Welcome to Webtechage! How can we help you today?'),
  ];

  @override
  void dispose() {
    _keywordController.dispose();
    _replyController.dispose();
    _suggestionController.dispose();
    super.dispose();
  }

  void _saveReply() {
    final keyword = _keywordController.text.trim();
    final reply = _replyController.text.trim();
    if (keyword.isEmpty || reply.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both trigger keyword and reply.'),
        ),
      );
      return;
    }
    setState(() {
      if (_editingIndex == null) {
        _replies.insert(0, _RCSChatbotReply(keyword.toUpperCase(), reply));
      } else {
        _replies[_editingIndex!] = _RCSChatbotReply(
          keyword.toUpperCase(),
          reply,
        );
      }
      _keywordController.clear();
      _replyController.clear();
      _suggestions.clear();
      _editingIndex = null;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Reply saved successfully.')));
  }

  void _editReply(int index) {
    setState(() {
      _editingIndex = index;
      _keywordController.text = _replies[index].keyword;
      _replyController.text = _replies[index].reply;
    });
  }

  void _addSuggestion() {
    final value = _suggestionController.text.trim();
    if (value.isEmpty) return;
    setState(() {
      _suggestions.add(value);
      _suggestionController.clear();
    });
  }

  InputDecoration _fieldDecoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF718096)),
    filled: true,
    fillColor: const Color(0xFFF8F9FC),
    contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFDDE3ED)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFDDE3ED)),
    ),
  );

  Widget _card({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(22),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFDCE2ED)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0B10213A),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DashboardDrawer(currentPage: 'Chatbot'),
      appBar: buildCpxBoatAppBar(context),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 850;
            return ListView(
              padding: EdgeInsets.fromLTRB(
                wide ? 24 : 14,
                24,
                wide ? 24 : 14,
                28,
              ),
              children: [
                const Text(
                  'Chatbot',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: navy,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Trigger keywords and their auto-replies — same library the admin panel's Chat Bot screen manages.",
                  style: TextStyle(fontSize: 12, color: muted),
                ),
                const SizedBox(height: 24),
                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add a reply',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: navy,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "When a customer's message matches this keyword, this reply (and its quick-reply chips) is available to send.",
                        style: TextStyle(fontSize: 12, color: muted),
                      ),
                      const SizedBox(height: 24),
                      if (wide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _labeledField(
                                'Trigger keyword *',
                                _keywordController,
                                'e.g. pricing',
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _labeledField(
                                'Reply *',
                                _replyController,
                                "e.g. Here's our pricing...",
                                maxLines: 1,
                              ),
                            ),
                          ],
                        )
                      else ...[
                        _labeledField(
                          'Trigger keyword *',
                          _keywordController,
                          'e.g. pricing',
                        ),
                        const SizedBox(height: 14),
                        _labeledField(
                          'Reply *',
                          _replyController,
                          "e.g. Here's our pricing...",
                          maxLines: 3,
                        ),
                      ],
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Quick-reply suggestions (optional)',
                              style: TextStyle(
                                fontSize: 12,
                                color: navy,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => showDialog<void>(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                title: const Text('Add suggestion'),
                                content: TextField(
                                  controller: _suggestionController,
                                  autofocus: true,
                                  decoration: _fieldDecoration(
                                    'Suggestion text',
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogContext),
                                    child: const Text('Cancel'),
                                  ),
                                  FilledButton(
                                    onPressed: () {
                                      _addSuggestion();
                                      Navigator.pop(dialogContext);
                                    },
                                    child: const Text('Add'),
                                  ),
                                ],
                              ),
                            ),
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text('Add suggestion'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Preview-only for now — one-to-one chatbot replies are sent as plain text, so suggestion chips saved here won't appear on the customer's phone. Buttons/chips only work on template-based campaigns.",
                        style: TextStyle(
                          fontSize: 11,
                          color: muted,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_suggestions.isEmpty)
                        const Text(
                          'No suggestion chips yet.',
                          style: TextStyle(fontSize: 11, color: muted),
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: _suggestions
                              .map(
                                (v) => InputChip(
                                  label: Text(v),
                                  onDeleted: () =>
                                      setState(() => _suggestions.remove(v)),
                                ),
                              )
                              .toList(),
                        ),
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Wrap(
                          spacing: 8,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Preview is available for saved replies.',
                                      ),
                                    ),
                                  ),
                              icon: const Icon(
                                Icons.visibility_outlined,
                                size: 16,
                              ),
                              label: const Text('Preview'),
                            ),
                            FilledButton.icon(
                              onPressed: _saveReply,
                              icon: const Icon(Icons.add, size: 17),
                              label: Text(
                                _editingIndex == null ? 'Save' : 'Update',
                              ),
                              style: FilledButton.styleFrom(
                                backgroundColor: panelAccent(context),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                _card(
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.chat_outlined,
                            color: panelAccent(context),
                            size: 17,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Saved replies',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: navy,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      ...List.generate(_replies.length, (index) {
                        final reply = _replies[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: index == _replies.length - 1
                                ? null
                                : const Border(
                                    bottom: BorderSide(
                                      color: Color(0xFFDCE2ED),
                                    ),
                                  ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 26,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Text(
                                    '${index + 1}.',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: muted,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE5F4F7),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        reply.keyword,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: panelAccent(context),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      reply.reply,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF65748B),
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                tooltip: 'View',
                                visualDensity: VisualDensity.compact,
                                onPressed: () => showDialog<void>(
                                  context: context,
                                  builder: (dialogContext) => AlertDialog(
                                    title: Text(reply.keyword),
                                    content: Text(reply.reply),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(dialogContext),
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.visibility_outlined,
                                  size: 17,
                                  color: navy,
                                ),
                              ),
                              IconButton(
                                tooltip: 'Edit',
                                visualDensity: VisualDensity.compact,
                                onPressed: () {
                                  _editReply(index);
                                  Scrollable.ensureVisible(
                                    context,
                                    duration: const Duration(milliseconds: 250),
                                    alignment: 0,
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  size: 17,
                                  color: navy,
                                ),
                              ),
                              IconButton(
                                tooltip: 'Delete',
                                visualDensity: VisualDensity.compact,
                                onPressed: () =>
                                    setState(() => _replies.removeAt(index)),
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 17,
                                  color: navy,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _labeledField(
    String label,
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return Column(
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
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: _fieldDecoration(hint),
        ),
      ],
    );
  }
}
