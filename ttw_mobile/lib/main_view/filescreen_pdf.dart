import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../constants.dart';
import '../model/uploaded_pdf.dart';
import '../model/user.dart';
import '../recognize_screen/extracted_pdf.dart';
import 'filescreen.dart';
import 'mainscreen.dart';
import 'package:http/http.dart' as http;

User user = User();

class PDFFileScreen extends StatefulWidget {
  final User user;

  const PDFFileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<PDFFileScreen> createState() => _PDFFileScreenState();
}

class _PDFFileScreenState extends State<PDFFileScreen> {
  late double screenHeight, screenWidth, resWidth;

  FlutterTts flutterTts = FlutterTts();

  String intro = "Book Rack Screen. PDF.";

  List<UploadedPDF> pdfList = <UploadedPDF>[];
  String titlecenter = "No Files";

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    
    return Scaffold(
      body: Stack(
        children: [
          buildBackground(),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 35, 10, 0),
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
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    buildImage(),
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
  }

  // @override
  // Widget build(BuildContext context) => Scaffold(
  //       body: Stack(
  //         children: [
  //           buildBackground(),
  //           Padding(
  //             padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
  //             child: Stack(
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     buildReturnButton(),
  //                     buildTitle(),
  //                     buildSpeechButton(),
  //                   ],
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.fromLTRB(10, 50, 12, 0),
  //                   child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.end,
  //                       children: [
  //                         buildImage(),
  //                       ]),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.fromLTRB(10, 60, 0, 0),
  //                   child: buildContext(),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     );

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

  Widget buildImage() => GestureDetector(
        onTap: () => {
          stop(),
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ImageFileScreen(
                        user: widget.user,
                      )))
        },
        child: const Text(
          "Image",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget buildContext() => Container(
      child: pdfList.isEmpty
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
                      children: List.generate(pdfList.length, (index) {
                        return InkWell(
                          splashColor: Colors.amber,
                          // onTap: () => {recognizeImage(index)},
                          onTap: () => {_loadText(index)},
                          child: Container(
                              child: Column(
                            children: [
                              Flexible(
                                flex: 4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 120,
                                      child: SizedBox(
                                          child: Image.asset(
                                              'assets/images/pdf_icon.png')),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      pdfList[index].pdf_name.toString(),
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
    http.post(Uri.parse(CONSTANTS.server + "/fyp_ttw/php/load_pdf.php"), body: {
      "email": widget.user.email.toString(),
    }).then((response) {
      var jsondata = jsonDecode(response.body);
      print(jsondata);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        if (extractdata['pdf'] != null) {
          pdfList = <UploadedPDF>[];
          extractdata['pdf'].forEach((v) {
            pdfList.add(UploadedPDF.fromJson(v));
          });
          setState(() {});
        } else {
          titlecenter = "No Files Available";
          setState(() {});
        }
      }
    });
  }

  void _loadText(int index) {
    String pdfText = pdfList[index].pdf_text.toString();
    String pdfName = pdfList[index].pdf_name.toString();

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => ExtractedPdfTextScreen(
          pdfText: pdfText,
          pdfName: pdfName,
          user: widget.user,
        ),
      ),
    );
  }
}
