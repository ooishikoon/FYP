import 'package:flutter/material.dart';
import '../model/user.dart';
import 'mainscreen.dart';

User user = User();

class IntroductionScreen extends StatefulWidget {
  final User user;
  const IntroductionScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  late double screenHeight, screenWidth, resWidth;

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
      body: Stack(alignment: Alignment.center, children: [
        Container(
            decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/introduction_page.png'),
              fit: BoxFit.fill),
        )),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const <Widget>[
                  IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.headphones,
                        size: 35,
                        color: Colors.black,
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 150,
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
        ),
        Column(
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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (content) => MainScreen(
                                    user: user,
                                  )));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
