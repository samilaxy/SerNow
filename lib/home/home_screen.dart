import 'package:flutter/material.dart';

import 'home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
       ListView(
        padding: const EdgeInsets.all(16),
        children: const [
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
      )
    );
  }
}