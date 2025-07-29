import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_client_screen.dart';
import 'client_provider.dart'; // Import the new ClientProvider

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({Key? key}) : super(key: key);

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  void _editClient(Client client) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddClientScreen(client: client)),
    );
  }

  void _deleteClient(Client client, ClientProvider clientProvider) {
    clientProvider.deleteClient(client.id);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Deleted ${client.id}')));
  }

  @override
  Widget build(BuildContext context) {
    final clientProvider = Provider.of<ClientProvider>(context);
    final clients = clientProvider.clients;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Clients',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0, // Adjust as needed for "little bigger"
          ),
        ),
        actions: [
          const Spacer(), // Pushes the button to the left
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                const Color.fromARGB(255, 3, 42, 100),
              ),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    8.0,
                  ), // Slightly rounded corners for a rectangular look
                ),
              ),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 18.0,
                ), // Increase padding for bigger size
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddClientScreen(),
                ),
              );
            },
            child: const Text(
              '+ Add Client',
              style: TextStyle(
                fontSize: 20.0,
              ), // Adjust text size for bigger button
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
                DataColumn(label: Text('Client ID')),
                DataColumn(label: Text('Contact Person')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Website')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Actions')), // New column for actions
              ],
              rows:
                  clients.map((client) {
                    return DataRow(
                      cells: [
                        DataCell(Text(client.id)),
                        DataCell(Text(client.contactPerson)),
                        DataCell(Text(client.email)),
                        DataCell(Text(client.website)),
                        DataCell(Text(client.status)),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editClient(client),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed:
                                    () => _deleteClient(client, clientProvider),
                              ),
                            ],
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
