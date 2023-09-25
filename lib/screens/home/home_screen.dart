import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../Utilities/constants.dart';
import '../components/servie_card.dart';
import 'service_details_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ServiceCard> data = [
    const ServiceCard(
      serviceName: 'Haircut Haircut',
      location: "Tema",
      description: 'Get a stylish haircut from our experienced barbers.',
      icon: "Icons.cut",
    ),
    const ServiceCard(
      serviceName: 'Plumbing',
      location: "Tema",
      description: 'Professional plumbing services for your home.',
      icon: "Icons.plumbing",
    ),
    const ServiceCard(
      serviceName: 'Tailoring',
      description: 'Custom clothing design and alterations.',
      location: "Accra",
      icon: "Icons.create",
    ),
    const ServiceCard(
      serviceName: 'Haircut',
      description: 'Get a stylish haircut from our experienced barbers.',
      location: "Takoradi",
      icon: "Icons.cut",
    ),
    const ServiceCard(
      serviceName: 'Plumbing',
      description: 'Professional plumbing services for your home.',
      location: "Tema",
      icon: "Icons.plumbing",
    ),
    const ServiceCard(
      serviceName: 'Tailoring',
      description: 'Custom clothing design and alterations.',
      location: "Accra",
      icon: "Icons.create",
    ),
    const ServiceCard(
      serviceName: 'Tailoring',
      location: "Adenta",
      description: 'Custom clothing design and alterations.',
      icon: "Icons.create",
    ),
    const ServiceCard(
      serviceName: 'Haircut',
      location: "Kumasi",
      description: 'Get a stylish haircut from our experienced barbers.',
      icon: "Icons.cut",
    ),
    const ServiceCard(
      serviceName: 'Plumbing',
      location: "Ho",
      description: 'Professional plumbing services for your home.',
      icon: "Icons.plumbing",
    ),
    const ServiceCard(
      serviceName: 'Tailoring',
      location: "Tamale",
      description: 'Custom clothing design and alterations.',
      icon: "Icons.create",
    ),
    const ServiceCard(
      serviceName: 'Tailoring',
      location: "Tema",
      description: 'Custom clothing design and alterations.',
      icon: "Icons.create",
    ),
    const ServiceCard(
      serviceName: 'Haircut',
      location: "Tema",
      description: 'Get a stylish haircut from our experienced barbers.',
      icon: "Icons.cut",
    ),
    const ServiceCard(
      serviceName: 'Tailoring',
      location: "Hohoe",
      description: 'Custom clothing design and alterations.',
      icon: "Icons.create",
    ),
    const ServiceCard(
      serviceName: 'Haircut',
      location: "Kpone",
      description: 'Get a stylish haircut from our experienced barbers.',
      icon: "Icons.cut",
    ),
    const ServiceCard(
      serviceName: 'Plumbing',
      location: "Teshi",
      description: 'Professional plumbing services for your home.',
      icon: "Icons.plumbing",
    ),
    const ServiceCard(
      serviceName: 'Tailoring',
      location: "Nungua",
      description: 'Custom clothing design and alterations.',
      icon: "Icons.create",
    ),
    const ServiceCard(
      serviceName: 'Plumbing',
      location: "Osu",
      description: 'Professional plumbing services for your home.',
      icon: "Icons.plumbing",
    ),
    const ServiceCard(
      serviceName: 'Tailoring',
      location: "London London London London",
      description: 'Custom clothing design and alterations.',
      icon: "Icons.create",
    ) // Add more ServiceCards as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(),
        body: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5.0,
                childAspectRatio: 0.8,
                crossAxisSpacing: 5.0),
            padding: const EdgeInsets.all(10),
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
            onTap: () {
              // Navigate to the details page here, passing data[index] as a parameter
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceDetailsPage(data[index]),
                ),
              );
            },
            child: ServiceCard(
              serviceName: data[index].serviceName,
              description: data[index].description,
              icon: data[index].icon,
              location: data[index].location,
            ),
          );
            }));
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return SafeArea(
      child: SizedBox(
        height: kToolbarHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Image.asset(
                logoImg,
                width: 80,
                height: 80,
              ),
            ),
            // IconButton(
            //     onPressed: () {
            //       // ProfileProvider.colorMode();
            //     },
            //     icon: Padding(
            //       padding: const EdgeInsets.only(right: 20),
            //       child: Icon(isDark
            //           ? LineAwesomeIcons.sun
            //           : LineAwesomeIcons.horizontal_ellipsis),
            //     ))
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

