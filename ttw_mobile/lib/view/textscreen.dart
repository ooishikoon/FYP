import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  void clearText() {
    textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            buildBackground(),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 20, 0),
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildReturnButton(),
                      buildSpeechButton(),
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

  Widget buildSpeechButton() => const IconButton(
        icon: Icon(
          Icons.headphones,
          size: 35,
          color: Colors.black,
        ),
        onPressed: null,
      );

  Widget buildContext() => Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Enter your text here',
                    alignLabelWithHint: true,
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 220),
                        child: Icon(Icons.description)),
                    suffixIcon: IconButton(
                      padding: const EdgeInsets.only(bottom: 220),
                      icon: const Icon(Icons.clear), // clear text
                      onPressed: clearText,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                minLines: 12,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: textEditingController,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () => speak(textEditingController.text),
                  style: ElevatedButton.styleFrom(
                      side: const BorderSide(
                          width: 3,
                          color: Colors.amber), //border width and color
                      elevation: 5, //elevation of button
                      shape: RoundedRectangleBorder(
                          //to set border radius to button
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.all(
                          20) //content padding inside button
                      ),
                  child: const Text("Convert"))
            ],
          ),
        ),
      );

  speak(String text) async {
    if (text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please enter some text.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      flutterTts.speak("Please enter some text");
      return;
    } else {
      await flutterTts.setLanguage('en-US');
      await flutterTts.setPitch(1); // 0.5 to 1.5
      await flutterTts.speak(text);
    }
  }
}
