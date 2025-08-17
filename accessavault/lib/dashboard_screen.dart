import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:accessavault/user_provider.dart'; // For UserProvider
import 'package:accessavault/client_provider.dart'; // For ClientProvider
import 'package:accessavault/role_provider.dart'; // For RoleProvider
import 'package:accessavault/group_provider.dart'; // For GroupProvider
import 'package:accessavault/app_provider.dart'; // For AppProvider

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final clientProvider = Provider.of<ClientProvider>(context);
    final roleProvider = Provider.of<RoleProvider>(context);
    final groupProvider = Provider.of<GroupProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

    final int totalUsers = userProvider.users.length;
    final int activeUsers =
        userProvider.users.where((user) => user['status'] == 'Active').length;
    final int totalClients = clientProvider.clients.length;
    final int totalRoles = roleProvider.roles.length;
    final int totalGroups = groupProvider.groups.length;
    final int totalApps = appProvider.apps.length;

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // Light Blue background
      appBar: AppBar(
        backgroundColor: const Color(0xFFE3F2FD), // Light Blue background
        elevation: 0,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  _buildStatCard(
                    'Total Users',
                    totalUsers.toString(),
                    Colors.blue.shade700,
                  ),
                  _buildStatCard(
                    'Active Users',
                    activeUsers.toString(),
                    Colors.green.shade700,
                  ),
                  _buildStatCard(
                    'Total Roles',
                    totalRoles.toString(),
                    Colors.purple.shade700,
                  ),
                  _buildStatCard(
                    'Total Groups',
                    totalGroups.toString(),
                    Colors.orange.shade700,
                  ),
                  _buildStatCard(
                    'Total Clients',
                    totalClients.toString(),
                    Colors.red.shade700,
                  ),
                  _buildStatCard(
                    'Total Apps',
                    totalApps.toString(),
                    Colors.teal.shade700,
                  ),
                ],
              ),
              const SizedBox(height: 48),
              Text(
                'Overview',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildBarChartCard(
                      'User Roles',
                      _getUserRoleBarChartData(userProvider.users, roleProvider.roles),
                      _getUserRoleTitles(roleProvider.roles),
                      userProvider.users.length, // Pass total users for maxY calculation
                      0, // Not directly used for this chart's maxY, but needed for function signature
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildPieChartCard(
                      'Groups by Client',
                      _getGroupsByClientPieChartData(groupProvider.groups, clientProvider.clients),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      width: 200, // Adjusted width for more cards
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
              color: color,
              fontSize: 18, // Adjusted font size
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFF0D47A1), // Dark Blue text
              fontSize: 40, // Adjusted font size
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChartCard(
    String title,
    List<BarChartGroupData> barGroups,
    List<String> titles,
    int totalUsers,
    int activeUsers,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1), // Dark Blue text
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: barGroups,
                  minY: 0,
                  maxY:
                      totalUsers.toDouble() > activeUsers.toDouble()
                          ? totalUsers.toDouble() + 5
                          : activeUsers.toDouble() +
                              5, // Add some padding to maxY
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          rod.toY.toString(),
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                      ), // Increased reservedSize
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 8, // Increased space
                            child: Text(
                              titles[value.toInt()],
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        },
                        reservedSize: 50, // Increased reservedSize
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChartCard(String title, List<PieChartSectionData> sections) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1), // Dark Blue text
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _getUserRoleBarChartData(
      List<Map<String, dynamic>> users, List<dynamic> roles) {
    final Map<String, int> roleCounts = {};
    for (var role in roles) {
      roleCounts[role.name] = 0;
    }

    for (var user in users) {
      final userRole = user['role'];
      if (roleCounts.containsKey(userRole)) {
        roleCounts[userRole] = roleCounts[userRole]! + 1;
      }
    }

    return roleCounts.entries.map((entry) {
      final index = roles.indexWhere((role) => role.name == entry.key);
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: Colors.blue.shade700,
            width: 20,
          ),
        ],
      );
    }).toList();
  }

  List<String> _getUserRoleTitles(List<dynamic> roles) {
    return roles.map((role) => role.name.toString()).toList();
  }

  List<PieChartSectionData> _getGroupsByClientPieChartData(
      List<dynamic> groups, List<dynamic> clients) {
    final Map<String, int> clientGroupCounts = {};
    final Map<String, String> clientIdToName = {
      for (var client in clients) client.id: client.name
    };

    for (var client in clients) {
      clientGroupCounts[client.name] = 0;
    }

    for (var group in groups) {
      final clientName = clientIdToName[group.clientId];
      if (clientName != null && clientGroupCounts.containsKey(clientName)) {
        clientGroupCounts[clientName] = clientGroupCounts[clientName]! + 1;
      }
    }

    final List<Color> pieColors = [
      Colors.blue.shade700,
      Colors.lightBlueAccent,
      Colors.cyan.shade700,
      Colors.teal.shade700,
      Colors.green.shade700,
      Colors.lime.shade700,
      Colors.amber.shade700,
      Colors.orange.shade700,
      Colors.deepOrange.shade700,
      Colors.red.shade700,
      Colors.pink.shade700,
      Colors.purple.shade700,
      Colors.deepPurple.shade700,
      Colors.indigo.shade700,
    ];

    int colorIndex = 0;
    return clientGroupCounts.entries.map((entry) {
      final color = pieColors[colorIndex % pieColors.length];
      colorIndex++;
      return PieChartSectionData(
        color: color,
        value: entry.value.toDouble(),
        title: entry.key,
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}
