import 'package:flutter/material.dart';
import 'package:accessavault/lib/role_detail_screen.dart';

class RolesScreen extends StatefulWidget {
  const RolesScreen({Key? key}) : super(key: key);

  @override
  _RolesScreenState createState() => _RolesScreenState();
}

class _RolesScreenState extends State<RolesScreen> {
  // Placeholder data for roles
  final List<Map<String, String>> _roles = [
    {'name': 'Admin', 'description': 'Full access to all features'},
    {'name': 'Editor', 'description': 'Can create and edit content'},
    {'name': 'Viewer', 'description': 'Can view content'},
  ];

  void _deleteRole(int index) {
    setState(() {
      _roles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Roles')),
      body: ListView.builder(
        itemCount: _roles.length,
        itemBuilder: (context, index) {
          final role = _roles[index];
          return ListTile(
            title: Text(role['name'] ?? ''),
            subtitle: Text(role['description'] ?? ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                RoleDetailScreen(roleName: role['name']!),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteRole(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
