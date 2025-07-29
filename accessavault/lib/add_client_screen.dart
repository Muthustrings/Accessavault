import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'client_provider.dart'; // Import Client class and ClientProvider

class AddClientScreen extends StatefulWidget {
  final Client? client; // Optional client for editing

  const AddClientScreen({Key? key, this.client}) : super(key: key);

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _clientNameController;
  late TextEditingController _clientIdController;
  late TextEditingController _contactPersonController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _websiteController;
  late String _statusValue;
  late TextEditingController _createdDateController;
  late TextEditingController _assignedUsersGroupsController;
  late TextEditingController _clientDescriptionNotesController;

  @override
  void initState() {
    super.initState();
    _clientNameController = TextEditingController(
      text: widget.client?.contactPerson ?? '',
    );
    _clientIdController = TextEditingController(text: widget.client?.id ?? '');
    _contactPersonController = TextEditingController(
      text: widget.client?.contactPerson ?? '',
    );
    _emailController = TextEditingController(text: widget.client?.email ?? '');
    _addressController =
        TextEditingController(); // Assuming address is not in Client model yet
    _websiteController = TextEditingController(
      text: widget.client?.website ?? '',
    );
    _statusValue = widget.client?.status ?? 'Active';
    _createdDateController = TextEditingController(
      text: '2024-04-29',
    ); // Example date
    _assignedUsersGroupsController = TextEditingController(
      text: 'Select users or groups',
    );
    _clientDescriptionNotesController =
        TextEditingController(); // Assuming notes are not in Client model yet
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _clientIdController.dispose();
    _contactPersonController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _websiteController.dispose();
    _createdDateController.dispose();
    _assignedUsersGroupsController.dispose();
    _clientDescriptionNotesController.dispose();
    super.dispose();
  }

  void _saveClient() {
    if (_formKey.currentState!.validate()) {
      final clientProvider = Provider.of<ClientProvider>(
        context,
        listen: false,
      );
      final newClient = Client(
        id: _clientIdController.text,
        contactPerson: _contactPersonController.text,
        email: _emailController.text,
        website: _websiteController.text,
        status: _statusValue,
      );

      if (widget.client != null) {
        clientProvider.updateClient(widget.client!.id, newClient);
      } else {
        clientProvider.addClient(newClient);
      }

      String action = widget.client == null ? 'Added' : 'Updated';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Client ${widget.client?.id ?? _clientIdController.text} $action',
          ),
        ),
      );
      Navigator.pop(context); // Go back to previous screen after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.client == null ? 'Add Client' : 'Edit Client',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _clientNameController,
                  decoration: const InputDecoration(labelText: 'Client Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter client name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _clientIdController,
                        decoration: const InputDecoration(
                          labelText: 'Client ID',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter client ID';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement upload image functionality
                        },
                        child: const Text('Upload Image'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _contactPersonController,
                        decoration: const InputDecoration(
                          labelText: 'Contact Person Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter contact person name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(labelText: 'Address'),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: TextFormField(
                        controller: _websiteController,
                        decoration: const InputDecoration(labelText: 'Website'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Status'),
                        value: _statusValue, // Default value
                        items: const [
                          DropdownMenuItem(
                            value: 'Active',
                            child: Text('Active'),
                          ),
                          DropdownMenuItem(
                            value: 'Inactive',
                            child: Text('Inactive'),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            _statusValue = newValue!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: TextFormField(
                        controller: _createdDateController,
                        decoration: const InputDecoration(
                          labelText: 'Created Date',
                        ),
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _assignedUsersGroupsController,
                  decoration: const InputDecoration(
                    labelText: 'Assigned Users/Groups',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _clientDescriptionNotesController,
                  decoration: const InputDecoration(
                    labelText: 'Client Description/Notes',
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.blue.shade900,
                        ),
                        foregroundColor: MaterialStateProperty.all(
                          Colors.white,
                        ),
                      ),
                      onPressed: _saveClient,
                      child: Text(
                        widget.client == null ? 'Add Client' : 'Update Client',
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context); // Go back to previous screen
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
