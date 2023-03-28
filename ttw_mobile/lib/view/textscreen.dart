import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../model/user.dart';
import 'mainscreen.dart';

User user = User();

class TextScreen extends StatefulWidget {
  final User user;

  const TextScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<TextScreen> createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {
  late double screenHeight, screenWidth, resWidth;

  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            buildBackground(),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 20, 0),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildReturnButton(),
                      buildSpeech(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 0, 30),
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
                    image: AssetImage('assets/images/text_page.png'),
                    fit: BoxFit.cover))),
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
                      user: user,
                    )));
      });

  Widget buildSpeech() => const IconButton(
        icon: Icon(
          Icons.headphones,
          size: 35,
          color: Colors.black,
        ),
        onPressed: null,
      );

  Widget buildContext() => Container(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: textEditingController,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () => speak(textEditingController.text),
                child: const Text("Start Text To Speech"),
              )
            ],
          ),
        ),
      );

  speak(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1); // 0.5 to 1.5
    await flutterTts.speak(text);
  }
}
