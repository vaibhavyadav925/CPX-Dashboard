part of '../app.dart';

class WhatsAppBusinessProfileScreen extends StatelessWidget {
  const WhatsAppBusinessProfileScreen({super.key});

  InputDecoration _fieldDecoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFFADB6C5), fontSize: 12),
    filled: true,
    fillColor: const Color(0xFFFBFCFE),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFE7EBF2)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFE7EBF2)),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFE7EBF2)),
    ),
  );

  Widget _label(String value) => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Text(
      value,
      style: const TextStyle(
        color: Color(0xFF11182B),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  Widget _counter(String value) => Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Text(value, style: const TextStyle(fontSize: 10, color: muted)),
  );

  Widget _readOnlyField(String hint, {int maxLines = 1}) => TextField(
    enabled: false,
    maxLines: maxLines,
    decoration: _fieldDecoration(hint),
  );

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 850;
    return Scaffold(
      drawer: const DashboardDrawer(currentPage: 'Business Profile'),
      appBar: buildCpxBoatAppBar(context),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(wide ? 22 : 13),
          children: [
            const Text(
              'Business Profile',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: navy,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'What customers see when they open your WhatsApp business info, as set on Meta.',
              style: TextStyle(fontSize: 12, color: muted),
            ),
            const SizedBox(height: 22),
            Container(
              padding: EdgeInsets.all(wide ? 23 : 15),
              decoration: _cardDecoration(radius: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Read-only for this account — update it from Meta Business Manager or WhatsApp Manager instead.',
                    style: TextStyle(fontSize: 12, color: muted),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Container(
                        width: 62,
                        height: 62,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEEF0F6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.business_outlined,
                          color: Color(0xFF65718A),
                          size: 25,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OutlinedButton(
                            onPressed: null,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              side: const BorderSide(color: Color(0xFFE7EBF2)),
                            ),
                            child: const Text(
                              'Change photo',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            'JPEG or PNG.',
                            style: TextStyle(fontSize: 10, color: muted),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _label('About'),
                  _readOnlyField(
                    'A short line shown next to your business name',
                  ),
                  _counter('0/139'),
                  const SizedBox(height: 20),
                  _label('Description'),
                  _readOnlyField('What your business does', maxLines: 3),
                  _counter('0/256'),
                  const SizedBox(height: 22),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final twoColumns = constraints.maxWidth > 650;
                      final fieldWidth = twoColumns
                          ? (constraints.maxWidth - 14) / 2
                          : constraints.maxWidth;
                      return Wrap(
                        spacing: 14,
                        runSpacing: 18,
                        children: [
                          SizedBox(
                            width: fieldWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Email'),
                                _readOnlyField('support@yourbusiness.com'),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: fieldWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Business category'),
                                DropdownButtonFormField<String>(
                                  initialValue: 'Not specified',
                                  isExpanded: true,
                                  decoration: _fieldDecoration('Not specified'),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'Not specified',
                                      child: Text('Not specified'),
                                    ),
                                  ],
                                  onChanged: null,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 18,
                                    color: Color(0xFF9299A5),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF9299A5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 22),
                  _label('Address'),
                  _readOnlyField('Business address'),
                  const SizedBox(height: 22),
                  _label('Websites'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
