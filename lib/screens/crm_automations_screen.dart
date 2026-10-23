part of '../app.dart';

class CRMAutomationsScreen extends StatefulWidget {
  const CRMAutomationsScreen({super.key});

  @override
  State<CRMAutomationsScreen> createState() => _CRMAutomationsScreenState();
}

class _CRMAutomationsScreenState extends State<CRMAutomationsScreen> {
  static const Color _ink = Color(0xFF17243B);
  static const Color _muted = Color(0xFF667892);
  static const Color _teal = Color(0xFF0B91AD);
  static const Color _line = Color(0xFFDCE3EE);
  static const Color _canvas = Color(0xFFF4F6FB);

  final List<Map<String, dynamic>> _automations = [
    {
      'name': 'Live test — WhatsApp + SMS + RCS (Claude)',
      'subtitle': 'New lead · Live Test Only · WhatsApp, SMS, RCS',
      'status': 'Draft',
      'enrolled': '1',
      'running': '0',
      'replies': '0',
      'converted': '0',
    },
    {
      'name': 'Live test — SMS + RCS (Claude)',
      'subtitle': 'New lead · Live Test Only · SMS, RCS',
      'status': 'Draft',
      'enrolled': '1',
      'running': '0',
      'replies': '0',
      'converted': '1',
    },
  ];

  Widget _card({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(14),
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A17243B),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }

  void _showNewAutomationDialog() {
    final nameController = TextEditingController();
    String selectedTemplate = 'Blank journey';

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Widget templateOption(String title, String description) {
              final selected = selectedTemplate == title;
              return InkWell(
                onTap: () => setDialogState(() => selectedTemplate = title),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFFF1FAFC) : Colors.white,
                    border: Border.all(
                      color: selected ? _teal : _line,
                      width: selected ? 1.5 : 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.route_outlined,
                        color: selected ? _teal : _muted,
                        size: 16,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 12,
                                color: _ink,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              description,
                              style: const TextStyle(
                                fontSize: 10,
                                color: _muted,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 18, 22, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'New automation',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: _ink,
                              ),
                            ),
                          ),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () => Navigator.pop(dialogContext),
                            icon: const Icon(
                              Icons.close,
                              size: 18,
                              color: _muted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Name',
                        style: TextStyle(fontSize: 12, color: _ink),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'e.g. Facebook leads follow-up',
                          hintStyle: const TextStyle(
                            fontSize: 12,
                            color: _muted,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 12,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8F9FC),
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
                            borderSide: const BorderSide(
                              color: _teal,
                              width: 1.4,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Start from',
                        style: TextStyle(fontSize: 12, color: _ink),
                      ),
                      const SizedBox(height: 7),
                      templateOption(
                        'Blank journey',
                        'Just a trigger — build your own steps.',
                      ),
                      templateOption(
                        '7-day lead follow-up',
                        'Welcome → read / not-read branches → reminders over 7 days; a reply assigns sales and stops. (From the SRS.)',
                      ),
                      templateOption(
                        'Welcome + 1 reminder',
                        'Welcome message; reply → assign sales; no reply in 24 h → one reminder.',
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: FilledButton.icon(
                          onPressed: () {
                            final name = nameController.text.trim();
                            if (name.isEmpty) {
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please enter an automation name.',
                                  ),
                                ),
                              );
                              return;
                            }
                            setState(() {
                              _automations.insert(0, {
                                'name': name,
                                'subtitle':
                                    'New lead · ${selectedTemplate == 'Blank journey' ? 'Blank journey' : selectedTemplate}',
                                'status': 'Draft',
                                'enrolled': '0',
                                'running': '0',
                                'replies': '0',
                                'converted': '0',
                              });
                            });
                            Navigator.pop(dialogContext);
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              const SnackBar(
                                content: Text('Automation created as a draft.'),
                              ),
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: _teal,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.add, size: 17),
                          label: const Text(
                            'Create and open builder',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(nameController.dispose);
  }

  Widget _metric(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: _canvas,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          children: [
            Icon(icon, size: 13, color: _muted),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: _ink,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: _muted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 850;
    return Scaffold(
      backgroundColor: _canvas,
      drawer: const DashboardDrawer(currentPage: 'Automations'),
      appBar: buildCpxBoatAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(wide ? 22 : 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE4F5F8),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.account_tree_outlined,
                    color: _teal,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 11),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Automations',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: _ink,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Customer journeys that follow up leads automatically — WhatsApp messages, waits, read/reply branches, sales hand-off.',
                          style: TextStyle(
                            fontSize: 11,
                            color: _muted,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (wide) const SizedBox(width: 12),
                if (wide)
                  FilledButton.icon(
                    onPressed: _showNewAutomationDialog,
                    style: FilledButton.styleFrom(
                      backgroundColor: _teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text(
                      'New automation',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            if (!wide) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _showNewAutomationDialog,
                  style: FilledButton.styleFrom(
                    backgroundColor: _teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('New automation'),
                ),
              ),
            ],
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 760 ? 2 : 1;
                final gap = 12.0;
                final cardWidth =
                    (constraints.maxWidth - gap * (columns - 1)) / columns;
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: _automations.map((automation) {
                    return SizedBox(
                      width: cardWidth,
                      child: _card(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE4F5F8),
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  child: const Icon(
                                    Icons.account_tree_outlined,
                                    size: 18,
                                    color: _teal,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        automation['name'] as String,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: _ink,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.bolt,
                                            size: 11,
                                            color: _muted,
                                          ),
                                          const SizedBox(width: 3),
                                          Expanded(
                                            child: Text(
                                              automation['subtitle'] as String,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: _muted,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0F2F7),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    automation['status'] as String,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: _muted,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 13),
                            Row(
                              children: [
                                _metric(
                                  'Enrolled',
                                  automation['enrolled'] as String,
                                  Icons.people_outline,
                                ),
                                const SizedBox(width: 7),
                                _metric(
                                  'Running',
                                  automation['running'] as String,
                                  Icons.account_tree_outlined,
                                ),
                                const SizedBox(width: 7),
                                _metric(
                                  'Replies',
                                  automation['replies'] as String,
                                  Icons.reply,
                                ),
                                const SizedBox(width: 7),
                                _metric(
                                  'Converted',
                                  automation['converted'] as String,
                                  Icons.emoji_events_outlined,
                                ),
                              ],
                            ),
                            const SizedBox(height: 13),
                            Row(
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () => ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Builder preview is not connected yet.',
                                          ),
                                        ),
                                      ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: _ink,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    side: const BorderSide(color: _line),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 15,
                                  ),
                                  label: const Text(
                                    'Edit',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                const SizedBox(width: 7),
                                OutlinedButton.icon(
                                  onPressed: () => setState(
                                    () => _automations.add(
                                      Map<String, dynamic>.from(automation)
                                        ..['name'] =
                                            '${automation['name']} (Copy)',
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: _ink,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    side: const BorderSide(color: _line),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.copy_outlined,
                                    size: 15,
                                  ),
                                  label: const Text(
                                    'Duplicate',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ),
                                const SizedBox(width: 7),
                                IconButton(
                                  onPressed: () => setState(
                                    () => _automations.remove(automation),
                                  ),
                                  tooltip: 'Delete',
                                  visualDensity: VisualDensity.compact,
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    size: 17,
                                    color: Colors.redAccent,
                                  ),
                                ),
                                const Spacer(),
                                const Text(
                                  'Last activity 4 d ago',
                                  style: TextStyle(fontSize: 10, color: _muted),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
