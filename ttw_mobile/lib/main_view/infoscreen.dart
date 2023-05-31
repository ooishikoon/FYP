import 'dart:async';
import 'package:flutter/material.dart';
import 'mainscreen.dart';
import '../model/user.dart';
import 'package:flutter_tts/flutter_tts.dart';

User user = User();

class InfoScreen extends StatefulWidget {
  final User user;
  const InfoScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  late double screenHeight, screenWidth, resWidth;
  late Timer timerSkip, timerSpeak;

  //FlutterTts instance
  late FlutterTts flutterTts;

  //Variable for text to be spoken
  String textToBeSpoken =
      'Tell the World is a text to speech mobile application to provide the user a listening tool that aims to assist the visually impaired to read the content by converting the text into speech. Tell the World helps them to read the content via listening by importing documents and dictionaries to check meaning while reading.';

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    //Initialize the FlutterTts instance
    flutterTts = FlutterTts();

    timerSpeak =
        Timer(const Duration(seconds: 0), () => _speak(textToBeSpoken));

    timerSkip = Timer(
        const Duration(seconds: 20),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (content) => MainScreen(
                      user: widget.user,
                    ))));
  }

  @override
  void dispose() {
    timerSkip.cancel();
    timerSpeak.cancel();
    super.dispose();
  }

  initializeTts() {
    flutterTts = FlutterTts();

    flutterTts.setStartHandler(() {
      setState(() {
        isPlaying = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });
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
          buildContext(),
          GestureDetector(
            onTap: () {
              _stop();
            },
          ),
          buildSkipButton(),
        ],
      ),
    );
  }

  Widget buildBackground() => ClipRRect(
        child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/introduction_page.png'),
                    fit: BoxFit.cover))),
      );

  Widget buildContext() => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 20, 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
            ),
          ),
          SizedBox(
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: const Image(
                image: AssetImage('assets/images/logo.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Padding(
                padding: EdgeInsets.fromLTRB(40, 20, 40, 30),
                child: Text(
                  "\t\t\t\t\tTell the World is a text to speech mobile application to provide the user a listening tool that aims to assist the visually impaired to read the content by converting the text into speech."
                  "\n\n\t\t\t\t\tTell the World helps them to read the content via listening by importing documents and dictionaries to check meaning while reading.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      );

  Widget buildSkipButton() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 20, 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.skip_next,
                    size: 20.0,
                  ),
                  label: const Text('Skip'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    minimumSize: const Size(100, 40),
                  ),
                  onPressed: () {
                    timerSkip.cancel();
                    timerSpeak.cancel();
                    _stop();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (content) => MainScreen(
                                  user: widget.user,
                                )));
                  },
                ),
              ],
            ),
          ),
        ],
      );

  Future _speak(String textToBeSpoken) async {
    if (textToBeSpoken != null && textToBeSpoken.isNotEmpty) {
      var result = await flutterTts.speak(textToBeSpoken);
      if (result == 1) {
        setState(() {
          isPlaying = true;
        });
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) {
      setState(() {
        isPlaying = false;
      });
    }
  }
}
