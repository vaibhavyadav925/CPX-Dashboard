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

  Future<void> _showForgotPasswordDialog() async {
    final recoveryEmailController = TextEditingController(
      text: _emailController.text.trim(),
    );
    final recoveryFormKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF0B2140),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF315C88)),
        ),
        title: const Text(
          'Forgot password?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        content: Form(
          key: recoveryFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter your account email. This form is ready for an authentication service, but password reset emails cannot be sent until one is connected.',
                style: TextStyle(
                  color: Color(0xFFD4DEEC),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: recoveryEmailController,
                autofocus: false,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                style: const TextStyle(color: Colors.white),
                decoration: _fieldDecoration(
                  'Work email',
                  Icons.mail_outline_rounded,
                ),
                validator: (value) {
                  final email = (value ?? '').trim();
                  if (email.isEmpty) return 'Enter your email address';
                  if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFFD4DEEC)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (!recoveryFormKey.currentState!.validate()) return;
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Email validated. Connect an authentication service to send a real password reset link.',
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF03BBD9),
              foregroundColor: Colors.white,
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );

    recoveryEmailController.dispose();
  }

  InputDecoration _fieldDecoration(
    String label,
    IconData icon, {
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFFD4E6F9), size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFF102E53),
      labelStyle: const TextStyle(color: Color(0xFFCCDDF2)),
      floatingLabelStyle: const TextStyle(color: Color(0xFF0B91AD)),
      hintStyle: const TextStyle(color: Color(0xFFB7CBE4)),
      prefixIconColor: const Color(0xFFD4E6F9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF315C88)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF315C88)),
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
          statusBarColor: Color(0xFF07152D),
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: Scaffold(
          // Keep the full phone canvas on one consistent navy base so
          // the area below the scrollable form never appears as a separate band.
          backgroundColor: const Color(0xFF06142D),
          body: Stack(
            fit: StackFit.expand,
            children: [
              const Positioned.fill(
                child: ColoredBox(color: Color(0xFF06142D)),
              ),
              Positioned(
                left: -210,
                bottom: -245,
                child: Container(
                  width: 430,
                  height: 430,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF047BD4).withOpacity(.32),
                      width: 2,
                    ),
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF064E9B).withOpacity(.22),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -250,
                bottom: -275,
                child: Container(
                  width: 460,
                  height: 460,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF00D6F2).withOpacity(.32),
                      width: 2,
                    ),
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF078BC0).withOpacity(.18),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 460),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(child: _buildCompactBrand()),
                          const SizedBox(height: 10),
                          _buildMobileBrandIntro(),
                          const SizedBox(height: 6),
                          _buildFormPanel(wide: false),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Borderless, full-bleed premium desktop/tablet experience.
    return Scaffold(
      backgroundColor: const Color(0xFF06162F),
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF07152D),
                    Color(0xFF082750),
                    Color(0xFF06142D),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: -240,
            bottom: -380,
            child: Container(
              width: 920,
              height: 650,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF047BD4).withOpacity(.40),
                  width: 3,
                ),
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF064E9B).withOpacity(.55),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: -310,
            bottom: -440,
            child: Container(
              width: 850,
              height: 800,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF00D6F2).withOpacity(.55),
                  width: 3,
                ),
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF078BC0).withOpacity(.38),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: wide ? 56 : 28,
                  vertical: 36,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 72,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1180),
                      child: wide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(flex: 11, child: _buildBrandPanel()),
                                const SizedBox(width: 80),
                                Expanded(
                                  flex: 10,
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
        ],
      ),
    );
  }

  Widget _buildBrandMark() => Image.asset(
    'assets/logo.png',
    width: 165,
    height: 56,
    fit: BoxFit.contain,
  );

  Widget _buildMobileBrandIntro() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFF0A416B).withOpacity(.55),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFF1A79BC).withOpacity(.65)),
          ),
          child: const Text(
            'CUSTOMER COMMUNICATION PLATFORM',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF83EEFA),
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
      const SizedBox(height: 20),
      const Text(
        'One workspace.',
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.w900,
          letterSpacing: -.7,
          height: 1.12,
        ),
      ),
      const Text(
        'Every conversation.',
        style: TextStyle(
          color: Color(0xFF05C5EB),
          fontSize: 30,
          fontWeight: FontWeight.w900,
          letterSpacing: -.7,
          height: 1.12,
        ),
      ),
      const SizedBox(height: 10),
      const Text(
        'Manage campaigns, messaging channels and customer engagement from your CPXBOAT dashboard.',
        style: TextStyle(color: Color(0xFFC7D9F1), fontSize: 12, height: 1.5),
      ),
    ],
  );

  Widget _buildBrandPanel() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBrandMark(),
        const SizedBox(height: 55),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: const Color(0xFF0A416B).withOpacity(.65),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFF1A79BC).withOpacity(.6)),
          ),
          child: const Text(
            'CUSTOMER COMMUNICATION PLATFORM',
            style: TextStyle(
              color: Color(0xFF83EEFA),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 28),
        const Text(
          'One workspace.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 43,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.2,
          ),
        ),
        const Text(
          'Every conversation.',
          style: TextStyle(
            color: Color(0xFF05C5EB),
            fontSize: 43,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.2,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Manage campaigns, messaging channels and customer\nengagement from your CPXBOAT dashboard.',
          style: TextStyle(color: Color(0xFFC7D9F1), fontSize: 15, height: 1.6),
        ),
        const SizedBox(height: 34),
        _brandFeature(
          Icons.dashboard_customize_outlined,
          'Unified dashboard',
          'Your key activity and performance in one place.',
        ),
        const SizedBox(height: 19),
        _brandFeature(
          Icons.forum_outlined,
          'Multi-channel messaging',
          'Keep campaigns and channels organised.',
        ),
        const SizedBox(height: 19),
        _brandFeature(
          Icons.insights_outlined,
          'Clear campaign insights',
          'Review delivery and engagement reports.',
        ),
        const SizedBox(height: 48),
        const Text(
          'CPXBOAT  •  Messaging made manageable',
          style: TextStyle(color: Color(0xFFB7C5D8), fontSize: 12),
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
      horizontal: wide ? 0 : 14,
      vertical: wide ? 18 : 10,
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
              fontSize: 32,
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
              style: const TextStyle(color: Colors.white),
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
            style: const TextStyle(color: Colors.white),
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
            style: const TextStyle(color: Colors.white),
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
                  color: const Color(0xFFD4E6F9),
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
              style: const TextStyle(color: Colors.white),
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
                    color: const Color(0xFFD4E6F9),
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
                  onPressed: _showForgotPasswordDialog,
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
                backgroundColor: const Color(0xFF03BBD9),
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
