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
        leadingWidth: 150.0, // Give enough space for the text
        leading: const Padding(
          padding: EdgeInsets.only(
            left: 16.0,
          ), // Add some padding from the edge
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Clients',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28.0, // Increased font size
                color:
                    Colors
                        .black, // Ensure text is visible against AppBar background
              ),
            ),
          ),
        ),
        title: const Text(''), // Empty title as "Clients" is now in leading
        actions: <Widget>[
          // The Spacer() is no longer needed here as the leading widget handles the left alignment
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
                  horizontal: 20.0,
                  vertical: 12.0,
                ), // Decrease padding for smaller size
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
                fontSize: 16.0,
              ), // Adjust text size for smaller button
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
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
                      cells: <DataCell>[
                        DataCell(Text(client.id)),
                        DataCell(Text(client.contactPerson)),
                        DataCell(Text(client.email)),
                        DataCell(Text(client.website)),
                        DataCell(Text(client.status)),
                        DataCell(
                          Row(
                            children: <Widget>[
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
