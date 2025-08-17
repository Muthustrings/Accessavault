import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart'; // Import file_picker
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
  late TextEditingController _businessNameController; // New field
  late TextEditingController _businessUserNameController; // New field
  late TextEditingController _businessLogoController; // New field
  late TextEditingController _aboutBusinessController; // New field
  late TextEditingController _businessIdController; // New field

  @override
  void initState() {
    super.initState();
    _clientNameController = TextEditingController(
      text: widget.client?.name ?? '',
    );
    _clientIdController = TextEditingController(text: widget.client?.id ?? '');
    _contactPersonController = TextEditingController(
      text: widget.client?.contactPerson ?? '',
    );
    _emailController = TextEditingController(text: widget.client?.email ?? '');
    _addressController = TextEditingController(
      text: widget.client?.aboutBusiness ?? '',
    ); // Using aboutBusiness for address for now
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
    _clientDescriptionNotesController = TextEditingController(
      text: widget.client?.aboutBusiness ?? '',
    ); // Using aboutBusiness for notes for now
    _businessNameController = TextEditingController(
      text: widget.client?.businessName ?? '',
    );
    _businessUserNameController = TextEditingController(
      text: widget.client?.businessUserName ?? '',
    );
    _businessLogoController = TextEditingController(
      text: widget.client?.businessLogoUrl ?? '',
    );
    _aboutBusinessController = TextEditingController(
      text: widget.client?.aboutBusiness ?? '',
    );
    _businessIdController = TextEditingController(
      text: widget.client?.businessId ?? '',
    );
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
    _businessNameController.dispose(); // Dispose new field
    _businessUserNameController.dispose(); // Dispose new field
    _businessLogoController.dispose(); // Dispose new field
    _aboutBusinessController.dispose(); // Dispose new field
    _businessIdController.dispose(); // Dispose new field
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
        name: _clientNameController.text,
        contactPerson: _contactPersonController.text,
        email: _emailController.text,
        website: _websiteController.text,
        status: _statusValue,
        businessId: _businessIdController.text,
        businessName: _businessNameController.text,
        businessUserName: _businessUserNameController.text,
        businessLogoUrl: _businessLogoController.text,
        aboutBusiness: _aboutBusinessController.text,
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
              children: <Widget>[
                TextFormField(
                  controller: _businessIdController,
                  decoration: const InputDecoration(
                    labelText: 'Business ID',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter business ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _businessNameController,
                  decoration: const InputDecoration(
                    labelText: 'Business Name',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter business name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _businessUserNameController,
                  decoration: const InputDecoration(
                    labelText: 'Business User Name',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter business user name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: _businessLogoController,
                        decoration: const InputDecoration(
                          labelText: 'Business Logo/Profile Pic URL',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 16.0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(
                                type: FileType.image,
                                allowMultiple: false,
                              );

                          if (result != null &&
                              result.files.single.path != null) {
                            setState(() {
                              _businessLogoController.text =
                                  result.files.single.path!;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No image selected.'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Select Image'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _aboutBusinessController,
                  decoration: const InputDecoration(
                    labelText: 'About the Business',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                  ),
                  value: _statusValue, // Default value
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'Active',
                      child: Text('Active'),
                    ),
                    DropdownMenuItem<String>(
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
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context); // Go back to previous screen
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B2447),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                      ),
                      onPressed: _saveClient,
                      child: Text(
                        widget.client == null ? 'Add Client' : 'Update Client',
                        style: const TextStyle(color: Colors.white),
                      ),
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
