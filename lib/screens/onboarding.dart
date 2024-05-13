import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reco_rec/screens/homescreen.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

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
      "description": 'Listen to the recipe instructions while cooking!',
    }
  ];

  Color titleColor = Color(0xffEFF1F4);
  Color descColor = Color(0xff8A9199);
  Color btnColor = Color(0xff21252C);
  Color btnBgColor = Color(0xffF98017);

  int currentPage = 0;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    bool onboardingCompleted = _prefs.getBool('onboarding_completed') ?? false;
    if (onboardingCompleted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ImagePickerDemo()),
      );
    }
  }

  void _completeOnboarding() async {
    await _prefs.setBool('onboarding_completed', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ImagePickerDemo()),
    );
  }

  void _nextPage() {
    if (currentPage < onboardContents.length - 1) {
      setState(() {
        currentPage++;
      });
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(121221),
      appBar: AppBar(
        backgroundColor: Color(121221),
        actions: [
          TextButton(
            onPressed: _completeOnboarding,
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
          ),
        ],
      ),
      body: Stack(
        children: [
          PageView.builder(
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(onboardContents[index]['image']),
                  const SizedBox(
                    height: 40,
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
            scrollDirection: Axis.horizontal,
            itemCount: onboardContents.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 335,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Text(
                          currentPage == onboardContents.length - 1
                              ? "Get Started"
                              : "Continue",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Color(0xff21252c),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          btnBgColor,
                        ),
                      ),
                    ),
                  ),
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
                  children: List<Widget>.generate(onboardContents.length,
                          (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 4,
                          width: (index == currentPage) ? 30 : 20,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: (index == currentPage)
                                ? const Color(0xFFEFF1F4)
                                : const Color(0xff2b303a),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
