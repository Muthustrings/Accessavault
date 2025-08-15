import 'package:flutter/material.dart';
import 'package:accessavault/create_multiple_groups_screen.dart';
import 'package:provider/provider.dart';
import 'package:accessavault/group_provider.dart';

class MultipleGroupsScreen extends StatefulWidget {
  const MultipleGroupsScreen({super.key});

  @override
  State<MultipleGroupsScreen> createState() => _MultipleGroupsScreenState();
}

class _MultipleGroupsScreenState extends State<MultipleGroupsScreen> {
  Set<String> _selectedGroupNames = {}; // To store names of selected groups

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
                                builder: (context) =>
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
                          onPressed: _selectedGroupNames.length == 1
                              ? () {
                                  final selectedGroupName = _selectedGroupNames.first;
                                  final groupProvider = Provider.of<GroupProvider>(context, listen: false);
                                  final groupToEdit = groupProvider.groups.firstWhere(
                                    (group) => group.name == selectedGroupName,
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CreateMultipleGroupsScreen(
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
                          onPressed: _selectedGroupNames.isNotEmpty
                              ? () {
                                  final groupProvider = Provider.of<GroupProvider>(context, listen: false);
                                  for (String groupName in _selectedGroupNames) {
                                    groupProvider.deleteGroup(groupName);
                                  }
                                  setState(() {
                                    _selectedGroupNames.clear();
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Selected groups deleted!')),
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
                            // Handle filters
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
                              builder: (context) =>
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
                        onPressed: _selectedGroupNames.length == 1
                            ? () {
                                final selectedGroupName = _selectedGroupNames.first;
                                final groupProvider = Provider.of<GroupProvider>(context, listen: false);
                                final groupToEdit = groupProvider.groups.firstWhere(
                                  (group) => group.name == selectedGroupName,
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateMultipleGroupsScreen(
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
                        onPressed: _selectedGroupNames.isNotEmpty
                            ? () {
                                final groupProvider = Provider.of<GroupProvider>(context, listen: false);
                                for (String groupName in _selectedGroupNames) {
                                  groupProvider.deleteGroup(groupName);
                                }
                                setState(() {
                                  _selectedGroupNames.clear();
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Selected groups deleted!')),
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
                          // Handle filters
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
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<GroupProvider>(
                builder: (context, groupProvider, child) {
                  final groups = groupProvider.groups;
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
                          DataColumn(label: Text('Actions')), // Added Actions column
                        ],
                        rows: groups.map((group) {
                          final isSelected = _selectedGroupNames.contains(group.name);
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
                                        _selectedGroupNames.remove(group.name);
                                      }
                                    });
                                  },
                                ),
                              ),
                              DataCell(Text(group.name)),
                              DataCell(Text(group.description)),
                              DataCell(Text(group.users.length.toString())),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CreateMultipleGroupsScreen(
                                              group: group,
                                            ),
                                          ),
                                        ).then((_) {
                                          // Clear selection after returning from edit screen
                                          setState(() {
                                            _selectedGroupNames.clear();
                                          });
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        // Show confirmation dialog before deleting
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Confirm Delete'),
                                              content: Text('Are you sure you want to delete group "${group.name}"?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text('Cancel'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text('Delete'),
                                                  onPressed: () {
                                                    groupProvider.deleteGroup(group.name);
                                                    setState(() {
                                                      _selectedGroupNames.remove(group.name);
                                                    });
                                                    Navigator.of(context).pop();
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text('Group "${group.name}" deleted!')),
                                                    );
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
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
