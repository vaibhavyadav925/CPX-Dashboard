part of '../app.dart';

class SMSOccasionsScreen extends StatefulWidget {
  const SMSOccasionsScreen({super.key});

  @override
  State<SMSOccasionsScreen> createState() => _SMSOccasionsScreenState();
}

class _SMSOccasionsScreenState extends State<SMSOccasionsScreen> {
  final List<_WhatsAppOccasion> _occasions = [
    _WhatsAppOccasion(
      name: 'Dussehra',
      date: DateTime(2026, 10, 20),
      region: 'India',
      verifyDate: true,
    ),
    _WhatsAppOccasion(
      name: 'Halloween',
      date: DateTime(2026, 10, 31),
      region: 'Shopping',
    ),
    _WhatsAppOccasion(
      name: 'Diwali',
      date: DateTime(2026, 11, 8),
      region: 'India',
      verifyDate: true,
    ),
    _WhatsAppOccasion(
      name: 'Bhai Dooj',
      date: DateTime(2026, 11, 10),
      region: 'India',
      verifyDate: true,
    ),
    _WhatsAppOccasion(
      name: "Singles' Day",
      date: DateTime(2026, 11, 11),
      region: 'Shopping',
    ),
  ];

  Future<void> _showAddOccasionDialog() async {
    final nameController = TextEditingController();
    DateTime? selectedDate;
    String? errorText;

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 490),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Add an occasion',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF202A3C),
                            ),
                          ),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: () => Navigator.pop(dialogContext),
                          icon: const Icon(Icons.close, color: muted, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'For a date that matters to your audience — Diwali, Eid, Lunar New Year, a regional holiday, your own store anniversary, anything. Saved on this browser.',
                      style: TextStyle(color: muted, fontSize: 12, height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Occasion name',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF354052),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: nameController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'e.g. Diwali',
                        errorText: errorText,
                        isDense: true,
                        filled: true,
                        fillColor: const Color(0xFFF8F9FC),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 13,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: const BorderSide(
                            color: Color(0xFFDDE3ED),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: const BorderSide(
                            color: Color(0xFFDDE3ED),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: BorderSide(
                            color: panelAccent(context),
                            width: 1.5,
                          ),
                        ),
                      ),
                      onChanged: (_) {
                        if (errorText != null) {
                          setDialogState(() => errorText = null);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Date',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF354052),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    InkWell(
                      borderRadius: BorderRadius.circular(9),
                      onTap: () async {
                        final now = DateTime.now();
                        final picked = await showDatePicker(
                          context: dialogContext,
                          initialDate: selectedDate ?? now,
                          firstDate: DateTime(now.year - 1),
                          lastDate: DateTime(now.year + 10),
                        );
                        if (picked != null) {
                          setDialogState(() => selectedDate = picked);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 13,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FC),
                          border: Border.all(color: const Color(0xFFDDE3ED)),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedDate == null
                                    ? 'dd-mm-yyyy'
                                    : '${selectedDate!.day.toString().padLeft(2, '0')}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.year}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: selectedDate == null ? muted : navy,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.calendar_month_outlined,
                              size: 16,
                              color: Color(0xFF202A3C),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 43,
                      child: FilledButton(
                        onPressed: () {
                          final name = nameController.text.trim();
                          if (name.isEmpty || selectedDate == null) {
                            setDialogState(() {
                              errorText = name.isEmpty
                                  ? 'Please enter an occasion name.'
                                  : null;
                            });
                            if (selectedDate == null && name.isNotEmpty) {
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please select a date.'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                            return;
                          }

                          setState(() {
                            _occasions.add(
                              _WhatsAppOccasion(
                                name: name,
                                date: DateTime(
                                  selectedDate!.year,
                                  selectedDate!.month,
                                  selectedDate!.day,
                                ),
                                region: 'Custom',
                              ),
                            );
                            _occasions.sort(
                              (_WhatsAppOccasion a, _WhatsAppOccasion b) =>
                                  a.date.compareTo(b.date),
                            );
                          });
                          Navigator.pop(dialogContext);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: panelAccent(context),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                        child: const Text(
                          'Add occasion',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    nameController.dispose();
  }

  String _dateLabel(DateTime date) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${weekdays[date.weekday - 1]}, ${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}, ${date.year}';
  }

  String _relativeDate(DateTime date) {
    final today = DateTime.now();
    final startToday = DateTime(today.year, today.month, today.day);
    final target = DateTime(date.year, date.month, date.day);
    final days = target.difference(startToday).inDays;
    if (days == 0) return 'Today';
    if (days == -1) return 'Yesterday';
    if (days < 0) return '${days.abs()} day(s) ago';
    return 'In $days day(s)';
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 850;

    return Scaffold(
      drawer: const DashboardDrawer(
        currentPage: 'Occasions',
        currentGroup: 'SMS-App',
      ),
      appBar: buildCpxBoatAppBar(context),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(wide ? 22 : 13),
          children: [
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Campaign Occasions',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: navy,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Upcoming dates worth running an offer around — pick one and start a campaign in one click.',
                          style: TextStyle(fontSize: 12, color: muted),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: _showAddOccasionDialog,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add your own occasion'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: navy,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 15,
                      ),
                      side: const BorderSide(color: Color(0xFFDCE2ED)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                  ),
                ],
              )
            else ...[
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: _showAddOccasionDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add your own occasion'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: navy,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    side: const BorderSide(color: Color(0xFFDCE2ED)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Campaign Occasions',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: navy,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Upcoming dates worth running an offer around — pick one and start a campaign in one click.',
                style: TextStyle(fontSize: 12, color: muted),
              ),
            ],
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE7F2F8),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFA8D8E9)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x100D2B55),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFCBE9F2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      size: 18,
                      color: panelAccent(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Occasion-based campaigns get noticeably better results',
                          style: TextStyle(
                            color: panelAccent(context),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Messages timed to a festival, holiday, or sale date see higher open and response rates than a random send. Pick a date below and schedule your campaign a few days ahead for the best reach.',
                          style: TextStyle(
                            color: Color(0xFF60758F),
                            fontSize: 12,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            ..._occasions.map((occasion) {
              final isShopping = occasion.region == 'Shopping';
              return Padding(
                padding: const EdgeInsets.only(bottom: 11),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: wide ? 22 : 15,
                    vertical: wide ? 17 : 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFFDCE2ED)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x100D2B55),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: wide
                      ? Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    spacing: 8,
                                    runSpacing: 5,
                                    children: [
                                      Text(
                                        occasion.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF17233C),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      _occasionBadge(
                                        occasion.region,
                                        isShopping,
                                      ),
                                      if (occasion.verifyDate)
                                        _occasionBadge(
                                          'Verify Date',
                                          false,
                                          verify: true,
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${_dateLabel(occasion.date)} · ${_relativeDate(occasion.date)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF60758F),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            FilledButton.icon(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => const SMSCampaignsScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.send_rounded, size: 15),
                              label: const Text('Start Campaign'),
                              style: FilledButton.styleFrom(
                                backgroundColor: panelAccent(context),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 12,
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 7,
                              runSpacing: 5,
                              children: [
                                Text(
                                  occasion.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF17233C),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                _occasionBadge(occasion.region, isShopping),
                                if (occasion.verifyDate)
                                  _occasionBadge(
                                    'Verify Date',
                                    false,
                                    verify: true,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${_dateLabel(occasion.date)} · ${_relativeDate(occasion.date)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF60758F),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: FilledButton.icon(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const SMSCampaignsScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.send_rounded, size: 15),
                                label: const Text('Start Campaign'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: panelAccent(context),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 13,
                                    vertical: 10,
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              );
            }),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFDCE2ED)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x100D2B55),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About the dates shown',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF17233C),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'Global and Indian civic dates (Republic Day, Independence Day, and the like) are exact. Movable festivals — Holi, Diwali, Eid, and similar — are best-effort estimates for the year, marked Verify date, since they shift slightly depending on regional observance. Use Add your own occasion for anything else specific to where you do business.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF60758F),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                '© CPXBOAT • SMS-App',
                style: TextStyle(fontSize: 10, color: muted),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _occasionBadge(String label, bool shopping, {bool verify = false}) {
    final color = verify
        ? const Color(0xFFF59E0B)
        : shopping
        ? const Color(0xFFB96800)
        : panelAccent(context);
    final background = verify
        ? const Color(0xFFFFF3E4)
        : shopping
        ? const Color(0xFFFFF4E8)
        : const Color(0xFFE5F5F8);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          height: 1,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
