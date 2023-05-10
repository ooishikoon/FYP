import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../model/uploaded_image.dart';
import '../model/user.dart';

User user = User();

class FileRecognizeImagePage extends StatefulWidget {
  final User user;
  final String? path;

  const FileRecognizeImagePage(
      {Key? key, required this.path, required this.user})
      : super(key: key);

  @override
  State<FileRecognizeImagePage> createState() => _FileRecognizeImagePageState();
}

class _FileRecognizeImagePageState extends State<FileRecognizeImagePage> {
  List<UploadedImage> fileList = <UploadedImage>[];
  FlutterTts flutterTts = FlutterTts();
  final TextEditingController fileName = TextEditingController();

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

  bool _isBusy = false;

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   final File file = File(widget.path!);
    //   if (file.existsSync()) {
    //     final InputImage inputImage = InputImage.fromFile(file);
    //     processImage(inputImage);
    //   } else {
    //     debugPrint('File does not exist at path: ${widget.path}');
    //   }
    // });

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final File file = File(widget.path!);
      if (file.existsSync()) {
        // Check the file format before attempting recognition
        if (file.path.endsWith('.jpg') || file.path.endsWith('.png')) {
          final InputImage inputImage = InputImage.fromFile(file);
          processImage(inputImage);
        } else {
          debugPrint('File format not supported: ${file.path}');
        }
      } else {
        debugPrint('File does not exist at path: ${widget.path}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Read Image"),
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
                  if (controller.text.isNotEmpty) {
                    speak(text: controller.text.trim());
                  }
                },
                icon: const Icon(
                  Icons.mic,
                  size: 28,
                ))
          ],
        ),
        body: _isBusy == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  maxLines: MediaQuery.of(context).size.height.toInt(),
                  controller: controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    // label: Text("Text to read...")
                  ),
                ),
              ));
  }

  void processImage(InputImage image) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    setState(() {
      _isBusy = true;
    });

    final RecognizedText recognizedText =
        await textRecognizer.processImage(image);

    controller.text = recognizedText.text;

    ///End busy state
    setState(() {
      _isBusy = false;
    });
  }
}
