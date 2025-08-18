import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'client_provider.dart'; // Import Client and ClientProvider
import 'role_provider.dart'; // Import RoleProvider
import 'user_provider.dart'; // Import UserProvider

class AddUserPage extends StatefulWidget {
  final Map<String, String>? user;
  final int? userIndex;
  const AddUserPage({super.key, this.user, this.userIndex});

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  late String _uniqId;
  late String _companyId;
  late String _employeeCode;
  late String _firstName;
  late String _lastName;
  late String _emailAddress;
  late String _phoneNumber;
  late String _hiredDate;
  late String _activeDate;
  String? _role; // Made nullable
  late String _status;
  Client? _selectedClient; // New variable for selected client

  bool _taggedToDepartment = false;
  String? _departmentId;

  bool _userAccount = false;
  String? _accountType;
  String? _accountIdentifier;
  String? _passwordType;
  String? _password;

  final List<String> _statuses = ['Active', 'Inactive'];
  final List<String> _yesNoOptions = ['Yes', 'No'];
  final List<String> _accountTypes = ['Email', 'Phone', 'Username'];
  final List<String> _passwordTypes = ['Password', 'OTP'];

  @override
  void initState() {
    super.initState();
    _uniqId = widget.user?['uniqId'] ?? '';
    _companyId = widget.user?['companyId'] ?? '';
    _employeeCode = widget.user?['employeeCode'] ?? '';
    _firstName = widget.user?['firstName'] ?? '';
    _lastName = widget.user?['lastName'] ?? '';
    _emailAddress = widget.user?['emailAddress'] ?? '';
    _phoneNumber = widget.user?['phoneNumber'] ?? '';
    _hiredDate = widget.user?['hiredDate'] ?? '';
    _activeDate = widget.user?['activeDate'] ?? '';
    _role = widget.user?['role'];
    _status = widget.user?['status'] ?? 'Active';
    _selectedClient = null; // Will be set from dropdown

    _taggedToDepartment = widget.user?['taggedToDepartment'] == 'Yes';
    _departmentId = widget.user?['departmentId'];

    _userAccount = widget.user?['userAccount'] == 'Yes';
    _accountType = widget.user?['accountType'];
    _accountIdentifier = widget.user?['accountIdentifier'];
    _passwordType = widget.user?['passwordType'];
    _password = widget.user?['password'];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ClientProvider, RoleProvider>(
      builder: (context, clientProvider, roleProvider, child) {
        if (widget.user != null && _selectedClient == null && clientProvider.clients.isNotEmpty) {
          final client_id = widget.user?['client_id'];
          if (client_id != null) {
            _selectedClient = clientProvider.clients.firstWhere(
                  (client) => client.id == client_id,
              orElse: () => clientProvider.clients.first,
            );
          }
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              widget.user != null ? 'Edit Employee' : 'Add Employee',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFFF5F5F5),
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildTextField(
                          label: 'Uniq ID',
                          initialValue: _uniqId,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter Uniq ID'
                              : null,
                          onSaved: (value) => _uniqId = value ?? '',
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'Company ID',
                          initialValue: _companyId,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter Company ID'
                              : null,
                          onSaved: (value) => _companyId = value ?? '',
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'Employee Code',
                          initialValue: _employeeCode,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter Employee Code'
                              : null,
                          onSaved: (value) => _employeeCode = value ?? '',
                        ),
                        const SizedBox(height: 16),
                        _buildDropdown(
                          label: 'Tagged to Department',
                          value: _taggedToDepartment ? 'Yes' : 'No',
                          items: _yesNoOptions,
                          onChanged: (value) {
                            setState(() {
                              _taggedToDepartment = value == 'Yes';
                              if (!_taggedToDepartment) {
                                _departmentId = null;
                              }
                            });
                          },
                        ),
                        if (_taggedToDepartment) ...[
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'Department ID',
                            initialValue: _departmentId ?? '',
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter Department ID'
                                : null,
                            onSaved: (value) => _departmentId = value ?? '',
                          ),
                        ],
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'First Name',
                          initialValue: _firstName,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter First Name'
                              : null,
                          onSaved: (value) => _firstName = value ?? '',
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'Last Name',
                          initialValue: _lastName,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter Last Name'
                              : null,
                          onSaved: (value) => _lastName = value ?? '',
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'Email Address',
                          initialValue: _emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter email address';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          onSaved: (value) => _emailAddress = value ?? '',
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'Phone Number',
                          initialValue: _phoneNumber,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter phone number';
                            }
                            if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                          onSaved: (value) => _phoneNumber = value ?? '',
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'Hired Date',
                          initialValue: _hiredDate,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter Hired Date'
                              : null,
                          onSaved: (value) => _hiredDate = value ?? '',
                        ),
                        const SizedBox(height: 16),
                        _buildDatePicker(
                          label: 'Active Date',
                          initialValue: _activeDate,
                          onSaved: (value) => _activeDate = value ?? '',
                        ),
                        const SizedBox(height: 16),
                        _buildDropdown(
                          label: 'Status',
                          value: _status,
                          items: _statuses,
                          onChanged: (value) {
                            setState(() {
                              _status = value ?? 'Active';
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildClientDropdown(
                          label: 'Client',
                          value: _selectedClient,
                          items: clientProvider.clients,
                          onChanged: (client) {
                            setState(() {
                              _selectedClient = client;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildDropdown(
                          label: 'Role',
                          value: _role,
                          items: roleProvider.roles.map((role) => role.name).toList(),
                          onChanged: (value) {
                            setState(() {
                              _role = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildDropdown(
                          label: 'User Account',
                          value: _userAccount ? 'Yes' : 'No',
                          items: _yesNoOptions,
                          onChanged: (value) {
                            setState(() {
                              _userAccount = value == 'Yes';
                              if (!_userAccount) {
                                _accountType = null;
                                _accountIdentifier = null;
                                _passwordType = null;
                                _password = null;
                              }
                            });
                          },
                        ),
                        if (_userAccount) ...[
                          const SizedBox(height: 16),
                          _buildDropdown(
                            label: 'Account Type',
                            value: _accountType,
                            items: _accountTypes,
                            onChanged: (value) {
                              setState(() {
                                _accountType = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'Email / Phone number / User Name',
                            initialValue: _accountIdentifier ?? '',
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter account identifier'
                                : null,
                            onSaved: (value) => _accountIdentifier = value ?? '',
                          ),
                          const SizedBox(height: 16),
                          _buildDropdown(
                            label: 'Password Type',
                            value: _passwordType,
                            items: _passwordTypes,
                            onChanged: (value) {
                              setState(() {
                                _passwordType = value;
                              });
                            },
                          ),
                          if (_passwordType == 'Password') ...[
                            const SizedBox(height: 16),
                            _buildTextField(
                              label: 'Password',
                              initialValue: _password ?? '',
                              obscureText: true,
                              validator: (value) => value == null || value.isEmpty
                                  ? 'Please enter password'
                                  : null,
                              onSaved: (value) => _password = value ?? '',
                            ),
                          ],
                        ],
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                              ),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  final userProvider = Provider.of<UserProvider>(
                                    context,
                                    listen: false,
                                  );
                                  final userData = {
                                    'uniqId': _uniqId,
                                    'companyId': _companyId,
                                    'employeeCode': _employeeCode,
                                    'taggedToDepartment': _taggedToDepartment ? 'Yes' : 'No',
                                    'departmentId': _departmentId ?? '',
                                    'firstName': _firstName,
                                    'lastName': _lastName,
                                    'emailAddress': _emailAddress,
                                    'phoneNumber': _phoneNumber,
                                    'hiredDate': _hiredDate,
                                    'activeDate': _activeDate,
                                    'role': _role ?? '',
                                    'status': _status,
                                    'client_id': _selectedClient?.id ?? '',
                                    'userAccount': _userAccount ? 'Yes' : 'No',
                                    'accountType': _accountType ?? '',
                                    'accountIdentifier': _accountIdentifier ?? '',
                                    'passwordType': _passwordType ?? '',
                                    'password': _password ?? '',
                                  };
                                  if (widget.user != null &&
                                      widget.userIndex != null) {
                                    userProvider.updateUser(
                                      widget.userIndex!,
                                      userData,
                                    );
                                  } else {
                                    userProvider.addUser(userData);
                                  }
                                  Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0B2447),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                              ),
                              child: Text(
                                widget.user != null ? 'Save Changes' : 'Add Employee',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    FormFieldValidator<String>? validator,
    required FormFieldSetter<String> onSaved,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          validator: validator,
          onSaved: onSaved,
          obscureText: obscureText,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value, // Made nullable
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items:
              items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          ),
        ),
      ],
    );
  }

  Widget _buildClientDropdown({
    required String label,
    required Client? value,
    required List<Client> items,
    required ValueChanged<Client?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<Client>(
          value: value,
          items:
              items.map((Client client) {
                return DropdownMenuItem<Client>(
                  value: client,
                  child: Text(client.contactPerson), // Display contact person
                );
              }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker({
    required String label,
    required String initialValue,
    required FormFieldSetter<String> onSaved,
  }) {
    TextEditingController controller = TextEditingController(text: initialValue);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.tryParse(initialValue) ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
              setState(() {
                controller.text = formattedDate;
                onSaved(formattedDate);
              });
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          validator: (value) => value == null || value.isEmpty
              ? 'Please select a date'
              : null,
          onSaved: onSaved,
        ),
      ],
    );
  }
}
