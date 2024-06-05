import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:reco_rec/screens/recipeslist.dart';
import 'package:flutter/cupertino.dart';

class ImagePickerDemo extends StatefulWidget {
  @override
  _ImagePickerDemoState createState() => _ImagePickerDemoState();
}

class _ImagePickerDemoState extends State<ImagePickerDemo> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  File? file;
  var _recognitions;
  var v = "";

  @override
  void initState() {
    super.initState();
    loadmodel().then((value) {
      setState(() {});
    });
  }

  loadmodel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/ingredient_labels.txt",
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image =
      await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        file = File(image!.path);
      });
      detectimage(file!);
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _openRecipes(BuildContext context, String v) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecipesList(v)),
    );
  }

  Future detectimage(File image) async {
    int startTime = new DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 5,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    var highConfidenceRecognitions =
    recognitions!.where((res) => res['confidence'] > 0.5).toList();

    setState(() {

      if (highConfidenceRecognitions.isEmpty) {
        v = "Ambiguity in Image";
        _recognitions = [];
      } else {
        _recognitions = highConfidenceRecognitions;
        v = highConfidenceRecognitions.map((res) => res['label']).join(', ');
      }
    });
    int endTime = new DateTime.now().millisecondsSinceEpoch;

    print("Inference took ${endTime - startTime}ms");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(121221),
      appBar: AppBar(
        title: Text(
          "Welcome!",
          style: TextStyle(
            fontFamily: "Roboto",
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFFEFF1F4),
          ),
        ),
        backgroundColor: Color(121221),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/wave-haikei.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                "assets/images/logo_recorec_plain.png",
                height: 180,
                width: 180,
              ),
              SizedBox(height: 30),
              if (_image != null)
                Image.file(
                  File(_image!.path),
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                )
              else
                Text(
                  'No image selected',
                  style: TextStyle(color: Colors.white, fontFamily: "Roboto"),
                ),
              SizedBox(height: 20),

              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Color(0xFF2D3B80)),
                ),
                onPressed: _pickImage,
                child: Text(
                  'Pick Image from Gallery',
                  style: TextStyle(fontFamily: "Roboto", color: Colors.white),
                ),
              ),

              SizedBox(height: 20),
              Text(
                v,
                style: TextStyle(color: Colors.white, fontFamily: "Roboto"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Color(0xFF2D3B80)),
                ),
                onPressed: (_image != null && v != "Ambiguity in Image") ? () => _openRecipes(context, v) : null,
                // Disable the button if _image is null or if v is "Ambiguity in Image"
                child: Text(
                  "Open Recipes",
                  style: TextStyle(color: Colors.white, fontFamily: "Roboto"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
