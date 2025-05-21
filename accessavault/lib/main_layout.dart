import 'package:flutter/material.dart';
import 'package:accessavault/groups_screen.dart';
import 'package:accessavault/settings_screen.dart';
import 'package:accessavault/security_settings_screen.dart';
import 'package:accessavault/notifications_settings_screen.dart';
import 'package:accessavault/settings_screen.dart';

class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0; // 0 for Dashboard, 1 for Users

  final List<Widget> _screens = [
    DashboardScreenContent(),
    UsersScreenContent(),
    RolesScreenContent(),
    GroupsScreenContent(),
    SettingsScreenContent(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 260,
            color: const Color(0xFF0B2447),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32),
                Row(
                  children: [
                    SizedBox(width: 24),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 22,
                      child: Icon(
                        Icons.shield,
                        color: Color(0xFF0B2447),
                        size: 28,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'AccessaVault',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                _SidebarItem(
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                  selected: _selectedIndex == 0,
                  onTap: () => _onItemTapped(0),
                ),
                _SidebarItem(
                  icon: Icons.person_outline,
                  label: 'Users',
                  selected: _selectedIndex == 1,
                  onTap: () => _onItemTapped(1),
                ),
                _SidebarItem(
                  icon: Icons.account_tree_outlined,
                  label: 'Roles',
                  selected: _selectedIndex == 2,
                  onTap: () => _onItemTapped(2),
                ),
                _SidebarItem(
                  icon: Icons.groups_outlined,
                  label: 'Groups',
                  selected: _selectedIndex == 3,
                  onTap: () => _onItemTapped(3),
                ),
                _SidebarItem(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  selected: _selectedIndex == 4,
                  onTap: () => _onItemTapped(4),
                ),
                Spacer(),
              ],
            ),
          ),
          // Main Content Area
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
    );
  }
}

// We will move the content of DashboardScreen and UsersScreen into these widgets
class DashboardScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF7F9FB),
      padding: EdgeInsets.symmetric(horizontal: 48, vertical: 40),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B2447),
              ),
            ),
            SizedBox(height: 20),
            // Statistic Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _StatCard(title: 'TOTAL USERS', value: '152'),
                SizedBox(width: 32),
                _StatCard(title: 'ACTIVE USERS', value: '124'),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _StatCard(title: 'ROLES', value: '8'),
                SizedBox(width: 32),
                _StatCard(title: 'GROUPS', value: '5'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UsersScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final users = [
      {
        'name': 'Tom Cook',
        'email': 'tom.cook@exxample.com',
        'role': 'Admin',
        'status': 'Active',
      },
      {
        'name': 'Lindsay Walton',
        'email': 'lindsay.walton@example.com',
        'role': 'User',
        'status': 'Active',
      },
      {
        'name': 'Courtney Henry',
        'email': 'courtney.henry@exmple.com',
        'role': 'User',
        'status': 'Inactive',
      },
      {
        'name': 'Kathryn Murphy',
        'email': 'kathryn.murphy@exmple.com',
        'role': 'User',
        'status': 'Active',
      },
    ];
    return Container(
      color: Color(0xFFF7F9FB),
      padding: EdgeInsets.symmetric(horizontal: 48, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Users',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B2447),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0B2447),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                ),
                onPressed: () {},
                child: Text(
                  'Add User',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search users',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            ),
          ),
          SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF0B2447),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Role',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF0B2447),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Status',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF0B2447),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                ...users
                    .map(
                      (user) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 18,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user['name']!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    user['email']!,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        user['status'] == 'Active'
                                            ? Colors.green[100]
                                            : Colors.red[100],
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Text(
                                    user['status']!,
                                    style: TextStyle(
                                      color:
                                          user['status'] == 'Active'
                                              ? Colors.green[900]
                                              : Colors.red[900],
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Reusing the _SidebarItem from dashboard_screen.dart, will need to copy its definition
class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: selected ? Colors.white.withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 22),
                SizedBox(width: 18),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 28, horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFF0B2447),
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class RolesScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF7F9FB),
      padding: EdgeInsets.symmetric(horizontal: 48, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Roles',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B2447),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement Add Role functionality
                },
                icon: Icon(Icons.add, size: 22),
                label: Text(
                  'Add Role',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0B2447),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                  elevation: 0,
                ),
              ),
            ],
          ),
          SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: DataTable(
                headingRowHeight: 48,
                dataRowHeight: 56,
                columnSpacing: 32,
                horizontalMargin: 0,
                columns: [
                  DataColumn(
                    label: Text(
                      'Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF0B2447),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF0B2447),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Users',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF0B2447),
                      ),
                    ),
                  ),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(
                        Text(
                          'Administrator',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          'Full access to the system',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      DataCell(Text('3', style: TextStyle(fontSize: 16))),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        Text(
                          'Manager',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          'Manage users and groups',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      DataCell(Text('7', style: TextStyle(fontSize: 16))),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        Text(
                          'Editor',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          'Edit content',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      DataCell(Text('12', style: TextStyle(fontSize: 16))),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        Text(
                          'Viewer',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          'View content only',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      DataCell(Text('25', style: TextStyle(fontSize: 16))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF7F9FB),
      padding: EdgeInsets.symmetric(horizontal: 48, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B2447),
            ),
          ),
          SizedBox(height: 36),
          _SettingsTile(
            title: 'General',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey[200]),
          _SettingsTile(
            title: 'Notifications',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NotificationsSettingsScreen(),
                ),
              );
            },
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey[200]),
          _SettingsTile(title: 'Billing', onTap: () {}),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  const _SettingsTile({required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                color: Color(0xFF23395d),
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[600], size: 32),
          ],
        ),
      ),
    );
  }
}
