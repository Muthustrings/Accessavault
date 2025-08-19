import 'package:flutter/material.dart';
import 'package:accessavault/create_multiple_groups_screen.dart';
import 'package:provider/provider.dart';
import 'package:accessavault/group_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';

class MultipleGroupsScreen extends StatefulWidget {
  const MultipleGroupsScreen({super.key});

  @override
  State<MultipleGroupsScreen> createState() => _MultipleGroupsScreenState();
}

class _MultipleGroupsScreenState extends State<MultipleGroupsScreen> {
  Set<String> _selectedGroupNames = {}; // To store names of selected groups
  TextEditingController _searchController = TextEditingController();
  String _filterText = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _filterText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multiple Groups'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        const CreateMultipleGroupsScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFF00529B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: const Text('Create Groups'),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed:
                              _selectedGroupNames.length == 1
                                  ? () {
                                    final selectedGroupName =
                                        _selectedGroupNames.first;
                                    final groupProvider =
                                        Provider.of<GroupProvider>(
                                          context,
                                          listen: false,
                                        );
                                    final groupToEdit = groupProvider.groups
                                        .firstWhere(
                                          (group) =>
                                              group.name == selectedGroupName,
                                        );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                CreateMultipleGroupsScreen(
                                                  group: groupToEdit,
                                                ),
                                      ),
                                    ).then((_) {
                                      // Clear selection after returning from edit screen
                                      setState(() {
                                        _selectedGroupNames.clear();
                                      });
                                    });
                                  }
                                  : null, // Disable if not exactly one group is selected
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF00529B),
                            side: const BorderSide(color: Color(0xFF00529B)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: const Text('Edit Selected'),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed:
                              _selectedGroupNames.isNotEmpty
                                  ? () {
                                    final groupProvider =
                                        Provider.of<GroupProvider>(
                                          context,
                                          listen: false,
                                        );
                                    for (String groupName
                                        in _selectedGroupNames) {
                                      groupProvider.deleteGroup(groupName);
                                    }
                                    setState(() {
                                      _selectedGroupNames.clear();
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Selected groups deleted!',
                                        ),
                                      ),
                                    );
                                  }
                                  : null, // Disable if no groups are selected
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: const Text('Delete Selected'),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Filter Groups'),
                                  content: TextField(
                                    controller: _searchController,
                                    decoration: const InputDecoration(
                                      labelText:
                                          'Search by Group Name or Description',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Clear Filter'),
                                      onPressed: () {
                                        _searchController.clear();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Close'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.filter_list),
                          label: const Text('Filters'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () => _generatePdf(context.read<GroupProvider>().groups),
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
                          onPressed: () => _generateExcel(context.read<GroupProvider>().groups),
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
                      ],
                    ),
                  );
                } else {
                  return Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      const CreateMultipleGroupsScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF00529B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text('Create Groups'),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        onPressed:
                            _selectedGroupNames.length == 1
                                ? () {
                                  final selectedGroupName =
                                      _selectedGroupNames.first;
                                  final groupProvider =
                                      Provider.of<GroupProvider>(
                                        context,
                                        listen: false,
                                      );
                                  final groupToEdit = groupProvider.groups
                                      .firstWhere(
                                        (group) =>
                                            group.name == selectedGroupName,
                                      );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              CreateMultipleGroupsScreen(
                                                group: groupToEdit,
                                              ),
                                    ),
                                  ).then((_) {
                                    // Clear selection after returning from edit screen
                                    setState(() {
                                      _selectedGroupNames.clear();
                                    });
                                  });
                                }
                                : null, // Disable if not exactly one group is selected
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF00529B),
                          side: const BorderSide(color: Color(0xFF00529B)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text('Edit Selected'),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        onPressed:
                            _selectedGroupNames.isNotEmpty
                                ? () {
                                  final groupProvider =
                                      Provider.of<GroupProvider>(
                                        context,
                                        listen: false,
                                      );
                                  for (String groupName
                                      in _selectedGroupNames) {
                                    groupProvider.deleteGroup(groupName);
                                  }
                                  setState(() {
                                    _selectedGroupNames.clear();
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Selected groups deleted!'),
                                    ),
                                  );
                                }
                                : null, // Disable if no groups are selected
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text('Delete Selected'),
                      ),
                      const Spacer(),
                      OutlinedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Filter Groups'),
                                content: TextField(
                                  controller: _searchController,
                                  decoration: const InputDecoration(
                                    labelText:
                                        'Search by Group Name or Description',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Clear Filter'),
                                    onPressed: () {
                                      _searchController.clear();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Close'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.filter_list),
                        label: const Text('Filters'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () => _generatePdf(context.read<GroupProvider>().groups),
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
                        onPressed: () => _generateExcel(context.read<GroupProvider>().groups),
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
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<GroupProvider>(
                builder: (context, groupProvider, child) {
                  final groups =
                      groupProvider.groups.where((group) {
                        final lowerCaseFilter = _filterText.toLowerCase();
                        return group.name.toLowerCase().contains(
                              lowerCaseFilter,
                            ) ||
                            group.description.toLowerCase().contains(
                              lowerCaseFilter,
                            );
                      }).toList();
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 38.0,
                        columns: const <DataColumn>[
                          DataColumn(label: Text('')),
                          DataColumn(label: Text('Group Name')),
                          DataColumn(label: Text('Description')),
                          DataColumn(label: Text('Members')),
                        ],
                        rows:
                            groups.map((group) {
                              final isSelected = _selectedGroupNames.contains(
                                group.name,
                              );
                              return DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    Checkbox(
                                      value: isSelected,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            _selectedGroupNames.add(group.name);
                                          } else {
                                            _selectedGroupNames.remove(
                                              group.name,
                                            );
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  DataCell(Text(group.name)),
                                  DataCell(Text(group.description)),
                                  DataCell(Text(group.users.length.toString())),
                                ],
                              );
                            }).toList(),
                      ),
                    ),
                  );
                },
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
              pw.Text('Multiple Groups List', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Group Name', 'Description', 'Members'],
                data: groups.map((group) => [
                  group.name,
                  group.description,
                  group.users.length.toString(),
                ]).toList(),
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/multiple_groups_list.pdf');
    await file.writeAsBytes(await pdf.save());
    OpenFilex.open(file.path);
  }

  Future<void> _generateExcel(List<Group> groups) async {
    final excel = Excel.createExcel();
    final sheet = excel.sheets[excel.getDefaultSheet()]!;

    // Add headers
    sheet.appendRow(['Group Name', 'Description', 'Members']);

    // Add data
    for (var group in groups) {
      sheet.appendRow([
        group.name,
        group.description,
        group.users.length.toString(),
      ]);
    }

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/multiple_groups_list.xlsx');
    await file.writeAsBytes(excel.encode()!);
    OpenFilex.open(file.path);
  }
}
