import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, John Doe'), // Replace with the user's name
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Implement logout functionality here
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'Services Available',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ServiceCard(
            serviceName: 'Haircut',
            description: 'Get a stylish haircut from our experienced barbers.',
            icon: Icons.cut,
          ),
          ServiceCard(
            serviceName: 'Plumbing',
            description: 'Professional plumbing services for your home.',
            icon: Icons.plumbing,
          ),
          ServiceCard(
            serviceName: 'Tailoring',
            description: 'Custom clothing design and alterations.',
            icon: Icons.create,
          ),
          // Add more ServiceCards as needed
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String serviceName;
  final String description;
  final IconData icon;

  ServiceCard({
    required this.serviceName,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon),
        title: Text(serviceName),
        subtitle: Text(description),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // Implement service details navigation here
        },
      ),
    );
  }
}
