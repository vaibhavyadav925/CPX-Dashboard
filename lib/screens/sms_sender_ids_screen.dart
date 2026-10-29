part of '../app.dart';

class SMSSenderIdsScreen extends StatefulWidget {
  const SMSSenderIdsScreen({super.key});

  @override
  State<SMSSenderIdsScreen> createState() => _SMSSenderIdsScreenState();
}

class _SMSSenderIdsScreenState extends State<SMSSenderIdsScreen> {
  final List<_SenderIdRecord> _senderIds = [
    _SenderIdRecord(
      senderId: 'WBTCSL',
      dateTime: '01-Sept-2026 | 18:05:13',
      category: 'Transaction',
    ),
  ];

  Future<void> _confirmDelete(_SenderIdRecord record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove sender ID?'),
        content: Text('Remove ${record.senderId} from this list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    setState(() => _senderIds.remove(record));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('${record.senderId} removed from the list.')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final compact = screenWidth < 700;
    final tableWidth = compact ? 620.0 : screenWidth - 44;
    final accent = panelAccent(context);
    const border = Color(0xFFDCE2ED);

    return Scaffold(
      drawer: const DashboardDrawer(
        currentPage: 'Sender IDs',
        currentGroup: 'SMS-App',
      ),
      appBar: buildCpxBoatAppBar(context),
      body: Container(
        color: const Color(0xFFF4F6FB),
        padding: EdgeInsets.fromLTRB(
          compact ? 14 : 22,
          compact ? 18 : 20,
          compact ? 14 : 22,
          24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sender IDs',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: navy,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Sender IDs approved for your account with each route type. New sender IDs are provisioned by our team after your DLT registration — reach out to support to add one.',
              style: TextStyle(fontSize: 12, color: muted, height: 1.4),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: border),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x100D2B55),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: _senderIds.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text(
                            'No sender IDs are available.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: muted),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          _tableHeader(accent, tableWidth),
                          Expanded(
                            child: ListView.separated(
                              itemCount: _senderIds.length,
                              separatorBuilder: (_, _) =>
                                  const Divider(height: 1, color: border),
                              itemBuilder: (context, index) {
                                final record = _senderIds[index];
                                return _tableRow(record, tableWidth);
                              },
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

  Widget _tableHeader(Color accent, double tableWidth) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: tableWidth,
        child: Container(
          color: accent,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              const Expanded(
                flex: 4,
                child: Text('Sender ID', style: _headerStyle),
              ),
              const Expanded(
                flex: 4,
                child: Text('Date and time', style: _headerStyle),
              ),
              const Expanded(
                flex: 4,
                child: Text('Category', style: _headerStyle),
              ),
              SizedBox(
                width: 70,
                child: const Text(
                  'Actions',
                  textAlign: TextAlign.right,
                  style: _headerStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tableRow(_SenderIdRecord record, double tableWidth) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: tableWidth,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  record.senderId,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  record.dateTime,
                  style: const TextStyle(fontSize: 12, color: muted),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  record.category,
                  style: const TextStyle(fontSize: 12, color: navy),
                ),
              ),
              SizedBox(
                width: 70,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    tooltip: 'Remove sender ID',
                    onPressed: () => _confirmDelete(record),
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      size: 17,
                      color: Color(0xFFFF5361),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const _headerStyle = TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );
}

class _SenderIdRecord {
  const _SenderIdRecord({
    required this.senderId,
    required this.dateTime,
    required this.category,
  });

  final String senderId;
  final String dateTime;
  final String category;
}
