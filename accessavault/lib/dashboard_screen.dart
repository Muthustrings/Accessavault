import 'package:flutter/material.dart';
import 'package:accessavault/users_screen.dart';

class DashboardScreen extends StatelessWidget {
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
                  selected: true,
                ),
                _SidebarItem(
                  icon: Icons.person_outline,
                  label: 'Users',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UsersScreen()),
                    );
                  },
                ),
                _SidebarItem(icon: Icons.account_tree_outlined, label: 'Roles'),
                _SidebarItem(icon: Icons.groups_outlined, label: 'Groups'),
                _SidebarItem(icon: Icons.settings_outlined, label: 'Settings'),
                Spacer(),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Container(
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
            ),
          ),
        ],
      ),
    );
  }
}

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
