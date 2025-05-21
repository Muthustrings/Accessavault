import 'package:flutter/material.dart';
import 'role_detail_screen.dart'; // Import the new screen

class RolesScreen extends StatelessWidget {
  final List<Map<String, String>> roles = [
    {
      'name': 'Administrator',
      'description': 'Full access to the system',
      'users': '3',
    },
    {'name': 'Manager', 'description': 'Manage users and groups', 'users': '7'},
    {'name': 'Editor', 'description': 'Edit content', 'users': '12'},
    {'name': 'Viewer', 'description': 'View content only', 'users': '25'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Roles')),
      body: ListView.builder(
        itemCount: roles.length,
        itemBuilder: (context, index) {
          final role = roles[index];
          return ListTile(
            title: Text(role['name']!),
            subtitle: Text(role['description']!),
            trailing: Text('${role['users']} Users'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => RoleDetailScreen(roleName: role['name']!),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add role functionality
        },
        child: Icon(Icons.add),
        tooltip: 'Add Role',
      ),
    );
  }
}
