import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final String serviceName;
  final String description;
  final IconData icon;

  const ServiceCard({super.key, 
    required this.serviceName,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: SizedBox(
        height: 150,
        child: ListTile(
          leading: SizedBox(
            height: 150,
            child: Icon(icon)),
          title: Text(serviceName),
          subtitle: Text(description),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            // Implement service details navigation here
            print("object");
          },
        ),
      ),
    );
  }
}

