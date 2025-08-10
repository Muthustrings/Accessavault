import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:accessavault/main.dart'; // Import main.dart for UserProvider

class UserSelectionScreen extends StatefulWidget {
  final List<String> initialSelectedUsers;

  const UserSelectionScreen({super.key, required this.initialSelectedUsers});

  @override
  _UserSelectionScreenState createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  late List<String> _selectedUsers;

  @override
  void initState() {
    super.initState();
    _selectedUsers = List.from(widget.initialSelectedUsers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(_selectedUsers);
          },
        ),
        title: const Text(
          'Select Users',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final users = userProvider.users;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final userName = user['name'] ?? 'Unknown User';
              final isSelected = _selectedUsers.contains(userName);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CheckboxListTile(
                  title: Text(userName),
                  subtitle: Text(user['email'] ?? ''),
                  value: isSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedUsers.add(userName);
                      } else {
                        _selectedUsers.remove(userName);
                      }
                    });
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pop(_selectedUsers);
        },
        label: const Text('Done', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.check, color: Colors.white),
        backgroundColor: const Color(0xFF0B2447),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
