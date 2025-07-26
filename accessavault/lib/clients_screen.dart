import 'package:flutter/material.dart';
import 'add_client_screen.dart';

class Client {
  String id;
  String contactPerson;
  String email;
  String website;
  String status;

  Client({
    required this.id,
    required this.contactPerson,
    required this.email,
    required this.website,
    required this.status,
  });
}

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({Key? key}) : super(key: key);

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final List<Client> _clients = [
    Client(
      id: 'CLIENT001',
      contactPerson: 'John Smith',
      email: 'john.smith@acme.com',
      website: 'acme.com',
      status: 'Active',
    ),
    Client(
      id: 'CLIENT002',
      contactPerson: 'Susan Johnson',
      email: 's.johnson@globex.com',
      website: 'globex.com',
      status: 'Inactives',
    ),
    Client(
      id: 'CLIENT003',
      contactPerson: 'Tony Stark',
      email: 't.stark.stark.com',
      website: 'stark.com',
      status: 'Active',
    ),
    Client(
      id: 'CLIENT004',
      contactPerson: 'Bruce Wayne',
      email: 'bruce@wayne.com',
      website: 'wayne.com',
      status: 'Inactives',
    ),
  ];

  void _editClient(Client client) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddClientScreen(client: client)),
    ).then((_) {
      // Refresh the list after returning from AddClientScreen
      setState(() {});
    });
  }

  void _deleteClient(Client client) {
    setState(() {
      _clients.removeWhere((c) => c.id == client.id);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Deleted ${client.id}')));
  }

  @override
  Widget build(BuildContext context) {
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
                  _clients.map((client) {
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
                                onPressed: () => _deleteClient(client),
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
