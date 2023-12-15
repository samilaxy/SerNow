import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:serv_now_new/controllers/admin_provider.dart';
import '../../models/service_model.dart';
import '../../utilities/constants.dart';
import '../components/image_slider.dart';
import '../components/image_with_placeholder.dart';
import '../home/zoom_imageview.dart';

class ReviewService extends StatefulWidget {
  const ReviewService({super.key});

  @override
  State<ReviewService> createState() => _ReviewServiceState();
}

class _ReviewServiceState extends State<ReviewService> {
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);
    ServiceModel? serviceData = provider.serviceData;
    String currency = "Ghs ";
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                color: Colors.grey,
                height: 220,
                width: double.maxFinite,
                child: MyImageSlider(imageUrls: serviceData?.imgUrls ?? [])),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: 40,
                        height: 40,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ZoomImageView(
                                          imageUrl:
                                              serviceData?.user?.img ?? "",
                                          placeholderUrl: tProfileImage),
                                    ));
                              },
                              child: Container(
                                  color: Colors.grey,
                                  child: ImageWithPlaceholder(
                                      imageUrl: serviceData?.user?.img ?? "",
                                      placeholderUrl: tProfileImage)),
                            ))),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 3.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(serviceData?.user?.fullName ?? "",
                                maxLines: 1,
                                style: GoogleFonts.poppins(fontSize: 15)),
                            Text(serviceData?.category ?? "",
                                maxLines: 1,
                                style: GoogleFonts.poppins(fontSize: 10)),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 25,
                          child: Text("$currency${serviceData?.price}",
                              style: GoogleFonts.poppins(
                                  fontSize: 18, fontWeight: FontWeight.normal)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 0),
                          child: SizedBox(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(serviceData?.location ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                        fontSize: 12, color: Colors.grey)),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  child: Icon(size: 12, Icons.location_on),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(thickness: 1),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: SizedBox(
                // color: Colors.amber,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Title",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: Colors.grey)),
                    Text(serviceData?.title ?? "",
                        style: GoogleFonts.poppins(fontSize: 18)),
                    const SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: Text("Category",
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      style: GoogleFonts.poppins(
                                          fontSize: 14, color: Colors.grey)),
                                ),
                                Text(serviceData?.category ?? "",
                                    style: GoogleFonts.poppins(fontSize: 16))
                              ]),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Contact",
                                    textAlign: TextAlign.end,
                                    style: GoogleFonts.poppins(
                                        fontSize: 14, color: Colors.grey)),
                                GestureDetector(
                                  onTap: () {
                                    provider
                                        .launchTel(serviceData?.user!.phone);
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                          size: 20,
                                          weight: 5,
                                          Icons.phone,
                                          color: Colors.green),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(serviceData?.user!.phone ?? "",
                                          style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              color: Colors.green)),
                                    ],
                                  ),
                                )
                              ])
                        ]),
                    const SizedBox(height: 30),
                    Text("Description",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: Colors.grey)),
                    const SizedBox(height: 5),
                    Text(serviceData?.description ?? "",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(fontSize: 14)),
                    const SizedBox(height: 50),
                    const Divider(thickness: 1.5)
                  ],
                ),
              ),
            ),
            // const SizedBox(height: 25),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text("Give reasons below, in the case of rejection",
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: Colors.grey)),
                ),
              ],
            ),
            SizedBox(
              height: 220,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16),
                child: TextFormField(
                  cursorColor: Colors.grey,
                  controller: commentController,
                  maxLines: 10, // Declare a TextEditingController
                  decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(30)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      label: Text("Comments*", style: GoogleFonts.poppins()),
                      prefixIcon: Container(width: 10)),
                ),
              ),
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!provider.isRejectLoading) {
                          provider.reviewService(serviceData?.id ?? "",
                              "reject", commentController.text, context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          side: BorderSide.none,
                          shape: const StadiumBorder()),
                      child: provider.isRejectLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.black26),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Reject",
                                    style: TextStyle(color: Colors.white)),
                                Icon(
                                  size: 20,
                                  Icons.cancel,
                                  color: Colors.black45,
                                )
                              ],
                            ),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!provider.isApproveLoading) {
                          provider.reviewService(serviceData?.id ?? "",
                              "approve", commentController.text, context);
                        }
                        // Navigator.pushNamed(context, 'home');
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          side: BorderSide.none,
                          shape: const StadiumBorder()),
                      child: provider.isApproveLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.black26),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Approve",
                                    style: TextStyle(color: Colors.white)),
                                Icon(
                                  size: 20,
                                  Icons.approval,
                                  color: Colors.black45,
                                )
                              ],
                            ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, 'pending'),
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: Theme.of(context).iconTheme.color)),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      title: Text("Review Service",
          style: GoogleFonts.poppins(
              textStyle: TextStyle(color: Theme.of(context).iconTheme.color),
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
