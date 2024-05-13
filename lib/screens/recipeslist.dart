import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:reco_rec/screens/instructions.dart';

class RecipesList extends StatefulWidget {
  final String v;

  RecipesList(this.v);

  @override
  _RecipesListState createState() => _RecipesListState();
}

class _RecipesListState extends State<RecipesList> {
  List<List<dynamic>>? csvData = [];

  @override
  void initState() {
    super.initState();
    loadAsset();
  }

  Future<void> loadAsset() async {
    final myData = await rootBundle.loadString('assets/recipes.csv');
    setState(() {
      csvData = CsvToListConverter().convert(myData);
    });
  }

  List<String> searchInCsv(String v) {
    List<String> results = [];
    if (csvData != null) {
      for (var row in csvData!) {
        if (row[1] == v) {
          results.add(row[2]);
        }
      }
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    var val;
    List<String> searchResults = searchInCsv(widget.v);
    return Scaffold(
      backgroundColor: Color(121221),
      appBar: AppBar(
        backgroundColor: Color(121221),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Recipes List',
              style: TextStyle(fontSize: 24,color: Colors.white,fontFamily: "Roboto"),
            ),
            SizedBox(height: 20),
            Text(
              'Select the recipe for instructions:',
              style: TextStyle(fontSize: 16,color: Colors.white,fontFamily: "Roboto"),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      searchResults[index],
                      style: TextStyle(fontSize: 16,color: Colors.white,fontFamily: "Roboto"),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.book,color: Colors.white),
                      onPressed: () {
                        // Navigate to the Instructions screen and pass v
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Instructions(v: searchResults[index]),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
