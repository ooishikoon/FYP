import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ttw_mobile/view/uploadscreen.dart';

import '../model/user.dart';

User user = User();

class PdfScreen extends StatefulWidget {
  final User user;

  const PdfScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  late double screenHeight, screenWidth, resWidth;

  String? _filePath;

  Future<void> _openFileExplorer() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    }
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
              child: buildContext(),
            ),
          ],
        ),
      );

  Widget buildBackground() => ClipRRect(
        child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/upload_page.png'),
                    fit: BoxFit.cover))),
      );

  Widget buildTitle() => const Text(
        "PDF Viewer",
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      );

  Widget buildReturnButton() => IconButton(
      icon: const Icon(
        Icons.keyboard_arrow_left,
        size: 35,
      ),
      onPressed: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (content) => UploadScreen(
                      user: widget.user,
                    )));
      });

  Widget buildSpeechButton() => const IconButton(
        icon: Icon(
          Icons.headphones,
          size: 32,
          color: Colors.black,
        ),
        onPressed: null,
      );

  Widget buildContext() => Scaffold(
        body: Container(
          color: Colors.yellow.withOpacity(
              0.1),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_filePath != null)
                  Expanded(
                    child: PdfView(
                      path: _filePath!,
                    ),
                  )
                else
                  const Text('No PDF selected.'),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _openFileExplorer,
          tooltip: 'Choose PDF',
          child: const Icon(Icons.attach_file),
        ),
      );
}
