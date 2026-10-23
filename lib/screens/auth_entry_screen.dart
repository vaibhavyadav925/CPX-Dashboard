part of '../app.dart';

class AuthEntryScreen extends StatefulWidget {
  const AuthEntryScreen({super.key});

  @override
  State<AuthEntryScreen> createState() => _AuthEntryScreenState();
}

class _AuthEntryScreenState extends State<AuthEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isSignup = false;
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  bool _rememberMe = true;
  bool _isArrowSliding = false;
  bool _isNavigating = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _continueToDashboard() {
    if (!_formKey.currentState!.validate()) return;
    if (_isSignup &&
        _passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match.')));
      return;
    }
    // UI-only preview: this form does not verify credentials or create a
    // secure account. Connect an authentication provider before deployment.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const DashboardScreen()),
    );
  }

  Future<void> _animateAndContinue() async {
    if (_isNavigating) return;

    // Validate before animating so invalid forms stay on the current screen.
    if (!_formKey.currentState!.validate()) return;
    if (_isSignup &&
        _passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match.')));
      return;
    }

    setState(() {
      _isArrowSliding = true;
      _isNavigating = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 280));
    if (!mounted) return;

    setState(() {
      _isArrowSliding = false;
    });

    // Keep navigation logic in the existing method.
    _continueToDashboard();
    if (mounted) {
      setState(() {
        _isNavigating = false;
      });
    }
  }

  InputDecoration _fieldDecoration(
    String label,
    IconData icon, {
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: muted, size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      labelStyle: const TextStyle(color: Color(0xFF172C4C)),
      floatingLabelStyle: const TextStyle(color: Color(0xFF0B91AD)),
      hintStyle: const TextStyle(color: Color(0xFF52627A)),
      prefixIconColor: const Color(0xFF52627A),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: premiumBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: premiumBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: teal, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final wide = width >= 850;

    // On phones, use the edge-to-edge layout from the supplied reference.
    // The desktop/tablet layout below remains unchanged.
    if (width < 600) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: navy,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: navy,
          body: Column(
            children: [
              // Navy background extends behind the phone status bar.
              Container(
                width: double.infinity,
                color: navy,
                child: SafeArea(
                  bottom: false,
                  child: SizedBox(
                    height: 72,
                    child: Center(child: _buildCompactBrand()),
                  ),
                ),
              ),
              Expanded(
                child: SafeArea(
                  top: false,
                  bottom: true,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    child: _buildFormPanel(wide: false),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B91AD), Color(0xFF14B8A6), navy],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(wide ? 32 : 18),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: premiumBorder),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x120B1730),
                        blurRadius: 32,
                        offset: Offset(0, 14),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: wide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(flex: 5, child: _buildBrandPanel()),
                            Expanded(
                              flex: 4,
                              child: _buildFormPanel(wide: true),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildCompactBrand(),
                            _buildFormPanel(wide: false),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandMark() => Image.asset(
    'assets/logo.png',
    width: 165,
    height: 56,
    fit: BoxFit.contain,
  );

  Widget _buildBrandPanel() => Container(
    constraints: const BoxConstraints(minHeight: 640),
    padding: const EdgeInsets.all(42),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [navy, Color(0xFF172C4C), Color(0xFF0B91AD)],
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [_buildBrandMark()]),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.12),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(.18)),
          ),
          child: const Text(
            'CUSTOMER COMMUNICATION PLATFORM',
            style: TextStyle(
              color: Color(0xFFB8F3EF),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'One workspace.\nEvery conversation.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 36,
            height: 1.15,
            fontWeight: FontWeight.w900,
            letterSpacing: -.6,
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Manage campaigns, messaging channels and customer engagement from your CPXBOAT dashboard.',
          style: TextStyle(color: Color(0xFFD4DEEC), fontSize: 15, height: 1.7),
        ),
        const SizedBox(height: 32),
        _brandFeature(
          Icons.dashboard_customize_outlined,
          'Unified dashboard',
          'Your key activity and performance in one place.',
        ),
        const SizedBox(height: 18),
        _brandFeature(
          Icons.forum_outlined,
          'Multi-channel messaging',
          'Keep campaigns and channels organised.',
        ),
        const SizedBox(height: 18),
        _brandFeature(
          Icons.insights_outlined,
          'Clear campaign insights',
          'Review delivery and engagement reports.',
        ),
        const Spacer(),
        const Text(
          'CPXBOAT  •  Messaging made manageable',
          style: TextStyle(color: Color(0xFFB7C5D8), fontSize: 11),
        ),
      ],
    ),
  );

  Widget _buildCompactBrand() => SizedBox(
    width: double.infinity,
    child: Center(
      child: Image.asset(
        'assets/logo.png',
        width: 165,
        height: 56,
        fit: BoxFit.contain,
        alignment: Alignment.center,
      ),
    ),
  );

  Widget _brandFeature(IconData icon, String title, String subtitle) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.1),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Icon(icon, color: const Color(0xFF7DE2D8), size: 20),
      ),
      const SizedBox(width: 13),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: Color(0xFFCFD9E7),
                fontSize: 11.5,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _buildFormPanel({required bool wide}) => Padding(
    padding: EdgeInsets.symmetric(
      horizontal: wide ? 42 : 14,
      vertical: wide ? 42 : 28,
    ),
    child: Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isSignup ? 'Create your account' : 'Welcome back',
            style: const TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 27,
              fontWeight: FontWeight.w900,
              letterSpacing: -.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isSignup
                ? 'Sign up to get started with CPXBOAT.'
                : 'Sign in to continue to your CPXBOAT workspace.',
            style: const TextStyle(
              color: Color(0xFFD4DEEC),
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          if (_isSignup) ...[
            TextFormField(
              controller: _nameController,
              style: const TextStyle(color: Color(0xFF0B1730)),
              textCapitalization: TextCapitalization.words,
              decoration: _fieldDecoration(
                'Full Name',
                Icons.person_outline_rounded,
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
            ),
            const SizedBox(height: 15),
          ],
          TextFormField(
            controller: _emailController,
            style: const TextStyle(color: Color(0xFF0B1730)),
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: _fieldDecoration(
              'Work email',
              Icons.mail_outline_rounded,
            ),
            validator: (v) {
              final email = (v ?? '').trim();
              if (email.isEmpty) return 'Enter your email address';
              if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email))
                return 'Enter a valid email address';
              return null;
            },
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: _passwordController,
            style: const TextStyle(color: Color(0xFF0B1730)),
            obscureText: _hidePassword,
            autofillHints: _isSignup
                ? const [AutofillHints.newPassword]
                : const [AutofillHints.password],
            decoration: _fieldDecoration(
              'Password',
              Icons.lock_outline_rounded,
              suffix: IconButton(
                tooltip: _hidePassword ? 'Show password' : 'Hide password',
                onPressed: () => setState(() => _hidePassword = !_hidePassword),
                icon: Icon(
                  _hidePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: muted,
                ),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Enter your password';
              if (v.length < 6) return 'Use at least 6 characters';
              return null;
            },
          ),
          if (_isSignup) ...[
            const SizedBox(height: 15),
            TextFormField(
              controller: _confirmPasswordController,
              style: const TextStyle(color: Color(0xFF0B1730)),
              obscureText: _hideConfirmPassword,
              decoration: _fieldDecoration(
                'Confirm password',
                Icons.lock_reset_outlined,
                suffix: IconButton(
                  tooltip: _hideConfirmPassword
                      ? 'Show password'
                      : 'Hide password',
                  onPressed: () => setState(
                    () => _hideConfirmPassword = !_hideConfirmPassword,
                  ),
                  icon: Icon(
                    _hideConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: muted,
                  ),
                ),
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Confirm your password' : null,
            ),
          ],
          if (!_isSignup) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: _rememberMe,
                    activeColor: teal,
                    onChanged: (v) => setState(() => _rememberMe = v ?? false),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                const Expanded(
                  child: Text(
                    'Remember me',
                    style: TextStyle(color: Color(0xFFD4DEEC), fontSize: 12),
                  ),
                ),
                TextButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Password recovery needs an authentication service.',
                      ),
                    ),
                  ),
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isNavigating ? null : _animateAndContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: teal,
                foregroundColor: const Color.fromARGB(255, 255, 254, 254),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isSignup ? 'Create account' : 'Sign in',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 9),
                  AnimatedSlide(
                    offset: _isArrowSliding
                        ? const Offset(0.7, 0)
                        : Offset.zero,
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeInOutCubic,
                    child: const Icon(Icons.arrow_forward_rounded, size: 18),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              const Expanded(child: Divider(color: premiumBorder)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  _isSignup ? 'ALREADY REGISTERED?' : 'NEW TO CPXBOAT?',
                  style: const TextStyle(
                    color: Color(0xFFD4DEEC),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .8,
                  ),
                ),
              ),
              const Expanded(child: Divider(color: premiumBorder)),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton(
              onPressed: () => setState(() => _isSignup = !_isSignup),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white),
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _isSignup ? 'Back to sign in' : 'Create a new account',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Center(
            child: Text(
              'By continuing, you agree to your organisation’s usage policies.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFD4DEEC),
                fontSize: 10,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(),
        ],
      ),
    ),
  );
}
