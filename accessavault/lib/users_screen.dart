import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:accessavault/user_provider.dart'; // Import UserProvider
import 'package:accessavault/add_user.dart';
import 'package:accessavault/client_provider.dart';
import 'package:accessavault/main.dart'; // For routeObserver
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(
      this,
      ModalRoute.of(context)! as PageRoute<dynamic>,
    );
    // Load users when this screen becomes active
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().loadUsers();
    });
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when returning to this screen
    context.read<UserProvider>().loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        title: const Text(
          'Employees',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _generatePdf(context.read<UserProvider>().users),
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                  label: const Text(
                    'Download PDF',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => _generateExcel(context.read<UserProvider>().users),
                  icon: const Icon(Icons.table_chart, color: Colors.white),
                  label: const Text(
                    'Download Excel',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddUserPage()),
                    );
                    context.read<UserProvider>().loadUsers();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B2447),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    '+ Add Employee',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            final users = userProvider.users;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Role',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Status',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Client',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Actions',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      rows:
                          users.map((user) {
                            return DataRow(
                              cells: [
                                DataCell(Text(user['name'] ?? '')),
                                DataCell(Text(user['role'] ?? '')),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          (user['status'] == 'Active')
                                              ? Colors.green[100]
                                              : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      user['status'] ?? '',
                                      style: TextStyle(
                                        color:
                                            (user['status'] == 'Active')
                                                ? Colors.green[900]
                                                : Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Consumer<ClientProvider>(
                                    builder: (context, clientProvider, child) {
                                      final clientId = user['client_id'];
                                      final client = clientProvider.clients
                                          .firstWhere(
                                            (c) => c.id == clientId,
                                            orElse:
                                                () => Client(
                                                  id: '',
                                                  name: 'N/A',
                                                  contactPerson: 'N/A',
                                                  email: '',
                                                  website: '',
                                                  status: '',
                                                  businessId: '',
                                                  businessName: 'N/A',
                                                  businessUserName: '',
                                                  businessLogoUrl: '',
                                                  aboutBusiness: '',
                                                ),
                                          );
                                      return Text(client.name);
                                    },
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () async {
                                          final userIndex = users.indexOf(user);
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => AddUserPage(
                                                    user: user,
                                                    userIndex: userIndex,
                                                  ),
                                            ),
                                          );
                                          context
                                              .read<UserProvider>()
                                              .loadUsers();
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          context
                                              .read<UserProvider>()
                                              .deleteUser(users.indexOf(user));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _generatePdf(List<Map<String, dynamic>> users) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Users List', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Name', 'Role', 'Status', 'Client'],
                data: users.map((user) => [
                  user['name'] ?? '',
                  user['role'] ?? '',
                  user['status'] ?? '',
                  user['client_id'] ?? '', // This will show client ID, not name
                ]).toList(),
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/users_list.pdf');
    await file.writeAsBytes(await pdf.save());
    OpenFilex.open(file.path);
  }

  Future<void> _generateExcel(List<Map<String, dynamic>> users) async {
    final excel = Excel.createExcel();
    final sheet = excel.sheets[excel.getDefaultSheet()]!;

    // Add headers
    sheet.appendRow(['Name', 'Role', 'Status', 'Client']);

    // Add data
    for (var user in users) {
      sheet.appendRow([
        user['name'] ?? '',
        user['role'] ?? '',
        user['status'] ?? '',
        user['client_id'] ?? '', // This will show client ID, not name
      ]);
    }

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/users_list.xlsx');
    await file.writeAsBytes(excel.encode()!);
    OpenFilex.open(file.path);
  }
}
