import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final Function(int) onItemSelected; // Callback untuk navigasi

  const Sidebar({super.key, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: Text(
              'FinTracker',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildDrawerItem(context, Icons.dashboard, 'Dashboard', 0),
          // _buildDrawerItem(context, Icons.pie_chart, 'Budget', 1),
          _buildDrawerItem(context, Icons.account_balance_wallet, 'Income', 1),
          _buildDrawerItem(context, Icons.attach_money, 'Expenses', 2),
          _buildDrawerItem(context, Icons.calendar_today, 'Monthly Plan', 3),

          // Add the Logout button at the bottom
          Divider(), // Divider to separate the logout button
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              // Implement your logout logic here
              _logout(context);
            },
          ),
        ],
      ),
    );
  }

  // Function to handle logout logic
  void _logout(BuildContext context) {
    // Logic for logging out the user goes here. For example:
    // - Clear user data from SharedPreferences, Firebase, or session
    // - Navigate back to the login screen
    // Example: Navigator.pushReplacementNamed(context, '/login');

    // Assuming you want to navigate to login screen (or any other page)
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    int index,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // Tutup sidebar
        onItemSelected(index); // Panggil callback untuk navigasi
      },
    );
  }
}
