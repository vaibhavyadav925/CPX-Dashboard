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
  static const _teal = Color(0xFF0B91AD);
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
  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.of(context).size.width < 760;
    final chosen = _selected.toList()..sort();
    final selectedCampaign = chosen.isEmpty ? null : _campaigns[chosen.first];
    return Scaffold(
      drawer: const DashboardDrawer(currentPage: 'Campaigns'),
      appBar: buildCpxBoatAppBar(context),
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFFF4F6FB),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(mobile ? 14 : 22, 20, 18, 16),
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
                        if (!mobile)
                          FilledButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.add, size: 17),
                            label: const Text('New campaign'),
                            style: FilledButton.styleFrom(
                              backgroundColor: _teal,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
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
                              prefixIcon: const Icon(Icons.search, size: 17),
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
                            value: _status,
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
                          border: Border.all(color: const Color(0xFFB9E2E9)),
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
                                const Icon(
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
                                    side: const BorderSide(color: _teal),
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
                                                  _selected.addAll(_visible);
                                                  _showReport =
                                                      _selected.isNotEmpty;
                                                } else {
                                                  _selected.removeAll(_visible);
                                                  if (_selected.isEmpty)
                                                    _showReport = false;
                                                }
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
                                        final checked = _selected.contains(i);
                                        return Container(
                                          height: 71,
                                          decoration: BoxDecoration(
                                            color: index.isEven
                                                ? Colors.white
                                                : const Color(0xFFF8FAFC),
                                            border: const Border(
                                              bottom: BorderSide(color: _line),
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
                                                        _showReport = true;
                                                      } else {
                                                        _selected.remove(i);
                                                        if (_selected.isEmpty)
                                                          _showReport = false;
                                                      }
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
                                                        children: const [
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
                                                            style: TextStyle(
                                                              fontSize: 8,
                                                              color: _teal,
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
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          ),
                                                          Text(
                                                            c['time']
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
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
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            _channel(
                                                              entry.value,
                                                            ),
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              color:
                                                                  _channelColor(
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
                                                                fontSize: 12,
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
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '${c['count']} Contacts',
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    OutlinedButton(
                                                      onPressed: () =>
                                                          setState(() {
                                                            _selected.add(i);
                                                            _showReport = true;
                                                          }),
                                                      style: OutlinedButton.styleFrom(
                                                        minimumSize: const Size(
                                                          48,
                                                          24,
                                                        ),
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                            ),
                                                        side: const BorderSide(
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
                                                      c['amount'].toString(),
                                                      style: const TextStyle(
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
                                                    onPressed: () {},
                                                    icon: const Icon(
                                                      Icons.download_outlined,
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
                                                          _showReport = true;
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
          if (_showReport && selectedCampaign != null)
            SizedBox(
              width: mobile ? 340 : 368,
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
        ],
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
                const Row(
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
                        onPressed: () {},
                        child: const Text(
                          'Download Report',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
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
