part of '../app.dart';

class CRMLeadSourcesScreen extends StatefulWidget {
  const CRMLeadSourcesScreen({super.key});

  @override
  State<CRMLeadSourcesScreen> createState() => _CRMLeadSourcesScreenState();
}

class _CRMLeadSourcesScreenState extends State<CRMLeadSourcesScreen> {
  static const Color _ink = Color(0xFF17243B);
  static const Color _muted = Color(0xFF667892);
  Color get _teal => PanelThemeController.instance.accentColor;
  static const Color _line = Color(0xFFDCE3EE);
  static const Color _canvas = Color(0xFFF4F6FB);
  int _tab = 0;
  final bool _confirmNewUrl = false;
  final _phone = TextEditingController();
  final _name = TextEditingController(text: 'Test Lead');
  String _source = 'Facebook Ads';
  String _webhook =
      'https://cpxboat.com/lead-webhook/1b2f2943fa6a08fc5f6ff138b3c7d6f9a5bbd63a';

  @override
  void dispose() {
    _phone.dispose();
    _name.dispose();
    super.dispose();
  }

  Widget _card({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(16),
  }) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: _line),
      borderRadius: BorderRadius.circular(12),
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

  Widget _field(TextEditingController controller, String hint) => TextField(
    controller: controller,
    style: const TextStyle(fontSize: 12, color: _ink),
    decoration: InputDecoration(
      hintText: hint,
      isDense: true,
      filled: true,
      fillColor: const Color(0xFFF8FAFD),
      contentPadding: const EdgeInsets.symmetric(horizontal: 11, vertical: 11),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _line),
      ),
    ),
  );

  Widget _copyButton(String text, {String label = 'Copy'}) =>
      OutlinedButton.icon(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: text));
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('$label copied')));
        },
        icon: const Icon(Icons.copy_rounded, size: 14),
        label: Text(label, style: const TextStyle(fontSize: 11)),
        style: OutlinedButton.styleFrom(
          foregroundColor: _ink,
          side: const BorderSide(color: _line),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

  Widget _fieldTable() {
    final rows = <List<String>>[
      [
        'phone',
        'Required. Also: phone_number, mobile, whatsapp. 10-digit Indian numbers get +91.',
      ],
      ['name', 'Or first_name + last_name, full_name'],
      ['email', 'email, email_address'],
      [
        'source',
        'facebook_ads, instagram_ads, google_ads, website ... (or ?source= in the URL)',
      ],
      ['campaign_name / campaign_id', 'Also form_name, utm_campaign'],
      ['adset_id, ad_id', 'Ad attribution'],
      ['city, product', 'Also location, service, interest'],
      ['consent', 'yes / opted_in — marketing consent'],
      ['tags', 'Comma-separated'],
      ['automation_id', 'Optional: also start this automation'],
      ['anything else', 'Kept as custom fields on the lead'],
    ];
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(9),
            color: const Color(0xFFF8FAFD),
            child: const Text(
              'FIELD NAMES WE UNDERSTAND',
              style: TextStyle(
                fontSize: 10,
                color: _muted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ...rows.map(
            (r) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: _line)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 145,
                    child: Text(
                      r[0],
                      style: const TextStyle(fontSize: 10, color: _ink),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      r[1],
                      style: const TextStyle(fontSize: 10, color: _muted),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _steps(List<Widget> children) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  Widget _step(int n, Widget text) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFFE5F5F8),
            shape: BoxShape.circle,
          ),
          child: Text(
            '$n',
            style: TextStyle(
              color: _teal,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: text),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final compact = width < 900;
    final instructions = _tab == 0
        ? _steps([
            const Text(
              '📣  Facebook & Instagram Lead Ads — through Zapier, Pabbly Connect or Make (no Meta app approval needed).',
              style: TextStyle(fontSize: 11, color: _muted),
            ),
            const SizedBox(height: 14),
            _step(
              1,
              const Text(
                'In Zapier (or Pabbly / Make) create a new Zap / workflow.',
                style: TextStyle(fontSize: 11, color: _ink),
              ),
            ),
            _step(
              2,
              const Text(
                'Trigger: Facebook Lead Ads → New Lead. Connect your Facebook account, choose your Page and Lead Form. (Instagram lead ads use the same Facebook trigger.)',
                style: TextStyle(fontSize: 11, color: _ink),
              ),
            ),
            _step(
              3,
              const Text(
                'Action: Webhooks by Zapier → POST (Pabbly: “API by Pabbly”, Make: “HTTP → Make a request”).',
                style: TextStyle(fontSize: 11, color: _ink),
              ),
            ),
            _step(
              4,
              const Text(
                'URL: paste your Lead Webhook URL and add ?source=facebook_ads (or instagram_ads) at the end.',
                style: TextStyle(fontSize: 11, color: _ink),
              ),
            ),
            _step(
              5,
              const Text(
                'Payload type JSON. Map fields: name → Full Name, phone → Phone Number, email → Email, campaign_name → Campaign / Form Name, ad_id, adset_id if available.',
                style: TextStyle(fontSize: 11, color: _ink),
              ),
            ),
            _step(
              6,
              const Text(
                'Click Test — the lead appears in Leads within seconds. Then turn the Zap on.',
                style: TextStyle(fontSize: 11, color: _ink),
              ),
            ),
          ])
        : _tab == 1
        ? _steps([
            _step(
              1,
              const Text(
                'In Google Ads open your campaign’s Lead form asset.',
                style: TextStyle(fontSize: 11, color: _ink),
              ),
            ),
            _step(
              2,
              const Text(
                'Under Lead delivery → Webhook integration, paste this URL:',
                style: TextStyle(fontSize: 11, color: _ink),
              ),
            ),
            _step(3, _copyButton('$_webhook?source=google_ads')),
            _step(
              4,
              const Text(
                'For Key, type any word (e.g. cpxboat) — your URL already contains your secret key.',
                style: TextStyle(fontSize: 11, color: _ink),
              ),
            ),
            _step(
              5,
              const Text(
                'Click Send test data, check Leads, then save the form. Google sends name, phone, email and your extra questions automatically.',
                style: TextStyle(fontSize: 11, color: _ink),
              ),
            ),
            const Text(
              'Alternatively use Zapier with the “Google Ads → New Lead Form Entry” trigger, exactly like the Facebook steps.',
              style: TextStyle(fontSize: 10, color: _muted),
            ),
          ])
        : _tab == 2
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🌐 Paste this into any web page (or give it to your web developer). WordPress form plugins with a “webhook” option (Contact Form 7 + webhook, WPForms, Elementor) can use the URL directly.',
                style: TextStyle(fontSize: 11, color: _muted),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF08090B),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const SelectableText(
                  '<form id="lead-form">\n  <input name="name" placeholder="Your name" required>\n  <input name="phone" placeholder="WhatsApp number" required>\n  <input name="email" placeholder="Email">\n  <label><input type="checkbox" name="consent" value="yes"> Send me updates on WhatsApp</label>\n  <button>Submit</button>\n</form>\n<script>\ndocument.getElementById(\'lead-form\').onsubmit = async (e) => {\n  e.preventDefault();\n  const data = Object.fromEntries(new FormData(e.target));\n  await fetch(\'WEBHOOK_URL?source=website\', { method: \'POST\', headers: { \'Content-Type\': \'application/json\' }, body: JSON.stringify(data) });\n  e.target.innerHTML = \'Thank you! We will contact you on WhatsApp shortly.\';\n};\n</script>',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '⚙ POST JSON (or form data). Send one lead, or { "leads": [ ... ] } for up to 200 at once. You can also post to /lead-webhook with header x-api-key.',
                style: TextStyle(fontSize: 11, color: _muted),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF08090B),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const SelectableText(
                  "curl -X POST 'WEBHOOK_URL?source=website' \\\n  -H 'Content-Type: application/json' \\\n  -d '{\"name\":\"Amit Kumar\",\"phone\":\"9876543210\",\"email\":\"amit@example.com\",\"city\":\"Noida\",\"product\":\"WhatsApp API\",\"consent\":\"yes\"}'",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF08090B),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Response: { "success": true, "lead_id": 123, "created": true }',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          );

    final leftPanel = _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Connect a source',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _ink,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(4, (i) {
              final labels = [
                'Facebook / Instagram',
                'Google Ads',
                'Website form',
                'API',
              ];
              return Expanded(
                child: InkWell(
                  onTap: () => setState(() => _tab = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _tab == i ? _teal : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      labels[i],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: compact ? 9 : 11,
                        color: _tab == i ? _teal : _muted,
                        fontWeight: _tab == i
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          instructions,
          if (_tab != 2 && _tab != 3) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFD),
                border: Border.all(color: _line),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      '$_webhook?source=${_tab == 1 ? 'google_ads' : 'facebook_ads'}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontFamily: 'monospace',
                        color: _ink,
                      ),
                    ),
                  ),
                  _copyButton(
                    '$_webhook?source=${_tab == 1 ? 'google_ads' : 'facebook_ads'}',
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          _fieldTable(),
        ],
      ),
    );

    final rightPanel = Column(
      children: [
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.bolt, color: Colors.orange, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Send a test lead',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _ink,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Text(
                'Uses the same URL your ads will use. Matching “New lead” automations will start — use your own number.',
                style: TextStyle(fontSize: 10, color: _muted),
              ),
              const SizedBox(height: 12),
              const Text('Phone', style: TextStyle(fontSize: 11, color: _ink)),
              const SizedBox(height: 4),
              _field(_phone, '98XXXXXXXX'),
              const SizedBox(height: 9),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Name',
                          style: TextStyle(fontSize: 11, color: _ink),
                        ),
                        const SizedBox(height: 4),
                        _field(_name, 'Test Lead'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Source',
                          style: TextStyle(fontSize: 11, color: _ink),
                        ),
                        const SizedBox(height: 4),
                        DropdownButtonFormField<String>(
                          initialValue: _source,
                          isDense: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF8FAFD),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: _line),
                            ),
                          ),
                          items:
                              [
                                    'Facebook Ads',
                                    'Instagram Ads',
                                    'Google Ads',
                                    'Website',
                                    'API',
                                    'Test',
                                  ]
                                  .map(
                                    (v) => DropdownMenuItem(
                                      value: v,
                                      child: Text(
                                        v,
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (v) =>
                              setState(() => _source = v ?? _source),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _phone.text.trim().isEmpty
                      ? null
                      : () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Connect your webhook backend to send a real test lead.',
                            ),
                          ),
                        ),
                  icon: const Icon(Icons.send_outlined, size: 14),
                  label: const Text(
                    'Send test lead',
                    style: TextStyle(fontSize: 11),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _card(
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Recent webhook hits',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _ink,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() {}),
                    icon: const Icon(Icons.refresh, size: 16),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const Divider(color: _line, height: 1),
              const SizedBox(height: 24),
              const Text(
                'Nothing received yet.',
                style: TextStyle(fontSize: 11, color: _muted),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: _canvas,
      drawer: const DashboardDrawer(currentPage: 'Lead Sources'),
      appBar: buildCpxBoatAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(compact ? 12 : 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [panelAccent(context), Color(0xFF7859E8)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.hub_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lead Sources',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: _ink,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Bring leads in automatically from your ads, website and other tools.',
                          style: TextStyle(fontSize: 11, color: _muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Your Lead Webhook URL',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: _ink,
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => showDialog<void>(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: const Text('Create a new webhook URL?'),
                              content: const Text(
                                'The current URL stops working immediately — update it in Zapier / Google Ads / your website afterwards.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _webhook =
                                          'https://cpxboat.com/lead-webhook/${DateTime.now().microsecondsSinceEpoch.toRadixString(16)}';
                                    });
                                    Navigator.pop(dialogContext);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          ),
                          icon: const Icon(Icons.refresh, size: 14),
                          label: const Text(
                            'New URL',
                            style: TextStyle(fontSize: 11),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _ink,
                            side: const BorderSide(color: _line),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Anything that can “POST” to a webhook can send you leads with this link. Keep it private — it works without a login.',
                      style: TextStyle(fontSize: 11, color: _muted),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFD),
                        border: Border.all(color: _line),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: SelectableText(
                              _webhook,
                              style: const TextStyle(
                                fontSize: 10,
                                fontFamily: 'monospace',
                                color: _ink,
                              ),
                            ),
                          ),
                          _copyButton(_webhook, label: 'Copy URL'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Same phone number again = the lead is updated, not duplicated. New leads instantly start your published “New lead” automations.',
                      style: TextStyle(fontSize: 10, color: _muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (compact) ...[
                leftPanel,
                const SizedBox(height: 14),
                rightPanel,
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: leftPanel),
                    const SizedBox(width: 14),
                    Expanded(flex: 3, child: rightPanel),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
