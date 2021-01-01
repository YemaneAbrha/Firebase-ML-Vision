import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FireBase ML',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Fire Base ML'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File pickedImage;
  bool isImageloaded = false;
  FirebaseVisionImage ourImage;
  Future retriveImage() async {
    var temp = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      pickedImage = File(temp.path);
      ourImage = FirebaseVisionImage.fromFile(pickedImage);
      isImageloaded = true;
    });
  }

  Future readText() async {
    // FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizerText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizerText.processImage(ourImage);
    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          print(word.text);
        }
      }
    }
  }

  Future detectBarcode() async {
    final BarcodeDetector barcodeDetector =
        FirebaseVision.instance.barcodeDetector();
    final List<Barcode> barcodes =
        await barcodeDetector.detectInImage(ourImage);
    for (Barcode readableCode in barcodes) {
      print(readableCode.displayValue);
    }
  }
// @Override
// public void onCreate() {
//     super.onCreate();
//     FirebaseApp.initializeApp(this);
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: [
            isImageloaded
                ? Center(
                    child: Container(
                      height: 200.0,
                      width: 200.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(pickedImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : Center(child: Text("Image is not loaded")),
            SizedBox(height: 10.0),
            RaisedButton(child: Text("Pick an Image"), onPressed: retriveImage),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                RaisedButton(
                  child: Text('Read Text'),
                  onPressed: readText,
                ),
                SizedBox(width: 10),
                RaisedButton(
                  child: Text("Read Barcode"),
                  onPressed: detectBarcode,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
