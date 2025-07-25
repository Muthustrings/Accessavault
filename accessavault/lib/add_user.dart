import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class AddUserPage extends StatefulWidget {
  final Map<String, String>? user;
  final int? userIndex;
  const AddUserPage({super.key, this.user, this.userIndex});

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _email;
  late String _role;
  late String _status;

  final List<String> _roles = ['Admin', 'User', 'Guest'];
  final List<String> _statuses = ['Active', 'Inactive'];

  @override
  void initState() {
    super.initState();
    _name = widget.user?['name'] ?? '';
    _email = widget.user?['email'] ?? '';
    _role = widget.user?['role'] ?? 'User';
    _status = widget.user?['status'] ?? 'Active';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          widget.user != null ? 'Edit User' : 'Add User',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      label: 'Full Name',
                      initialValue: _name,
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Please enter full name'
                                  : null,
                      onSaved: (value) => _name = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Email',
                      initialValue: _email,
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Please enter email'
                                  : null,
                      onSaved: (value) => _email = value ?? '',
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      label: 'Role',
                      value: _role,
                      items: _roles,
                      onChanged: (value) {
                        setState(() {
                          _role = value ?? 'User';
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      label: 'Status',
                      value: _status,
                      items: _statuses,
                      onChanged: (value) {
                        setState(() {
                          _status = value ?? 'Active';
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              final userProvider = Provider.of<UserProvider>(
                                context,
                                listen: false,
                              );
                              if (widget.user != null &&
                                  widget.userIndex != null) {
                                userProvider.updateUser(widget.userIndex!, {
                                  'name': _name,
                                  'email': _email,
                                  'role': _role,
                                  'status': _status,
                                });
                              } else {
                                userProvider.addUser({
                                  'name': _name,
                                  'email': _email,
                                  'role': _role,
                                  'status': _status,
                                });
                              }
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0B2447),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                          child: Text(
                            widget.user != null ? 'Save Changes' : 'Add User',
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
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required FormFieldValidator<String> validator,
    required FormFieldSetter<String> onSaved,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          validator: validator,
          onSaved: onSaved,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items:
              items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}
