part of '../app.dart';

class WhatsAppCommerceScreen extends StatefulWidget {
  const WhatsAppCommerceScreen({super.key});

  @override
  State<WhatsAppCommerceScreen> createState() => _WhatsAppCommerceScreenState();
}

class _WhatsAppCommerceScreenState extends State<WhatsAppCommerceScreen> {
  int _tab = 0;
  String _orderFilter = 'All orders';
  String _orderSearch = '';
  bool _showGuide = true;
  final TextEditingController _orderSearchController = TextEditingController();
  final List<_CommerceRecord> _batches = [
    _CommerceRecord(
      'Sample Batch',
      'Created to test the Commerce > Batches UI.',
      '2026-09-28',
    ),
  ];
  final List<_CommerceRecord> _categories = [
    _CommerceRecord(
      'Sample Category',
      'Created to test the Commerce > Categories UI.',
      '2026-09-28',
    ),
  ];

  @override
  void dispose() {
    _orderSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 850;
    return Scaffold(
      drawer: const DashboardDrawer(currentPage: 'Commerce'),
      appBar: buildCpxBoatAppBar(context),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(wide ? 22 : 13),
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F3F7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: panelAccent(context),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Commerce',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: navy,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Sell from your Meta catalog on WhatsApp. Track orders, organise products and manage catalog settings.',
                        style: TextStyle(fontSize: 12, color: muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            if (_showGuide) _guideCard(),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(4, (index) {
                  const labels = [
                    'Orders',
                    'Batches',
                    'Categories',
                    'Settings',
                  ];
                  final active = _tab == index;
                  return InkWell(
                    onTap: () => setState(() => _tab = index),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 13, 16, 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: active
                                ? panelAccent(context)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        labels[index],
                        style: TextStyle(
                          fontSize: 13,
                          color: active
                              ? panelAccent(context)
                              : const Color(0xFF526078),
                          fontWeight: active
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const Divider(height: 1, color: Color(0xFFDCE2ED)),
            const SizedBox(height: 22),
            if (_tab == 0) _ordersContent(wide),
            if (_tab == 1) _recordsContent(isBatch: true),
            if (_tab == 2) _recordsContent(isBatch: false),
            if (_tab == 3) _settingsContent(),
          ],
        ),
      ),
    );
  }

  Widget _guideCard() {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: _cardDecoration(radius: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F5F8),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  Icons.menu_book_outlined,
                  color: panelAccent(context),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New to WhatsApp Commerce? Start here',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: navy,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'What each part of this page does — and which parts change your real WhatsApp account.',
                      style: TextStyle(fontSize: 11, color: muted),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => setState(() => _showGuide = false),
                icon: const Icon(Icons.keyboard_arrow_up, size: 16),
                label: const Text('Hide guide'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: navy,
                  side: const BorderSide(color: Color(0xFFDCE2ED)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          LayoutBuilder(
            builder: (context, c) {
              final two = c.maxWidth > 720;
              final width = two ? (c.maxWidth - 12) / 2 : c.maxWidth;
              final cards = [
                _guideItem(
                  Icons.storefront_outlined,
                  'Your Meta catalog',
                  'Meta feature',
                  'A catalog is your product list (name, photo, price, SKU) kept by Meta. You add and edit products in Meta Commerce Manager, not in this panel.\n\nOnce a catalog is connected to your WhatsApp Business Account, customers can browse it in the chat, add items to a cart and send you the cart.',
                ),
                _guideItem(
                  Icons.tune_rounded,
                  'Settings',
                  'Changes your Meta account',
                  'Catalog visibility shows or hides your catalog (shop) button in chats and on your WhatsApp business profile. Add to cart lets customers build a cart and send it as an order.\n\nThese switches change the real WhatsApp number, straight away. Connecting or disconnecting a catalog does too.',
                ),
                _guideItem(
                  Icons.receipt_long_outlined,
                  'Orders',
                  'From WhatsApp',
                  'When a customer sends a cart from your catalog, WhatsApp passes it to us and it shows up here. Only cart orders from a connected catalog appear here. Ordinary chat messages don’t.\n\nWhatsApp doesn’t send payment or delivery information. The order status is your own record for keeping track.',
                ),
                _guideItem(
                  Icons.layers_outlined,
                  'Batches & Categories',
                  'This panel only',
                  'Batches and Categories are ways to organise your catalog products inside this panel, for example “Diwali offer” or “Shoes”.\n\nThey are not Meta features. Customers never see them on WhatsApp, and they don’t change your catalog.',
                ),
              ];
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: cards
                    .map((card) => SizedBox(width: width, child: card))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _guideItem(IconData icon, String title, String badge, String body) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFDCE2ED)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE5F5F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: panelAccent(context), size: 19),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: navy,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: badge.startsWith('Changes')
                            ? const Color(0xFFFFF4E5)
                            : badge.startsWith('From')
                            ? const Color(0xFFE5FAEF)
                            : badge.startsWith('This')
                            ? const Color(0xFFEEF0F5)
                            : const Color(0xFFE4F6FA),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(
                          fontSize: 10,
                          color: badge.startsWith('Changes')
                              ? const Color(0xFFB45309)
                              : badge.startsWith('From')
                              ? const Color(0xFF07945B)
                              : badge.startsWith('This')
                              ? muted
                              : panelAccent(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  body,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.55,
                    color: muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ordersContent(bool wide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, c) {
            final spacing = 14.0;
            final w = (c.maxWidth - spacing * 3) / 4;
            final cards = [
              _statCard(
                Icons.shopping_cart_outlined,
                'TOTAL ORDERS',
                '0',
                panelAccent(context),
              ),
              _statCard(
                Icons.check_circle_outline,
                'DELIVERED',
                '0',
                const Color(0xFF16A878),
                'Marked delivered by you',
              ),
              _statCard(
                Icons.local_shipping_outlined,
                'IN PROGRESS',
                '0',
                const Color(0xFFF59E0B),
                '0 new, not yet handled',
              ),
              _statCard(
                Icons.account_balance_wallet_outlined,
                'ORDER VALUE',
                '—',
                const Color(0xFF718096),
                'Cart value, excluding cancelled. Not payments received.',
              ),
            ];
            return Wrap(
              spacing: spacing,
              runSpacing: 12,
              children: cards
                  .map(
                    (card) => SizedBox(
                      width: c.maxWidth < 650 ? c.maxWidth : w,
                      child: card,
                    ),
                  )
                  .toList(),
            );
          },
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDCE2ED)),
            borderRadius: BorderRadius.circular(9),
            color: const Color(0xFFF3F5FA),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, size: 17, color: muted),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Orders appear here when a customer sends a cart from your WhatsApp catalog. WhatsApp includes the products, quantities and prices, but no payment or delivery information. Collect payment the way you normally do. The status column is your own record. Changing it doesn’t message the customer or change anything at Meta.',
                  style: TextStyle(fontSize: 11, color: muted),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: _cardDecoration(radius: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Orders',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: navy,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Newest first. Search by customer name, number, order number or product SKU.',
                style: TextStyle(fontSize: 12, color: muted),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 20,
                children:
                    [
                          'All orders',
                          'New',
                          'In progress',
                          'Delivered',
                          'Cancelled',
                        ]
                        .map(
                          (f) => InkWell(
                            onTap: () => setState(() => _orderFilter = f),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: _orderFilter == f
                                        ? panelAccent(context)
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Text(
                                f,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _orderFilter == f
                                      ? panelAccent(context)
                                      : const Color(0xFF526078),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
              const Divider(height: 1, color: Color(0xFFDCE2ED)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: wide ? 275 : 230,
                    child: TextField(
                      controller: _orderSearchController,
                      onChanged: (v) => setState(() => _orderSearch = v),
                      decoration: _commerceInput('Search orders', Icons.search),
                    ),
                  ),
                  SizedBox(
                    width: 135,
                    child: TextField(
                      decoration: _commerceInput(
                        'dd-mm-yyyy',
                        Icons.calendar_today_outlined,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 135,
                    child: TextField(
                      decoration: _commerceInput(
                        'dd-mm-yyyy',
                        Icons.calendar_today_outlined,
                      ),
                    ),
                  ),
                  const Text(
                    'Show',
                    style: TextStyle(fontSize: 11, color: muted),
                  ),
                  DropdownButton<int>(
                    value: 25,
                    items: const [25, 50, 100]
                        .map(
                          (v) => DropdownMenuItem(value: v, child: Text('$v')),
                        )
                        .toList(),
                    onChanged: (_) {},
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFDCE2ED)),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(
                      panelAccent(context),
                    ),
                    headingTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    columns: const [
                      DataColumn(label: Text('Order')),
                      DataColumn(label: Text('Customer')),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Products')),
                      DataColumn(label: Text('Amount')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: const [
                      DataRow(
                        cells: [
                          DataCell(
                            SizedBox(
                              width: 210,
                              child: Center(
                                child: Text(
                                  'No orders yet. They’ll appear here when customers send a cart from your WhatsApp catalog.',
                                  style: TextStyle(color: muted, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          DataCell(SizedBox()),
                          DataCell(SizedBox()),
                          DataCell(SizedBox()),
                          DataCell(SizedBox()),
                          DataCell(SizedBox()),
                          DataCell(SizedBox()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statCard(
    IconData icon,
    String label,
    String value,
    Color color, [
    String? note,
  ]) {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: _cardDecoration(radius: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, color: muted)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 23,
                    height: 1,
                    fontWeight: FontWeight.w800,
                    color: navy,
                  ),
                ),
                if (note != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    note,
                    style: const TextStyle(fontSize: 10, color: muted),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _recordsContent({required bool isBatch}) {
    final records = isBatch ? _batches : _categories;
    final noun = isBatch ? 'batch' : 'category';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(13),
          constraints: const BoxConstraints(maxWidth: 760),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F5FA),
            border: Border.all(color: const Color(0xFFDCE2ED)),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, size: 17, color: muted),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isBatch
                      ? 'A batch is a hand-picked set of products, for example one offer, one season or one campaign. Use it to keep track of which products belong together. Batches are only kept in this panel. They aren’t a Meta feature, customers don’t see them on WhatsApp, and they never change your catalog.'
                      : 'A category is a label for a type of product, for example Shoes or Kitchen. Use it to find products quickly and keep your catalog organised in this panel. Categories are only kept in this panel. They aren’t a Meta feature, customers don’t see them on WhatsApp, and they never change your catalog.',
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.45,
                    color: muted,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: () => _createRecord(isBatch),
            icon: const Icon(Icons.add, size: 18),
            label: Text('Create $noun'),
            style: FilledButton.styleFrom(
              backgroundColor: panelAccent(context),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: records
              .map(
                (record) => SizedBox(
                  width: 500,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: _cardDecoration(radius: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE4F5F8),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                isBatch
                                    ? Icons.hub_outlined
                                    : Icons.sell_outlined,
                                color: panelAccent(context),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    record.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: navy,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    record.description,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5FAEF),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Active',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF07945B),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Wrap(
                          spacing: 14,
                          runSpacing: 5,
                          children: [
                            const Text(
                              '◇  0 products',
                              style: TextStyle(fontSize: 10, color: muted),
                            ),
                            const Text(
                              'WABA 891829130081235',
                              style: TextStyle(fontSize: 10, color: muted),
                            ),
                            Text(
                              'Created ${record.created}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: muted,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 22, color: Color(0xFFDCE2ED)),
                        Wrap(
                          spacing: 6,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => _recordMessage(record, 'View'),
                              icon: const Icon(
                                Icons.visibility_outlined,
                                size: 15,
                              ),
                              label: const Text('View'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => _editRecord(record, isBatch),
                              icon: const Icon(Icons.edit_outlined, size: 15),
                              label: const Text('Edit'),
                            ),
                            TextButton.icon(
                              onPressed: () =>
                                  setState(() => records.remove(record)),
                              icon: const Icon(
                                Icons.archive_outlined,
                                size: 15,
                              ),
                              label: const Text('Archive'),
                            ),
                            IconButton(
                              onPressed: () =>
                                  setState(() => records.remove(record)),
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _settingsContent() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(radius: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4E5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.storefront_outlined,
              color: Color(0xFFF59E0B),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Commerce settings aren’t available for this number',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: navy,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'This WhatsApp account isn’t set up for Commerce yet — it needs to complete Meta’s Joint Solution setup.',
                  style: TextStyle(fontSize: 12, color: muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _commerceInput(String hint, IconData icon) => InputDecoration(
    hintText: hint,
    prefixIcon: Icon(icon, size: 17),
    filled: true,
    fillColor: Colors.white,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: Color(0xFFDDE3ED)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: Color(0xFFDDE3ED)),
    ),
  );

  void _createRecord(bool isBatch) {
    final controller = TextEditingController();
    final descriptionController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Create ${isBatch ? 'batch' : 'category'}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: '${isBatch ? 'Batch' : 'Category'} name',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(
                  () => (isBatch ? _batches : _categories).insert(
                    0,
                    _CommerceRecord(
                      controller.text.trim(),
                      descriptionController.text.trim().isEmpty
                          ? 'Created in Commerce panel.'
                          : descriptionController.text.trim(),
                      '2026-10-14',
                    ),
                  ),
                );
              }
              Navigator.pop(dialogContext);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _editRecord(_CommerceRecord record, bool isBatch) {
    final controller = TextEditingController(text: record.name);
    final descriptionController = TextEditingController(
      text: record.description,
    );
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Edit ${isBatch ? 'batch' : 'category'}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: '${isBatch ? 'Batch' : 'Category'} name',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                record.name = controller.text.trim().isEmpty
                    ? record.name
                    : controller.text.trim();
                record.description = descriptionController.text.trim();
              });
              Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _recordMessage(_CommerceRecord record, String action) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$action: ${record.name}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
}
