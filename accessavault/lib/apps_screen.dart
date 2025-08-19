import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_app_screen.dart';
import 'package:accessavault/app_provider.dart'; // Import the new AppProvider
import 'package:accessavault/client_provider.dart'; // Import ClientProvider
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';

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
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _generatePdf(context.read<AppProvider>().apps, context.read<ClientProvider>().clients),
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                  label: const Text(
                    'Download PDF',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => _generateExcel(context.read<AppProvider>().apps, context.read<ClientProvider>().clients),
                  icon: const Icon(Icons.table_chart, color: Colors.white),
                  label: const Text(
                    'Download Excel',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
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
              ],
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
                            orElse: () => Client(id: '', name: 'N/A', contactPerson: '', email: '', website: '', status: '', businessId: '', businessName: 'N/A', businessUserName: '', businessLogoUrl: '', aboutBusiness: ''))
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

  Future<void> _generatePdf(List<App> apps, List<Client> clients) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Apps List', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['App Name', 'App ID', 'Client', 'App Type', 'Status'],
                data: apps.map((app) {
                  final clientName = clients
                      .firstWhere((client) => client.id == app.clientId,
                          orElse: () => Client(id: '', name: 'N/A', contactPerson: '', email: '', website: '', status: '', businessId: '', businessName: 'N/A', businessUserName: '', businessLogoUrl: '', aboutBusiness: ''))
                      .name;
                  return [
                    app.name,
                    app.id,
                    clientName,
                    app.type,
                    app.status,
                  ];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/apps_list.pdf');
    await file.writeAsBytes(await pdf.save());
    OpenFilex.open(file.path);
  }

  Future<void> _generateExcel(List<App> apps, List<Client> clients) async {
    final excel = Excel.createExcel();
    final sheet = excel.sheets[excel.getDefaultSheet()]!;

    // Add headers
    sheet.appendRow(['App Name', 'App ID', 'Client', 'App Type', 'Status']);

    // Add data
    for (var app in apps) {
      final clientName = clients
          .firstWhere((client) => client.id == app.clientId,
              orElse: () => Client(id: '', name: 'N/A', contactPerson: '', email: '', website: '', status: '', businessId: '', businessName: 'N/A', businessUserName: '', businessLogoUrl: '', aboutBusiness: ''))
          .name;
      sheet.appendRow([
        app.name,
        app.id,
        clientName,
        app.type,
        app.status,
      ]);
    }

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/apps_list.xlsx');
    await file.writeAsBytes(excel.encode()!);
    OpenFilex.open(file.path);
  }
}
