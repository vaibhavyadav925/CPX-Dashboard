part of '../app.dart';

class RCSReportsScreen extends StatefulWidget {
  const RCSReportsScreen({super.key});

  @override
  State<RCSReportsScreen> createState() => _RCSReportsScreenState();
}

class _RCSReportsScreenState extends State<RCSReportsScreen> {
  static const _tabs = [
    'Campaigns',
    'Live Message Reports',
    'Conversation Reports',
    'Chatbot Reports',
    'API Reports',
  ];

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  String _activeTab = 'Campaigns';
  String _status = 'All statuses';

  @override
  void dispose() {
    _searchController.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 850;
    final accent = panelAccent(context);
    const line = Color(0xFFDCE2ED);

    return Scaffold(
      drawer: const DashboardDrawer(
        currentPage: 'Reports',
        currentGroup: 'RCS-App',
      ),
      appBar: buildCpxBoatAppBar(context),
      body: Container(
        color: const Color(0xFFF4F6FB),
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            compact ? 14 : 22,
            20,
            compact ? 14 : 22,
            24,
          ),
          children: [
            const Text(
              'RCS Reports',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: navy,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Review campaign delivery, message activity, conversations and chatbot performance.',
              style: TextStyle(fontSize: 12, color: muted),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _tabs.map((tab) => _tab(tab, accent)).toList(),
              ),
            ),
            const Divider(height: 1, color: line),
            const SizedBox(height: 20),
            if (_activeTab == 'Campaigns') ...[
              _campaignMetrics(accent),
              const SizedBox(height: 20),
              _campaignFilters(compact, line),
              const SizedBox(height: 16),
              _emptyState(
                icon: Icons.sensors_rounded,
                title: 'No RCS campaign reports yet',
                message: 'Campaign delivery reports will appear here when report data is available.',
              ),
            ] else ...[
              _dateFilters(line),
              const SizedBox(height: 16),
              _emptyState(
                icon: _tabIcon(_activeTab),
                title: 'No ${_activeTab.toLowerCase()} available',
                message: 'Choose a date range and select Get Reports to check for RCS report data.',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tab(String label, Color accent) {
    final selected = _activeTab == label;
    return InkWell(
      onTap: () => setState(() => _activeTab = label),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? accent : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: selected ? accent : navy,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _campaignMetrics(Color accent) {
    return LayoutBuilder(
      builder: (context, box) {
        final columns = box.maxWidth < 650
            ? 1
            : box.maxWidth < 1100
            ? 2
            : 4;
        final width = (box.maxWidth - 14 * (columns - 1)) / columns;
        final metrics = [
          ('Initiated', Icons.rocket_launch_outlined, navy),
          ('Delivered', Icons.check_circle_outline_rounded, Color(0xFF1BA76B)),
          ('Read', Icons.visibility_outlined, accent),
          ('Failed', Icons.cancel_outlined, Color(0xFFFF4F59)),
        ];

        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: metrics
              .map(
                (metric) => Container(
                  width: width,
                  height: 96,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  decoration: _cardDecoration(radius: 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              metric.$1,
                              style: const TextStyle(
                                fontSize: 12,
                                color: muted,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              '—',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w800,
                                color: navy,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: metric.$3.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(metric.$2, color: metric.$3, size: 19),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _campaignFilters(bool compact, Color line) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
        SizedBox(
          width: compact ? 250 : 288,
          child: TextField(
            controller: _searchController,
            decoration: _inputDecoration(line, 'Search RCS campaigns...'),
            onChanged: (_) => setState(() {}),
          ),
        ),
        SizedBox(
          width: 174,
          child: DropdownButtonFormField<String>(
            initialValue: _status,
            isDense: true,
            decoration: _inputDecoration(line, null),
            items: const [
              DropdownMenuItem(
                value: 'All statuses',
                child: Text('All statuses', style: TextStyle(fontSize: 12)),
              ),
              DropdownMenuItem(
                value: 'Completed',
                child: Text('Completed', style: TextStyle(fontSize: 12)),
              ),
              DropdownMenuItem(
                value: 'Failed',
                child: Text('Failed', style: TextStyle(fontSize: 12)),
              ),
            ],
            onChanged: (value) =>
                setState(() => _status = value ?? 'All statuses'),
          ),
        ),
        _dateField('From', _fromController, line),
        _dateField('To', _toController, line),
      ],
    );
  }

  Widget _dateFilters(Color line) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(radius: 14),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          _dateField('From', _fromController, line),
          _dateField('To', _toController, line),
          SizedBox(
            height: 40,
            child: FilledButton.icon(
              onPressed: _showNoReportsMessage,
              icon: const Icon(Icons.search, size: 16),
              label: const Text('Get Reports'),
              style: FilledButton.styleFrom(
                backgroundColor: panelAccent(context),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateField(
    String label,
    TextEditingController controller,
    Color line,
  ) {
    return SizedBox(
      width: 136,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: navy,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            readOnly: true,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2035),
              );
              if (date != null) {
                controller.text =
                    '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
              }
            },
            decoration: _inputDecoration(line, 'dd-mm-yyyy').copyWith(
              suffixIcon: const Icon(Icons.calendar_today_outlined, size: 14),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(Color line, String? hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 12, color: muted),
      isDense: true,
      filled: true,
      fillColor: const Color(0xFFF9FAFD),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: line),
      ),
    );
  }

  Widget _emptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 180),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(radius: 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 30, color: panelAccent(context)),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: navy,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: muted),
          ),
        ],
      ),
    );
  }

  IconData _tabIcon(String tab) {
    return switch (tab) {
      'Live Message Reports' => Icons.mark_chat_read_outlined,
      'Conversation Reports' => Icons.forum_outlined,
      'Chatbot Reports' => Icons.smart_toy_outlined,
      'API Reports' => Icons.code_rounded,
      _ => Icons.analytics_outlined,
    };
  }

  void _showNoReportsMessage() {
    if (_fromController.text.isEmpty || _toController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a date range first.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No RCS report data is available for this date range.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
