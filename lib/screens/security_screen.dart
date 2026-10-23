part of '../app.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final Color ink = const Color(0xFF14213A);
  final Color borderColor = const Color(0xFFD9DFEA);
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String apiKey = '425470ee-9d39-11f1-9df0-dae8d4bd3a21';
  bool twoFactorEnabled = false;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      drawer: const DashboardDrawer(currentPage: 'Security'),
      appBar: buildCpxBoatAppBar(context),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
        children: [
          Text(
            'Security',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: ink,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'API key, password, and two-factor authentication.',
            style: TextStyle(fontSize: 12, color: muted),
          ),
          const SizedBox(height: 20),
          _securityCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'API key',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: ink,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Used to authenticate your server-to-server API requests.',
                  style: TextStyle(fontSize: 11, color: muted),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 34,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FC),
                          border: Border.all(color: borderColor),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: SelectableText(
                          apiKey,
                          style: const TextStyle(
                            fontSize: 11,
                            fontFamily: 'monospace',
                            color: Color(0xFF17233A),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      tooltip: 'Copy API key',
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: apiKey));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('API key copied')),
                        );
                      },
                      icon: const Icon(Icons.content_copy_rounded, size: 17),
                      style: IconButton.styleFrom(
                        side: BorderSide(color: borderColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _regenerateKey,
                  icon: const Icon(Icons.refresh_rounded, size: 15),
                  label: const Text(
                    'Regenerate key',
                    style: TextStyle(fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ink,
                    side: BorderSide(color: borderColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _securityCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Change password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: ink,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  "Choose a strong password you don't use elsewhere.",
                  style: TextStyle(fontSize: 11, color: muted),
                ),
                const SizedBox(height: 20),
                _passwordField('Current password', currentPasswordController),
                const SizedBox(height: 12),
                _passwordField('New password', newPasswordController),
                const SizedBox(height: 12),
                _passwordField(
                  'Confirm new password',
                  confirmPasswordController,
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _updatePassword,
                  style: FilledButton.styleFrom(
                    backgroundColor: teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Update password',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _securityCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Two-factor authentication',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: ink,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Add an extra layer of security to your account.',
                  style: TextStyle(fontSize: 11, color: muted),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  constraints: const BoxConstraints(maxWidth: 360),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5F4F7),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: const Icon(
                          Icons.shield_outlined,
                          color: Color(0xFF0B91AD),
                          size: 17,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              twoFactorEnabled ? 'Enabled' : 'Disabled',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: ink,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              twoFactorEnabled
                                  ? 'A verification code will be required at sign-in.'
                                  : 'Turn on to require a code at sign-in.',
                              style: const TextStyle(
                                fontSize: 10,
                                color: muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: twoFactorEnabled,
                        activeColor: teal,
                        onChanged: (value) =>
                            setState(() => twoFactorEnabled = value),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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

  Widget _securityCard({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: borderColor),
      borderRadius: BorderRadius.circular(13),
      boxShadow: const [
        BoxShadow(
          color: Color(0x080E1B33),
          blurRadius: 3,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: child,
  );

  Widget _passwordField(String label, TextEditingController controller) =>
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: ink,
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 35,
              child: TextField(
                controller: controller,
                obscureText: true,
                style: const TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: borderColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  void _regenerateKey() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Regenerate API key?'),
        content: const Text(
          'Your existing API key will be replaced. Update any integrations that use it.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(
                () => apiKey =
                    '${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}-${DateTime.now().microsecondsSinceEpoch.toRadixString(16)}',
              );
              Navigator.pop(ctx);
            },
            child: const Text('Regenerate'),
          ),
        ],
      ),
    );
  }

  void _updatePassword() {
    if (currentPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all password fields.')),
      );
      return;
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New password and confirmation do not match.'),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Password form validated. Connect this action to your authentication service to save the password.',
        ),
      ),
    );
  }
}
