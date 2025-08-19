import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:accessavault/add_role_screen.dart';
import 'package:accessavault/role_detail_screen.dart';
import 'package:accessavault/role_provider.dart'; // Import the new RoleProvider
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';

class RolesScreen extends StatefulWidget {
  const RolesScreen({super.key});

  @override
  RolesScreenState createState() => RolesScreenState();
}

class RolesScreenState extends State<RolesScreen> {
  @override
  void initState() {
    super.initState();
    // Load roles when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RoleProvider>().loadRoles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        title: const Text(
          'Roles',
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
                  onPressed: () => _generatePdf(context.read<RoleProvider>().roles),
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
                  onPressed: () => _generateExcel(context.read<RoleProvider>().roles),
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
                      MaterialPageRoute(
                        builder: (context) => AddRoleScreen(
                          onRoleAdded: (newRole, users) {
                            context.read<RoleProvider>().addRole(
                                  Role(
                                    name: newRole['name']!,
                                    description: newRole['description']!,
                                    users: users ?? [],
                                  ),
                                );
                          },
                        ),
                      ),
                    );
                    context.read<RoleProvider>().loadRoles(); // Reload roles after adding
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
                    '+ Add Role',
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
        child: Consumer<RoleProvider>(
          builder: (context, roleProvider, child) {
            final roles = roleProvider.roles;
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
                            'Description',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Users',
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
                      rows: roles.asMap().entries.map((entry) {
                        final role = entry.value;
                        return DataRow(
                          cells: [
                            DataCell(Text(role.name)),
                            DataCell(Text(role.description)),
                            DataCell(Text(role.users.length.toString())),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RoleDetailScreen(
                                            roleName: role.name,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      context.read<RoleProvider>().deleteRole(role.name);
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

  Future<void> _generatePdf(List<Role> roles) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Roles List', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Name', 'Description', 'Users'],
                data: roles.map((role) => [
                  role.name,
                  role.description,
                  role.users.length.toString(),
                ]).toList(),
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/roles_list.pdf');
    await file.writeAsBytes(await pdf.save());
    OpenFilex.open(file.path);
  }

  Future<void> _generateExcel(List<Role> roles) async {
    final excel = Excel.createExcel();
    final sheet = excel.sheets[excel.getDefaultSheet()]!;

    // Add headers
    sheet.appendRow(['Name', 'Description', 'Users']);

    // Add data
    for (var role in roles) {
      sheet.appendRow([
        role.name,
        role.description,
        role.users.length.toString(),
      ]);
    }

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/roles_list.xlsx');
    await file.writeAsBytes(excel.encode()!);
    OpenFilex.open(file.path);
  }
}
