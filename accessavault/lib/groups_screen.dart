import 'package:flutter/material.dart';
import 'package:accessavault/group_detail_screen.dart';

class GroupsScreenContent extends StatefulWidget {
  const GroupsScreenContent({Key? key}) : super(key: key);

  @override
  _GroupsScreenContentState createState() => _GroupsScreenContentState();
}

class _GroupsScreenContentState extends State<GroupsScreenContent> {
  // Placeholder data for groups
  final List<Map<String, String>> _groups = [
    {
      'group_name': 'Administrators',
      'description': 'Users with administrative privileges',
    },
    {
      'group_name': 'Developers',
      'description': 'Users involved in development',
    },
    {
      'group_name': 'Marketing',
      'description': 'Users in the marketing department',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Groups')),
      body: ListView.builder(
        itemCount: _groups.length,
        itemBuilder: (context, index) {
          final group = _groups[index];
          return ListTile(
            title: Text(group['group_name'] ?? ''),
            subtitle: Text(group['description'] ?? ''),
          );
        },
      ),
    );
  }
}
