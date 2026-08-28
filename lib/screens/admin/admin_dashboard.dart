import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentPage = 0;

  final List<AdminMenuPage> menuPages = [
    AdminMenuPage(title: 'Dashboard', icon: Icons.dashboard_rounded, page: 0),
    AdminMenuPage(title: 'Users', icon: Icons.people_rounded, page: 1),
    AdminMenuPage(title: 'Transactions', icon: Icons.receipt_long_rounded, page: 2),
    AdminMenuPage(title: 'Analytics', icon: Icons.analytics_rounded, page: 3),
    AdminMenuPage(title: 'Settings', icon: Icons.settings_rounded, page: 4),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07111F),
      body: SafeArea(
        child: Row(
          children: [
            Container(
              width: 250,
              color: const Color(0xFF081421),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'AURENZA',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'ADMIN',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2F80ED),
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: menuPages
                          .map((page) => _buildMenuItem(page))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildPageContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(AdminMenuPage page) {
    final isActive = _currentPage == page.page;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF12304F) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          page.icon,
          color: isActive ? const Color(0xFF63AEFF) : const Color(0xFF70869D),
        ),
        title: Text(
          page.title,
          style: TextStyle(
            fontSize: 13,
            color: isActive ? Colors.white : const Color(0xFF8297AC),
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        onTap: () {
          setState(() {
            _currentPage = page.page;
          });
        },
      ),
    );
  }

  Widget _buildPageContent() {
    switch (_currentPage) {
      case 0:
        return _buildAdminDashboardHome();
      case 1:
        return _buildUsersPage();
      case 2:
        return _buildTransactionsPage();
      case 3:
        return _buildAnalyticsPage();
      case 4:
        return _buildSettingsPage();
      default:
        return _buildAdminDashboardHome();
    }
  }

  Widget _buildAdminDashboardHome() {
    return CustomScrollView(
      slivers: [
        _buildAdminTopBar('Admin Dashboard'),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildAdminStats(),
              const SizedBox(height: 24),
              _buildRecentUsers(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildAdminStats() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildStatCard('Total Users', '1,234', Icons.people_rounded),
        _buildStatCard('Total Transactions', '5,678', Icons.receipt_long_rounded),
        _buildStatCard('Total Volume', '\$234.5K', Icons.trending_up_rounded),
        _buildStatCard('Platform Fee', '\$12.3K', Icons.monetization_on_rounded),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B192B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: const Color(0xFF62AEFF), size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 11, color: Color(0xFF8FA5BD)),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentUsers() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0B192B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Users',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          DataTable(
            columns: const [
              DataColumn(label: Text('User')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Joined')),
            ],
            rows: [
              DataRow(cells: [
                const DataCell(Text('John Doe')),
                const DataCell(Text('john@example.com')),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Active',
                      style: TextStyle(fontSize: 11, color: Color(0xFF42D392)),
                    ),
                  ),
                ),
                const DataCell(Text('2024-01-15')),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUsersPage() => _buildAdminPlaceholder('Users', 'Manage user accounts and roles');
  Widget _buildTransactionsPage() => _buildAdminPlaceholder('Transactions', 'Monitor all transactions');
  Widget _buildAnalyticsPage() => _buildAdminPlaceholder('Analytics', 'View platform analytics');
  Widget _buildSettingsPage() => _buildAdminPlaceholder('Settings', 'Admin settings and configuration');

  Widget _buildAdminPlaceholder(String title, String subtitle) {
    return CustomScrollView(
      slivers: [
        _buildAdminTopBar(title),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B192B),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(.07)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF8FA5BD),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  SliverAppBar _buildAdminTopBar(String title) {
    return SliverAppBar(
      title: Text(title),
      backgroundColor: const Color(0xFF0A1728),
      elevation: 0,
      pinned: true,
    );
  }
}

class AdminMenuPage {
  final String title;
  final IconData icon;
  final int page;

  AdminMenuPage({
    required this.title,
    required this.icon,
    required this.page,
  });
}
