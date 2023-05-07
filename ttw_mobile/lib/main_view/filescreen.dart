import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../constants.dart';
import '../model/uploaded_image.dart';
import '../model/user.dart';
import '../recognize_screen/file_recognize_image.dart';
import 'filescreen_pdf.dart';
import 'mainscreen.dart';
import 'package:http/http.dart' as http;

User user = User();

class ImageFileScreen extends StatefulWidget {
  final User user;

  const ImageFileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ImageFileScreen> createState() => _ImageFileScreenState();
}

class _ImageFileScreenState extends State<ImageFileScreen> {
  late double screenHeight, screenWidth, resWidth;

  FlutterTts flutterTts = FlutterTts();

  String intro = "Book Rack Screen. Image.";

  List<UploadedImage> imageList = <UploadedImage>[];
  String titlecenter = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            buildBackground(),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildReturnButton(),
                      buildTitle(),
                      buildSpeechButton(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 50, 12, 0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          buildPdf(),
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 60, 0, 0),
                    child: buildContext(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget buildBackground() => ClipRRect(
        child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/file_page.png'),
                    fit: BoxFit.cover))),
      );

  Widget buildTitle() => const Text(
        "Book Rack",
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      );

  Widget buildReturnButton() => IconButton(
      icon: const Icon(
        Icons.keyboard_arrow_left,
        size: 35,
      ),
      onPressed: () {
        stop();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (content) => MainScreen(
                      user: widget.user,
                    )));
      });

  Widget buildSpeechButton() => IconButton(
        icon: const Icon(
          Icons.headphones,
          size: 32,
          color: Colors.black,
        ),
        onPressed: () => speakIntro(intro),
      );

  Widget buildPdf() => GestureDetector(
        onTap: () => {
          stop(),
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => PDFFileScreen(
                        user: widget.user,
                      )))
        },
        child: const Text(
          "PDF",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget buildContext() => Container(
      child: imageList.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                    fontSize: 22,
                  )))
          : Column(children: [
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: (1 / 1),
                      children: List.generate(imageList.length, (index) {
                        return InkWell(
                          splashColor: Colors.amber,
                          onTap: () => {recognizeImage(index)},
                          child: Container(
                              child: Column(
                            children: [
                              Flexible(
                                flex: 4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        child: Image.network(
                                      CONSTANTS.server +
                                          "/fyp_ttw/assets/image/" +
                                          imageList[index].image_id.toString() +
                                          '.jpg',
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                    )),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      imageList[index].image_name.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                        );
                      }))),
            ]));

  speakIntro(String intro) async {
    if (intro != null && intro.isNotEmpty) {
      await flutterTts.setLanguage('en-US');
      await flutterTts.setPitch(1); // 0.5 to 1.5
      await flutterTts.speak(intro);
    }
  }

  stop() async {
    await flutterTts.stop();
  }

  void _loadFile() {
    http.post(Uri.parse(CONSTANTS.server + "/fyp_ttw/php/load_image.php"),
        body: {
          "email": widget.user.email.toString(),
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      print(jsondata);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        if (extractdata['images'] != null) {
          imageList = <UploadedImage>[];
          extractdata['images'].forEach((v) {
            imageList.add(UploadedImage.fromJson(v));
          });
          setState(() {});
        } else {
          titlecenter = "No Files Available";
          setState(() {});
        }
      }
    });
  }

  void recognizeImage(int index) {
    String imagePath = CONSTANTS.server +
        "/fyp_ttw/assets/image/" +
        imageList[index].image_id.toString() +
        '.jpg';

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => FileRecognizeImagePage(
          path: imagePath,
          user: widget.user,
        ),
      ),
    );
  }
}
