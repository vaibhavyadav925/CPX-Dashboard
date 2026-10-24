part of '../app.dart';

class CRMOverviewScreen extends StatelessWidget {
  const CRMOverviewScreen({super.key});

  static const Color _ink = Color(0xFF17243B);
  static const Color _muted = Color(0xFF667892);
  Color get _teal => PanelThemeController.instance.accentColor;
  static const Color _line = Color(0xFFDCE3EE);
  static const Color _canvas = Color(0xFFF4F6FB);

  Widget _card({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(16),
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _line),
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
  }

  Widget _sectionTitle(
    IconData icon,
    String title,
    String subtitle, {
    String? action,
    VoidCallback? onAction,
  }) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFE4F5F8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: _teal, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: _ink,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: _muted),
              ),
            ],
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onAction,
            child: Text(action, style: TextStyle(color: _teal, fontSize: 11)),
          ),
      ],
    );
  }

  Widget _guideCard(
    IconData icon,
    String title,
    String subtitle,
    List<String> bullets, {
    String? link,
    VoidCallback? onTap,
  }) {
    return _card(
      padding: const EdgeInsets.all(13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFFE7F4F7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 17, color: _teal),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: _ink,
                        ),
                      ),
                    ),
                    if (link != null)
                      InkWell(
                        onTap: onTap,
                        child: Text(
                          link,
                          style: TextStyle(
                            fontSize: 10,
                            color: _teal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 10, color: _muted),
                ),
                const SizedBox(height: 6),
                ...bullets.map(
                  (b) => Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '•  ',
                          style: TextStyle(color: _muted, fontSize: 10),
                        ),
                        Expanded(
                          child: Text(
                            b,
                            style: const TextStyle(
                              fontSize: 10,
                              height: 1.35,
                              color: _muted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metric(
    IconData icon,
    String title,
    String value,
    String caption,
    Color color,
  ) {
    return _card(
      padding: const EdgeInsets.all(13),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .11),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 10, color: _muted),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: _ink,
                  ),
                ),
                Text(
                  caption,
                  style: const TextStyle(fontSize: 9, color: _muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _canvas,
      drawer: const DashboardDrawer(currentPage: 'Overview'),
      appBar: buildCpxBoatAppBar(context),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4E8BEE), Color(0xFF8855E8)],
                    ),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(
                    Icons.grid_view_rounded,
                    color: Colors.white,
                    size: 19,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CRM Overview',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: _ink,
                        ),
                      ),
                      Text(
                        'Your leads, pipeline and automated follow-ups at a glance.',
                        style: TextStyle(fontSize: 11, color: _muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFAAD8EC)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Get started in 3 steps',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: _ink,
                    ),
                  ),
                  const SizedBox(height: 10),
                  LayoutBuilder(
                    builder: (context, c) {
                      final wide = c.maxWidth > 760;
                      final cards = [
                        _guideCard(
                          Icons.check_circle_outline,
                          '1. Connect a lead source',
                          'Send leads from Facebook / Instagram / Google ads or your website.',
                          ['Connect a source to automatically capture leads.'],
                          link: 'Lead Sources →',
                          onTap: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const CRMOverviewScreen(),
                            ),
                          ),
                        ),
                        _guideCard(
                          Icons.radio_button_unchecked,
                          '2. Publish an automation',
                          'Use the 7-day follow-up template and pick your WhatsApp templates.',
                          ['Build a follow-up journey and publish it.'],
                          link: 'Automations →',
                        ),
                        _guideCard(
                          Icons.check_circle_outline,
                          '3. Work your leads',
                          'Assign to sales, add notes, move them through the pipeline.',
                          ['Track progress from New to Converted or Lost.'],
                          link: 'Leads →',
                        ),
                      ];
                      return wide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: cards
                                  .map(
                                    (w) => Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        child: w,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            )
                          : Column(
                              children: cards
                                  .map(
                                    (w) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: w,
                                    ),
                                  )
                                  .toList(),
                            );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(
                    Icons.menu_book_outlined,
                    'How to use CRM & Automation',
                    'Step-by-step: from getting leads in to automatic follow-ups and results.',
                    action: '⌃  Hide guide',
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, c) {
                      final wide = c.maxWidth > 850;
                      final items = [
                        _guideCard(Icons.tune, 'Step 1. Set up your CRM', '', [
                          'Pick your Time zone and business hours (days and times). Journeys can wait for business hours before sending.',
                          'Set most automated messages per lead in 24 hours so nobody gets too many messages.',
                          'Under Team access to CRM, give each team member a CRM role: Manager sees and does everything; Sales sees only the leads assigned to them; Viewer can only look.',
                        ], link: 'CRM Settings →'),
                        _guideCard(
                          Icons.local_fire_department_outlined,
                          'Step 2. Bring in your leads',
                          '',
                          [
                            'Every lead sent to your Webhook URL appears in Leads within seconds.',
                            'Connect Facebook / Instagram / Google Ads or your website form through your webhook URL.',
                            'You can also import leads from CSV or click Add lead on the Leads page.',
                          ],
                          link: 'Lead Sources →',
                        ),
                        _guideCard(
                          Icons.assignment_ind_outlined,
                          'Step 3. Work your leads',
                          '',
                          [
                            'Each lead moves through the pipeline: New → Contacted → Interested → Qualified → Converted (or Lost).',
                            'Click a lead to see its full history, add notes and tags, and assign an owner.',
                            'Filter by status, source, tag or owner; select many leads for bulk actions.',
                          ],
                          link: 'Leads →',
                        ),
                        _guideCard(
                          Icons.hub_outlined,
                          'Step 4. Build an automation (journey)',
                          '',
                          [
                            'Start from a ready template (for example 7-day lead follow-up) or a blank journey.',
                            'Trigger decides who enters: A new lead arrives, a tag is added, an API / webhook call, or a date and time.',
                            'Add WhatsApp / SMS / RCS message, Wait, Condition, Action, Go to step, Goal / Converted and Stop.',
                          ],
                          link: 'Automations → New automation',
                        ),
                        _guideCard(
                          Icons.science_outlined,
                          'Step 5. Test, then publish',
                          '',
                          [
                            'Click Test this journey and enter your mobile number. The draft runs only for you.',
                            'When it looks right, click Publish. From now on, every new lead that matches the trigger starts automatically.',
                            'Pause stops new runs and running steps until you resume.',
                          ],
                          link: 'In the journey builder →',
                        ),
                        _guideCard(
                          Icons.bar_chart,
                          'Step 6. Track the results',
                          '',
                          [
                            'Analytics shows how many leads entered, messages sent, delivered, read, replies and conversions.',
                            'Journeys & logs list every lead in the automation and what happened at each step.',
                            'The CRM Overview (this page) sums up leads, pipeline, sources and automation results.',
                          ],
                          link: 'Journey → Analytics, Journeys & logs →',
                        ),
                      ];
                      return Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: items
                            .map(
                              (w) => SizedBox(
                                width: wide
                                    ? (c.maxWidth - 10) / 2
                                    : c.maxWidth,
                                child: w,
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _guideCard(Icons.shield_outlined, 'Good to know', '', [
                    'Messages sent by journeys are charged from your wallet like campaigns. If the wallet is empty, the message step fails and can be retried later.',
                    'Leads who opted out or are on the do-not-contact list are always skipped.',
                    'A lead runs only once at a time in the same journey, so a lead that comes in twice is never messaged twice at the same time.',
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, c) {
                final wide = c.maxWidth > 800;
                final metrics = [
                  _metric(
                    Icons.badge_outlined,
                    'Total leads',
                    '1',
                    '1 this week',
                    _teal,
                  ),
                  _metric(
                    Icons.person_add_alt_1,
                    'New today',
                    '0',
                    'last 24 hours',
                    const Color(0xFF168BE8),
                  ),
                  _metric(
                    Icons.emoji_events_outlined,
                    'Converted',
                    '1',
                    '100% of leads',
                    const Color(0xFF08A878),
                  ),
                  _metric(
                    Icons.person_off_outlined,
                    'Unassigned open leads',
                    '0',
                    'need an owner',
                    const Color(0xFFFF8B26),
                  ),
                ];
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: metrics
                      .map(
                        (w) => SizedBox(
                          width: wide
                              ? (c.maxWidth - 30) / 4
                              : (c.maxWidth - 10) / 2,
                          child: w,
                        ),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, c) {
                final wide = c.maxWidth > 850;
                final chart = _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'New leads — last 14 days',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: _ink,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 175,
                        child: CustomPaint(
                          painter: _CRMOverviewChartPainter(
                            accent: panelAccent(context),
                          ),
                          child: const SizedBox.expand(),
                        ),
                      ),
                    ],
                  ),
                );
                final pipeline = _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pipeline',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: _ink,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...[
                        ('New', 0, panelAccent(context)),
                        ('Contacted', 0, Color(0xFF655CFF)),
                        ('Interested', 0, Color(0xFFFF9900)),
                        ('Qualified', 0, Color(0xFF9747FF)),
                        ('Converted', 1, Color(0xFF08B878)),
                        ('Lost', 0, Color(0xFFFF2458)),
                      ].map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 7,
                                    height: 7,
                                    decoration: BoxDecoration(
                                      color: e.$3,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      e.$1,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: _muted,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${e.$2}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: _ink,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: LinearProgressIndicator(
                                  value: e.$2 == 0 ? 0 : 1,
                                  minHeight: 5,
                                  backgroundColor: const Color(0xFFE9EDF4),
                                  color: e.$3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                return wide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 7, child: chart),
                          const SizedBox(width: 12),
                          Expanded(flex: 3, child: pipeline),
                        ],
                      )
                    : Column(
                        children: [chart, const SizedBox(height: 12), pipeline],
                      );
              },
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, c) {
                final wide = c.maxWidth > 850;
                final sources = _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Lead sources',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: _ink,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => showApiPendingMessage(
                              context,
                              'connecting more channels',
                            ),
                            child: Text(
                              '♧ Connect more',
                              style: TextStyle(fontSize: 10, color: _teal),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Source',
                              style: TextStyle(fontSize: 10, color: _muted),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Leads',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 10, color: _muted),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Converted',
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 10, color: _muted),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Test',
                              style: TextStyle(fontSize: 11, color: _ink),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '1',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11, color: _ink),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '1 (100%)',
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 11, color: _muted),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 70),
                    ],
                  ),
                );

                final automation = _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Automations — last 30 days',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: _ink,
                              ),
                            ),
                          ),
                          Text(
                            '♧ 0 live',
                            style: TextStyle(fontSize: 10, color: _teal),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            [
                              ('Running journeys', '0', Icons.hub_outlined),
                              ('Messages sent', '1', Icons.send_outlined),
                              ('Read', '0', Icons.visibility_outlined),
                              ('Replies', '0', Icons.reply_outlined),
                            ].map((e) {
                              return Container(
                                width: wide
                                    ? (c.maxWidth - 52) / 2
                                    : (c.maxWidth - 40) / 2,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: _canvas,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(e.$3, size: 14, color: _muted),
                                    const SizedBox(height: 6),
                                    Text(
                                      e.$2,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: _ink,
                                      ),
                                    ),
                                    Text(
                                      e.$1,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: _muted,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                );

                return wide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: sources),
                          const SizedBox(width: 12),
                          Expanded(child: automation),
                        ],
                      )
                    : Column(
                        children: [
                          sources,
                          const SizedBox(height: 12),
                          automation,
                        ],
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
