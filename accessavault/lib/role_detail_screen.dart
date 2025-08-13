import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:accessavault/user_selection_screen.dart';
import 'package:accessavault/role_provider.dart';

class RoleDetailScreen extends StatefulWidget {
  final String roleName;

  const RoleDetailScreen({super.key, required this.roleName});

  @override
  _RoleDetailScreenState createState() => _RoleDetailScreenState();
}

class _RoleDetailScreenState extends State<RoleDetailScreen> {
  final TextEditingController _roleNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<String> _selectedUsers = [];
  late Role _currentRole;

  @override
  void initState() {
    super.initState();
    _loadRoleData();
  }

  Future<void> _loadRoleData() async {
    final roleProvider = Provider.of<RoleProvider>(context, listen: false);
    final role = roleProvider.roles.firstWhere(
      (r) => r.name == widget.roleName,
      orElse: () => Role(name: widget.roleName, description: ''), // Fallback
    );
    setState(() {
      _currentRole = role;
      _roleNameController.text = _currentRole.name;
      _descriptionController.text = _currentRole.description;
      _selectedUsers = List.from(_currentRole.users);
    });
  }

  @override
  void dispose() {
    _roleNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
        title: const Text(
          'Edit Role',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    label: 'Role Name',
                    controller: _roleNameController,
                    readOnly: true, // Role name should not be editable
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Description',
                    controller: _descriptionController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Users',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final selected = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserSelectionScreen(
                            initialSelectedUsers: _selectedUsers,
                          ),
                        ),
                      );
                      if (selected != null) {
                        setState(() {
                          _selectedUsers
                            ..clear()
                            ..addAll(selected.cast<String>());
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedUsers.isEmpty
                                  ? 'Select users'
                                  : _selectedUsers.join(', '),
                              style: TextStyle(
                                color: _selectedUsers.isEmpty
                                    ? Colors.grey[600]
                                    : Colors.black,
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
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
                          final roleProvider = Provider.of<RoleProvider>(context, listen: false);
                          final updatedRole = Role(
                            name: _currentRole.name,
                            description: _descriptionController.text,
                            users: _selectedUsers,
                          );
                          roleProvider.updateRole(_currentRole.name, updatedRole);
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0B2447),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(color: Colors.white),
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
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    bool readOnly = false, // Added readOnly parameter
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          readOnly: readOnly, // Used the readOnly parameter
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}
