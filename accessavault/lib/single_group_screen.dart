import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:accessavault/add_group_screen.dart';
import 'package:accessavault/group_provider.dart'; // Import GroupProvider
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';

class SingleGroupScreen extends StatefulWidget {
  const SingleGroupScreen({super.key});

  @override
  State<SingleGroupScreen> createState() => _SingleGroupScreenState();
}

class _SingleGroupScreenState extends State<SingleGroupScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure groups are loaded when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GroupProvider>().loadGroups();
    });
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, GroupProvider groupProvider, Group group) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Group'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this group?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                await groupProvider.deleteGroup(group.name);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupProvider = Provider.of<GroupProvider>(context);
    final List<Group> groups = groupProvider.groups;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _generatePdf(groupProvider.groups),
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
                  onPressed: () => _generateExcel(groupProvider.groups),
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddGroupScreen(),
                      ),
                    );
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
                    '+ Add Group',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Single Groups',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
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
                        'Group Name',
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
                        'Users', // Changed from Roles to Users as per Group model
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
                      groups.asMap().entries.map((entry) {
                        final group = entry.value;
                        return DataRow(
                          cells: [
                            DataCell(Text(group.name)),
                            DataCell(Text(group.description)),
                            DataCell(Text(group.users.join(', '))), // Display users
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      // TODO: Implement edit functionality for groups
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const AddGroupScreen(
                                                isEditMode: true,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(context, groupProvider, group);
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
        ),
      ),
    );
  }

  Future<void> _generatePdf(List<Group> groups) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Groups List', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Group Name', 'Description', 'Users'],
                data: groups.map((group) => [
                  group.name,
                  group.description,
                  group.users.join(', '),
                ]).toList(),
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/groups_list.pdf');
    await file.writeAsBytes(await pdf.save());
    OpenFilex.open(file.path);
  }

  Future<void> _generateExcel(List<Group> groups) async {
    final excel = Excel.createExcel();
    final sheet = excel.sheets[excel.getDefaultSheet()]!;

    // Add headers
    sheet.appendRow(['Group Name', 'Description', 'Users']);

    // Add data
    for (var group in groups) {
      sheet.appendRow([
        group.name,
        group.description,
        group.users.join(', '),
      ]);
    }

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/groups_list.xlsx');
    await file.writeAsBytes(excel.encode()!);
    OpenFilex.open(file.path);
  }
}
