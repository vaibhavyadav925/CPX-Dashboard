part of '../app.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  String company = 'Webtechage-Manager';
  String firstName = '';
  String lastName = '';
  String email = 'Vaibhav@webtechagel.com';
  String phone = '6392368875';
  String region = 'India (INR)';
  String country = 'India';
  String stateName = '';
  String gstin = '';
  final Color borderColor = const Color(0xFFD9DFEA);
  final Color ink = const Color(0xFF14213A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      drawer: const DashboardDrawer(currentPage: 'Account Details'),
      appBar: buildCpxBoatAppBar(context),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
        children: [
          Text(
            'Account Details',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: ink,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'Manage your profile and billing information.',
            style: TextStyle(fontSize: 12, color: muted),
          ),
          const SizedBox(height: 26),
          Text(
            'Profile Details',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: ink,
            ),
          ),
          const SizedBox(height: 10),
          _panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: ink,
                            ),
                          ),
                          const Text(
                            'Your personal and company details.',
                            style: TextStyle(fontSize: 11, color: muted),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: _editProfile,
                      icon: const Icon(Icons.edit_outlined, size: 13),
                      label: const Text(
                        'Edit Settings',
                        style: TextStyle(fontSize: 11),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ink,
                        side: BorderSide(color: borderColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _profileGrid(),
              ],
            ),
          ),
          const SizedBox(height: 26),
          Text(
            'Billing Details',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: ink,
            ),
          ),
          const SizedBox(height: 10),
          _panel(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Wallet balance',
                        style: TextStyle(fontSize: 11, color: muted),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹2.648',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: ink,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5F4F7),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: panelAccent(context),
                    size: 17,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Billing details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: ink,
                            ),
                          ),
                          const Text(
                            'Used for invoices and account communication.',
                            style: TextStyle(fontSize: 11, color: muted),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: _editBilling,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ink,
                        side: BorderSide(color: borderColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 9,
                        ),
                      ),
                      child: const Text(
                        'Edit billing details',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _billingRow('Company name', company),
                _billingRow('Contact number', phone),
                _billingRow('Email address', email),
                _billingRow('Country', country),
                _billingRow('State', stateName.isEmpty ? '—' : stateName),
                _billingRow('GSTIN', gstin.isEmpty ? '—' : gstin, last: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _panel({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: borderColor),
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0A15213B),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: child,
  );

  Widget _profileGrid() => Wrap(
    spacing: 50,
    runSpacing: 16,
    children: [
      _profileField('Company name', company, width: 150),
      _profileField(
        'First name',
        firstName.isEmpty ? '—' : firstName,
        width: 150,
      ),
      _profileField('Last name', lastName.isEmpty ? '—' : lastName, width: 150),
      _profileField('Email', email, width: 150),
      _profileField('Mobile number', phone, width: 150),
      _profileField('Region', region, width: 150),
    ],
  );

  Widget _profileField(String label, String value, {double width = 180}) =>
      SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: muted)),
            const SizedBox(height: 3),
            Text(
              value,
              style: TextStyle(
                fontSize: 11,
                color: ink,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );

  Widget _billingRow(String label, String value, {bool last = false}) =>
      Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          border: last
              ? null
              : Border(bottom: BorderSide(color: borderColor, width: .7)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 11, color: muted),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 11,
                color: ink,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );

  InputDecoration _inputDecoration(String label, {String? hint}) =>
      InputDecoration(
        labelText: label,
        hintText: hint,
        isDense: true,
        filled: true,
        fillColor: const Color(0xFFF8F9FC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: panelAccent(context), width: 1.5),
        ),
      );

  Future<void> _editProfile() async {
    final companyC = TextEditingController(text: company);
    final firstC = TextEditingController(text: firstName);
    final lastC = TextEditingController(text: lastName);
    final emailC = TextEditingController(text: email);
    final phoneC = TextEditingController(text: phone);

    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setModal) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Edit Settings',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: ink,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                            icon: const Icon(
                              Icons.close,
                              size: 18,
                              color: muted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Update your personal and company details.',
                        style: TextStyle(fontSize: 12, color: muted),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: companyC,
                        decoration: _inputDecoration('Company name'),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: firstC,
                              decoration: _inputDecoration('First name'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: lastC,
                              decoration: _inputDecoration('Last name'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: emailC,
                              decoration: _inputDecoration('Email'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: phoneC,
                              decoration: _inputDecoration('Mobile number'),
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        enabled: false,
                        controller: TextEditingController(text: region),
                        decoration: _inputDecoration('Region'),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: panelAccent(context),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 13,
                              ),
                            ),
                            onPressed: () => Navigator.pop(dialogContext, true),
                            child: const Text(
                              'Save changes',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (saved == true && mounted) {
      setState(() {
        company = companyC.text;
        firstName = firstC.text;
        lastName = lastC.text;
        email = emailC.text;
        phone = phoneC.text;
      });
    }
    companyC.dispose();
    firstC.dispose();
    lastC.dispose();
    emailC.dispose();
    phoneC.dispose();
  }

  Future<void> _editBilling() async {
    final companyC = TextEditingController(text: company);
    final phoneC = TextEditingController(text: phone);
    final emailC = TextEditingController(text: email);
    final gstC = TextEditingController(text: gstin);
    final stateC = TextEditingController(text: stateName);
    String countryValue = country;

    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setModal) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Edit billing details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: ink,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                            icon: const Icon(
                              Icons.close,
                              size: 18,
                              color: muted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: companyC,
                              decoration: _inputDecoration('Company name'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: phoneC,
                              decoration: _inputDecoration('Contact number'),
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: emailC,
                              decoration: _inputDecoration('Email address'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: countryValue,
                              isExpanded: true,
                              decoration: _inputDecoration('Country'),
                              items: const [
                                DropdownMenuItem(
                                  value: 'India',
                                  child: Text(
                                    'India',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'United States',
                                  child: Text(
                                    'United States',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'United Kingdom',
                                  child: Text(
                                    'United Kingdom',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                              onChanged: (value) => setModal(() {
                                countryValue = value ?? 'India';
                              }),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: stateC,
                              decoration: _inputDecoration(
                                'State',
                                hint: 'Select state',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: gstC,
                              decoration: _inputDecoration(
                                'GSTIN',
                                hint: 'Enter GST number',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: panelAccent(context),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 13,
                              ),
                            ),
                            onPressed: () => Navigator.pop(dialogContext, true),
                            child: const Text(
                              'Save details',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (saved == true && mounted) {
      setState(() {
        company = companyC.text;
        phone = phoneC.text;
        email = emailC.text;
        gstin = gstC.text;
        stateName = stateC.text;
        country = countryValue;
      });
    }
    companyC.dispose();
    phoneC.dispose();
    emailC.dispose();
    gstC.dispose();
    stateC.dispose();
  }
}
