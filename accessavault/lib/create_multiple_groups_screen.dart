import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:accessavault/group_provider.dart';
import 'package:accessavault/role_provider.dart';
import 'package:accessavault/client_provider.dart';
import 'package:accessavault/user_provider.dart'; // Import UserProvider
import 'package:multi_select_flutter/multi_select_flutter.dart'; // For multi-select dropdown
import 'package:file_picker/file_picker.dart'; // For CSV import

class CreateMultipleGroupsScreen extends StatefulWidget {
  final Group? group; // Optional group for editing

  const CreateMultipleGroupsScreen({super.key, this.group});

  @override
  State<CreateMultipleGroupsScreen> createState() =>
      _CreateMultipleGroupsScreenState();
}

class _CreateMultipleGroupsScreenState
    extends State<CreateMultipleGroupsScreen> {
  final List<Map<String, dynamic>> _groups = [];
  final _formKey = GlobalKey<FormState>(); // Add a form key

  @override
  void initState() {
    super.initState();
    if (widget.group != null) {
      // Editing existing group
      _groups.add({
        'name': TextEditingController(text: widget.group!.name),
        'description': TextEditingController(text: widget.group!.description),
        'roleType': null, // Role type is not directly in Group model
        'permissions': <String>[],
        'selectedUsers': List<String>.from(widget.group!.users),
        'selectedClient': widget.group!.clientId,
      });
    } else {
      // Creating new group(s)
      _addGroup(); // Add one empty group initially
    }
  }

  void _addGroup() {
    setState(() {
      _groups.add({
        'name': TextEditingController(),
        'description': TextEditingController(),
        'roleType': null,
        'permissions': <String>[],
        'selectedUsers': <String>[],
        'selectedClient': null,
      });
    });
  }

  @override
  void dispose() {
    for (var group in _groups) {
      group['name'].dispose();
      group['description'].dispose();
    }
    super.dispose();
  }

  void _removeGroup(int index) {
    setState(() {
      _groups[index]['name'].dispose();
      _groups[index]['description'].dispose();
      _groups.removeAt(index);
    });
  }

  void _createAllGroups() {
    if (!_formKey.currentState!.validate()) {
      return; // Stop if form is not valid
    }

    final groupProvider = Provider.of<GroupProvider>(context, listen: false);
    for (var groupData in _groups) {
      final newGroup = Group(
        name: groupData['name'].text,
        description: groupData['description'].text,
        users: List<String>.from(groupData['selectedUsers']),
        clientId: groupData['selectedClient'],
      );

      if (widget.group != null) {
        // Update existing group
        groupProvider.updateGroup(widget.group!.name, newGroup);
      } else {
        // Add new group
        groupProvider.addGroup(newGroup);
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(widget.group != null ? 'Group updated successfully!' : 'Groups created successfully!')),
    );
    Navigator.of(context).pop();
  }

  void _clearAll() {
    setState(() {
      for (var group in _groups) {
        group['name'].clear();
        group['description'].clear();
        group['roleType'] = null;
        group['permissions'] = <String>[];
        group['selectedUsers'] = <String>[];
        group['selectedClient'] = null;
      }
    });
  }

  Future<void> _importGroupsFromCSV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.single.bytes != null) {
      final String csvContent = String.fromCharCodes(result.files.single.bytes!);
      final List<String> lines = csvContent.split('\n');

      if (lines.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CSV file is empty.')),
        );
        return;
      }

      // Assuming CSV format: GroupName,Description,User1;User2,ClientId
      // Skip header row if present
      final List<Map<String, dynamic>> importedGroups = [];
      for (int i = 0; i < lines.length; i++) {
        if (lines[i].trim().isEmpty) continue; // Skip empty lines
        final List<String> values = lines[i].split(',');
        if (values.length >= 4) { // Ensure enough columns
          final String groupName = values[0].trim();
          final String description = values[1].trim();
          final List<String> users = values[2].trim().split(';').where((e) => e.isNotEmpty).toList();
          final String clientId = values[3].trim();

          importedGroups.add({
            'name': TextEditingController(text: groupName),
            'description': TextEditingController(text: description),
            'roleType': null, // Not directly from CSV for now
            'permissions': <String>[],
            'selectedUsers': users,
            'selectedClient': clientId,
          });
        } else {
          print('Skipping malformed CSV line: ${lines[i]}');
        }
      }

      if (importedGroups.isNotEmpty) {
        setState(() {
          _groups.clear(); // Clear existing groups
          _groups.addAll(importedGroups);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${importedGroups.length} groups imported from CSV!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No valid groups found in CSV.')),
        );
      }
    } else {
      // User canceled the picker
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CSV import cancelled.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleProvider = Provider.of<RoleProvider>(context);
    final roles = roleProvider.roles.map((role) => role.name).toList();

    final clientProvider = Provider.of<ClientProvider>(context);
    final clients = clientProvider.clients;

    final userProvider = Provider.of<UserProvider>(context);
    final users = userProvider.users.map((user) => user['name'] as String).toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.group != null ? 'Edit Group' : 'Create Multiple AD Groups')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Assign the form key
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _groups.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Group #${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (_groups.length > 1 && widget.group == null) // Only allow removing if creating multiple
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () => _removeGroup(index),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _groups[index]['name'],
                              decoration: const InputDecoration(
                                labelText: 'Group Name',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter group name';
                                }
                                return null;
                              },
                              readOnly: widget.group != null, // Make name read-only in edit mode
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _groups[index]['description'],
                              decoration: const InputDecoration(
                                labelText: 'Description',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                              ),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _groups[index]['roleType'],
                              decoration: const InputDecoration(
                                labelText: 'Role Type',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                              ),
                              items: roles.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _groups[index]['roleType'] = newValue;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _groups[index]['selectedClient'],
                              decoration: const InputDecoration(
                                labelText: 'Client',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                              ),
                              items: clients.map((client) {
                                return DropdownMenuItem<String>(
                                  value: client.id, // Use client ID as value
                                  child: Text(client.name),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _groups[index]['selectedClient'] = newValue;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            MultiSelectDialogField(
                              items: users
                                  .map((user) => MultiSelectItem<String>(user, user))
                                  .toList(),
                              title: const Text("Select Users"),
                              selectedColor: Colors.blue,
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 1.8,
                                ),
                              ),
                              buttonIcon: const Icon(
                                Icons.person,
                                color: Colors.blue,
                              ),
                              buttonText: const Text(
                                "Select Users",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                ),
                              ),
                              initialValue: _groups[index][
                                  'selectedUsers'], // Set initial value for multi-select
                              onConfirm: (results) {
                                setState(() {
                                  _groups[index]['selectedUsers'] = results;
                                });
                              },
                              chipDisplay: MultiSelectChipDisplay(
                                onTap: (item) {
                                  setState(() {
                                    _groups[index]['selectedUsers'].remove(item);
                                  });
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
              const SizedBox(height: 16),
              if (widget.group == null) // Only show "Add New Group" and "Import CSV" in create mode
                ElevatedButton.icon(
                  onPressed: _addGroup,
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Group'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              const SizedBox(height: 8),
              if (widget.group == null) // Only show "Import CSV" in create mode
                OutlinedButton.icon(
                  onPressed: _importGroupsFromCSV,
                  icon: const Icon(Icons.file_upload),
                  label: const Text('Import Groups from CSV'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: _clearAll,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                    ),
                    child: const Text('Clear All'),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                    ),
                    child: const Text('Back'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _createAllGroups,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B2447),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                    ),
                    child: Text(
                      widget.group != null ? 'Save Changes' : 'Create All Groups',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
