import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_app_screen.dart';
import 'package:accessavault/app_provider.dart'; // Import the new AppProvider
import 'package:accessavault/client_provider.dart'; // Import ClientProvider

class AppsScreen extends StatefulWidget {
  const AppsScreen({Key? key}) : super(key: key);

  @override
  State<AppsScreen> createState() => _AppsScreenState();
}

class _AppsScreenState extends State<AppsScreen> {
  @override
  void initState() {
    super.initState();
    // Load apps when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadApps();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Apps',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28.0,
          ), // Increased font size
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
                      4.0,
                    ), // Slightly more rounded corners
                  ),
                ),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ), // Smaller padding
                ),
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddAppScreen()),
                );
                context.read<AppProvider>().loadApps(); // Reload apps after adding
              },
              child: const Text(
                '+ Add App',
                style: TextStyle(fontSize: 16.0),
              ), // Smaller font size
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<AppProvider>(
          builder: (context, appProvider, child) {
            final apps = appProvider.apps;
            final clientProvider = Provider.of<ClientProvider>(context); // Get ClientProvider
            return ListView(
              children: [
                DataTable(
                  columns: const [
                    DataColumn(label: Text('App Name')),
                    DataColumn(label: Text('App ID')),
                    DataColumn(label: Text('Client')),
                    DataColumn(label: Text('App Type')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: apps.map((app) {
                    final clientName = clientProvider.clients
                        .firstWhere((client) => client.id == app.clientId,
                            orElse: () => Client(id: '', name: 'N/A', contactPerson: '', email: '', website: '', status: ''))
                        .name;
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
                        DataCell(Text(clientName)), // Display client name
                        DataCell(Text(app.type)),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: app.status == 'Active'
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
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _editApp(context, app);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _deleteApp(context, app);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _editApp(BuildContext context, App app) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddAppScreen(app: app)),
    ).then((_) {
      context.read<AppProvider>().loadApps(); // Reload apps after editing
    });
  }

  void _deleteApp(BuildContext context, App app) {
    context.read<AppProvider>().deleteApp(app.id);
  }
}
