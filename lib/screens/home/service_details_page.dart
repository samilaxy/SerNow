import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:serv_now/screens/components/image_with_placeholder.dart';
import 'package:serv_now/utilities/constants.dart';

import '../components/servie_card.dart';

class ServiceDetailsPage extends StatelessWidget {
  final ServiceCard serviceData;

  ServiceDetailsPage(this.serviceData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 200,
                    width: double.maxFinite,
                    child: ImageWithPlaceholder(
                        imageUrl: serviceData.icon, placeholderUrl: noImg)),
                Text(serviceData.serviceName),
                Text(serviceData.description),
                // Add more details about the service here
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ServiceData {
  final String serviceName;
  final String description;
  final String icon;
  final String location;

  ServiceData({
    required this.serviceName,
    required this.description,
    required this.icon,
    required this.location,
  });
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () => Navigator.pushNamed(context, 'home'),
                icon: const Icon(LineAwesomeIcons.angle_left)),
            // Text("Profile", style: Theme.of(context).textTheme.titleSmall),
            IconButton(
                onPressed: () {
                  // ProfileProvider.colorMode();
                },
                icon: Icon(isDark
                    ? LineAwesomeIcons.bookmark
                    : LineAwesomeIcons.bookmark_1))
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
