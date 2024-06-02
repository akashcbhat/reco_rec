import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reco_rec/screens/homescreen.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  List onboardContents = [
    {
      "image": 'assets/images/1.png',
      "title": 'Your Cooking Partner',
      "description": 'Experience intelligent identification and recipe suggestions!',
    },
    {
      "image": 'assets/images/2.png',
      "title": 'Healthy Recipe Suggestions',
      "description":
      'No worries when Recorec is here to give healthy recipes!',
    },
    {
      "image": 'assets/images/3.png',
      "title": 'Text to Speech Integration',
      "description":
      'Listen to the recipe instructions while cooking!',
    }
  ];

  Color titleColor = Color(0xffEFF1F4);
  Color descColor = Color(0xff8A9199);
  Color btnColor = Color(0xffEFF1F4);
  Color btnBgColor = Color(0xFF2D3B80);

  int currentPage = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  void onChanged(int index) {
    setState(() {
      currentPage = index;
    });
  }

  Future<void> _setOnboardingSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen', true);
  }

  void _navigateToHome() {
    _setOnboardingSeen().then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ImagePickerDemo()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(121221),
      appBar: AppBar(
        backgroundColor: Color(121221),
        actions: [
          TextButton(
            onPressed: _navigateToHome,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 8.0),
              child: Text(
                "Skip",
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 16,
                  color: descColor,
                ),
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          PageView.builder(
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300, // Set the desired width
                    height: 300, // Set the desired height
                    child: Image.asset(onboardContents[index]['image']),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    onboardContents[index]['title'],
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto',
                        color: titleColor),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                      child: Text(
                        onboardContents[index]['description'],
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          color: descColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                ],
              );
            },
            controller: pageController,
            scrollDirection: Axis.horizontal,
            itemCount: onboardContents.length,
            onPageChanged: onChanged,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  (currentPage == (onboardContents.length - 1))
                      ? SizedBox(
                    width: 335,
                    child: ElevatedButton(
                      onPressed: _navigateToHome,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Text(
                          "Get Started",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Color(0xffEFF1F4),
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              btnBgColor)),
                    ),
                  )
                      : SizedBox(
                    width: 335,
                    child: ElevatedButton(
                      onPressed: () {
                        pageController.animateToPage(currentPage + 1,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.fastEaseInToSlowEaseOut);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Text(
                          "Continue",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Color(0xffEFF1F4),
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              btnBgColor)),
                    ),
                  )
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(onboardContents.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 4,
                      width: (index == currentPage) ? 30 : 20,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: (index == currentPage)
                              ? const Color(0xFFEFF1F4)
                              : const Color(0xff2b303a)),
                    );
                  }),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
