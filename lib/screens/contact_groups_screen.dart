part of '../app.dart';

class ContactGroupsScreen extends StatefulWidget {
  const ContactGroupsScreen({super.key});

  @override
  State<ContactGroupsScreen> createState() => _ContactGroupsScreenState();
}

class _ContactGroupsScreenState extends State<ContactGroupsScreen> {
  final List<String> _groups = ['Ajay', 'Rohit', 'testing', 'rohit testing'];
  final Map<String, List<Map<String, String>>> _contacts = {
    'Ajay': [
      {'name': 'kunal', 'phone': '919205067680'},
      {'name': '', 'phone': '919205075430'},
      {'name': 'Jay', 'phone': '917337522120'},
      {'name': '', 'phone': '919198510510'},
      {'name': '', 'phone': '919136765010'},
      {'name': '', 'phone': '919310063414'},
      {'name': '', 'phone': '918448172887'},
      {'name': '', 'phone': '917217283381'},
      {'name': '', 'phone': '919990332999'},
      {'name': '', 'phone': '919305011640'},
    ],
    'testing': [
      {'name': 'ajay', 'phone': '1234567890'},
      {'name': 'ajay11', 'phone': '0987654321'},
    ],
    'rohit testing': [
      {'name': '', 'phone': '919990999719'},
    ],
    'Rohit': [
      {'name': '', 'phone': '919205075430'},
      {'name': '', 'phone': '917337522120'},
      {'name': '', 'phone': '919198510510'},
      {'name': '', 'phone': '919136765010'},
      {'name': '', 'phone': '919310063414'},
      {'name': '', 'phone': '918448172887'},
      {'name': '', 'phone': '917217283381'},
      {'name': '', 'phone': '919990332999'},
      {'name': '', 'phone': '919305011640'},
    ],
  };
  String _selected = 'Ajay';

  Future<void> _newGroup() async {
    final nameController = TextEditingController();
    final sheetController = TextEditingController();
    final manualController = TextEditingController();
    String mode = 'Excel/CSV';

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, refreshDialog) => Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460, maxHeight: 620),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'New contact group',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF202B3D),
                            ),
                          ),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: () => Navigator.pop(dialogContext),
                          icon: const Icon(
                            Icons.close,
                            size: 18,
                            color: Color(0xFF8A96A8),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'Import from a spreadsheet, Google Sheet, or type numbers manually.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF718096)),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Group name',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: nameController,
                      decoration: _groupFieldDecoration(),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFD9E1ED)),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Row(
                        children: ['Excel/CSV', 'Google Sheet', 'Manual']
                            .map(
                              (label) => Expanded(
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(7),
                                  onTap: () =>
                                      refreshDialog(() => mode = label),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 9,
                                      horizontal: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: mode == label
                                          ? const Color(0xFF0B91AD)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      label,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: mode == label
                                            ? Colors.white
                                            : const Color(0xFF718096),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (mode == 'Excel/CSV')
                      Container(
                        height: 48,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFD9E1ED),
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.upload_file_outlined,
                              size: 16,
                              color: Color(0xFF718096),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Upload .xlsx or .csv',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF718096),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (mode == 'Google Sheet')
                      TextField(
                        controller: sheetController,
                        decoration: _groupFieldDecoration(
                          hint: 'https://docs.google.com/spreadsheets/d/...',
                        ),
                      ),
                    if (mode == 'Manual') ...[
                      TextField(
                        controller: manualController,
                        maxLines: 5,
                        decoration: _groupFieldDecoration(
                          hint: '9876543210, John\n9123456780, Priya',
                          hintSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'One per line: phone number, optional name.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF718096),
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0B91AD),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        onPressed: () {
                          final groupName = nameController.text.trim();
                          if (groupName.isEmpty) return;
                          final entries = <Map<String, String>>[];
                          if (mode == 'Manual') {
                            for (final line in manualController.text.split(
                              RegExp(r'\r?\n'),
                            )) {
                              final parts = line.split(',');
                              final phone = parts.first.trim();
                              if (phone.isNotEmpty)
                                entries.add({
                                  'phone': phone,
                                  'name': parts.length > 1
                                      ? parts.sublist(1).join(',').trim()
                                      : '',
                                });
                            }
                          }
                          setState(() {
                            if (!_groups.contains(groupName))
                              _groups.add(groupName);
                            _contacts[groupName] = entries;
                            _selected = groupName;
                          });
                          Navigator.pop(dialogContext);
                        },
                        child: const Text(
                          'Import',
                          style: TextStyle(fontWeight: FontWeight.w700),
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
    sheetController.dispose();
    manualController.dispose();
  }

  InputDecoration _groupFieldDecoration({
    String? hint,
    double hintSize = 11,
  }) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(fontSize: hintSize, color: const Color(0xFF9AA4B2)),
    isDense: true,
    filled: true,
    fillColor: const Color(0xFFF7F9FC),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFD9E1ED)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFD9E1ED)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF0B91AD), width: 1.5),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final rows = _contacts[_selected] ?? <Map<String, String>>[];
    final isMobile = MediaQuery.sizeOf(context).width < 800;
    return Scaffold(
      drawer: const DashboardDrawer(currentPage: 'Contact Groups'),
      appBar: buildCpxBoatAppBar(context),
      body: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contacts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF17243B),
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Manage phonebook groups used as campaign recipients.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF718096),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _newGroup,
                  icon: const Icon(Icons.add, size: 17),
                  label: const Text('New group'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B91AD),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 10 : 16,
                      vertical: isMobile ? 11 : 14,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final groupWidth = isMobile
                      ? 135.0
                      : (constraints.maxWidth < 850 ? 175.0 : 250.0);
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: groupWidth,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFFDCE3EE)),
                            borderRadius: BorderRadius.circular(13),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x10000000),
                                blurRadius: 3,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: ListView(
                            children: _groups
                                .map(
                                  (group) => Padding(
                                    padding: const EdgeInsets.only(bottom: 3),
                                    child: Material(
                                      color: _selected == group
                                          ? const Color(0xFFE5F5F8)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(7),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(7),
                                        onTap: () =>
                                            setState(() => _selected = group),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 7,
                                            vertical: 9,
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.people_outline,
                                                size: 14,
                                                color: Color(0xFF334155),
                                              ),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  group,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: _selected == group
                                                        ? const Color(
                                                            0xFF0B91AD,
                                                          )
                                                        : const Color(
                                                            0xFF17243B,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _groups.remove(group);
                                                    _contacts.remove(group);
                                                    if (_selected == group)
                                                      _selected =
                                                          _groups.isEmpty
                                                          ? ''
                                                          : _groups.first;
                                                  });
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.all(3),
                                                  child: Icon(
                                                    Icons.delete_outline,
                                                    size: 13,
                                                    color: Color(0xFF7C8AA0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFFDCE3EE)),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x10000000),
                                blurRadius: 3,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: LayoutBuilder(
                            builder: (context, tableConstraints) {
                              final tableWidth = tableConstraints.maxWidth < 520
                                  ? 520.0
                                  : tableConstraints.maxWidth;
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  width: tableWidth,
                                  child: Column(
                                    children: [
                                      Container(
                                        color: const Color(0xFF0B91AD),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 13,
                                        ),
                                        child: const Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                'Name',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                'Phone',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
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
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 76,
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  'Actions',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: rows.isEmpty
                                            ? const Center(
                                                child: Text(
                                                  'No contacts in this group',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF718096),
                                                  ),
                                                ),
                                              )
                                            : ListView.builder(
                                                itemCount: rows.length,
                                                itemBuilder: (context, index) {
                                                  final row = rows[index];
                                                  return Container(
                                                    constraints:
                                                        const BoxConstraints(
                                                          minHeight: 60,
                                                        ),
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 8,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: index.isOdd
                                                          ? const Color(
                                                              0xFFF8FAFD,
                                                            )
                                                          : Colors.white,
                                                      border: const Border(
                                                        bottom: BorderSide(
                                                          color: Color(
                                                            0xFFDCE3EE,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 3,
                                                          child: Text(
                                                            row['name']!.isEmpty
                                                                ? '—'
                                                                : row['name']!,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Color(
                                                                    0xFF17243B,
                                                                  ),
                                                                ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Text(
                                                            row['phone'] ?? '',
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Color(
                                                                    0xFF17243B,
                                                                  ),
                                                                ),
                                                          ),
                                                        ),
                                                        const Expanded(
                                                          flex: 2,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: DecoratedBox(
                                                              decoration: BoxDecoration(
                                                                color: Color(
                                                                  0xFFE2F8EC,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                      Radius.circular(
                                                                        20,
                                                                      ),
                                                                    ),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          9,
                                                                      vertical:
                                                                          4,
                                                                    ),
                                                                child: Text(
                                                                  'Active',
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: Color(
                                                                      0xFF079C55,
                                                                    ),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 76,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              IconButton(
                                                                visualDensity:
                                                                    VisualDensity
                                                                        .compact,
                                                                tooltip: 'Edit',
                                                                onPressed: () {
                                                                  final controller =
                                                                      TextEditingController(
                                                                        text:
                                                                            row['name'],
                                                                      );
                                                                  showDialog<
                                                                    void
                                                                  >(
                                                                    context:
                                                                        context,
                                                                    builder: (ctx) => AlertDialog(
                                                                      title:
                                                                          const Text(
                                                                            'Edit contact',
                                                                          ),
                                                                      content: TextField(
                                                                        controller:
                                                                            controller,
                                                                        decoration:
                                                                            const InputDecoration(
                                                                              labelText: 'Name',
                                                                            ),
                                                                      ),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed: () => Navigator.pop(
                                                                            ctx,
                                                                          ),
                                                                          child:
                                                                              const Text(
                                                                                'Cancel',
                                                                              ),
                                                                        ),
                                                                        ElevatedButton(
                                                                          onPressed: () {
                                                                            setState(
                                                                              () => row['name'] = controller.text.trim(),
                                                                            );
                                                                            Navigator.pop(
                                                                              ctx,
                                                                            );
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                                'Save',
                                                                              ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                                icon: const Icon(
                                                                  Icons
                                                                      .edit_outlined,
                                                                  size: 15,
                                                                ),
                                                              ),
                                                              IconButton(
                                                                visualDensity:
                                                                    VisualDensity
                                                                        .compact,
                                                                tooltip:
                                                                    'Delete',
                                                                onPressed: () =>
                                                                    setState(
                                                                      () => rows
                                                                          .removeAt(
                                                                            index,
                                                                          ),
                                                                    ),
                                                                icon: const Icon(
                                                                  Icons
                                                                      .delete_outline,
                                                                  size: 15,
                                                                  color: Colors
                                                                      .redAccent,
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
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
