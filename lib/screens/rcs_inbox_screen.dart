part of '../app.dart';

class RCSInboxScreen extends StatefulWidget {
  const RCSInboxScreen({super.key});

  @override
  State<RCSInboxScreen> createState() => _RCSInboxScreenState();
}

class _RCSInboxScreenState extends State<RCSInboxScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _assignment = 'Round Robin';
  String _activeFilter = 'All (170)';
  int? _selectedConversation;

  final List<Map<String, String>> _conversations = [
    {
      'number': '916000292943',
      'date': '15 Oct',
      'preview': 'STOP',
      'tag': 'anu i',
      'unread': '1',
    },
    {
      'number': '916000152642',
      'date': '14 Oct',
      'preview': 'Hi',
      'tag': 'abc abc',
      'unread': '1',
    },
    {
      'number': '916000156539',
      'date': '11 Oct',
      'preview': 'Thank You',
      'tag': 'Ajay K',
      'unread': '0',
    },
    {
      'number': '916000173618',
      'date': '09 Oct',
      'preview': 'STOP',
      'tag': 'Ajay K',
      'unread': '1',
    },
    {
      'number': '917337522120',
      'date': '08 Oct',
      'preview': 'hiii',
      'tag': 'Ajay K',
      'unread': '0',
    },
    {
      'number': '916000101294',
      'date': '08 Oct',
      'preview': "You've been unsubscribed successfully",
      'tag': 'anu i',
      'unread': '1',
    },
    {
      'number': '916000206350',
      'date': '05 Oct',
      'preview': 'Thanks',
      'tag': 'Ajay K',
      'unread': '0',
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
    final filtered = _conversations.where((c) {
      final q = _searchController.text.trim().toLowerCase();
      final matchesSearch =
          q.isEmpty ||
          c['number']!.contains(q) ||
          c['preview']!.toLowerCase().contains(q);
      final matchesFilter =
          _activeFilter.startsWith('All') ||
          (_activeFilter.startsWith('Unread') && c['unread'] == '1') ||
          (_activeFilter.startsWith('Blocked') && c['preview'] == 'STOP') ||
          _activeFilter.startsWith('Assigned');
      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      drawer: const DashboardDrawer(
        currentPage: 'Inbox',
        currentGroup: 'RCS-App',
      ),
      appBar: buildCpxBoatAppBar(context),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          compact ? 10 : 22,
          compact ? 12 : 20,
          compact ? 10 : 22,
          compact ? 10 : 18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Inbox',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF17233B),
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Replies to your RCS campaigns — CTA suggestion taps and free-text responses from customers.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF718096),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!compact) const SizedBox(width: 12),
                if (!compact)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Chat assignment',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF56647B),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 145,
                        height: 34,
                        child: DropdownButtonFormField<String>(
                          initialValue: _assignment,
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF8F9FC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFDDE3ED),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFDDE3ED),
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF27364F),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Round Robin',
                              child: Text('Round Robin'),
                            ),
                            DropdownMenuItem(
                              value: 'Parallel',
                              child: Text('Parallel'),
                            ),
                            DropdownMenuItem(
                              value: 'Manual',
                              child: Text('Manual'),
                            ),
                          ],
                          onChanged: (v) =>
                              setState(() => _assignment = v ?? 'Round Robin'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.info_outline_rounded,
                        size: 14,
                        color: Color(0xFF7C8AA1),
                      ),
                    ],
                  ),
              ],
            ),
            if (compact)
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 8),
                child: Row(
                  children: [
                    const Text(
                      'Chat assignment',
                      style: TextStyle(fontSize: 11, color: Color(0xFF56647B)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _assignment,
                        isExpanded: true,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF27364F),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Round Robin',
                            child: Text('Round Robin'),
                          ),
                          DropdownMenuItem(
                            value: 'Parallel',
                            child: Text('Parallel'),
                          ),
                          DropdownMenuItem(
                            value: 'Manual',
                            child: Text('Manual'),
                          ),
                        ],
                        onChanged: (v) =>
                            setState(() => _assignment = v ?? 'Round Robin'),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: compact ? 8 : 22),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFDCE3ED)),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x080B1224),
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Row(
                  children: [
                    SizedBox(
                      width: compact ? width - 22 : 288,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(12, 10, 12, 8),
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
                            padding: const EdgeInsets.symmetric(horizontal: 11),
                            child: SizedBox(
                              height: 34,
                              child: TextField(
                                controller: _searchController,
                                onChanged: (_) => setState(() {}),
                                style: const TextStyle(fontSize: 11),
                                decoration: InputDecoration(
                                  hintText: 'Search by number...',
                                  hintStyle: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF718096),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    size: 15,
                                    color: Color(0xFF718096),
                                  ),
                                  prefixIconConstraints: const BoxConstraints(
                                    minWidth: 30,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 9,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFD),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFDCE3ED),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFDCE3ED),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 9),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                _rcsFilterChip('All (170)'),
                                _rcsFilterChip('Unread (136)'),
                                _rcsFilterChip('Blocked (1)'),
                                _rcsFilterChip('Assigned'),
                              ],
                            ),
                          ),
                          const Divider(height: 12, color: Color(0xFFE5EAF1)),
                          Expanded(
                            child: ListView.separated(
                              itemCount: filtered.length,
                              separatorBuilder: (_, _) => const Divider(
                                height: 1,
                                indent: 54,
                                color: Color(0xFFE8EDF3),
                              ),
                              itemBuilder: (context, index) {
                                final c = filtered[index];
                                final original = _conversations.indexOf(c);
                                final selected =
                                    _selectedConversation == original;
                                return InkWell(
                                  onTap: () => setState(
                                    () => _selectedConversation = original,
                                  ),
                                  child: Container(
                                    color: selected
                                        ? const Color(0xFFF0F7FF)
                                        : Colors.white,
                                    padding: const EdgeInsets.fromLTRB(
                                      11,
                                      10,
                                      9,
                                      10,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 35,
                                          height: 35,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFE7F0FF),
                                            shape: BoxShape.circle,
                                          ),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            '9',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF1672F8),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      c['number']!,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Color(
                                                          0xFF17233B,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    c['date']!,
                                                    style: const TextStyle(
                                                      fontSize: 9,
                                                      color: Color(0xFF718096),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                c['preview']!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Color(0xFF64748B),
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Wrap(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 6,
                                                          vertical: 2,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFFEEF1F6,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      c['tag']!,
                                                      style: const TextStyle(
                                                        fontSize: 8,
                                                        color: Color(
                                                          0xFF64748B,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (c['unread'] == '1')
                                          const Padding(
                                            padding: EdgeInsets.only(
                                              left: 4,
                                              top: 15,
                                            ),
                                            child: CircleAvatar(
                                              radius: 7,
                                              backgroundColor: Color(
                                                0xFF1672F8,
                                              ),
                                              child: Text(
                                                '1',
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.white,
                                                ),
                                              ),
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
                      ),
                    ),
                    if (!compact)
                      const VerticalDivider(width: 1, color: Color(0xFFE5EAF1)),
                    if (!compact)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE7F0FF),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.chat_bubble_rounded,
                                  color: Color(0xFF1672F8),
                                  size: 27,
                                ),
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                'RCS Business Messaging',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF17233B),
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Select a conversation on the left to view CTA taps\nand replies.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  height: 1.5,
                                  color: Color(0xFF718096),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rcsFilterChip(String label) {
    final active = _activeFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: InkWell(
        onTap: () => setState(() => _activeFilter = label),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF1672F8) : const Color(0xFFEEF1F6),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: active ? Colors.white : const Color(0xFF64748B),
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
