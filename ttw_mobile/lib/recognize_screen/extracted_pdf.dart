import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../main_view/filescreen_pdf.dart';
import '../model/uploaded_image.dart';
import '../model/user.dart';

class ExtractedPdfTextScreen extends StatefulWidget {
  final User user;
  String pdfText;
  String pdfName;

  ExtractedPdfTextScreen({
    Key? key,
    required this.user,
    required this.pdfText,
    required this.pdfName,
  }) : super(key: key);

  @override
  State<ExtractedPdfTextScreen> createState() => _ExtractedPdfTextScreenState();
}

class _ExtractedPdfTextScreenState extends State<ExtractedPdfTextScreen> {
  List<UploadedImage> imageList = <UploadedImage>[];

  FlutterTts flutterTts = FlutterTts();

  void stop() async {
    await flutterTts.stop();
  }

  void speak({String? text}) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setVolume(1.0);

    try {
      await flutterTts.speak(text!);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            child: const Icon(
              Icons.keyboard_arrow_left,
              size: 35,
            ),
            onTap: () {
              stop();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) => PDFFileScreen(
                            user: widget.user,
                          )));
            }),
        title: Text(widget.pdfName),
        actions: [
          IconButton(
              onPressed: () {
                stop();
              },
              icon: const Icon(
                Icons.stop,
                size: 28,
              )),
          IconButton(
              onPressed: () {
                speak(text: widget.pdfText);
              },
              icon: const Icon(
                Icons.mic,
                size: 28,
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: (widget.pdfText) != null
                    ? Text(
                        widget.pdfText,
                        style: TextStyle(fontSize: 16),
                      )
                    : Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
