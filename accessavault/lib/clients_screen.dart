import 'package:flutter/material.dart';
import 'add_client_screen.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({Key? key}) : super(key: key);

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
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue.shade900),
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddClientScreen(),
                ),
              );
            },
            child: const Text('+ Add Client'),
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
              ],
              rows: const [
                DataRow(
                  cells: [
                    DataCell(Text('CLIENT001')),
                    DataCell(Text('John Smith')),
                    DataCell(Text('john.smith@acme.com')),
                    DataCell(Text('Active')),
                    DataCell(Text('Active')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('CLIENT002')),
                    DataCell(Text('Susan Johnson')),
                    DataCell(Text('s.johnson@globex.com')),
                    DataCell(Text('Inactives')),
                    DataCell(Text('Inactives')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('CLIENT003')),
                    DataCell(Text('Tony Stark')),
                    DataCell(Text('t.stark.stark.com')),
                    DataCell(Text('Active')),
                    DataCell(Text('Active')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('CLIENT004')),
                    DataCell(Text('Bruce Wayne')),
                    DataCell(Text('bruce@wayne.com')),
                    DataCell(Text('Inactives')),
                    DataCell(Text('Inactives')),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
