import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io'; // Import dart:io for File
import 'add_client_screen.dart';
import 'client_provider.dart'; // Import the new ClientProvider
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

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

  Widget _buildLogoImage(String imageUrl) {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading network image from $imageUrl: $error');
          return Image.asset(
            'asset/image/logo.png',
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          );
        },
      );
    } else if (imageUrl.isNotEmpty) {
      final File localFile = File(imageUrl);
      if (localFile.existsSync()) {
        return Image.file(
          localFile,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('Error loading local image from $imageUrl: $error');
            return Image.asset(
              'asset/image/logo.png',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            );
          },
        );
      } else {
        print('Local file does not exist at path: $imageUrl');
      }
    }
    return Image.asset(
      'asset/image/logo.png',
      width: 40,
      height: 40,
      fit: BoxFit.cover,
    );
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
          ElevatedButton.icon(
            onPressed: () => _generatePdf(clientProvider.clients),
            icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
            label: const Text(
              'Download PDF',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            onPressed: () => _generateExcel(clientProvider.clients),
            icon: const Icon(Icons.table_chart, color: Colors.white),
            label: const Text(
              'Download Excel',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 10),
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
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Business ID')),
              DataColumn(label: Text('Business Name')),
              DataColumn(label: Text('Business User Name')),
              DataColumn(label: Text('Business Logo')),
              DataColumn(label: Text('About Business')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Actions')),
            ],
            rows: clients.map((client) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(Text(client.businessId)),
                  DataCell(Text(client.businessName)),
                  DataCell(Text(client.businessUserName)),
                  DataCell(
                    ClipOval(
                      child: _buildLogoImage(client.businessLogoUrl),
                    ),
                  ),
                  DataCell(Text(client.aboutBusiness)),
                  DataCell(
                    Text(
                      client.status,
                      style: TextStyle(
                        color: client.status == 'Active' ? Colors.green : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataCell(
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editClient(client),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteClient(client, clientProvider),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Future<void> _generatePdf(List<Client> clients) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Clients List', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Business ID', 'Business Name', 'Business User Name', 'Status'],
                data: clients.map((client) => [
                  client.businessId,
                  client.businessName,
                  client.businessUserName,
                  client.status,
                ]).toList(),
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/clients_list.pdf');
    await file.writeAsBytes(await pdf.save());
    OpenFilex.open(file.path);
  }

  Future<void> _generateExcel(List<Client> clients) async {
    final excel = Excel.createExcel();
    final sheet = excel.sheets[excel.getDefaultSheet()]!;

    // Add headers
    sheet.appendRow(['Business ID', 'Business Name', 'Business User Name', 'Status']);

    // Add data
    for (var client in clients) {
      sheet.appendRow([
        client.businessId,
        client.businessName,
        client.businessUserName,
        client.status,
      ]);
    }

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/clients_list.xlsx');
    await file.writeAsBytes(excel.encode()!);
    OpenFilex.open(file.path);
  }
}
