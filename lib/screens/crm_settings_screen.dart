part of '../app.dart';

class CRMSettingsScreen extends StatefulWidget {
  const CRMSettingsScreen({super.key});
  @override
  State<CRMSettingsScreen> createState() => _CRMSettingsScreenState();
}

class _CRMSettingsScreenState extends State<CRMSettingsScreen> {
  static const Color ink = Color(0xFF17243B);
  static const Color mutedText = Color(0xFF667892);
  static const Color line = Color(0xFFDCE3EE);
  static const Color tealColor = Color(0xFF0B91AD);
  final Set<String> days = {'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'};
  final List<String> holidays = [];
  final List<Map<String, String>> blocked = [];
  final Map<String, String> roles = {
    'abc abc': 'Manager',
    'Ajay K': 'Manager',
    'anu i': 'Sales',
    'anu i ': 'Manager',
    'xxzz z zz zx': 'Manager',
  };
  final TextEditingController from = TextEditingController(text: '10:00');
  final TextEditingController to = TextEditingController(text: '19:00');
  final TextEditingController phone = TextEditingController();
  final TextEditingController reason = TextEditingController();
  final TextEditingController holiday = TextEditingController();
  String zone = 'Asia/Kolkata';
  String holidayDraft = '';
  String limit = '0';

  @override
  void dispose() {
    from.dispose();
    to.dispose();
    phone.dispose();
    reason.dispose();
    holiday.dispose();
    super.dispose();
  }

  Widget card({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(18),
  }) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: line),
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
  Widget heading(IconData icon, String title, String subtitle) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 17, color: tealColor),
      const SizedBox(width: 8),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: ink,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                height: 1.35,
                color: mutedText,
              ),
            ),
          ],
        ),
      ),
    ],
  );
  InputDecoration decoration(String hint) => InputDecoration(
    hintText: hint,
    isDense: true,
    filled: true,
    fillColor: const Color(0xFFF8FAFD),
    contentPadding: const EdgeInsets.symmetric(horizontal: 11, vertical: 11),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: line),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: line),
    ),
  );
  Widget label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Text(
      text,
      style: TextStyle(fontSize: 12, color: ink, fontWeight: FontWeight.w500),
    ),
  );
  Widget field(
    TextEditingController controller,
    String hint, {
    double? width,
  }) => SizedBox(
    width: width,
    child: TextField(
      controller: controller,
      style: TextStyle(fontSize: 12, color: ink),
      decoration: decoration(hint),
    ),
  );
  Widget smallButton(
    String text,
    VoidCallback action, {
    bool primary = false,
    IconData? icon,
  }) {
    if (primary) {
      return SizedBox(
        height: 36,
        child: FilledButton.icon(
          onPressed: action,
          icon: Icon(icon ?? Icons.add, size: 15),
          label: Text(
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          style: FilledButton.styleFrom(
            backgroundColor: tealColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
    }
    return SizedBox(
      height: 36,
      child: OutlinedButton.icon(
        onPressed: action,
        icon: Icon(icon ?? Icons.add, size: 14),
        label: Text(text, style: const TextStyle(fontSize: 12)),
        style: OutlinedButton.styleFrom(
          foregroundColor: mutedText,
          side: const BorderSide(color: line),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DashboardDrawer(),
      appBar: buildCpxBoatAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            // Keep the existing CRM Settings content unchanged.
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9E9FF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.tune_rounded,
                            color: Color(0xFF6475E8),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CRM Settings',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: ink,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Business hours for automated messages, your do-not-contact list and who in your team can do what.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: mutedText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final wide = constraints.maxWidth >= 900;
                        final left = card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              heading(
                                Icons.access_time,
                                'Business hours',
                                'Automations with “Send only in business hours” turned on hold messages until the next open slot. Example: a lead at 11 pm gets the welcome at 10 am.',
                              ),
                              const SizedBox(height: 18),
                              label('Open on'),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children:
                                    [
                                          'Sun',
                                          'Mon',
                                          'Tue',
                                          'Wed',
                                          'Thu',
                                          'Fri',
                                          'Sat',
                                        ]
                                        .map(
                                          (d) => ChoiceChip(
                                            label: Text(
                                              d,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: days.contains(d)
                                                    ? Colors.white
                                                    : mutedText,
                                              ),
                                            ),
                                            selected: days.contains(d),
                                            onSelected: (v) => setState(
                                              () => v
                                                  ? days.add(d)
                                                  : days.remove(d),
                                            ),
                                            selectedColor: tealColor,
                                            backgroundColor: Colors.white,
                                            side: BorderSide(
                                              color: days.contains(d)
                                                  ? tealColor
                                                  : line,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 2,
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),
                              const SizedBox(height: 16),
                              LayoutBuilder(
                                builder: (context, c) {
                                  final row = c.maxWidth > 420;
                                  final fromField = Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      label('From'),
                                      field(from, '10:00'),
                                    ],
                                  );
                                  final toField = Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [label('To'), field(to, '19:00')],
                                  );
                                  return row
                                      ? Row(
                                          children: [
                                            Expanded(child: fromField),
                                            const SizedBox(width: 10),
                                            Expanded(child: toField),
                                          ],
                                        )
                                      : Column(
                                          children: [
                                            fromField,
                                            const SizedBox(height: 10),
                                            toField,
                                          ],
                                        );
                                },
                              ),
                              const SizedBox(height: 14),
                              label('Time zone'),
                              DropdownButtonFormField<String>(
                                value: zone,
                                decoration: decoration('Time zone'),
                                items:
                                    const [
                                          'Asia/Kolkata',
                                          'America/New_York',
                                          'America/Chicago',
                                          'America/Denver',
                                          'America/Los_Angeles',
                                          'Europe/London',
                                          'UTC',
                                        ]
                                        .map(
                                          (z) => DropdownMenuItem(
                                            value: z,
                                            child: Text(
                                              z,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (v) =>
                                    setState(() => zone = v ?? zone),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.event_busy_outlined,
                                    size: 14,
                                    color: mutedText,
                                  ),
                                  const SizedBox(width: 5),
                                  label('Holidays (closed all day)'),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: holiday,
                                      readOnly: true,
                                      decoration: decoration('dd-mm-yyyy')
                                          .copyWith(
                                            suffixIcon: const Icon(
                                              Icons.calendar_month,
                                              size: 16,
                                            ),
                                          ),
                                      onTap: () async {
                                        final d = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime(2100),
                                        );
                                        if (d != null)
                                          setState(
                                            () => holidayDraft =
                                                '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}',
                                          );
                                        if (holidayDraft.isNotEmpty)
                                          holiday.text = holidayDraft;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  smallButton('Add', () {
                                    if (holiday.text.trim().isNotEmpty &&
                                        !holidays.contains(holiday.text.trim()))
                                      setState(() {
                                        holidays.add(holiday.text.trim());
                                        holiday.clear();
                                      });
                                  }),
                                ],
                              ),
                              const SizedBox(height: 7),
                              if (holidays.isEmpty)
                                const Text(
                                  'No holidays. Messages due on a holiday wait for the next open day.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: mutedText,
                                  ),
                                )
                              else
                                Wrap(
                                  spacing: 6,
                                  children: holidays
                                      .map(
                                        (h) => Chip(
                                          label: Text(
                                            h,
                                            style: const TextStyle(
                                              fontSize: 11,
                                            ),
                                          ),
                                          onDeleted: () => setState(
                                            () => holidays.remove(h),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              const SizedBox(height: 18),
                              label(
                                'Most automated messages per lead in 24 hours',
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 86,
                                    child: TextFormField(
                                      initialValue: limit,
                                      keyboardType: TextInputType.number,
                                      decoration: decoration('0'),
                                      onChanged: (v) => limit = v,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    '0 = no limit',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: mutedText,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                "Counts WhatsApp, SMS and RCS from every journey together, so one lead isn't flooded.",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: mutedText,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: smallButton(
                                  'Save',
                                  () => ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                        const SnackBar(
                                          content: Text('CRM settings saved'),
                                        ),
                                      ),
                                  primary: true,
                                  icon: Icons.save_outlined,
                                ),
                              ),
                            ],
                          ),
                        );
                        final right = card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              heading(
                                Icons.do_not_disturb_on_outlined,
                                'Do-not-contact list',
                                'Automations never send marketing messages to these numbers. Customers who reply STOP are added automatically — and opt-outs are respected too.',
                              ),
                              const SizedBox(height: 16),
                              LayoutBuilder(
                                builder: (context, c) {
                                  void addBlockedNumber() {
                                    final p = phone.text.trim();
                                    if (p.isEmpty) return;
                                    setState(() {
                                      blocked.add({
                                        'phone': p,
                                        'reason': reason.text.trim(),
                                      });
                                      phone.clear();
                                      reason.clear();
                                    });
                                  }

                                  final fields = Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: field(phone, 'Phone'),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        flex: 6,
                                        child: field(
                                          reason,
                                          'Reason (optional)',
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      smallButton(
                                        'Add',
                                        addBlockedNumber,
                                        primary: true,
                                      ),
                                    ],
                                  );
                                  if (c.maxWidth >= 500) return fields;
                                  return Column(
                                    children: [
                                      field(phone, 'Phone'),
                                      const SizedBox(height: 8),
                                      field(reason, 'Reason (optional)'),
                                      const SizedBox(height: 8),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: smallButton(
                                          'Add',
                                          addBlockedNumber,
                                          primary: true,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                constraints: const BoxConstraints(
                                  minHeight: 62,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: line),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: blocked.isEmpty
                                    ? const Center(
                                        child: Text(
                                          'No numbers yet.',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: mutedText,
                                          ),
                                        ),
                                      )
                                    : Column(
                                        children: blocked
                                            .asMap()
                                            .entries
                                            .map<Widget>((entry) {
                                              final item = entry.value;
                                              final phoneNumber =
                                                  item['phone'] ?? '';
                                              final reasonText =
                                                  item['reason'] ?? '';
                                              return ListTile(
                                                dense: true,
                                                title: Text(
                                                  phoneNumber,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: ink,
                                                  ),
                                                ),
                                                subtitle: reasonText.isEmpty
                                                    ? null
                                                    : Text(
                                                        reasonText,
                                                        style: const TextStyle(
                                                          fontSize: 11,
                                                          color: mutedText,
                                                        ),
                                                      ),
                                                trailing: IconButton(
                                                  onPressed: () => setState(
                                                    () => blocked.removeAt(
                                                      entry.key,
                                                    ),
                                                  ),
                                                  icon: const Icon(
                                                    Icons.delete_outline,
                                                    color: Colors.red,
                                                    size: 18,
                                                  ),
                                                ),
                                              );
                                            })
                                            .toList(),
                                      ),
                              ),
                            ],
                          ),
                        );
                        final cards = wide
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(flex: 1, child: left),
                                  const SizedBox(width: 16),
                                  Expanded(flex: 1, child: right),
                                ],
                              )
                            : Column(
                                children: [
                                  left,
                                  const SizedBox(height: 14),
                                  right,
                                ],
                              );
                        return cards;
                      },
                    ),
                    const SizedBox(height: 18),
                    card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          heading(
                            Icons.verified_user_outlined,
                            'Team access to CRM',
                            'Your team members from Agent Roles. By default a Manager gets Manager access and an Agent gets Sales access. Which CRM pages they can open is still set in Agent Roles → module access.',
                          ),
                          const SizedBox(height: 16),
                          LayoutBuilder(
                            builder: (context, c) {
                              final wide = c.maxWidth > 650;
                              final entries = [
                                (
                                  'Manager',
                                  'Everything: all leads, build & publish journeys, CRM settings',
                                ),
                                (
                                  'Sales',
                                  'Only leads assigned to them (and leads they add); journeys view-only',
                                ),
                                (
                                  'Viewer',
                                  "Look only: leads, journeys and analytics — can't change anything",
                                ),
                              ];
                              return wide
                                  ? Row(
                                      children: entries
                                          .map(
                                            (e) => Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                  right: 6,
                                                ),
                                                padding: const EdgeInsets.all(
                                                  10,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFFF5F6FA,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(9),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      e.$1,
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: ink,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 3),
                                                    Text(
                                                      e.$2,
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        color: mutedText,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    )
                                  : Column(
                                      children: entries
                                          .map(
                                            (e) => Container(
                                              width: double.infinity,
                                              margin: const EdgeInsets.only(
                                                bottom: 6,
                                              ),
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF5F6FA),
                                                borderRadius:
                                                    BorderRadius.circular(9),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    e.$1,
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: ink,
                                                    ),
                                                  ),
                                                  Text(
                                                    e.$2,
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      color: mutedText,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    );
                            },
                          ),
                          const SizedBox(height: 8),
                          ...roles.entries
                              .map(
                                (e) => Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: line),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 7,
                                      horizontal: 2,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                e.key,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: ink,
                                                ),
                                              ),
                                              Text(
                                                e.value == 'Manager'
                                                    ? '${e.key == 'Ajay K' ? 'Ajay' : 'dcdcdc'} · ${e.value} in Agent Roles'
                                                    : '${e.key == 'anu i' ? 'dcdsdc' : 'ajay1'} · ${e.value == 'Sales' ? 'Agent' : 'Manager'} in Agent Roles',
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: mutedText,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        SizedBox(
                                          width: 160,
                                          child:
                                              DropdownButtonFormField<String>(
                                                // Use a guaranteed-valid unique menu key.
                                                // The displayed role is still Manager/Sales/Viewer.
                                                initialValue:
                                                    e.value == 'Manager'
                                                    ? 'role_manager'
                                                    : e.value == 'Sales'
                                                    ? 'role_sales'
                                                    : e.value == 'Viewer'
                                                    ? 'role_viewer'
                                                    : e.value ==
                                                          'default_manager'
                                                    ? 'default_manager'
                                                    : e.value == 'default_sales'
                                                    ? 'default_sales'
                                                    : 'role_manager',
                                                decoration: decoration('Role'),
                                                items: const [
                                                  DropdownMenuItem<String>(
                                                    value: 'default_manager',
                                                    child: Text(
                                                      'Default (Manager)',
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: 'default_sales',
                                                    child: Text(
                                                      'Default (Sales)',
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: 'role_manager',
                                                    child: Text(
                                                      'Manager',
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: 'role_sales',
                                                    child: Text(
                                                      'Sales',
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: 'role_viewer',
                                                    child: Text(
                                                      'Viewer',
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                                onChanged: (v) => setState(() {
                                                  roles[e.key] = switch (v) {
                                                    'default_manager' ||
                                                    'role_manager' => 'Manager',
                                                    'default_sales' ||
                                                    'role_sales' => 'Sales',
                                                    'role_viewer' => 'Viewer',
                                                    _ => e.value,
                                                  };
                                                }),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ],
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
}
