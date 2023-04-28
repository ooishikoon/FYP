import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:ttw_mobile/view/uploadscreen.dart';

import '../model/user.dart';

User user = User();

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RecognizePdfScreen(
        user: user,
      ),
    );
  }
}

class RecognizePdfScreen extends StatefulWidget {
  final User user;
  const RecognizePdfScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<RecognizePdfScreen> createState() => _RecognizePdfScreenState();
}

class _RecognizePdfScreenState extends State<RecognizePdfScreen> {
  TextEditingController controller = TextEditingController();

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

  Future<String> pickDocument() async {
    //Picked Image For Products

    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowCompression: true);

    if (result != null) {
      final String? files = result.files.single.path;
      return files!;
    } else {
      // User canceled the picker
      print("File Picked canceled");
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (content) => UploadScreen(
                          user: user,
                        )));
          },
        ),
        title: const Text("Read PDF"),
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
      body: Container(
        padding: const EdgeInsets.all(20),
        child: TextFormField(
          controller: controller,
          maxLines: MediaQuery.of(context).size.height.toInt(),
          decoration: const InputDecoration(
            border: InputBorder.none,
            // label: Text("Text to read...")
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          pickDocument().then((value) async {
            debugPrint(value);
            if (value != '') {
              PDFDoc doc = await PDFDoc.fromPath(value);

              final text = await doc.text;

              controller.text = text;
            } else {
              controller.text = "No PDF selected.";
            }
          });
        },
        label: const Icon(Icons.attach_file),
      ),
    );
  }
}
