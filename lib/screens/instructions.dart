import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Instructions extends StatelessWidget {
  final String v;
  final FlutterTts flutterTts = FlutterTts();

  Instructions({required this.v});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _fetchRecipeData(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          // Parse the CSV data and find the matching recipe
          final recipe = _findRecipe(snapshot.data!);
          if (recipe != null) {
            return WillPopScope(
              // Intercept when user tries to navigate back
              onWillPop: () async {
                // Stop TTS when user navigates back
                await flutterTts.stop();
                return true;
              },
              child: Scaffold(
                backgroundColor: Color(121221),
                appBar: AppBar(
                  title: Text('Instructions',
                      style:
                          TextStyle(color: Colors.white, fontFamily: "Roboto")),
                  backgroundColor: Color(121221),
                  iconTheme: IconThemeData(color: Colors.white),
                ),
                body: Center(
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
                        'Preparation Time: ${recipe[3]}', // Assuming preparation time is in the second column
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: "Roboto"),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Cooking Time: ${recipe[4]}', // Assuming cooking time is in the third column
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
                          textAlign: TextAlign
                              .justify, // Assuming ingredients are in the fourth column
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
                          textAlign: TextAlign
                              .justify, // Assuming instructions are in the fifth column
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontFamily: "Roboto"),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFF2D3B80)),
                        ),
                        onPressed: () async {
                          // Speak out the text contents of the screen
                          await _speakInstructions(recipe[7]);
                        },
                        child: Text(
                          'Read Instructions',
                          style: TextStyle(
                              color: Colors.white, fontFamily: "Roboto"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
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
    // Assuming the first column contains the recipe names
    int rowIndex = data.indexWhere((row) => row[2] == v);
    return rowIndex != -1 ? data[rowIndex] : null;
  }

  Future<void> _speakInstructions(String instructions) async {
    try {
      // Set TTS engine properties
      await flutterTts.setLanguage("en-IN");
      await flutterTts.setPitch(0.9); // Increase pitch for a higher voice
      await flutterTts.setSpeechRate(0.5); // Adjust speaking rate
      await flutterTts.setVolume(1.0); // Set volume to maximum

      // Speak the instructions
      await flutterTts.speak(instructions);
    } catch (e) {
      print("Error while speaking instructions: $e");
    }
  }
}
