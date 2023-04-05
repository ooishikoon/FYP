import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../model/user.dart';
import 'mainscreen.dart';

User user = User();

class UploadScreen extends StatefulWidget {
  final User user;

  const UploadScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  late double screenHeight, screenWidth, resWidth;

  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController textEditingController = TextEditingController();

  void clearText() {
    textEditingController.clear();
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
                    padding: const EdgeInsets.fromLTRB(10, 30, 0, 30),
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
                    image: AssetImage('assets/images/upload_page.png'),
                    fit: BoxFit.cover))),
      );

  Widget buildTitle() => const Text(
        "Upload",
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
                builder: (content) => MainScreen(
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

  Widget buildContext() => ListView(
          padding: const EdgeInsets.fromLTRB(0, 40, 10, 0),
          shrinkWrap: true,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.file_copy,
                        size: 35,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Upload file",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_right,
                  size: 35,
                ),
              ],
            ),
            const Divider(
              height: 20,
              color: Colors.black,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.image,
                        size: 35,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Upload image",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_right,
                  size: 35,
                ),
              ],
            ),
            const Divider(
              height: 20,
              color: Colors.black,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.text_fields,
                        size: 35,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Upload Text",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_right,
                  size: 35,
                ),
              ],
            ),
            const Divider(
              height: 20,
              color: Colors.black,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.document_scanner,
                        size: 35,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Scan",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_right,
                  size: 35,
                ),
              ],
            ),
            const Divider(
              height: 20,
              color: Colors.black,
            ),
          ]);
}
