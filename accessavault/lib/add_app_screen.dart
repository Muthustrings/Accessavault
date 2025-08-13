import 'package:flutter/material.dart';
import 'package:accessavault/app_provider.dart'; // Import App class definition
import 'package:accessavault/client_provider.dart'; // Import ClientProvider
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart'; // Import Provider package
import 'package:accessavault/apps_screen.dart'; // Import AppsScreen
import 'package:accessavault/group_provider.dart'; // Import GroupProvider
import 'package:accessavault/main.dart'; // Import UserProvider from main.dart


class AddAppScreen extends StatefulWidget {
  const AddAppScreen({Key? key, this.app}) : super(key: key);

  final App? app;

  @override
  _AddAppScreenState createState() => _AddAppScreenState();
}

class _AddAppScreenState extends State<AddAppScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _appNameController;
  late TextEditingController _appIdController;
  late TextEditingController _descriptionController;
  late TextEditingController _redirectUrlController;

  String? _pickedFileName;
  String? _selectedClient; // To hold the selected client
  bool _statusActive = true; // To hold the selected status
  List<String> _selectedGroups = []; // To hold selected groups
  List<String> _selectedUsers = []; // To hold selected users

  @override
  void initState() {
    super.initState();
    _appNameController = TextEditingController(text: widget.app?.name ?? '');
    _appIdController = TextEditingController(text: widget.app?.id ?? '');
    _descriptionController =
        TextEditingController(text: widget.app?.description ?? '');
    _redirectUrlController =
        TextEditingController(text: widget.app?.redirectUrl ?? '');
    _statusActive = widget.app?.status == 'Active';
    _selectedClient = widget.app?.clientId;
    _selectedGroups = widget.app?.assignedGroups ?? [];
    _selectedUsers = widget.app?.assignedUsers ?? [];
  }

  @override
  void dispose() {
    _appNameController.dispose();
    _appIdController.dispose();
    _descriptionController.dispose();
    _redirectUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _pickedFileName = result.files.single.name;
      });
    } else {
      // User canceled the picker
    }
  }

  void _createApplication() {
    if (_formKey.currentState!.validate()) {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      final clientProvider = Provider.of<ClientProvider>(context, listen: false);
      final selectedClientObject = clientProvider.clients.firstWhere(
        (client) => client.name == _selectedClient,
        orElse: () => Client(id: '', name: '', contactPerson: '', email: '', website: '', status: ''), // Fallback
      );

      final newApp = App(
        id: _appIdController.text,
        name: _appNameController.text,
        clientId: selectedClientObject.id.isNotEmpty ? selectedClientObject.id : null, // Use clientId
        image: _pickedFileName ?? '',
        description: _descriptionController.text,
        status: _statusActive ? 'Active' : 'Inactive',
        redirectUrl: _redirectUrlController.text,
        assignedGroups: _selectedGroups,
        assignedUsers: _selectedUsers,
        type: 'Web', // Default value, as it's not in the form
        icon: Icons.apps, // Default icon
        iconColor: Colors.blue, // Default icon color
      );

      if (widget.app != null) {
        appProvider.updateApp(widget.app!.id, newApp);
      } else {
        appProvider.addApp(newApp);
      }

      String action = widget.app == null ? 'Added' : 'Updated';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Application ${widget.app?.id ?? _appIdController.text} $action',
          ),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AppsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientProvider = Provider.of<ClientProvider>(context);
    final clients = clientProvider.clients;
    final groupProvider = Provider.of<GroupProvider>(context);
    final groups = groupProvider.groups;
    final userProvider = Provider.of<UserProvider>(context);
    final users = userProvider.users;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.app == null ? 'Add Application' : 'Edit Application',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Name
                TextFormField(
                  controller: _appNameController,
                  decoration: const InputDecoration(
                    labelText: 'App Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter app name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // App ID
                TextFormField(
                  controller: _appIdController,
                  decoration: const InputDecoration(
                    labelText: 'App ID',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter app ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Client
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Client',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedClient,
                  items: clients.map((client) {
                    return DropdownMenuItem(
                      value: client.name,
                      child: Text(client.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedClient = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a client';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Upload Image
                InkWell(
                  onTap: _pickFile,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.cloud_upload_outlined,
                          size: 50,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _pickedFileName ?? 'Drag & drop or click to upload',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Status
                Row(
                  children: [
                    const Text('Status:'),
                    const SizedBox(width: 10),
                    Row(
                      children: [
                        Radio<bool>(
                          value: true,
                          groupValue: _statusActive,
                          onChanged: (value) {
                            setState(() {
                              _statusActive = value!;
                            });
                          },
                        ),
                        const Text('Active'),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<bool>(
                          value: false,
                          groupValue: _statusActive,
                          onChanged: (value) {
                            setState(() {
                              _statusActive = value!;
                            });
                          },
                        ),
                        const Text('Inactive'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Redirect URL
                TextFormField(
                  controller: _redirectUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Redirect URL',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter redirect URL';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Assigned Groups
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Assigned Groups',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedGroups.isNotEmpty ? _selectedGroups.first : null,
                  items: groups.map((group) {
                    return DropdownMenuItem(
                      value: group.name,
                      child: Text(group.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      if (value != null && !_selectedGroups.contains(value)) {
                        _selectedGroups.add(value);
                      }
                    });
                  },
                  hint: const Text('Select groups'),
                ),
                Wrap(
                  spacing: 8.0,
                  children: _selectedGroups.map((group) {
                    return Chip(
                      label: Text(group),
                      onDeleted: () {
                        setState(() {
                          _selectedGroups.remove(group);
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Assigned Users
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Assigned Users',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedUsers.isNotEmpty ? _selectedUsers.first : null,
                  items: users.map((user) {
                    return DropdownMenuItem(
                      value: user['name'], // Assuming user has a 'name' property
                      child: Text(user['name'] ?? ''),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      if (value != null && !_selectedUsers.contains(value)) {
                        _selectedUsers.add(value);
                      }
                    });
                  },
                  hint: const Text('Select users'),
                ),
                Wrap(
                  spacing: 8.0,
                  children: _selectedUsers.map((user) {
                    return Chip(
                      label: Text(user),
                      onDeleted: () {
                        setState(() {
                          _selectedUsers.remove(user);
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 3, 42, 100),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      onPressed: _createApplication,
                      child: const Text(
                        'Create Application',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                        side: BorderSide(color: Colors.grey.shade400),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
