import 'package:flutter/material.dart';

class CreateMultipleGroupsScreen extends StatefulWidget {
  const CreateMultipleGroupsScreen({super.key});

  @override
  State<CreateMultipleGroupsScreen> createState() =>
      _CreateMultipleGroupsScreenState();
}

class _CreateMultipleGroupsScreenState
    extends State<CreateMultipleGroupsScreen> {
  final List<Map<String, dynamic>> _groups = [
    {
      'name': TextEditingController(),
      'description': TextEditingController(),
      'roleType': null,
      'permissions': null,
    },
  ];

  final List<String> _roleTypes = ['Role 1', 'Role 2', 'Role 3'];
  final List<String> _permissions = [
    'Permission A',
    'Permission B',
    'Permission C',
  ];

  void _addGroup() {
    setState(() {
      _groups.add({
        'name': TextEditingController(),
        'description': TextEditingController(),
        'roleType': null,
        'permissions': null,
      });
    });
  }

  void _removeGroup(int index) {
    setState(() {
      _groups.removeAt(index);
    });
  }

  void _createAllGroups() {
    for (var group in _groups) {
      // Here you would handle the creation of each group.
      // For example, you could print the values to the console.
      print('Group Name: ${group['name'].text}');
      print('Description: ${group['description'].text}');
      print('Role Type: ${group['roleType']}');
      print('Permissions: ${group['permissions']}');
    }
    // Optionally, show a success message or navigate away.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Groups created successfully!')),
    );
    Navigator.of(context).pop();
  }

  void _clearAll() {
    setState(() {
      for (var group in _groups) {
        group['name'].clear();
        group['description'].clear();
        group['roleType'] = null;
        group['permissions'] = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Multiple AD Groups')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                              if (_groups.length > 1)
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
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _groups[index]['description'],
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _groups[index]['roleType'],
                                  decoration: const InputDecoration(
                                    labelText: 'Role Type',
                                    border: OutlineInputBorder(),
                                  ),
                                  items:
                                      _roleTypes.map((String value) {
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
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _groups[index]['permissions'],
                                  decoration: const InputDecoration(
                                    labelText: 'Permissions',
                                    border: OutlineInputBorder(),
                                  ),
                                  items:
                                      _permissions.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      _groups[index]['permissions'] = newValue;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _addGroup,
              icon: const Icon(Icons.add),
              label: const Text('Add New Group'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                // Handle import from CSV
              },
              icon: const Icon(Icons.file_upload),
              label: const Text('Import Groups from CSV'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _createAllGroups,
                  child: const Text('Create All Groups'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _clearAll,
                  child: const Text('Clear All'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Back'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
