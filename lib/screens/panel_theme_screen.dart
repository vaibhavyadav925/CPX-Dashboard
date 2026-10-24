part of '../app.dart';

class PanelThemeScreen extends StatefulWidget {
  const PanelThemeScreen({super.key});

  @override
  State<PanelThemeScreen> createState() => _PanelThemeScreenState();
}

class _PanelThemeScreenState extends State<PanelThemeScreen> {
  final List<Color> _colors = const [
    Color(0xFF5B4BC4),
    Color(0xFF2864E8),
    Color(0xFF0B91AD),
    Color(0xFF16A34A),
    Color(0xFF9A6700),
    Color(0xFFEA580C),
    Color(0xFFDC2626),
    Color(0xFFDB2777),
    Color(0xFF7C3AED),
    Color(0xFF111827),
  ];
  bool _soundOn = true;

  @override
  Widget build(BuildContext context) {
    final accent = panelAccent(context);
    final colorHex = accent
        .toARGB32()
        .toRadixString(16)
        .substring(2)
        .toUpperCase();
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      drawer: const DashboardDrawer(currentPage: 'Panel Theme'),
      appBar: buildCpxBoatAppBar(context),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
        children: [
          const Text(
            'Panel Theme',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: Color(0xFF14213A),
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'Customize the look of your panel.',
            style: TextStyle(fontSize: 12, color: muted),
          ),
          const SizedBox(height: 20),
          _panelCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Panel theme',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF14213A),
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Choose a color for the panel header, navigation, buttons, links, and tables. Changes apply immediately.',
                  style: TextStyle(fontSize: 11, color: muted),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 9,
                  runSpacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ..._colors.map(
                      (color) => InkWell(
                        key: ValueKey(
                          'panel-theme-color-${color.toARGB32().toRadixString(16)}',
                        ),
                        onTap: () => _saveAccentColor(color),
                        customBorder: const CircleBorder(),
                        child: Container(
                          width: 29,
                          height: 29,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: accent == color
                              ? Icon(
                                  Icons.check,
                                  size: 17,
                                  color: _textColorFor(color),
                                )
                              : null,
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 28,
                      color: const Color(0xFFD9DFEA),
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                    ),
                    InkWell(
                      onTap: () async {
                        final picked = await showDialog<Color>(
                          context: context,
                          builder: (context) {
                            Color temp = accent;
                            return StatefulBuilder(
                              builder: (context, setDialogState) => AlertDialog(
                                title: const Text('Choose accent color'),
                                content: SizedBox(
                                  width: 260,
                                  child: Wrap(
                                    spacing: 12,
                                    runSpacing: 12,
                                    children: _colors
                                        .map(
                                          (c) => InkWell(
                                            onTap: () =>
                                                setDialogState(() => temp = c),
                                            child: Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                color: c,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: temp == c
                                                      ? Colors.black
                                                      : Colors.white,
                                                  width: 2,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, temp),
                                    child: const Text('Select'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                        if (picked != null) _saveAccentColor(picked);
                      },
                      child: Container(
                        width: 29,
                        height: 29,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFD9DFEA)),
                          gradient: const SweepGradient(
                            colors: [
                              Colors.red,
                              Colors.yellow,
                              Colors.green,
                              Colors.cyan,
                              Colors.blue,
                              Colors.purple,
                              Colors.red,
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.colorize,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF14213A),
                        side: const BorderSide(color: Color(0xFFD9DFEA)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () => _saveAccentColor(defaultPanelAccent),
                      icon: const Icon(Icons.refresh, size: 14),
                      label: const Text(
                        'Reset to default',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Text(
                      'Current: #$colorHex',
                      style: const TextStyle(fontSize: 10, color: muted),
                    ),
                    const Text(
                      'Changes apply instantly across the panel.',
                      style: TextStyle(fontSize: 10, color: muted),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FC),
                    border: Border.all(color: const Color(0xFFD9DFEA)),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, size: 13, color: muted),
                      SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          'Your selected color updates the panel header, navigation, buttons, links, active controls, and table headers immediately. Page backgrounds, text, and status colors remain unchanged.',
                          style: TextStyle(fontSize: 9, color: muted),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _panelCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notification sound',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF14213A),
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Play a sound in the WhatsApp/RCS Inbox and Notification Center when something new arrives.',
                  style: TextStyle(fontSize: 11, color: muted),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD9DFEA)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5F5F8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.notifications_none_rounded,
                          size: 16,
                          color: accent,
                        ),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _soundOn ? 'On' : 'Muted',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              _soundOn
                                  ? "You'll hear a short sound for new messages and alerts."
                                  : 'Notification sounds are muted.',
                              style: const TextStyle(
                                fontSize: 10,
                                color: muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SegmentedButton<bool>(
                        showSelectedIcon: false,
                        style: ButtonStyle(
                          visualDensity: VisualDensity.compact,
                          textStyle: const WidgetStatePropertyAll(
                            TextStyle(fontSize: 10),
                          ),
                          padding: const WidgetStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 9),
                          ),
                          backgroundColor: WidgetStateProperty.resolveWith(
                            (states) => states.contains(WidgetState.selected)
                                ? accent
                                : Colors.white,
                          ),
                          foregroundColor: WidgetStateProperty.resolveWith(
                            (states) => states.contains(WidgetState.selected)
                                ? Colors.white
                                : const Color(0xFF14213A),
                          ),
                        ),
                        segments: const [
                          ButtonSegment(
                            value: true,
                            label: Text('On'),
                            icon: Icon(
                              Icons.notifications_active_outlined,
                              size: 12,
                            ),
                          ),
                          ButtonSegment(
                            value: false,
                            label: Text('Mute'),
                            icon: Icon(
                              Icons.notifications_off_outlined,
                              size: 12,
                            ),
                          ),
                        ],
                        selected: {_soundOn},
                        onSelectionChanged: (values) =>
                            setState(() => _soundOn = values.first),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _panelCard({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFD9DFEA)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0D14213A),
          blurRadius: 3,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: child,
  );

  Color _textColorFor(Color color) =>
      ThemeData.estimateBrightnessForColor(color) == Brightness.dark
      ? Colors.white
      : const Color(0xFF14213A);

  Future<void> _saveAccentColor(Color color) async {
    try {
      await PanelThemeController.instance.setAccentColor(color);
    } on Exception catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save the panel theme: $error')),
      );
    }
  }
}
