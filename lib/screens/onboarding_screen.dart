import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utilities/constants.dart';
import '../models/onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;
  PageController _controller = PageController(initialPage: 0);
  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<OnBoardingModel> contents = [
      OnBoardingModel(
          img: image2,
          title: 'Top-Rated Providers',
          description:
              'ServNow connects top-rated local service providers, that users can access and hire the best and most reputable professionals for their service needs through the app.'),
      OnBoardingModel(
          img: image3,
          title: 'Simplify Life',
          description:
              'Join the ServNow community and simplify your life. ServNow services makes life more straightforward and hassle-free by providing easy access to trusted local service providers.'),
      OnBoardingModel(
          img: image4,
          title: 'Endless Search',
          description:
              'Tired of searching endlessly for trusted services?. ServNow aims to provide a solution to this problem by making it easier to find reliable local service providers.')
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: contents.length,
                onPageChanged: (int index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (_, i) {
                  return Column(
                    children: [
                      const Expanded(child: SizedBox(height: 150)),
                      SizedBox(
                          height: 300, child: Image.asset(contents[i].img)),
                      const SizedBox(height: 30),
                      Text(
                        contents[i].title,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        contents[i].description,
                        textAlign: TextAlign.center,
                        //overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  contents.length, (index) => buildBot(currentPage, index)),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100))),
                    onPressed: () async {
                      if (currentPage == contents.length - 1) {
                        Navigator.pushNamed(context, 'phone');
                      }
                      _controller.nextPage(
                          duration: const Duration(microseconds: 100),
                          curve: Curves.bounceIn);
                    },
                    child: Text(
                        currentPage == contents.length - 1 ? "Start" : "Next",
                        style: GoogleFonts.poppins(
                          // fontSize: 13.0,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ))),
              ),
            )
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildBot(int currentPage, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 10,
      margin: const EdgeInsets.only(right: 3),
      width: currentPage == index ? 20 : 10,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: mainColor),
    );
  }
}
