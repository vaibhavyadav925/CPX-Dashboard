part of '../app.dart';

class SmartFallbackCampaignsScreen extends StatefulWidget {
  const SmartFallbackCampaignsScreen({super.key});

  @override
  State<SmartFallbackCampaignsScreen> createState() =>
      _SmartFallbackCampaignsScreenState();
}

class _SmartFallbackCampaignsScreenState
    extends State<SmartFallbackCampaignsScreen> {
  final Set<int> _selected = <int>{};
  bool _showReport = false;
  String _search = '';
  String _status = 'All statuses';
  final List<Map<String, dynamic>> _campaigns = const [
    {
      'name': 'Test_demo_cam',
      'time': '05:10 pm · 20 Contacts',
      'count': 20,
      'amount': '₹17.11',
      'order': ['wa', 'rcs', 'sms'],
      'date': '9/9/2026, 5:10:46 pm',
    },
    {
      'name': 'Smart_fallback_...',
      'time': '04:58 pm · 19 Contacts',
      'count': 19,
      'amount': '₹9.76',
      'order': ['rcs', 'wa', 'sms'],
      'date': '9/9/2026, 4:58:00 pm',
    },
    {
      'name': 'sc_rcs_sms_wa',
      'time': '04:05 pm · 13 Contacts',
      'count': 13,
      'amount': '₹7.92',
      'order': ['rcs', 'sms', 'wa'],
      'date': '9/9/2026, 4:05:00 pm',
    },
    {
      'name': 'sc_sms_wa_rcs',
      'time': '04:05 pm · 13 Contacts',
      'count': 13,
      'amount': '₹9.10',
      'order': ['sms', 'wa', 'rcs'],
      'date': '9/9/2026, 4:05:00 pm',
    },
    {
      'name': 'sc_sms_rcs_wa',
      'time': '04:05 pm · 13 Contacts',
      'count': 13,
      'amount': '₹9.10',
      'order': ['sms', 'rcs', 'wa'],
      'date': '9/9/2026, 4:05:00 pm',
    },
    {
      'name': 'sc_wa_rcs_sms',
      'time': '04:05 pm · 13 Contacts',
      'count': 13,
      'amount': '₹18.05',
      'order': ['wa', 'rcs', 'sms'],
      'date': '9/9/2026, 4:05:00 pm',
    },
    {
      'name': 'sc_rcs_wa',
      'time': '04:05 pm · 13 Contacts',
      'count': 13,
      'amount': '₹3.87',
      'order': ['rcs', 'wa'],
      'date': '9/9/2026, 4:05:00 pm',
    },
    {
      'name': 'rcs_dlr_fix_ver...',
      'time': '04:05 pm · 13 Contacts',
      'count': 13,
      'amount': '₹8.51',
      'order': ['rcs', 'sms'],
      'date': '9/9/2026, 4:05:00 pm',
    },
  ];
  Color get _teal => PanelThemeController.instance.accentColor;
  static const _navy = Color(0xFF151C30);
  static const _line = Color(0xFFD9E0ED);
  List<int> get _visible =>
      List<int>.generate(_campaigns.length, (i) => i).where((i) {
        final c = _campaigns[i];
        return c['name'].toString().toLowerCase().contains(
              _search.toLowerCase(),
            ) &&
            (_status == 'All statuses' || _status == 'Completed');
      }).toList();
  int get _total =>
      _selected.fold(0, (sum, i) => sum + (_campaigns[i]['count'] as int));

  Future<void> _downloadCampaign(
    Map<String, dynamic> campaign, {
    bool statsOnly = false,
  }) {
    final order = (campaign['order'] as List).join(' → ');
    if (statsOnly) {
      return saveCsvFile(
        context,
        fileName: 'smart_fallback_campaign_stats',
        headers: const ['Campaign', 'Metric', 'Value'],
        rows: [
          [campaign['name'], 'Recipients', campaign['count']],
          [campaign['name'], 'Amount', campaign['amount']],
          [campaign['name'], 'Fallback order', order],
          [campaign['name'], 'Date', campaign['date']],
        ],
      );
    }

    return saveCsvFile(
      context,
      fileName: 'smart_fallback_campaign_report',
      headers: const [
        'Campaign',
        'Recipients',
        'Amount',
        'Fallback order',
        'Date',
      ],
      rows: [
        [
          campaign['name'],
          campaign['count'],
          campaign['amount'],
          order,
          campaign['date'],
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 760;
    final chosen = _selected.toList()..sort();
    final selectedCampaign = chosen.isEmpty ? null : _campaigns[chosen.first];
    return Scaffold(
      drawer: const DashboardDrawer(
        currentPage: 'Campaigns',
        currentGroup: 'Smart Fallback',
      ),
      appBar: buildCpxBoatAppBar(context),
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  color: const Color(0xFFF4F6FB),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          mobile ? 14 : 22,
                          20,
                          18,
                          16,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Fallback campaigns',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF172033),
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    'Cross-channel priority-cascade campaigns.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF68758B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FilledButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) =>
                                        const SmartFallbackNewCampaignScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add, size: 17),
                              label: const Text('New campaign'),
                              style: FilledButton.styleFrom(
                                backgroundColor: _teal,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(22, 0, 22, 18),
                        child: Wrap(
                          spacing: 9,
                          runSpacing: 8,
                          children: [
                            SizedBox(
                              width: mobile ? double.infinity : 263,
                              height: 36,
                              child: TextField(
                                onChanged: (value) =>
                                    setState(() => _search = value),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    size: 17,
                                  ),
                                  hintText: 'Search campaigns...',
                                  hintStyle: const TextStyle(fontSize: 12),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF9FAFD),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(color: _line),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(color: _line),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 158,
                              height: 36,
                              child: DropdownButtonFormField<String>(
                                initialValue: _status,
                                items: const ['All statuses', 'Completed']
                                    .map(
                                      (value) => DropdownMenuItem(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) => setState(
                                  () => _status = value ?? 'All statuses',
                                ),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 7,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF9FAFD),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(color: _line),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_selected.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(22, 0, 22, 14),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE7F5F8),
                              border: Border.all(
                                color: const Color(0xFFB9E2E9),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 12,
                              runSpacing: 8,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: _teal,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${_selected.length} campaign${_selected.length == 1 ? '' : 's'} selected',
                                      style: const TextStyle(
                                        color: Color(0xFF173C4A),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      '$_total contacts',
                                      style: const TextStyle(
                                        color: Color(0xFF526779),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 6,
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        if (selectedCampaign == null) return;
                                        setState(() => _showReport = true);
                                      },
                                      icon: const Icon(
                                        Icons.analytics_outlined,
                                        size: 16,
                                      ),
                                      label: const Text('View Analytics'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: _teal,
                                        side: BorderSide(color: _teal),
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => setState(() {
                                        _selected.clear();
                                        _showReport = false;
                                      }),
                                      child: const Text('Clear selection'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(22, 0, 22, 18),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: _line),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x10000000),
                                  blurRadius: 3,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  width: mobile ? 1120 : null,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 38,
                                        color: _teal,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 42,
                                              child: Checkbox(
                                                value:
                                                    _visible.isNotEmpty &&
                                                    _visible.every(
                                                      _selected.contains,
                                                    ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    if (value == true) {
                                                      _selected.addAll(
                                                        _visible,
                                                      );
                                                    } else {
                                                      _selected.removeAll(
                                                        _visible,
                                                      );
                                                    }
                                                    // Selecting rows only updates selection.
                                                    // Open analytics only when the user taps View Analytics.
                                                    _showReport = false;
                                                  });
                                                },
                                                side: const BorderSide(
                                                  color: Colors.white,
                                                ),
                                                checkColor: _teal,
                                                activeColor: Colors.white,
                                              ),
                                            ),
                                            _head('Campaign Name', 190),
                                            _head('Fallback order', 145),
                                            _head('Recipients', 145),
                                            _head('Amount', 125),
                                            _head('Status', 145),
                                            _head('Download', 110),
                                            _head('Actions', 145),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: _visible.length,
                                          itemBuilder: (context, index) {
                                            final i = _visible[index];
                                            final c = _campaigns[i];
                                            final checked = _selected.contains(
                                              i,
                                            );
                                            return Container(
                                              height: 71,
                                              decoration: BoxDecoration(
                                                color: index.isEven
                                                    ? Colors.white
                                                    : const Color(0xFFF8FAFC),
                                                border: const Border(
                                                  bottom: BorderSide(
                                                    color: _line,
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 42,
                                                    child: Checkbox(
                                                      value: checked,
                                                      activeColor: _teal,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          if (value == true) {
                                                            _selected.add(i);
                                                          } else {
                                                            _selected.remove(i);
                                                          }
                                                          // Do not open the report on checkbox selection.
                                                          _showReport = false;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 190,
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 46,
                                                          height: 54,
                                                          margin:
                                                              const EdgeInsets.only(
                                                                right: 10,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color: const Color(
                                                              0xFFE5F4F7,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'SEP',
                                                                style: TextStyle(
                                                                  fontSize: 9,
                                                                  color: _teal,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                              Text(
                                                                '9',
                                                                style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: _teal,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                              Text(
                                                                '2026',
                                                                style:
                                                                    TextStyle(
                                                                      fontSize:
                                                                          8,
                                                                      color:
                                                                          _teal,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                c['name']
                                                                    .toString(),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              Text(
                                                                c['time']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Color(
                                                                    0xFF718096,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 145,
                                                    child: Center(
                                                      child: Wrap(
                                                        crossAxisAlignment:
                                                            WrapCrossAlignment
                                                                .center,
                                                        spacing: 4,
                                                        children: (c['order'] as List<String>).asMap().entries.map((
                                                          entry,
                                                        ) {
                                                          return Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                _channel(
                                                                  entry.value,
                                                                ),
                                                                style: TextStyle(
                                                                  fontSize: 13,
                                                                  color: _channelColor(
                                                                    entry.value,
                                                                  ),
                                                                ),
                                                              ),
                                                              if (entry.key <
                                                                  (c['order']
                                                                              as List<
                                                                                String
                                                                              >)
                                                                          .length -
                                                                      1)
                                                                const Text(
                                                                  '→',
                                                                  style: TextStyle(
                                                                    color: Color(
                                                                      0xFF536174,
                                                                    ),
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                            ],
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 145,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          '${c['count']} Contacts',
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 6,
                                                        ),
                                                        OutlinedButton(
                                                          onPressed: () =>
                                                              _showDeliveryStatusDialog(
                                                                c,
                                                              ),
                                                          style: OutlinedButton.styleFrom(
                                                            minimumSize:
                                                                const Size(
                                                                  48,
                                                                  24,
                                                                ),
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal: 8,
                                                                ),
                                                            side:
                                                                const BorderSide(
                                                                  color: _line,
                                                                ),
                                                          ),
                                                          child: const Text(
                                                            '◷ View',
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              color: Color(
                                                                0xFF159C65,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 125,
                                                    child: Center(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 9,
                                                              vertical: 4,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: const Color(
                                                            0xFFE5F5F8,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                15,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          c['amount']
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: _teal,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 145,
                                                    child: Center(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 4,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: const Color(
                                                            0xFFE2F8ED,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                15,
                                                              ),
                                                        ),
                                                        child: const Text(
                                                          'Completed',
                                                          style: TextStyle(
                                                            color: Color(
                                                              0xFF0A9D5A,
                                                            ),
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 110,
                                                    child: Center(
                                                      child: IconButton(
                                                        onPressed: () =>
                                                            _downloadCampaign(
                                                              c,
                                                            ),
                                                        icon: const Icon(
                                                          Icons
                                                              .download_outlined,
                                                          size: 17,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 145,
                                                    child: Center(
                                                      child: TextButton.icon(
                                                        onPressed: () =>
                                                            setState(() {
                                                              _selected.add(i);
                                                              _showReport =
                                                                  true;
                                                            }),
                                                        icon: const Icon(
                                                          Icons.reply_rounded,
                                                          size: 14,
                                                        ),
                                                        label: const Text(
                                                          'View Analytics',
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_showReport && selectedCampaign != null)
            Positioned.fill(
              child: Material(
                color: Colors.black.withOpacity(0.38),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: mobile ? MediaQuery.of(context).size.width : 368,
                    height: double.infinity,
                    child: Material(
                      elevation: 12,
                      color: Colors.white,
                      child: _reportPanel(
                        selectedCampaign,
                        _selected.length,
                        _total,
                        () => setState(() => _showReport = false),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showDeliveryStatusDialog(Map<String, dynamic> campaign) {
    final total = campaign['count'] as int;
    final delivered = (total * 0.70).round();
    final read = (total * 0.30).round();
    const sent = 0;
    const failed = 0;
    final unread = (total - delivered - read - sent - failed).clamp(0, total);

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE2F8ED),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.query_stats_rounded,
                        color: Color(0xFF20B86A),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery Status',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF263247),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Campaign message breakdown',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF68758B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFDDE5EF)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.wifi_tethering,
                            size: 12,
                            color: Color(0xFF20A65A),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Live',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF68758B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      icon: const Icon(
                        Icons.close,
                        size: 18,
                        color: Color(0xFF9AA4B2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '${campaign['name']} · ${campaign['date']} · $total Contacts',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF68758B),
                  ),
                ),
                const SizedBox(height: 14),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 440;
                    final statusList = <(String, int, Color, IconData)>[
                      (
                        'Total',
                        total,
                        const Color(0xFFE8F5EF),
                        Icons.people_alt_outlined,
                      ),
                      ('Sent', sent, const Color(0xFFF59E0B), Icons.check),
                      (
                        'Delivered',
                        delivered,
                        const Color(0xFF397CFF),
                        Icons.done_all,
                      ),
                      ('Read', read, const Color(0xFF20A65A), Icons.done_all),
                      (
                        'Failed',
                        failed,
                        const Color(0xFFEF4444),
                        Icons.warning_amber_rounded,
                      ),
                      (
                        'Unread',
                        unread,
                        const Color(0xFF8B5CF6),
                        Icons.chat_bubble_outline,
                      ),
                    ];
                    Widget ring = SizedBox(
                      width: 175,
                      height: 175,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          for (final size in [158.0, 132.0, 106.0, 80.0])
                            Container(
                              width: size,
                              height: size,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: size == 158.0
                                      ? const Color(0xFFEF4444)
                                      : const Color(0xFFE9ECF2),
                                  width: size == 158.0 ? 8 : 7,
                                ),
                              ),
                            ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF68758B),
                                ),
                              ),
                              Text(
                                '$total',
                                style: const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF172033),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                    Widget statuses = Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFDDE3ED)),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Column(
                        children: [
                          for (final row in statusList)
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: row.$1 == 'Total'
                                    ? const Color(0xFFE8F5EF)
                                    : const Color(0xFFF8F9FC),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  if (row.$1 != 'Total')
                                    Icon(row.$4, size: 14, color: row.$3),
                                  if (row.$1 != 'Total')
                                    const SizedBox(width: 7),
                                  Expanded(
                                    child: Text(
                                      row.$1,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF303B4F),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${row.$2}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF303B4F),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  SizedBox(
                                    width: 42,
                                    child: Text(
                                      total == 0
                                          ? '0.00%'
                                          : '${(row.$2 * 100 / total).toStringAsFixed(2)}%',
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF7A8598),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const Divider(height: 12),
                          Row(
                            children: [
                              const Icon(
                                Icons.auto_awesome_outlined,
                                size: 14,
                                color: Color(0xFF8B95A7),
                              ),
                              const SizedBox(width: 7),
                              const Expanded(
                                child: Text(
                                  'Click Count',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF303B4F),
                                  ),
                                ),
                              ),
                              const Text(
                                '— not tracked',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF7A8598),
                                ),
                              ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                tooltip: 'Download click count',
                                onPressed: () => saveCsvFile(
                                  context,
                                  fileName: 'smart_fallback_click_count',
                                  headers: const ['Campaign', 'Click Count'],
                                  rows: [
                                    [campaign['name'], 'Not tracked'],
                                  ],
                                ),
                                icon: const Icon(
                                  Icons.download_outlined,
                                  size: 13,
                                ),
                              ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                onPressed: () {},
                                icon: const Icon(Icons.link, size: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                    return compact
                        ? Column(
                            children: [
                              ring,
                              const SizedBox(height: 12),
                              statuses,
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ring,
                              const SizedBox(width: 12),
                              Expanded(child: statuses),
                            ],
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _head(String label, double width) => SizedBox(
    width: width,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
  String _channel(String c) => c == 'wa'
      ? '●'
      : c == 'rcs'
      ? '▰'
      : '▤';
  Color _channelColor(String c) => c == 'wa'
      ? const Color(0xFF20A65A)
      : c == 'rcs'
      ? const Color(0xFF2379E8)
      : const Color(0xFFF1B927);
  Widget _reportPanel(
    Map<String, dynamic> campaign,
    int count,
    int total,
    VoidCallback close,
  ) {
    final read = (total * .30).round(),
        delivered = (total * .70).round(),
        sent = count > 1 ? 1 : 1;
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: _teal,
            padding: const EdgeInsets.fromLTRB(18, 16, 12, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'CAMPAIGN REPORT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: close,
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('🟢 🔵 🟡', style: TextStyle(fontSize: 15)),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        count == 1
                            ? campaign['name']
                            : '$count campaigns selected',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDDF7E9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Completed',
                        style: TextStyle(
                          color: Color(0xFF16965A),
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  '${campaign['date']} · $total Contacts',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('All', style: TextStyle(color: _teal, fontSize: 12)),
                    Text(
                      'WhatsApp',
                      style: TextStyle(fontSize: 11, color: Color(0xFF596579)),
                    ),
                    Text(
                      'RCS',
                      style: TextStyle(fontSize: 11, color: Color(0xFF596579)),
                    ),
                    Text(
                      'SMS',
                      style: TextStyle(fontSize: 11, color: Color(0xFF596579)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F5F8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'ⓘ  Analytics will be updated after 15 minutes. For detailed reports, please click on Download Reports.',
                    style: TextStyle(fontSize: 10, color: Color(0xFF68758B)),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                    border: Border.all(color: _line),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _metric('$total', 'TOTAL'),
                      _metric('$read', 'READ', const Color(0xFF22A567)),
                      _metric(
                        '$delivered',
                        'DELIVERED',
                        const Color(0xFF397CFF),
                      ),
                      _metric('$sent', 'SENT', const Color(0xFFF3A000)),
                      _metric('0', 'FAILED', const Color(0xFFE84A4A)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _progress(
                  'Delivered',
                  delivered,
                  total,
                  const Color(0xFF3B82F6),
                ),
                _progress('Read', read, total, const Color(0xFF2DA66B)),
                _progress('Sent', sent, total, const Color(0xFFF59E0B)),
                _progress('Failed', 0, total, const Color(0xFFE84A4A)),
                const Divider(height: 30),
                const Text(
                  'CAMPAIGN DETAILS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF4B5563),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _downloadCampaign(campaign),
                        child: const Text(
                          'Download Report',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            _downloadCampaign(campaign, statsOnly: true),
                        child: const Text(
                          'Download Stats',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metric(
    String value,
    String label, [
    Color color = const Color(0xFF172033),
  ]) => Column(
    children: [
      Text(
        value,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 16,
          color: color,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: const TextStyle(fontSize: 8, color: Color(0xFF788398)),
      ),
    ],
  );
  Widget _progress(String label, int value, int total, Color color) => Padding(
    padding: const EdgeInsets.only(bottom: 17),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 7),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 11))),
            Text(
              '$value',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: total == 0 ? 0 : value / total,
            minHeight: 6,
            backgroundColor: const Color(0xFFE9ECF2),
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${total == 0 ? 0 : (value / total * 100).round()}% of total messages',
          style: const TextStyle(fontSize: 9, color: Color(0xFF718096)),
        ),
      ],
    ),
  );
}

class SmartFallbackNewCampaignScreen extends StatefulWidget {
  const SmartFallbackNewCampaignScreen({super.key});

  @override
  State<SmartFallbackNewCampaignScreen> createState() =>
      _SmartFallbackNewCampaignScreenState();
}

class _SmartFallbackNewCampaignScreenState
    extends State<SmartFallbackNewCampaignScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numbersController = TextEditingController();
  String _firstChannel = 'RCS';
  String _secondChannel = 'WHATSAPP';
  String _thirdChannel = 'None';
  String _numberSource = 'Paste Numbers';
  String _phonebookGroup = 'Select a contact group';
  String _rcsTemplate = 'Select Template';
  String _whatsappTemplate = 'Select Template';
  bool _rcsExpanded = true;
  bool _whatsappExpanded = false;
  bool _removeDuplicates = false;
  int _previewChannel = 0;

  static const Color _teal = Color(0xFF0C94AC);
  static const Color _purple = Color(0xFF7438F5);
  static const Color _line = Color(0xFFD9E0ED);

  @override
  void dispose() {
    _nameController.dispose();
    _numbersController.dispose();
    super.dispose();
  }

  List<String> get _numbers {
    final raw = _numbersController.text
        .split(RegExp(r'[\n,; \t]+'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    return _removeDuplicates ? raw.toSet().toList() : raw;
  }

  List<String> get _channels => [
    _firstChannel,
    if (_secondChannel != 'None') _secondChannel,
    if (_thirdChannel != 'None') _thirdChannel,
  ];

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 760;
    final channels = _channels;
    return Scaffold(
      drawer: const DashboardDrawer(
        currentPage: 'Campaigns',
        currentGroup: 'Smart Fallback',
      ),
      appBar: buildCpxBoatAppBar(context),
      body: Container(
        color: const Color(0xFFF4F6FB),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(mobile ? 14 : 24, 14, 18, 12),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Back to campaigns',
                    visualDensity: VisualDensity.compact,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, size: 18),
                  ),
                  const Text(
                    'Fallback  /  New campaign',
                    style: TextStyle(fontSize: 12, color: Color(0xFF596579)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  mobile ? 14 : 24,
                  0,
                  mobile ? 14 : 24,
                  22,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create Campaign',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF172033),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Unified Campaign — cascades across your connected channels.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF68758B)),
                    ),
                    const SizedBox(height: 18),
                    if (mobile)
                      Column(
                        children: [
                          _campaignDetailsCard(),
                          const SizedBox(height: 14),
                          _templateCard(),
                          const SizedBox(height: 14),
                          _recipientsCard(),
                          const SizedBox(height: 14),
                          _previewCard(channels),
                          const SizedBox(height: 14),
                          _sendButton(),
                        ],
                      )
                    else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                _campaignDetailsCard(),
                                const SizedBox(height: 14),
                                _templateCard(),
                                const SizedBox(height: 14),
                                _recipientsCard(),
                                const SizedBox(height: 14),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: _sendButton(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(width: 270, child: _previewCard(channels)),
                        ],
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

  Widget _card({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(16),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _fieldLabel(String text, {bool required = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 12, color: Color(0xFF263247)),
        children: [
          TextSpan(text: text),
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Color(0xFFE34A4A)),
            ),
        ],
      ),
    ),
  );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF8A95A8)),
    filled: true,
    fillColor: const Color(0xFFF9FAFD),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: _line),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: _line),
    ),
  );

  Widget _campaignDetailsCard() => _card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Campaign Name', required: true),
        TextField(
          controller: _nameController,
          decoration: _inputDecoration('Enter Campaign Name'),
        ),
        const SizedBox(height: 16),
        const Text(
          'Fallback Flow order',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF263247),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Choose your channel flow order — any two or three connected channels, in any order.',
          style: TextStyle(fontSize: 10, color: Color(0xFF68758B)),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < 620;
            final fields = [
              _channelDropdown(
                'First channel',
                _firstChannel,
                ['RCS', 'WHATSAPP', 'SMS'],
                (v) {
                  if (v != null) setState(() => _firstChannel = v);
                },
              ),
              _channelDropdown(
                'Second channel',
                _secondChannel,
                ['None', 'RCS', 'WHATSAPP', 'SMS'],
                (v) {
                  if (v != null) setState(() => _secondChannel = v);
                },
              ),
              _channelDropdown(
                'Third channel',
                _thirdChannel,
                ['None', 'RCS', 'WHATSAPP', 'SMS'],
                (v) {
                  if (v != null) setState(() => _thirdChannel = v);
                },
              ),
            ];
            if (stacked) {
              return Column(
                children: [
                  for (int i = 0; i < fields.length; i++) ...[
                    fields[i],
                    if (i != fields.length - 1) const SizedBox(height: 10),
                  ],
                ],
              );
            }
            return Row(
              children: [
                for (int i = 0; i < fields.length; i++) ...[
                  Expanded(child: fields[i]),
                  if (i != fields.length - 1) const SizedBox(width: 10),
                ],
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        Text(
          'Order: ${_channels.join(' → ')}',
          style: const TextStyle(fontSize: 10, color: Color(0xFF68758B)),
        ),
      ],
    ),
  );

  Widget _channelDropdown(
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _fieldLabel(label, required: label != 'Third channel'),
      DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        decoration: _inputDecoration('Select channel'),
        items: options
            .map(
              (option) => DropdownMenuItem(
                value: option,
                child: Text(option, style: const TextStyle(fontSize: 12)),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    ],
  );

  Widget _templateCard() => _card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Template',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFF263247),
          ),
        ),
        const SizedBox(height: 12),
        if (_channels.contains('RCS'))
          _templateSection(
            title: 'RCS',
            subtitle: '1st Channel) Primary',
            expanded: _rcsExpanded,
            onToggle: () => setState(() {
              _rcsExpanded = !_rcsExpanded;
              _previewChannel = _channels
                  .indexOf('RCS')
                  .clamp(0, _channels.length - 1)
                  .toInt();
            }),
            value: _rcsTemplate,
            onChanged: (v) =>
                setState(() => _rcsTemplate = v ?? 'Select Template'),
          ),
        if (_channels.contains('RCS') &&
            (_channels.contains('WHATSAPP') || _channels.contains('SMS')))
          const SizedBox(height: 8),
        if (_channels.contains('WHATSAPP'))
          _templateSection(
            title: 'WhatsApp',
            subtitle: '2nd Channel',
            expanded: _whatsappExpanded,
            onToggle: () => setState(() {
              _whatsappExpanded = !_whatsappExpanded;
              _previewChannel = _channels
                  .indexOf('WHATSAPP')
                  .clamp(0, _channels.length - 1)
                  .toInt();
            }),
            value: _whatsappTemplate,
            onChanged: (v) =>
                setState(() => _whatsappTemplate = v ?? 'Select Template'),
          ),
        if (_channels.contains('SMS'))
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: _templateSection(
              title: 'SMS',
              subtitle: 'Channel template',
              expanded: false,
              onToggle: () =>
                  showApiPendingMessage(context, 'SMS template selection'),
              value: 'Select Template',
              onChanged: (_) {},
            ),
          ),
      ],
    ),
  );

  Widget _templateSection({
    required String title,
    required String subtitle,
    required bool expanded,
    required VoidCallback onToggle,
    required String value,
    required ValueChanged<String?> onChanged,
  }) => Container(
    decoration: BoxDecoration(
      color: expanded ? const Color(0xFFFFFBF5) : Colors.white,
      border: Border.all(color: expanded ? const Color(0xFFFFD18A) : _line),
      borderRadius: BorderRadius.circular(7),
    ),
    child: Column(
      children: [
        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
            child: Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFA000),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.looks_one,
                    size: 13,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$title ($subtitle)',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF263247),
                    ),
                  ),
                ),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 17,
                  color: const Color(0xFF68758B),
                ),
              ],
            ),
          ),
        ),
        if (expanded)
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel('Template', required: true),
                DropdownButtonFormField<String>(
                  value: value,
                  isExpanded: true,
                  decoration: _inputDecoration('Select Template'),
                  items: const [
                    DropdownMenuItem(
                      value: 'Select Template',
                      child: Text(
                        'Select Template',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'webtech_carousel',
                      child: Text(
                        'webtech_carousel',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Promotional',
                      child: Text(
                        'Promotional',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Order Update',
                      child: Text(
                        'Order Update',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                  onChanged: onChanged,
                ),
                const SizedBox(height: 5),
                const Text(
                  'Message preview is available on the right-hand side.',
                  style: TextStyle(
                    fontSize: 9,
                    color: Color(0xFF68758B),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  );

  Widget _recipientsCard() => _card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Send Campaign to',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFF263247),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 14,
          runSpacing: 8,
          children: [
            for (final source in ['Paste Numbers', 'Upload File', 'Phonebook'])
              InkWell(
                onTap: () => setState(() => _numberSource = source),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _numberSource == source
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      size: 15,
                      color: _numberSource == source
                          ? _purple
                          : const Color(0xFF8A95A8),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      source,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF354155),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (_numberSource == 'Phonebook') ...[
          DropdownButtonFormField<String>(
            value: _phonebookGroup,
            isExpanded: true,
            decoration: _inputDecoration('Select a contact group'),
            items: const [
              DropdownMenuItem(
                value: 'Select a contact group',
                child: Text(
                  'Select a contact group',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              DropdownMenuItem(
                value: 'All Contacts',
                child: Text('All Contacts', style: TextStyle(fontSize: 12)),
              ),
              DropdownMenuItem(
                value: 'Customers',
                child: Text('Customers', style: TextStyle(fontSize: 12)),
              ),
              DropdownMenuItem(
                value: 'Leads',
                child: Text('Leads', style: TextStyle(fontSize: 12)),
              ),
            ],
            onChanged: (value) => setState(
              () => _phonebookGroup = value ?? 'Select a contact group',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _numbersController,
            minLines: 4,
            maxLines: 6,
            onChanged: (_) => setState(() {}),
            decoration:
                _inputDecoration(
                  'Paste numbers here, one per line or separated by commas',
                ).copyWith(
                  alignLabelWithHint: true,
                  contentPadding: const EdgeInsets.all(12),
                ),
          ),
        ] else if (_numberSource == 'Upload File') ...[
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => saveCsvFile(
                context,
                fileName: 'smart_fallback_recipients_sample',
                headers: const ['phone_number', 'name'],
                rows: const [],
              ),
              icon: const Icon(Icons.download_outlined, size: 13),
              label: const Text(
                'Download Sample File',
                style: TextStyle(fontSize: 10),
              ),
              style: TextButton.styleFrom(
                foregroundColor: _purple,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
          InkWell(
            onTap: () => showApiPendingMessage(context, 'CSV/XLS file upload'),
            child: Container(
              width: double.infinity,
              height: 128,
              decoration: BoxDecoration(
                color: const Color(0xFFFAF7FF),
                border: Border.all(
                  color: const Color(0xFFD7B8FF),
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 28,
                    color: Color(0xFF69758A),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Upload File',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7438F5),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Supported Formats: CSV & XLS',
                    style: TextStyle(fontSize: 10, color: Color(0xFF68758B)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Excel file size should be below 50MB',
            style: TextStyle(fontSize: 9, color: Color(0xFF68758B)),
          ),
          const SizedBox(height: 3),
          const Text(
            'Excel/CSV upload supports up to 10,00,000 numbers',
            style: TextStyle(fontSize: 9, color: Color(0xFF68758B)),
          ),
        ] else ...[
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: () {
                final raw = _numbersController.text
                    .split(RegExp(r'[\n,; \t]+'))
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();
                _numbersController.text = raw.toSet().join('\n');
                setState(() => _removeDuplicates = true);
              },
              style: OutlinedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                side: const BorderSide(color: _line),
              ),
              child: const Text(
                'Remove Duplicate Numbers',
                style: TextStyle(fontSize: 10),
              ),
            ),
          ),
          TextField(
            controller: _numbersController,
            minLines: 5,
            maxLines: 7,
            onChanged: (_) => setState(() {}),
            decoration:
                _inputDecoration(
                  'Paste numbers here, one per line or comma-separated',
                ).copyWith(
                  alignLabelWithHint: true,
                  contentPadding: const EdgeInsets.all(12),
                ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Country code is required for every number (e.g. 91 for India).',
            style: TextStyle(fontSize: 9, color: Color(0xFF68758B)),
          ),
          const SizedBox(height: 3),
          const Text(
            'Copy-paste supports up to 1,50,000 numbers',
            style: TextStyle(fontSize: 9, color: Color(0xFF68758B)),
          ),
        ],
        if (_numberSource != 'Upload File') ...[
          const SizedBox(height: 7),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Total Mobile Numbers: ${_numbers.length}',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF263247),
              ),
            ),
          ),
        ],
      ],
    ),
  );

  Widget _previewCard(List<String> channels) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(left: 8, bottom: 8),
        child: Text(
          'Campaign Details',
          style: TextStyle(fontSize: 12, color: Color(0xFF68758B)),
        ),
      ),
      Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: _line)),
        ),
        child: Row(
          children: [
            for (int i = 0; i < channels.length; i++)
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _previewChannel = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _previewChannel == i
                              ? _purple
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      channels[i],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        color: _previewChannel == i
                            ? _purple
                            : const Color(0xFF68758B),
                        fontWeight: _previewChannel == i
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      Center(
        child: Container(
          width: 205,
          height: 340,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF141820),
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F2F9),
              borderRadius: BorderRadius.circular(21),
            ),
            child: Builder(
              builder: (context) {
                final isWhatsApp =
                    _previewChannel < channels.length &&
                    channels[_previewChannel] == 'WHATSAPP';
                final isRcs =
                    _previewChannel < channels.length &&
                    channels[_previewChannel] == 'RCS';
                final selectedTemplate = !isWhatsApp && isRcs
                    ? _rcsTemplate
                    : isWhatsApp
                    ? _whatsappTemplate
                    : 'SMS message preview';
                return Column(
                  children: [
                    Container(
                      color: isWhatsApp
                          ? const Color(0xFF075E54)
                          : const Color(0xFF0876E8),
                      padding: const EdgeInsets.fromLTRB(8, 7, 8, 9),
                      child: Column(
                        children: [
                          if (isWhatsApp)
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '12:19 PM',
                                  style: TextStyle(
                                    fontSize: 6,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '▴ ▾ ▣',
                                  style: TextStyle(
                                    fontSize: 6,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          if (isWhatsApp) const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.arrow_back,
                                size: 13,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 7),
                              CircleAvatar(
                                radius: 11,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.business,
                                  size: 12,
                                  color: isWhatsApp
                                      ? const Color(0xFF075E54)
                                      : const Color(0xFF0876E8),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Your Business',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'online',
                                      style: TextStyle(
                                        fontSize: 7,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isWhatsApp) ...[
                                const Icon(
                                  Icons.call,
                                  size: 12,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 6),
                              ],
                              const Icon(
                                Icons.more_vert,
                                size: 13,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        color: isWhatsApp
                            ? const Color(0xFFECE5DD)
                            : const Color(0xFFF1F2F9),
                        child: isWhatsApp
                            ? Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(
                                    8,
                                    10,
                                    24,
                                    8,
                                  ),
                                  padding: const EdgeInsets.fromLTRB(
                                    8,
                                    8,
                                    8,
                                    6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _whatsappTemplate == 'Select Template'
                                            ? 'Type a message'
                                            : _whatsappTemplate,
                                        style: const TextStyle(
                                          fontSize: 9,
                                          color: Color(0xFF29313B),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          '12:19 PM',
                                          style: TextStyle(
                                            fontSize: 6,
                                            color: Color(0xFF87909A),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    selectedTemplate == 'Select Template'
                                        ? 'Select a template to preview it here.'
                                        : selectedTemplate,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF68758B),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    if (isWhatsApp)
                      Container(
                        height: 28,
                        color: const Color(0xFFF7F7F7),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 5,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.add,
                              size: 12,
                              color: Color(0xFF7B8490),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Container(
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.mic,
                              size: 12,
                              color: Color(0xFF7B8490),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    ],
  );

  Widget _sendButton() => FilledButton.icon(
    onPressed: () {
      if (_nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a campaign name.')),
        );
        return;
      }
      if (_channels.length < 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Choose at least two channels for fallback.'),
          ),
        );
        return;
      }
      if (_rcsTemplate == 'Select Template' && _channels.contains('RCS')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an RCS template.')),
        );
        return;
      }
      if (_numbers.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter at least one mobile number.'),
          ),
        );
        return;
      }
      showApiPendingMessage(context, 'smart fallback campaign submission');
    },
    icon: const Icon(Icons.send_rounded, size: 14),
    label: const Text('Send Now', style: TextStyle(fontSize: 11)),
    style: FilledButton.styleFrom(
      backgroundColor: _purple,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
    ),
  );
}
