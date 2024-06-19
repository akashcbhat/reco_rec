import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';

class Instructions extends StatefulWidget {
  final String v;

  Instructions({required this.v});

  @override
  _InstructionsState createState() => _InstructionsState();
}

class _InstructionsState extends State<Instructions>
    with SingleTickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;
  bool isPaused = false;
  late AnimationController _controller;
  late Animation<Color?> _colorTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _colorTween = _controller.drive(
      ColorTween(begin: Colors.blue, end: Colors.red),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
        isPaused = false;
      });
      _controller.stop();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _speakInstructions(String instructions) async {
    try {
      await flutterTts.setLanguage("en-IN");
      await flutterTts.setPitch(0.9);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      await flutterTts.setVoice({"name": "en-in-x-ene-network", "locale": "en-IN"});

      setState(() {
        isSpeaking = true;
        isPaused = false;
      });
      await flutterTts.speak(instructions);
    } catch (e) {
      print("Error while speaking instructions: $e");
    }
  }

  Future<void> _pauseInstructions() async {
    await flutterTts.pause();
    setState(() {
      isPaused = true;
      isSpeaking = false;
    });
  }

  Future<void> _replayInstructions(String instructions) async {
    await flutterTts.stop();
    await _speakInstructions(instructions);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _fetchRecipeData(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          final recipe = _findRecipe(snapshot.data!);
          if (recipe != null) {
            return WillPopScope(
              onWillPop: () async {
                await flutterTts.stop();
                return true;
              },
              child: Scaffold(
                backgroundColor: Color(121221),
                appBar: AppBar(
                  title: Text('Instructions',
                      style: TextStyle(
                          color: Colors.white, fontFamily: "Roboto")),
                  backgroundColor: Color(121221),
                  iconTheme: IconThemeData(color: Colors.white),
                ),
                body: SingleChildScrollView(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 40),
                          Text(
                            '${recipe[2]}',
                            style: TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                                fontFamily: "Roboto"),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Preparation Time: ${recipe[3]}',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: "Roboto"),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Cooking Time: ${recipe[4]}',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: "Roboto"),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Serving: ${recipe[5]}',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: "Roboto"),
                          ),
                          SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                            child: Text(
                              'Ingredients: ${recipe[6]}',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontFamily: "Roboto"),
                            ),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                            child: Text(
                              'Instructions: ${recipe[7]}',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontFamily: "Roboto"),
                            ),
                          ),
                          SizedBox(height: 20),
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              return ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Colors.blue),
                                ),
                                onPressed: isSpeaking || isPaused
                                    ? null
                                    : () async {
                                  setState(() {
                                    isSpeaking = true;
                                  });
                                  _controller.forward();
                                  await _speakInstructions(recipe[7]);
                                  _controller.stop();
                                },
                                child: Text(
                                  'Read Instructions',
                                  style: TextStyle(
                                      color: Colors.white, fontFamily: "Roboto"),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 15),
                          if (isSpeaking || isPaused)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.pause),
                                  color: Colors.white,
                                  onPressed: isSpeaking
                                      ? () async {
                                    await _pauseInstructions();
                                  }
                                      : null,
                                ),
                                IconButton(
                                  icon: Icon(Icons.replay),
                                  color: Colors.white,
                                  onPressed: isPaused
                                      ? () async {
                                    await _replayInstructions(recipe[7]);
                                  }
                                      : null,
                                ),
                              ],
                            ),
                          SizedBox(height: 15),
                          if (isSpeaking)
                            Container(
                              child: Lottie.asset(
                                'assets/lottie.json',
                                height: 50,
                                width: 50,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Color(121221),
                title: Text('Instructions'),
              ),
              body: Center(
                child: Text(
                  'Recipe not found!',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(121221),
              title: Text('Instructions'),
            ),
            body: Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: 24),
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(121221),
              title: Text('Instructions'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Future<List<dynamic>> _fetchRecipeData() async {
    String csvData = await rootBundle.loadString('assets/recipes.csv');
    List<List<dynamic>> rows = const CsvToListConverter().convert(csvData);
    return rows;
  }

  List<dynamic>? _findRecipe(List<dynamic> data) {
    int rowIndex = data.indexWhere((row) => row[2] == widget.v);
    return rowIndex != -1 ? data[rowIndex] : null;
  }
}
