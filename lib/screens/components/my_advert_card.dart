import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../controllers/my_adverts_provider.dart';
import '../../main.dart';
import '../../models/discover_model.dart';
import '../../screens/components/image_with_placeholder.dart';
import '../../utilities/constants.dart';
import 'custom_alertdialog.dart';

class MyAdvertCard extends StatefulWidget {
  final DiscoverModel service;

  const MyAdvertCard({Key? key, required this.service}) : super(key: key);

  @override
  State<MyAdvertCard> createState() => _MyAdvertCardState();
}

class _MyAdvertCardState extends State<MyAdvertCard> {
  late String serId;

  @override
  Widget build(BuildContext context) {
    final myAdvert = Provider.of<MyAdvertsProvider>(context);
    String currency = "GHS ";

    return Container(
      width: 150.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              SizedBox(
                height: 120,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: ImageWithPlaceholder(
                    imageUrl: widget.service.img,
                    placeholderUrl: noImg,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.service.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$currency${widget.service.price}',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13.0,
                            )),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                widget.service.status ? "Active" : "Pending",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 10.0,
                                ),
                              ),
                            ),
                            Icon(
                              size: 10,
                              Icons.circle,
                              color: widget.service.status
                                  ? Colors.green
                                  : Colors.red,
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomAlertDialog(
                          context: context,
                          onOkPressed: () {
                            serId = widget.service.id ?? '';
                            myAdvert.deleteService(serId, context);
                          },
                          title: 'Delete Service',
                          content:
                              "Services deleted can't be recovered, Are you sure you want to delete?",
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    size: 20,
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await myAdvert.fetchService(
                        widget.service.id ?? "", context);
                    print("service: ${widget.service.id}");
                    navigatorKey.currentState!.pushNamed('updateAdvert');
                  },
                  icon: const Icon(
                    size: 20,
                    LineAwesomeIcons.edit,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
