part of '../app.dart';

class WhatsAppInboxScreen extends StatefulWidget {
  const WhatsAppInboxScreen({super.key});

  @override
  State<WhatsAppInboxScreen> createState() => _WhatsAppInboxScreenState();
}

class _WhatsAppInboxScreenState extends State<WhatsAppInboxScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _assignment = 'Parallel';
  String _activeFilter = 'All (8)';
  String _activeTag = 'Any tag (8)';
  int? _selectedConversation;

  final List<Map<String, String>> _conversations = [
    {
      'name': 'ajaykalakoti34 😍',
      'date': '12/10/26',
      'preview': 'Template',
      'tag': 'Ajay K',
      'initial': 'A',
      'status': 'All',
    },
    {
      'name': '🔒 Real Parity Test',
      'date': '21/09/26',
      'preview': '[BUTTON]',
      'tag': 'Ajay K',
      'initial': 'R',
      'status': 'Blocked',
    },
    {
      'name': 'Vijay Rathnam',
      'date': '14/09/26',
      'preview': '[BUTTON]',
      'tag': 'abc abc',
      'initial': 'V',
      'status': 'All',
    },
    {
      'name': 'Javed Khan',
      'date': '09/09/26',
      'preview': '[BUTTON]',
      'tag': 'xxzz z xz zx',
      'initial': 'J',
      'status': 'Assigned',
    },
    {
      'name': 'Mukesh Yadav',
      'date': '05/09/26',
      'preview': 'Document',
      'tag': 'xxzz z xz zx',
      'initial': 'M',
      'status': 'All',
    },
    {
      'name': 'G S B Broadband',
      'date': '04/09/26',
      'preview': 'Thank you for contacting GSB Broad B...',
      'tag': 'Ajay K',
      'initial': 'G',
      'status': 'All',
    },
    {
      'name': 'हर हर कृष्णा 🙏🌸✨',
      'date': '03/09/26',
      'preview': 'आज की Work Report – 3 September 20...',
      'tag': 'xxzz z xz zx',
      'initial': 'ह',
      'status': 'All',
    },
    {
      'name': 'Priya Sharma',
      'date': '02/09/26',
      'preview': 'Hello, I need some information',
      'tag': 'Warm Lead',
      'initial': 'P',
      'status': 'Unread',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 760;
    final filtered = _conversations.where((conversation) {
      final query = _searchController.text.trim().toLowerCase();
      final matchesQuery =
          query.isEmpty ||
          conversation['name']!.toLowerCase().contains(query) ||
          conversation['preview']!.toLowerCase().contains(query);
      final matchesFilter =
          _activeFilter == 'All (8)' ||
          (_activeFilter.startsWith('Blocked') &&
              conversation['status'] == 'Blocked') ||
          (_activeFilter.startsWith('Assigned') &&
              conversation['status'] == 'Assigned') ||
          (_activeFilter.startsWith('Unread') &&
              conversation['status'] == 'Unread');
      return matchesQuery && matchesFilter;
    }).toList();

    return Scaffold(
      drawer: const DashboardDrawer(
        currentPage: 'Inbox',
        currentGroup: 'WhatsApp-App',
      ),
      appBar: buildCpxBoatAppBar(context),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          compact ? 8 : 20,
          compact ? 8 : 20,
          compact ? 8 : 20,
          compact ? 8 : 18,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFDCE3ED)),
            borderRadius: BorderRadius.circular(14),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFFFCFCFE),
                  border: Border(bottom: BorderSide(color: Color(0xFFE3E8F0))),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Chat assignment',
                      style: TextStyle(fontSize: 11, color: Color(0xFF56647B)),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 132,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _assignment,
                          isDense: true,
                          isExpanded: true,
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF27364F),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Parallel',
                              child: Text('Parallel'),
                            ),
                            DropdownMenuItem(
                              value: 'Round robin',
                              child: Text('Round robin'),
                            ),
                            DropdownMenuItem(
                              value: 'Manual',
                              child: Text('Manual'),
                            ),
                          ],
                          onChanged: (value) =>
                              setState(() => _assignment = value ?? 'Parallel'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 14,
                      color: Color(0xFF7C8AA1),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: compact ? width - 34 : 264,
                      child: _buildConversationList(filtered, compact),
                    ),
                    if (!compact) ...[
                      const VerticalDivider(width: 1, color: Color(0xFFE0E6EF)),
                      Expanded(child: _buildConversationPane()),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConversationList(
    List<Map<String, String>> conversations,
    bool compact,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 7),
          child: Text(
            'Inbox',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF17233B),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            height: 31,
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(fontSize: 11),
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                hintStyle: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF718096),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 15,
                  color: Color(0xFF718096),
                ),
                prefixIconConstraints: const BoxConstraints(minWidth: 29),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                filled: true,
                fillColor: const Color(0xFFF8FAFD),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: const BorderSide(color: Color(0xFFDCE3ED)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: const BorderSide(color: Color(0xFFDCE3ED)),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 9),
          child: Row(
            children: [
              _filterChip('All (8)'),
              _filterChip('Unread (0)'),
              _filterChip('Blocked (1)'),
              _filterChip('Assigned (8)'),
            ],
          ),
        ),
        const SizedBox(height: 7),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 9),
          child: Row(
            children: [
              const Icon(
                Icons.sell_outlined,
                size: 12,
                color: Color(0xFF718096),
              ),
              const SizedBox(width: 4),
              _tagChip('Any tag (8)'),
              _tagChip('Hot Lead (3)'),
              _tagChip('Warm Lead (1)'),
            ],
          ),
        ),
        const SizedBox(height: 7),
        const Divider(height: 1, color: Color(0xFFE5EAF1)),
        Expanded(
          child: conversations.isEmpty
              ? const Center(
                  child: Text(
                    'No conversations found',
                    style: TextStyle(fontSize: 11, color: muted),
                  ),
                )
              : ListView.separated(
                  itemCount: conversations.length,
                  separatorBuilder: (_, _) => const Divider(
                    height: 1,
                    indent: 54,
                    color: Color(0xFFE8EDF3),
                  ),
                  itemBuilder: (context, index) {
                    final item = conversations[index];
                    final originalIndex = _conversations.indexOf(item);
                    final selected = _selectedConversation == originalIndex;
                    return InkWell(
                      onTap: () {
                        setState(() => _selectedConversation = originalIndex);
                        if (compact) {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  _MobileWhatsAppChatScreen(conversation: item),
                            ),
                          );
                        }
                      },
                      child: Container(
                        color: selected
                            ? const Color(0xFFF0FAFC)
                            : Colors.white,
                        padding: const EdgeInsets.fromLTRB(10, 9, 8, 9),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE5F4F6),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                item['initial']!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: panelAccent(context),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 9),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item['name']!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF1D2A42),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        item['date']!,
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: Color(0xFF77859A),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    item['preview']!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF0F3F8),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      item['tag']!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 8,
                                        color: Color(0xFF607087),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _filterChip(String label) {
    final active = _activeFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _activeFilter = label),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: active ? panelAccent(context) : const Color(0xFFF0F3F8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: active ? Colors.white : const Color(0xFF59677D),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _tagChip(String label) {
    final active = _activeTag == label;
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _activeTag = label),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: active ? panelAccent(context) : const Color(0xFFF0F3F8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: active ? Colors.white : const Color(0xFF59677D),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConversationPane() {
    if (_selectedConversation != null) {
      final item = _conversations[_selectedConversation!];
      return Column(
        children: [
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE5EAF1))),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: const Color(0xFFE5F4F6),
                  child: Text(
                    item['initial']!,
                    style: TextStyle(color: panelAccent(context), fontSize: 12),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item['name']!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: navy,
                    ),
                  ),
                ),
                const Icon(Icons.more_horiz, color: muted),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 35,
                    color: Color(0xFFB8DCDD),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item['preview']!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Conversation preview',
                    style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: const BoxDecoration(
              color: Color(0xFFE7F0EF),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.chat, color: Color(0xFF25B75A), size: 26),
          ),
          const SizedBox(height: 12),
          const Text(
            'WhatsApp Business Inbox',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF26344B),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Select a conversation on the left to view and reply\nto messages.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              height: 1.45,
              color: Color(0xFF718096),
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileWhatsAppChatScreen extends StatelessWidget {
  final Map<String, String> conversation;
  const _MobileWhatsAppChatScreen({required this.conversation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCpxBoatAppBar(context),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 38,
              color: Color(0xFFB8DCDD),
            ),
            const SizedBox(height: 12),
            Text(
              conversation['preview']!,
              style: const TextStyle(color: muted, fontSize: 12),
            ),
            const SizedBox(height: 5),
            const Text(
              'Conversation preview',
              style: TextStyle(color: muted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
