import 'package:flutter/material.dart';

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

class ClientProvider with ChangeNotifier {
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
      status: 'Inactive',
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
      status: 'Inactive',
    ),
  ];

  List<Client> get clients => _clients;

  void addClient(Client client) {
    _clients.add(client);
    notifyListeners();
  }

  void updateClient(String id, Client updatedClient) {
    final index = _clients.indexWhere((client) => client.id == id);
    if (index != -1) {
      _clients[index] = updatedClient;
      notifyListeners();
    }
  }

  void deleteClient(String id) {
    _clients.removeWhere((client) => client.id == id);
    notifyListeners();
  }
}
