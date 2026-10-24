part of '../app.dart';

class AgentRolesScreen extends StatefulWidget {
  const AgentRolesScreen({super.key});

  @override
  State<AgentRolesScreen> createState() => _AgentRolesScreenState();
}

class _AgentRolesScreenState extends State<AgentRolesScreen> {
  final List<Map<String, dynamic>> _users = [
    {
      'first': 'anu',
      'last': 'i',
      'username': 'dcdsdc',
      'email': 'anuwde@gmail.com',
      'role': 'Agent',
      'access': 8,
      'active': true,
      'mobile': '1234567890',
    },
    {
      'first': 'anu',
      'last': 'i',
      'username': 'sdcd',
      'email': 'anu@gmail.com',
      'role': 'Manager',
      'access': 3,
      'active': true,
      'mobile': '1234567890',
    },
    {
      'first': 'abc',
      'last': 'abc',
      'username': 'dcdcdc',
      'email': 'asbc@gmail.com',
      'role': 'Manager',
      'access': 3,
      'active': true,
      'mobile': '1234567890',
    },
    {
      'first': 'xxzx z xz zx',
      'last': '',
      'username': 'ajay1',
      'email': 'rohit2.raghav2@gmail.com',
      'role': 'Manager',
      'access': 18,
      'active': true,
      'mobile': '1234567890',
    },
    {
      'first': 'Ajay K',
      'last': '',
      'username': 'AjayManager',
      'email': 'abc@gmail.com',
      'role': 'Manager',
      'access': 2,
      'active': true,
      'mobile': '1234567890',
    },
  ];
  final List<String> _modules = const [
    'Dashboard',
    'Campaigns',
    'Chatbot',
    'Scheduled',
    'Download Center',
    'User Roles',
    'Onboard Channels',
    'Security',
    'Occasions',
    'Business Profile',
    'Tier Limit',
    'Commerce',
    'CRM Leads',
    'Inbox',
    'Templates',
    'Reports',
    'Contacts',
    'Billing',
    'Channels Info',
    'Account Details',
    'Panel Theme',
    'Sender IDs',
    'Quick Links',
    'Flows',
    'AI Assistant',
    'Automations',
  ];

  InputDecoration _input(String hint) => InputDecoration(
    hintText: hint,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: Color(0xFFD9E0EA)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: Color(0xFFD9E0EA)),
    ),
  );

  Future<void> _editUser(int index) async {
    final user = Map<String, dynamic>.from(_users[index]);
    final first = TextEditingController(text: user['first']);
    final last = TextEditingController(text: user['last']);
    final username = TextEditingController(text: user['username']);
    final password = TextEditingController();
    final email = TextEditingController(text: user['email']);
    final mobile = TextEditingController(text: user['mobile']);
    String role = user['role'];
    final selected = <String>{...(_modules.take(user['access'] as int))};
    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, refresh) => AlertDialog(
          title: Row(
            children: [
              const Expanded(
                child: Text(
                  'Edit user',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(ctx),
                icon: const Icon(Icons.close, size: 18),
              ),
            ],
          ),
          content: SizedBox(
            width: 430,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(child: _field('First name', first)),
                      const SizedBox(width: 8),
                      Expanded(child: _field('Last name', last)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _field('Username', username)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _field(
                          'Password (unchanged if blank)',
                          password,
                          obscure: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _field('Email', email)),
                      const SizedBox(width: 8),
                      Expanded(child: _field('Mobile number *', mobile)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Role',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    initialValue: role,
                    decoration: _input('Role'),
                    items: const [
                      DropdownMenuItem(value: 'Agent', child: Text('Agent')),
                      DropdownMenuItem(
                        value: 'Manager',
                        child: Text('Manager'),
                      ),
                    ],
                    onChanged: (v) => refresh(() => role = v ?? role),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Module access',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFD9E0EA)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Wrap(
                      spacing: 18,
                      runSpacing: 0,
                      children: _modules.map((m) {
                        return SizedBox(
                          width: 155,
                          child: CheckboxListTile(
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              m,
                              style: const TextStyle(fontSize: 10),
                            ),
                            value: selected.contains(m),
                            onChanged: (v) => refresh(() {
                              if (v == true) {
                                selected.add(m);
                              } else {
                                selected.remove(m);
                              }
                            }),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choose which sections of the panel this user can access.',
                    style: TextStyle(fontSize: 10, color: muted),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: panelAccent(context),
                      ),
                      onPressed: () {
                        setState(() {
                          _users[index]['first'] = first.text;
                          _users[index]['last'] = last.text;
                          _users[index]['username'] = username.text;
                          _users[index]['email'] = email.text;
                          _users[index]['mobile'] = mobile.text;
                          _users[index]['role'] = role;
                          _users[index]['access'] = selected.length;
                        });
                        Navigator.pop(ctx);
                      },
                      child: const Text('Save changes'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    bool obscure = false,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 4),
      TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(fontSize: 11),
        decoration: _input(''),
      ),
    ],
  );

  Future<void> _resetPassword(int index) async {
    final password = TextEditingController();
    final confirm = TextEditingController();
    bool show1 = false;
    bool show2 = false;
    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, refresh) => AlertDialog(
          title: Row(
            children: [
              const Expanded(
                child: Text(
                  'Reset password',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(ctx),
                icon: const Icon(Icons.close, size: 18),
              ),
            ],
          ),
          content: SizedBox(
            width: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _field(
                  'Username',
                  TextEditingController(text: _users[index]['username']),
                ),
                const SizedBox(height: 12),
                const Text(
                  'New password',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
                TextField(
                  controller: password,
                  obscureText: !show1,
                  decoration: _input('').copyWith(
                    suffixIcon: IconButton(
                      onPressed: () => refresh(() => show1 = !show1),
                      icon: Icon(
                        show1
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Confirm password',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
                TextField(
                  controller: confirm,
                  obscureText: !show2,
                  decoration: _input('').copyWith(
                    suffixIcon: IconButton(
                      onPressed: () => refresh(() => show2 = !show2),
                      icon: Icon(
                        show2
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: panelAccent(context),
                    ),
                    onPressed: () {
                      if (password.text.isNotEmpty &&
                          password.text == confirm.text) {
                        Navigator.pop(ctx);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Enter matching passwords.'),
                          ),
                        );
                      }
                    },
                    child: const Text('Reset password'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmAction(int index, {required bool block}) async {
    final user = _users[index];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          block ? 'Block this user?' : 'Remove this user?',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        content: Text(
          block
              ? 'This immediately revokes their access to the panel until unblocked.'
              : 'This revokes their access immediately and can’t be undone.',
          style: const TextStyle(fontSize: 12, color: muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE5484D),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(block ? 'Block' : 'Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      setState(() {
        if (block) {
          user['active'] = !(user['active'] as bool);
        } else {
          _users.removeAt(index);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageColor,
      appBar: buildCpxBoatAppBar(context),
      drawer: const DashboardDrawer(currentPage: 'Agent Roles'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Agent Roles',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: navy,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Manage team members under your account and which parts of the panel each one can access.',
                style: TextStyle(fontSize: 12, color: muted),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFDCE2EC)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x10000000),
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Team members',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: navy,
                                    ),
                                  ),
                                  Text(
                                    'Sub-users under your account, and which parts of the panel each one can access. (${_users.length} of 5 used)',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FilledButton.icon(
                              onPressed: _users.length >= 5
                                  ? null
                                  : () {
                                      setState(
                                        () => _users.add({
                                          'first': 'New',
                                          'last': 'user',
                                          'username': 'newuser',
                                          'email': '',
                                          'role': 'Agent',
                                          'access': 0,
                                          'active': true,
                                          'mobile': '',
                                        }),
                                      );
                                      _editUser(_users.length - 1);
                                    },
                              icon: const Icon(Icons.add, size: 15),
                              label: const Text('Add user'),
                              style: FilledButton.styleFrom(
                                backgroundColor: panelAccent(context),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (ctx, constraints) {
                            final compact = constraints.maxWidth < 720;
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                width: compact ? 900 : constraints.maxWidth,
                                child: Column(
                                  children: [
                                    Container(
                                      color: panelAccent(context),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 14,
                                      ),
                                      child: const Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              'Name',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              'Email',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              'Role',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              'Access',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              'Status',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 180,
                                            child: Text(
                                              'Actions',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: _users.length,
                                        itemBuilder: (ctx, i) {
                                          final u = _users[i];
                                          return Container(
                                            color: i.isEven
                                                ? Colors.white
                                                : const Color(0xFFF8FAFC),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8,
                                              horizontal: 14,
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${u['first']} ${u['last']}'
                                                            .trim(),
                                                        style: const TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${u['username']}',
                                                        style: const TextStyle(
                                                          fontSize: 10,
                                                          color: muted,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    '${u['email']}',
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: _pill(
                                                      '${u['role']}',
                                                      u['role'] == 'Agent'
                                                          ? const Color(
                                                              0xFFE9EDF4,
                                                            )
                                                          : const Color(
                                                              0xFFE0F4F8,
                                                            ),
                                                      u['role'] == 'Agent'
                                                          ? muted
                                                          : const Color(
                                                              0xFF0B91AD,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    '${u['access']} modules',
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      color: muted,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: _pill(
                                                      u['active']
                                                          ? 'Active'
                                                          : 'Blocked',
                                                      u['active']
                                                          ? const Color(
                                                              0xFFE1F8EB,
                                                            )
                                                          : const Color(
                                                              0xFFFFE7E7,
                                                            ),
                                                      u['active']
                                                          ? const Color(
                                                              0xFF008B54,
                                                            )
                                                          : const Color(
                                                              0xFFD93838,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 180,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      IconButton(
                                                        tooltip: 'Edit user',
                                                        onPressed: () =>
                                                            _editUser(i),
                                                        icon: const Icon(
                                                          Icons.edit_outlined,
                                                          size: 17,
                                                        ),
                                                      ),
                                                      IconButton(
                                                        tooltip:
                                                            'Reset password',
                                                        onPressed: () =>
                                                            _resetPassword(i),
                                                        icon: const Icon(
                                                          Icons.key_outlined,
                                                          size: 17,
                                                        ),
                                                      ),
                                                      IconButton(
                                                        tooltip: u['active']
                                                            ? 'Block user'
                                                            : 'Unblock user',
                                                        onPressed: () =>
                                                            _confirmAction(
                                                              i,
                                                              block: true,
                                                            ),
                                                        icon: Icon(
                                                          u['active']
                                                              ? Icons
                                                                    .lock_outline
                                                              : Icons
                                                                    .lock_open_outlined,
                                                          size: 17,
                                                        ),
                                                      ),
                                                      IconButton(
                                                        tooltip: 'Delete user',
                                                        onPressed: () =>
                                                            _confirmAction(
                                                              i,
                                                              block: false,
                                                            ),
                                                        icon: const Icon(
                                                          Icons.delete_outline,
                                                          size: 17,
                                                          color: Color(
                                                            0xFFE5484D,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pill(String text, Color bg, Color fg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: 10, color: fg, fontWeight: FontWeight.w700),
    ),
  );
}
