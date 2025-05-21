import 'package:flutter/material.dart';

class UsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement Add User functionality
              },
              icon: Icon(Icons.add, size: 22, color: Colors.white),
              label: Text('Add User', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0B2447),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search users',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: 4, // Placeholder count
                itemBuilder: (context, index) {
                  // Placeholder user data
                  final users = [
                    {
                      'name': 'Tom Cook',
                      'email': 'tom.cook@exxample.com',
                      'role': 'Admin',
                      'status': 'Active',
                    },
                    {
                      'name': 'Lindsay Walton',
                      'email': 'lindsay.walton@example.com',
                      'role': 'User',
                      'status': 'Active',
                    },
                    {
                      'name': 'Courtney Henry',
                      'email': 'courtney.henry@exmple.com',
                      'role': 'User',
                      'status': 'Inactive',
                    },
                    {
                      'name': 'Kathryn Murphy',
                      'email': 'kathryn.murphy@exmple.com',
                      'role': 'User',
                      'status': 'Active',
                    },
                  ];
                  final user = users[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(user['name']!),
                      subtitle: Text(user['email']!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Chip(
                            label: Text(user['role']!),
                            backgroundColor: Colors.grey[300],
                          ),
                          SizedBox(width: 8.0),
                          Chip(
                            label: Text(user['status']!),
                            backgroundColor:
                                user['status'] == 'Active'
                                    ? Colors.green[100]
                                    : Colors.red[100],
                            labelStyle: TextStyle(
                              color:
                                  user['status'] == 'Active'
                                      ? Colors.green[900]
                                      : Colors.red[900],
                            ),
                          ),
                        ],
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
