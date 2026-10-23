part of '../app.dart';

class WhatsAppQuickLinksScreen extends StatefulWidget {
  const WhatsAppQuickLinksScreen({super.key});

  @override
  State<WhatsAppQuickLinksScreen> createState() =>
      _WhatsAppQuickLinksScreenState();
}

class _WhatsAppQuickLinksScreenState extends State<WhatsAppQuickLinksScreen> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String _link = '';

  @override
  void dispose() {
    _numberController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _generateLink() {
    final number = _numberController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (number.isEmpty) {
      setState(() => _link = '');
      return;
    }
    final message = Uri.encodeComponent(_messageController.text.trim());
    setState(() {
      _link = 'https://wa.me/$number${message.isEmpty ? '' : '?text=$message'}';
    });
  }

  InputDecoration _quickLinkDecoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF8B96A8)),
    filled: true,
    fillColor: const Color(0xFFF8F9FC),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFDCE2EC)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFDCE2EC)),
    ),
  );

  Widget _sectionCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(radius: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: navy,
            ),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: muted)),
          const SizedBox(height: 25),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 850;
    final details = _sectionCard(
      title: 'Details',
      subtitle: 'The number customers will message.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WhatsApp number (with country code)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: navy,
            ),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: _numberController,
            keyboardType: TextInputType.phone,
            onChanged: (_) => _generateLink(),
            decoration: _quickLinkDecoration('919876543210'),
          ),
          const SizedBox(height: 18),
          const Text(
            'Prefilled message (optional)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: navy,
            ),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: _messageController,
            maxLines: 4,
            onChanged: (_) => _generateLink(),
            decoration: _quickLinkDecoration(
              "Hi! I'd like to know more about...",
            ),
          ),
        ],
      ),
    );

    final result = _sectionCard(
      title: 'Result',
      subtitle:
          'Share the link directly, or use the QR code for offline material.',
      child: SizedBox(
        width: double.infinity,
        child: _link.isEmpty
            ? const SizedBox(
                height: 180,
                child: Center(
                  child: Text(
                    'Enter a number to generate the link and QR code.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: muted),
                  ),
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QrImageView(
                    data: _link,
                    version: QrVersions.auto,
                    size: 120,
                    backgroundColor: Colors.white,
                    errorCorrectionLevel: QrErrorCorrectLevel.M,
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    _link,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: teal),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _link));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('WhatsApp link copied'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.copy_rounded, size: 16),
                        label: const Text('Copy link'),
                      ),
                      FilledButton.icon(
                        onPressed: () => _generateLink(),
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: const Text('Generate'),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );

    return Scaffold(
      drawer: const DashboardDrawer(currentPage: 'Quick Links'),
      appBar: buildCpxBoatAppBar(context),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(wide ? 22 : 13),
          children: [
            const Text(
              'Click-to-WhatsApp link',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: navy,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Generate a wa.me link with a prefilled message, and a QR code for print or a website.',
              style: TextStyle(fontSize: 12, color: muted),
            ),
            const SizedBox(height: 22),
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: details),
                  const SizedBox(width: 22),
                  Expanded(child: result),
                ],
              )
            else ...[
              details,
              const SizedBox(height: 16),
              result,
            ],
          ],
        ),
      ),
    );
  }
}
