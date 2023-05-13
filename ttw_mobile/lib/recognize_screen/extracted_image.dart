import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../model/uploaded_image.dart';
import '../model/user.dart';

class ExtractedImageTextScreen extends StatefulWidget {
  final User user;
  String imageText;
  String imageName;

  ExtractedImageTextScreen({
    Key? key,
    required this.user,
    required this.imageText,
    required this.imageName,
  }) : super(key: key);

  @override
  State<ExtractedImageTextScreen> createState() => _ExtractedImageTextScreenState();
}

class _ExtractedImageTextScreenState extends State<ExtractedImageTextScreen> {
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
        title: Text(widget.imageName),
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
                speak(text: widget.imageText);
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
                child: (widget.imageText) != null
                    ? Text(
                        widget.imageText,
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
