import 'package:flutter/material.dart';
import 'add_app_screen.dart';

class App {
  final String name;
  final String id;
  final String linkedClient;
  final String type;
  final String status;
  final IconData icon;
  final Color iconColor;

  App({
    required this.name,
    required this.id,
    required this.linkedClient,
    required this.type,
    required this.status,
    required this.icon,
    required this.iconColor,
  });
}

class AppsScreen extends StatefulWidget {
  const AppsScreen({Key? key}) : super(key: key);

  @override
  State<AppsScreen> createState() => _AppsScreenState();
}

class _AppsScreenState extends State<AppsScreen> {
  final List<App> _apps = [
    App(
      name: 'Project Management',
      id: 'APP1001',
      linkedClient: 'Client A',
      type: 'Web',
      status: 'Active',
      icon: Icons.bar_chart,
      iconColor: Colors.green,
    ),
    App(
      name: 'Mobile CRM',
      id: 'APP1002',
      linkedClient: 'Client B',
      type: 'Mobile',
      status: 'Active',
      icon: Icons.phone_android,
      iconColor: Colors.green,
    ),
    App(
      name: 'Data Analytics',
      id: 'APP1003',
      linkedClient: 'Client C',
      type: 'Web',
      status: 'Active',
      icon: Icons.analytics,
      iconColor: Colors.blue,
    ),
    App(
      name: 'Email Service',
      id: 'APP1004',
      linkedClient: 'Client D',
      type: 'Web',
      status: 'Inactive',
      icon: Icons.email,
      iconColor: Colors.deepOrange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Apps',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 3, 42, 100), // Darker blue
                ),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      6.0,
                    ), // Slightly more rounded corners
                  ),
                ),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddAppScreen()),
                );
              },
              child: const Text('+ Add App', style: TextStyle(fontSize: 18.0)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DataTable(
              columns: const [
                DataColumn(label: Text('App Name')),
                DataColumn(label: Text('App ID')),
                DataColumn(label: Text('Linked Client')),
                DataColumn(label: Text('App Type')),
                DataColumn(label: Text('Status')),
              ],
              rows:
                  _apps.map((app) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              Icon(app.icon, color: app.iconColor),
                              const SizedBox(width: 8.0),
                              Text(app.name),
                            ],
                          ),
                        ),
                        DataCell(Text(app.id)),
                        DataCell(Text(app.linkedClient)),
                        DataCell(Text(app.type)),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  app.status == 'Active'
                                      ? Colors.green.shade600
                                      : Colors.grey.shade600,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Text(
                              app.status,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
