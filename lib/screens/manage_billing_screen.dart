part of '../app.dart';

class ManageBillingScreen extends StatefulWidget {
  const ManageBillingScreen({super.key});

  @override
  State<ManageBillingScreen> createState() => _ManageBillingScreenState();
}

class _ManageBillingScreenState extends State<ManageBillingScreen> {
  int activeTab = 0;
  String channelTab = 'WhatsApp';
  String transactionFilter = 'All';
  final TextEditingController searchController = TextEditingController();
  final TextEditingController balanceController = TextEditingController(
    text: '5000',
  );
  final TextEditingController companyController = TextEditingController(
    text: 'Webtechage',
  );
  final TextEditingController phoneController = TextEditingController(
    text: '6392368875',
  );
  final TextEditingController emailController = TextEditingController(
    text: 'Vaibhav@webtechagel.com',
  );
  final TextEditingController countryController = TextEditingController(
    text: 'India',
  );
  final TextEditingController stateController = TextEditingController();
  final TextEditingController gstController = TextEditingController();
  DateTime fromDate = DateTime(2026, 10, 1);
  DateTime toDate = DateTime(2026, 10, 31);
  final List<Map<String, String>> transactions = [
    {
      'type': 'Campaigns',
      'detail': 'RCS Campaign Wallet Deduction',
      'campaign': 'real camp',
      'channel': 'RCS',
      'amount': '₹0.00',
      'date': '14 Oct 2026',
      'time': '01:15 pm',
      'debit': '₹0.28',
      'refund': '₹0.28',
      'by': '—',
    },
    {
      'type': '--',
      'detail': 'Spending ceiling raised by 30.0000 (now 30.0000) by pavan_admin: 3x rule',
      'campaign': '—',
      'channel': '',
      'amount': '−₹30.00 ↓',
      'date': '14 Oct 2026',
      'time': '09:25 am',
      'debit': '—',
      'refund': '—',
      'by': 'Pavan_admin',
    },
    {
      'type': 'Reseller Wallet Recharge',
      'detail': 'ded',
      'campaign': '—',
      'channel': '',
      'amount': '+₹23.00 ↑',
      'date': '13 Oct 2026',
      'time': '11:08 pm',
      'debit': '—',
      'refund': '—',
      'by': 'Pavan_admin',
    },
    {
      'type': 'Campaigns',
      'detail': 'RCS Campaign Wallet Deduction',
      'campaign': 'fvf',
      'channel': 'RCS',
      'amount': '₹0.00',
      'date': '13 Oct 2026',
      'time': '12:15 pm',
      'debit': '₹5.29',
      'refund': '₹5.29',
      'by': '—',
    },
    {
      'type': 'Campaigns',
      'detail': 'RCS Campaign Wallet Deduction',
      'campaign': 'dfd',
      'channel': 'RCS',
      'amount': '₹0.00',
      'date': '13 Oct 2026',
      'time': '11:52 am',
      'debit': '₹0.56',
      'refund': '₹0.56',
      'by': '—',
    },
    {
      'type': 'Wallet Recharge',
      'detail': '',
      'campaign': '—',
      'channel': '',
      'amount': '+₹5,000.00 ↑',
      'date': '13 Oct 2026',
      'time': '10:15 am',
      'debit': '—',
      'refund': '—',
      'by': 'Pavan_admin',
    },
  ];

  @override
  void dispose() {
    searchController.dispose();
    balanceController.dispose();
    companyController.dispose();
    phoneController.dispose();
    emailController.dispose();
    countryController.dispose();
    stateController.dispose();
    gstController.dispose();
    super.dispose();
  }

  String money(num n) => '₹${n.toStringAsFixed(2)}';
  double get walletAmount => double.tryParse(balanceController.text) ?? 0;

  Future<void> _downloadLedger() {
    final query = searchController.text.toLowerCase();
    final filtered = transactions.where(
      (row) =>
          row.values.join(' ').toLowerCase().contains(query) &&
          (transactionFilter == 'All' || row['type'] == transactionFilter),
    );
    const columns = [
      'type',
      'detail',
      'campaign',
      'channel',
      'amount',
      'date',
      'time',
      'debit',
      'refund',
      'by',
    ];

    return saveCsvFile(
      context,
      fileName: 'billing_ledger',
      headers: const [
        'Type',
        'Detail',
        'Campaign',
        'Channel',
        'Amount',
        'Date',
        'Time',
        'Debit',
        'Refund',
        'By',
      ],
      rows: filtered.map(
        (row) => columns.map((column) => row[column]).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      drawer: const DashboardDrawer(currentPage: 'Manage Billings'),
      appBar: buildCpxBoatAppBar(context),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 1100;
            return ListView(
              padding: EdgeInsets.fromLTRB(
                compact ? 12 : 22,
                16,
                compact ? 12 : 22,
                28,
              ),
              children: [
                const Text(
                  'Billing',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: navy,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Wallet, subscription plan, transactions, and billing details.',
                  style: TextStyle(fontSize: 12, color: muted),
                ),
                const SizedBox(height: 22),
                _summaryCards(compact),
                const SizedBox(height: 16),
                _tabs(),
                const SizedBox(height: 18),
                if (activeTab == 0) _transactionHistory(compact),
                if (activeTab == 1) _conversationCharges(compact),
                if (activeTab == 2) _walletBalance(),
                if (activeTab == 3) _billingDetails(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _topPill(Widget icon, String label) => Container(
    margin: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: const Color(0xFFF0F2F7),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: const Color(0xFFDCE2ED)),
    ),
    child: Row(
      children: [
        icon,
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: navy,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
  Widget _topIcon(IconData icon, {String? badge}) => SizedBox(
    width: 38,
    child: Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          onPressed: () =>
              showApiPendingMessage(context, 'this account shortcut'),
          padding: EdgeInsets.zero,
          icon: Icon(
            icon,
            size: 19,
            color: MediaQuery.sizeOf(context).width < 800
                ? Colors.white
                : const Color(0xFF65718A),
          ),
        ),
        if (badge != null)
          Positioned(
            right: 2,
            top: 2,
            child: Container(
              width: 15,
              height: 15,
              decoration: const BoxDecoration(
                color: Color(0xFFE94452),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                badge,
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    ),
  );

  BoxDecoration _billingCardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: const Color(0xFFDCE2ED)),
    boxShadow: const [
      BoxShadow(color: Color(0x090D1930), blurRadius: 3, offset: Offset(0, 1)),
    ],
  );
  Widget _summaryCards(bool compact) {
    final wallet = _panel(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Wallet balance',
                  style: TextStyle(fontSize: 12, color: muted),
                ),
                const SizedBox(height: 5),
                const Text(
                  '₹2.648',
                  style: TextStyle(
                    fontSize: 21,
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
              color: panelAccent(context).withValues(alpha: .11),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              color: panelAccent(context),
              size: 20,
            ),
          ),
        ],
      ),
    );
    final plan = _panel(
      padding: const EdgeInsets.all(20),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Current plan', style: TextStyle(fontSize: 12, color: muted)),
          SizedBox(height: 7),
          Text(
            'Monthly',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: navy,
            ),
          ),
        ],
      ),
    );
    return compact
        ? Column(children: [wallet, const SizedBox(height: 12), plan])
        : Row(
            children: [
              Expanded(child: wallet),
              const SizedBox(width: 14),
              Expanded(child: plan),
            ],
          );
  }

  Widget _panel({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(18),
  }) => Container(
    padding: padding,
    decoration: _billingCardDecoration(),
    child: child,
  );
  Widget _tabs() {
    const labels = [
      'Transaction History',
      'Conversation Charges',
      'Wallet Balance',
      'Billing Details',
    ];
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFD8DFEA))),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(labels.length, (i) {
            final selected = activeTab == i;
            return InkWell(
              onTap: () => setState(() => activeTab = i),
              child: Container(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 11),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: selected
                          ? panelAccent(context)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 12,
                    color: selected
                        ? panelAccent(context)
                        : const Color(0xFF58657D),
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _sectionHeading(String title, String subtitle) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: navy,
        ),
      ),
      const SizedBox(height: 3),
      Text(subtitle, style: const TextStyle(fontSize: 12, color: muted)),
    ],
  );
  Widget _field({
    String? hint,
    TextEditingController? controller,
    double width = 220,
    Widget? suffix,
  }) => SizedBox(
    width: width,
    height: 38,
    child: TextField(
      controller: controller,
      style: const TextStyle(fontSize: 12, color: navy),
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        filled: true,
        fillColor: const Color(0xFFF8F9FC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Color(0xFFD9E0EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Color(0xFFD9E0EB)),
        ),
      ),
    ),
  );
  Widget _transactionHistory(bool compact) {
    final q = searchController.text.toLowerCase();
    final filtered = transactions
        .where(
          (r) =>
              r.values.join(' ').toLowerCase().contains(q) &&
              (transactionFilter == 'All' || r['type'] == transactionFilter),
        )
        .toList();
    const headerStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );
    return _panel(
      padding: EdgeInsets.all(compact ? 12 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeading(
            'Transaction History',
            'View previous transaction details from here.',
          ),
          const SizedBox(height: 22),
          if (compact) ...[
            Row(
              children: [
                Expanded(
                  child: _field(
                    hint: 'Search',
                    controller: searchController,
                    width: double.infinity,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 38,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: transactionFilter,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8F9FC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(
                            color: Color(0xFFD9E0EB),
                          ),
                        ),
                      ),
                      items:
                          [
                                'All',
                                'Campaigns',
                                'Wallet Recharge',
                                'Reseller Wallet Recharge',
                              ]
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (v) =>
                          setState(() => transactionFilter = v ?? 'All'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: _downloadLedger,
                icon: const Icon(Icons.download_outlined, size: 16),
                label: const Text(
                  'Download Ledger',
                  style: TextStyle(fontSize: 12),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: navy,
                  side: const BorderSide(color: Color(0xFFD9E0EB)),
                ),
              ),
            ),
          ] else
            Row(
              children: [
                SizedBox(
                  width: 290,
                  child: _field(
                    hint: 'Search',
                    controller: searchController,
                    width: 290,
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 160,
                  height: 38,
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: transactionFilter,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 11,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8F9FC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(color: Color(0xFFD9E0EB)),
                      ),
                    ),
                    items:
                        [
                              'All',
                              'Campaigns',
                              'Wallet Recharge',
                              'Reseller Wallet Recharge',
                            ]
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (v) =>
                        setState(() => transactionFilter = v ?? 'All'),
                  ),
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: _downloadLedger,
                  icon: const Icon(Icons.download_outlined, size: 16),
                  label: const Text(
                    'Download Ledger',
                    style: TextStyle(fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: navy,
                    side: const BorderSide(color: Color(0xFFD9E0EB)),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: compact ? 12 : 35,
              headingRowHeight: 40,
              dataRowMinHeight: 53,
              dataRowMaxHeight: 66,
              headingRowColor: WidgetStateProperty.all(panelAccent(context)),
              border: TableBorder.all(
                color: const Color(0xFFD9E0EB),
                width: .6,
              ),
              columns: const [
                DataColumn(label: Text('Type', style: headerStyle)),
                DataColumn(label: Text('Campaign', style: headerStyle)),
                DataColumn(label: Text('Amount', style: headerStyle)),
                DataColumn(label: Text('Date | Time', style: headerStyle)),
                DataColumn(label: Text('Total Debit', style: headerStyle)),
                DataColumn(label: Text('Total Refund', style: headerStyle)),
                DataColumn(label: Text('Added By', style: headerStyle)),
              ],
              rows: filtered
                  .map(
                    (r) => DataRow(
                      cells: [
                        DataCell(
                          SizedBox(
                            width: compact ? 150 : 220,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r['type']!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: navy,
                                  ),
                                ),
                                if ((r['detail'] ?? '').isNotEmpty)
                                  Text(
                                    r['detail']!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: muted,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        DataCell(
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r['campaign']!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: navy,
                                ),
                              ),
                              if ((r['channel'] ?? '').isNotEmpty)
                                Text(
                                  r['channel']!,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: muted,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        DataCell(_amountPill(r['amount']!)),
                        DataCell(
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r['date']!,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: panelAccent(context),
                                ),
                              ),
                              Text(
                                r['time']!,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(_amountPill(r['debit']!)),
                        DataCell(_amountPill(r['refund']!)),
                        DataCell(
                          Text(
                            r['by']!,
                            style: TextStyle(
                              fontSize: 11,
                              color: panelAccent(context),
                            ),
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
  }

  Widget _amountPill(String value) {
    final positive =
        value.contains('+') ||
        value.contains('↑') ||
        value.contains('0.28') ||
        value.contains('5.29') ||
        value.contains('0.56');
    final neutral = value == '—';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: neutral
            ? Colors.transparent
            : positive
            ? const Color(0xFFE4F8ED)
            : const Color(0xFFFBE9EB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 10,
          color: neutral
              ? muted
              : positive
              ? const Color(0xFF0A9B59)
              : const Color(0xFFE34850),
        ),
      ),
    );
  }

  Widget _conversationCharges(bool compact) {
    final whatsapp = channelTab == 'WhatsApp';
    final labels = whatsapp
        ? ['Date | Time', 'Customer Number', 'Message', 'Amount', 'Wallet']
        : ['Date | Time', 'Customer Number', 'Reply Type', 'Channel', 'Amount'];
    final rows = whatsapp
        ? <DataRow>[
            const DataRow(
              cells: [
                DataCell(
                  SizedBox(
                    width: 700,
                    height: 45,
                    child: Center(
                      child: Text(
                        'No WhatsApp conversation charges in this period.',
                        style: TextStyle(fontSize: 11, color: muted),
                      ),
                    ),
                  ),
                ),
                DataCell(SizedBox()),
                DataCell(SizedBox()),
                DataCell(SizedBox()),
                DataCell(SizedBox()),
              ],
            ),
          ]
        : List<DataRow>.generate(
            5,
            (i) => DataRow(
              cells: [
                DataCell(
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '08 Oct 2026',
                        style: TextStyle(
                          fontSize: 10,
                          color: panelAccent(context),
                        ),
                      ),
                      Text(
                        '12:${38 - i} pm',
                        style: const TextStyle(fontSize: 10, color: muted),
                      ),
                    ],
                  ),
                ),
                const DataCell(
                  Text(
                    '7337522120',
                    style: TextStyle(fontSize: 11, color: navy),
                  ),
                ),
                const DataCell(
                  Text(
                    'Inbox Reply',
                    style: TextStyle(fontSize: 10, color: muted),
                  ),
                ),
                const DataCell(
                  Text('RCS', style: TextStyle(fontSize: 11, color: navy)),
                ),
                const DataCell(
                  Text(
                    '−₹0.13 ↓',
                    style: TextStyle(fontSize: 10, color: Color(0xFFE34850)),
                  ),
                ),
              ],
            ),
          );
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: const Color(0xFFE9EDF4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: ['WhatsApp', 'RCS']
                  .map(
                    (v) => InkWell(
                      onTap: () => setState(() => channelTab = v),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: channelTab == v
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: channelTab == v
                              ? Border.all(color: const Color(0xFFD8DFEA))
                              : null,
                        ),
                        child: Text(
                          v,
                          style: TextStyle(
                            fontSize: 11,
                            color: navy,
                            fontWeight: channelTab == v
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 14),
        if (whatsapp)
          _panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.card_giftcard_outlined,
                      color: panelAccent(context),
                      size: 17,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Free service messages this month',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: navy,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  "Replies that aren't templates (inbox replies, chatbot / AI bot replies, automations): the first 1,000 per WhatsApp number each month are free, then each is charged at your plan's Service price. Messages customers send you are always free.",
                  style: TextStyle(fontSize: 11, color: muted),
                ),
                const SizedBox(height: 20),
                const Text(
                  'No service messages sent yet this month — all 1,000 free messages are available.',
                  style: TextStyle(fontSize: 11, color: muted),
                ),
              ],
            ),
          )
        else
          _panel(
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RCS conversation pricing',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: navy,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'RCS conversation messages you send — Inbox text replies and chatbot auto-replies — are charged at your plan’s Conversation price. Customer messages you receive are free; template sends are charged as campaigns.',
                  style: TextStyle(fontSize: 11, color: muted),
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        _statCards(compact, whatsapp),
        const SizedBox(height: 12),
        _panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$channelTab Conversation Charges',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: navy,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                whatsapp
                    ? 'Service messages charged after the free allowance, and templates sent from the Inbox or CRM automations. Campaign messages are listed under their campaigns. If WhatsApp reports a message as failed, its charge is refunded automatically.'
                    : 'RCS conversation messages you sent — Inbox text replies and chatbot auto-replies — charged at your plan\'s Conversation price.',
                style: const TextStyle(fontSize: 11, color: muted),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _dateField(fromDate, (d) => setState(() => fromDate = d)),
                  _dateField(toDate, (d) => setState(() => toDate = d)),
                  FilledButton.icon(
                    onPressed: () => setState(() {}),
                    icon: const Icon(Icons.search, size: 15),
                    label: const Text('Apply'),
                    style: FilledButton.styleFrom(
                      backgroundColor: panelAccent(context),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowHeight: 38,
                  dataRowMinHeight: 48,
                  dataRowMaxHeight: 54,
                  columnSpacing: compact ? 24 : 70,
                  headingRowColor: WidgetStateProperty.all(
                    panelAccent(context),
                  ),
                  border: TableBorder.all(
                    color: const Color(0xFFD9E0EB),
                    width: .6,
                  ),
                  columns: labels
                      .map(
                        (t) => DataColumn(
                          label: Text(
                            t,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  rows: rows,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statCards(bool compact, bool whatsapp) {
    final a = _statCard(
      whatsapp ? 'Charged Messages' : 'Conversation Replies',
      whatsapp ? '0' : '24',
      Icons.forum_outlined,
      panelAccent(context),
    );
    final b = _statCard(
      'Total Charged (₹)',
      whatsapp ? '0' : '3.12',
      Icons.account_balance_wallet_outlined,
      const Color(0xFFE85B62),
    );
    return compact
        ? Column(children: [a, const SizedBox(height: 12), b])
        : Row(
            children: [
              Expanded(child: a),
              const SizedBox(width: 12),
              Expanded(child: b),
            ],
          );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) =>
      _panel(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 11, color: muted),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: navy,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: color, size: 19),
            ),
          ],
        ),
      );
  Widget _dateField(
    DateTime date,
    ValueChanged<DateTime> onChanged,
  ) => SizedBox(
    width: 160,
    height: 38,
    child: OutlinedButton.icon(
      onPressed: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2035),
        );
        if (d != null) onChanged(d);
      },
      icon: const Icon(Icons.calendar_today_outlined, size: 13),
      label: Text(
        '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}',
        style: const TextStyle(fontSize: 11),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: navy,
        alignment: Alignment.centerLeft,
        side: const BorderSide(color: Color(0xFFD9E0EB)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      ),
    ),
  );

  Widget _walletBalance() {
    final gst = walletAmount * .18;
    final fee = walletAmount * .02;
    return _panel(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Balance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: navy,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Top up your wallet to keep campaigns running.',
            style: TextStyle(fontSize: 11, color: muted),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 320,
            child: TextField(
              controller: balanceController,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                filled: true,
                fillColor: const Color(0xFFF8F9FC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: const BorderSide(color: Color(0xFFD9E0EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: const BorderSide(color: Color(0xFFD9E0EB)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: [5000, 10000, 15000, 20000]
                .map(
                  (n) => OutlinedButton(
                    onPressed: () {
                      balanceController.text = '$n';
                      setState(() {});
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      minimumSize: const Size(0, 28),
                      foregroundColor: walletAmount == n
                          ? panelAccent(context)
                          : muted,
                      side: BorderSide(
                        color: walletAmount == n
                            ? panelAccent(context)
                            : const Color(0xFFD9E0EB),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      '₹${n.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 14),
          Container(
            width: 322,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD9E0EB)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _priceRow('Wallet amount', money(walletAmount)),
                _priceRow('GST (18%)', money(gst)),
                _priceRow('Payment gateway fee (2%)', money(fee)),
                const Divider(height: 14),
                _priceRow(
                  'Total amount',
                  money(walletAmount + gst + fee),
                  bold: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: 322,
            height: 38,
            child: FilledButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment flow is not connected yet.'),
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: panelAccent(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: const Text(
                'Proceed to Payment',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '*Only for Indian customers',
            style: TextStyle(fontSize: 10, color: muted),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool bold = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: bold ? navy : muted,
              fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            color: navy,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ],
    ),
  );

  Widget _billingDetails() => _panel(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Billing details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: navy,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Used for invoices and account communication.',
                    style: TextStyle(fontSize: 11, color: muted),
                  ),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: _editBillingDetails,
              style: OutlinedButton.styleFrom(
                foregroundColor: navy,
                side: const BorderSide(color: Color(0xFFD9E0EB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: const Text(
                'Edit billing details',
                style: TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: 370,
          child: Column(
            children: [
              _detailRow('Company name', companyController.text),
              _detailRow('Contact number', phoneController.text),
              _detailRow('Email address', emailController.text),
              _detailRow('Country', countryController.text),
              _detailRow(
                'State',
                stateController.text.isEmpty ? '—' : stateController.text,
              ),
              _detailRow(
                'GSTIN',
                gstController.text.isEmpty ? '—' : gstController.text,
              ),
            ],
          ),
        ),
      ],
    ),
  );
  Widget _detailRow(String label, String value) => Container(
    padding: const EdgeInsets.symmetric(vertical: 10),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: Color(0xFFE4E8F0))),
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 11, color: muted),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 11,
              color: navy,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
  void _editBillingDetails() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit billing details'),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  [
                        [companyController, 'Company name'],
                        [phoneController, 'Contact number'],
                        [emailController, 'Email address'],
                        [countryController, 'Country'],
                        [stateController, 'State'],
                        [gstController, 'GSTIN'],
                      ]
                      .map(
                        (pair) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: TextField(
                            controller: pair[0] as TextEditingController,
                            decoration: InputDecoration(
                              labelText: pair[1] as String,
                              border: const OutlineInputBorder(),
                            ),
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(
              backgroundColor: panelAccent(context),
            ),
            child: const Text('Save changes'),
          ),
        ],
      ),
    );
  }
}
