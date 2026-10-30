part of '../app.dart';

class ChannelsInfoScreen extends StatefulWidget {
  const ChannelsInfoScreen({super.key});

  @override
  State<ChannelsInfoScreen> createState() => _ChannelsInfoScreenState();
}

class _ChannelsInfoScreenState extends State<ChannelsInfoScreen> {
  String _detail = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openDetail(String channel) => setState(() => _detail = channel);
  void _backToChannels() => setState(() => _detail = '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DashboardDrawer(currentPage: 'Channels Info'),
      appBar: buildCpxBoatAppBar(context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 700;
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              compact ? 12 : 18,
              14,
              compact ? 12 : 18,
              22,
            ),
            child: _detail.isEmpty ? _overview(compact) : _detailPage(compact),
          );
        },
      ),
    );
  }

  Widget _headerPill(IconData icon, String text) => Container(
    margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: const Color(0xFFF0F3F8),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFDCE2EC)),
    ),
    child: Row(
      children: [
        Icon(icon, size: 14, color: panelAccent(context)),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontSize: 10,
            color: navy,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );

  Widget _headerIcon(IconData icon, {String? badge}) => SizedBox(
    width: 37,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Icon(icon, size: 17, color: const Color.fromARGB(255, 254, 254, 254)),
        if (badge != null)
          Positioned(
            right: 3,
            top: 3,
            child: Container(
              width: 13,
              height: 13,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFEF4444),
                shape: BoxShape.circle,
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    ),
  );

  Widget _overview(bool compact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Channels Info',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: navy,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'View and manage the channels connected to your account.',
          style: TextStyle(fontSize: 12, color: muted),
        ),
        const SizedBox(height: 20),
        _panel(
          'Connected channels',
          'Channels currently active on your account — click one to see its details.',
          child: _responsiveGrid(compact, [
            _connectedCard('RCS', Icons.sms_rounded, const Color(0xFF4387F7)),
            _connectedCard(
              'WhatsApp',
              Icons.chat_rounded,
              const Color(0xFF18C96A),
              isWhatsApp: true,
            ),
            _connectedCard(
              'SMS',
              Icons.message_rounded,
              const Color(0xFFFFB600),
            ),
          ]),
        ),
        const SizedBox(height: 14),
        _panel(
          'Available channels',
          'Connect additional channels to reach customers everywhere.',
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FAFC),
                  border: Border.all(color: const Color(0xFFB7E7EF)),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Row(
                  children: [
                    Icon(Icons.link, size: 14, color: panelAccent(context)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Connect any two of RCS, WhatsApp, or SMS and we’ll give you the Fallback channel free — if a message fails on one channel, it automatically retries on the next.',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF526B82),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _responsiveGrid(compact, [
                _availableCard('Instagram', 'assets/insta_logo.png'),
                _availableCard('Facebook', 'assets/fb_logo.png'),
                _availableCard('Email', 'assets/mail.png'),
                _availableCard('Web Widget', Icons.web_rounded),
              ]),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FAFC),
                  border: Border.all(color: const Color(0xFFB7E7EF)),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: compact
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _fallbackInfo(),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: _fallbackButton(),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Icon(
                            Icons.hub_outlined,
                            size: 30,
                            color: panelAccent(context),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: _fallbackInfo()),
                          _fallbackButton(),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _fallbackInfo() => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'You’ve unlocked Fallback channel',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: navy,
        ),
      ),
      SizedBox(height: 4),
      Text(
        'Since you’ve connected 3 channels, you can set a priority order (e.g. WhatsApp → RCS → SMS) and CPXBOAT will automatically retry on the next channel if a message fails to deliver on the first.',
        style: TextStyle(fontSize: 10, color: muted),
      ),
    ],
  );
  Widget _fallbackButton() => FilledButton.icon(
    onPressed: () => ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Fallback setup selected'))),
    style: FilledButton.styleFrom(
      backgroundColor: panelAccent(context),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
    icon: const SizedBox.shrink(),
    label: const Text(
      'Set up Fallback  →',
      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
    ),
  );

  Widget _responsiveGrid(bool compact, List<Widget> children) {
    if (compact) {
      return Column(
        children: children
            .map(
              (w) =>
                  Padding(padding: const EdgeInsets.only(bottom: 8), child: w),
            )
            .toList(),
      );
    }
    return LayoutBuilder(
      builder: (context, box) {
        final columns = box.maxWidth < 950 ? 2 : 3;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: children
              .map(
                (w) => SizedBox(
                  width: (box.maxWidth - (columns - 1) * 10) / columns,
                  child: w,
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _connectedCard(
    String name,
    IconData icon,
    Color color, {
    bool isWhatsApp = false,
  }) => InkWell(
    onTap: () => _openDetail(name),
    borderRadius: BorderRadius.circular(9),
    child: Container(
      height: 67,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD9E0EC)),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: isWhatsApp
                    ? Image.asset(
                        'assets/whatsapp.png',
                        width: 19,
                        height: 19,
                        fit: BoxFit.contain,
                      )
                    : Icon(icon, size: 15, color: Colors.white),
              ),
              const Spacer(),
              const Icon(
                Icons.check_circle_outline,
                size: 10,
                color: Color(0xFF27A56A),
              ),
              const SizedBox(width: 3),
              const Text(
                'Connected',
                style: TextStyle(fontSize: 8, color: Color(0xFF269C67)),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: navy,
                ),
              ),
              const Spacer(),
              const Icon(Icons.chevron_right, size: 14, color: muted),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _availableCard(String name, dynamic icon) => Container(
    constraints: const BoxConstraints(minHeight: 108),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFFD9E0EC)),
      borderRadius: BorderRadius.circular(9),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFFA4A8AD),
                borderRadius: BorderRadius.circular(6),
              ),
              child: icon is String
                  ? Padding(
                      padding: const EdgeInsets.all(4),
                      child: Image.asset(
                        icon,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.white,
                              size: 45,
                            ),
                      ),
                    )
                  : Icon(icon as IconData, color: Colors.white, size: 15),
            ),
            const Spacer(),
            const Icon(
              Icons.lock_outline,
              size: 12,
              color: Color.fromARGB(255, 252, 252, 253),
            ),
          ],
        ),
        const SizedBox(height: 7),
        Text(
          name,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: navy,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Not connected yet.',
          style: TextStyle(fontSize: 9, color: muted),
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton(
            onPressed: () => ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Connect $name selected'))),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 25),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              side: const BorderSide(color: Color(0xFFD9E0EC)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Text(
              'Connect channel',
              style: TextStyle(fontSize: 9, color: navy),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _panel(String title, String subtitle, {required Widget child}) =>
      Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 0),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFD9E0EC)),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: navy,
              ),
            ),
            const SizedBox(height: 3),
            Text(subtitle, style: const TextStyle(fontSize: 10, color: muted)),
            const SizedBox(height: 13),
            child,
          ],
        ),
      );

  Widget _detailPage(bool compact) {
    final isRcs = _detail == 'RCS';
    final isWhatsapp = _detail == 'WhatsApp';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Channels Info',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: navy,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'View and manage the channels connected to your account.',
          style: TextStyle(fontSize: 12, color: muted),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: _backToChannels,
          child: Row(
            children: [
              const Icon(Icons.arrow_back, size: 15, color: muted),
              const SizedBox(width: 6),
              const Text(
                'Channel Info / ',
                style: TextStyle(fontSize: 12, color: muted),
              ),
              Text(
                _detail,
                style: const TextStyle(
                  fontSize: 12,
                  color: navy,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          isRcs
              ? 'View RCS channel details from here.'
              : isWhatsapp
              ? 'View WhatsApp channel details from here.'
              : 'View SMS channel details from here.',
          style: const TextStyle(fontSize: 12, color: muted),
        ),
        const SizedBox(height: 15),
        if (isRcs)
          _rcsDetails(compact)
        else if (isWhatsapp)
          _whatsappDetails(compact)
        else
          _smsDetails(compact),
      ],
    );
  }

  Widget _rcsDetails(bool compact) => Column(
    children: [
      _panel(
        '',
        '',
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cols = constraints.maxWidth < 650 ? 1 : 3;
            final entries = <List<String>>[
              ['Channel Name', 'RCS'],
              ['Status', 'Connected'],
              ['Username', 'Vaibhav'],
              ['First Name', '--'],
              ['Last Name', '--'],
              ['Mobile Number', '6392368875'],
              ['Email Id', 'Vaibhav@webtechagel.com'],
              ['Country', 'India'],
            ];
            return Wrap(
              spacing: 10,
              runSpacing: 13,
              children: entries.map((entry) {
                return SizedBox(
                  width: (constraints.maxWidth - (cols - 1) * 10) / cols,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry[0],
                        style: const TextStyle(fontSize: 10, color: muted),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        entry[1],
                        style: const TextStyle(
                          fontSize: 11,
                          color: navy,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
      const SizedBox(height: 12),
      _panel(
        'Your RCS bots',
        'Each category sends as its own bot — pick one when creating a template.',
        child: _responsiveGrid(compact, [
          _botCard(
            'PROMOTIONAL',
            'VISHAL GENERAL',
            'Connected 9/28/2026, 8:50:17 PM',
            const Color(0xFF8B5CF6),
            Icons.campaign_outlined,
          ),
          _botCard(
            'TRANSACTIONAL',
            'VISHAL GENERAL',
            'Connected 9/30/2026, 12:07:04 PM',
            const Color(0xFF3B82F6),
            Icons.swap_horiz_rounded,
          ),
          _botCard(
            'OTP',
            '',
            'Not connected yet.',
            const Color(0xFFD9DEE8),
            Icons.key_outlined,
            connected: false,
          ),
        ]),
      ),
    ],
  );

  Widget _botCard(
    String category,
    String name,
    String status,
    Color top,
    IconData icon, {
    bool connected = true,
  }) => Container(
    height: 86,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFFD9E0EC)),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 3,
          decoration: BoxDecoration(
            color: top,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            Icon(icon, size: 14, color: top),
            const SizedBox(width: 6),
            Text(
              category,
              style: const TextStyle(
                fontSize: 9,
                color: Color(0xFF53627A),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (name.isNotEmpty) ...[
          const SizedBox(height: 5),
          Text(
            name,
            style: const TextStyle(
              fontSize: 10,
              color: navy,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        const Spacer(),
        Row(
          children: [
            Icon(
              Icons.circle,
              size: 5,
              color: connected
                  ? const Color(0xFF28A66B)
                  : const Color(0xFFD6DCE5),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                status,
                style: const TextStyle(fontSize: 9, color: muted),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _whatsappDetails(bool compact) => _panel(
    'Connected WhatsApp Accounts',
    'WhatsApp Business Accounts connected via embedded signup.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: compact ? double.infinity : 260,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Search by username...',
              prefixIcon: const Icon(Icons.search, size: 16),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              filled: true,
              fillColor: const Color(0xFFF7F9FC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFD9E0EC)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFD9E0EC)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 25,
            headingRowHeight: 36,
            dataRowMinHeight: 56,
            dataRowMaxHeight: 65,
            headingRowColor: WidgetStateProperty.all(panelAccent(context)),
            columns: const [
              DataColumn(
                label: Text(
                  'User Info',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Display Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Phone Number',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Status',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Quality',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Info',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Meta Timeline',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Actions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
            rows: ['Vaibhav']
                .where((u) => u.contains(_searchController.text.toLowerCase()))
                .map(
                  (u) => DataRow(
                    cells: [
                      DataCell(
                        const SizedBox(
                          width: 145,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Vaibhav',
                                style: TextStyle(fontSize: 10, color: navy),
                              ),
                              Text(
                                'Vaibhav@webtechagel.com',
                                style: TextStyle(fontSize: 9, color: muted),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const DataCell(
                        Text(
                          'Webtechage Pvt Ltd',
                          style: TextStyle(fontSize: 10, color: navy),
                        ),
                      ),
                      const DataCell(
                        Text(
                          '+1 555 944 0081',
                          style: TextStyle(fontSize: 10, color: navy),
                        ),
                      ),
                      DataCell(
                        _statusChip(
                          'Connected',
                          const Color(0xFFE2F9ED),
                          const Color(0xFF168653),
                        ),
                      ),
                      DataCell(
                        _statusChip(
                          'GREEN',
                          const Color(0xFFE2F9ED),
                          const Color(0xFF168653),
                        ),
                      ),
                      const DataCell(
                        SizedBox(
                          width: 165,
                          child: Text(
                            'WABA: 891829130081235\nTier: TIER_UNLIMITED\nWhatsApp level: --',
                            style: TextStyle(fontSize: 9, color: muted),
                          ),
                        ),
                      ),
                      const DataCell(
                        SizedBox(
                          width: 170,
                          child: Text(
                            'Created 10/24/2025, 1:54:40 PM\nUpdated 8/22/2026, 1:24:50 PM',
                            style: TextStyle(fontSize: 9, color: muted),
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              tooltip: 'Refresh',
                              onPressed: () => showApiPendingMessage(
                                context,
                                'channel refresh',
                              ),
                              icon: const Icon(Icons.refresh_rounded, size: 15),
                            ),
                            IconButton(
                              tooltip: 'Sync',
                              onPressed: () => showApiPendingMessage(
                                context,
                                'channel synchronization',
                              ),
                              icon: const Icon(Icons.sync_rounded, size: 15),
                            ),
                            IconButton(
                              tooltip: 'Disconnect',
                              onPressed: () => showApiPendingMessage(
                                context,
                                'channel disconnection',
                              ),
                              icon: const Icon(
                                Icons.link_off_rounded,
                                size: 15,
                                color: Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ],
    ),
  );

  Widget _statusChip(String text, Color bg, Color fg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: 9, color: fg, fontWeight: FontWeight.w700),
    ),
  );

  Widget _smsDetails(bool compact) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFFD9E0EC)),
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [
        BoxShadow(
          color: Color(0x08000000),
          blurRadius: 3,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth < 650 ? 1 : 3;
        const entries = <List<String>>[
          ['PE Registration ID', '1201159186502183560'],
          ['Registered Mobile Number', '6392368875'],
          ['Country', 'India'],
          ['Registered E-mail ID', 'Vaibhav@webtechagel.com'],
          ['Organization name', 'Webtechage'],
        ];
        return Wrap(
          spacing: 16,
          runSpacing: 18,
          children: entries.map((entry) {
            return SizedBox(
              width: (constraints.maxWidth - (cols - 1) * 16) / cols,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry[0],
                    style: const TextStyle(fontSize: 10, color: muted),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry[1],
                    style: const TextStyle(
                      fontSize: 11,
                      color: navy,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    ),
  );
}
