import 'package:flutter/material.dart';
import 'package:accessavault/create_multiple_groups_screen.dart';

class MultipleGroupsScreen extends StatefulWidget {
  const MultipleGroupsScreen({super.key});

  @override
  State<MultipleGroupsScreen> createState() => _MultipleGroupsScreenState();
}

class _MultipleGroupsScreenState extends State<MultipleGroupsScreen> {
  final List<Map<String, dynamic>> _groups = [
    {
      "name": "Engineering_Team",
      "description": "Construction supporting tenns",
      "roles": ["Developer", "Manager", "Analyst"],
      "members": "Feb 10, 2023",
      "selected": false,
    },
    {
      "name": "Sales_Regional",
      "description": "Handles basic management",
      "roles": ["Analyst", "Researcher"],
      "members": "Sep 27, 2023",
      "selected": false,
    },
    {
      "name": "Compliance_2024",
      "description": "Conduct trainee committees",
      "roles": ["Admin", "Researcher"],
      "members": "Jan 5, 2024",
      "selected": false,
    },
    {
      "name": "Research_&_Development",
      "description": "Develop asset roles",
      "roles": ["Whemer"],
      "members": "Mar 15, 2023",
      "selected": false,
    },
    {
      "name": "IT_Support",
      "description": "Resourcing time management",
      "roles": ["Admin"],
      "members": "Aug 19, 2023",
      "selected": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multiple Groups'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        const CreateMultipleGroupsScreen(),
                              ),
                            );
                          },
                          child: Text('Create Groups'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color(0xFF00529B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Color(0xFF00529B),
                            side: BorderSide(color: Color(0xFF00529B)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Text('Edit Selected'),
                        ),
                        SizedBox(width: 10),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.filter_list),
                          label: Text('Filters'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            side: BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      const CreateMultipleGroupsScreen(),
                            ),
                          );
                        },
                        child: Text('Create Groups'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF00529B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(0xFF00529B),
                          side: BorderSide(color: Color(0xFF00529B)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text('Edit Selected'),
                      ),
                      Spacer(),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.filter_list),
                        label: Text('Filters'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 38.0,
                    columns: const <DataColumn>[
                      DataColumn(label: Text('')),
                      DataColumn(label: Text('Group Name')),
                      DataColumn(label: Text('Description')),
                      DataColumn(label: Text('Roles Assigned')),
                      DataColumn(label: Text('Members')),
                    ],
                    rows:
                        _groups.map((group) {
                          return DataRow(
                            cells: <DataCell>[
                              DataCell(
                                Checkbox(
                                  value: group['selected'],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      group['selected'] = value!;
                                    });
                                  },
                                ),
                              ),
                              DataCell(Text(group['name'])),
                              DataCell(Text(group['description'])),
                              DataCell(
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: 4.0,
                                  children:
                                      (group['roles'] as List<String>)
                                          .map(
                                            (role) => Chip(
                                              label: Text(role),
                                              backgroundColor:
                                                  Colors.grey.shade200,
                                            ),
                                          )
                                          .toList(),
                                ),
                              ),
                              DataCell(Text(group['members'])),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
