import 'package:flutter/material.dart';
import '../model/user.dart';
import 'mainscreen.dart';

User user = User();

class DictionaryScreen extends StatefulWidget {
  final User user;
  const DictionaryScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  late double screenHeight, screenWidth, resWidth;

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
                      buildSpeechButton(),
                    ],
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
                    image: AssetImage('assets/images/dictionary_page.png'),
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
}
