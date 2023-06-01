import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../login_register/loginscreen.dart';
import '../login_register/registrationscreen.dart';
import '../model/user.dart';
import '../utils/in_app_tour.dart';
import 'dictionaryscreen.dart';
import 'filescreen.dart';
import 'infoscreen.dart';
import 'profilescreen.dart';
import 'textscreen.dart';
import 'uploadscreen.dart';

User user = User();

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late double screenHeight, screenWidth, resWidth;

  final GlobalKey textKey = GlobalKey();
  final GlobalKey uploadKey = GlobalKey();
  final GlobalKey bookrackKey = GlobalKey();
  final GlobalKey dictionaryKey = GlobalKey();
  final GlobalKey tourKey = GlobalKey();
  final GlobalKey profileKey = GlobalKey();

  late TutorialCoachMark tutorialCoachMark;

  bool isSaved = false;

  //Guide Tour Button
  void _initMainInAppTour() {
    tutorialCoachMark = TutorialCoachMark(
        targets: mainTargetsPage(
          textKey: textKey,
          uploadKey: uploadKey,
          bookrackKey: bookrackKey,
          dictionaryKey: dictionaryKey,
          tourKey: tourKey,
          profileKey: profileKey,
        ),
        colorShadow: Colors.amber,
        paddingFocus: 10,
        hideSkip: false,
        opacityShadow: 0.8,
        onFinish: () {
          print("Completed");
        });
  }

  void _showInAppTour() {
    Future.delayed(const Duration(seconds: 2), () {
      tutorialCoachMark.show(context: context);
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
      body: Stack(alignment: Alignment.center, children: [
        Container(
            decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/main_page.png'),
              fit: BoxFit.fill),
        )),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 25, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                      height: 45,
                      child: GestureDetector(
                        onTap: () => {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (content) => InfoScreen(
                                        user: widget.user,
                                      )))
                        },
                        child: const SizedBox(
                          child: ClipRRect(
                            child: Image(
                              image: AssetImage('assets/images/info_icon.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: (1 / 1),
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  children: [
                    InkWell(
                      key: textKey,
                      splashColor: Colors.amber,
                      onTap: () => {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => TextScreen(
                                      user: widget.user,
                                    )))
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shadowColor: Colors.amber,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 247, 242, 199),
                                Color.fromARGB(255, 243, 204, 86),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 90,
                                child: ClipRRect(
                                  child: Image(
                                    image: AssetImage(
                                        'assets/images/text_editor.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Text(
                                "Text",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      key: uploadKey,
                      splashColor: Colors.amber,
                      onTap: () => {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => UploadScreen(
                                      user: widget.user,
                                    )))
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shadowColor: Colors.amber,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 247, 242, 199),
                                Color.fromARGB(255, 243, 204, 86),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 90,
                                child: ClipRRect(
                                  // borderRadius: BorderRadius.circular(200),
                                  child: Image(
                                    image: AssetImage(
                                        'assets/images/upload_icon.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Text(
                                "Upload",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      key: bookrackKey,
                      splashColor: Colors.amber,
                      onTap: () async {
                        if (widget.user.email == "guest@ttw.com") {
                          _loadOptions();
                        } else {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (content) => ImageFileScreen(
                                        user: widget.user,
                                      )));
                        }
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shadowColor: Colors.amber,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 247, 242, 199),
                                Color.fromARGB(255, 243, 204, 86),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 90,
                                child: ClipRRect(
                                  child: Image(
                                    image: AssetImage(
                                        'assets/images/books_learn_library_school_icon.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Text(
                                "Book Rack",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      key: dictionaryKey,
                      splashColor: Colors.amber,
                      onTap: () => {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    DictionaryScreen(
                                      user: widget.user,
                                    )))
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shadowColor: Colors.amber,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 247, 242, 199),
                                Color.fromARGB(255, 243, 204, 86),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 90,
                                child: ClipRRect(
                                  // borderRadius: BorderRadius.circular(200),
                                  child: Image(
                                    image: AssetImage(
                                        'assets/images/dictionary_icon.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Text(
                                "Dictionary",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      key: tourKey,
                      splashColor: Colors.amber,
                      onTap: () => {
                        _initMainInAppTour(),
                        _showInAppTour(),
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shadowColor: Colors.amber,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 247, 242, 199),
                                Color.fromARGB(255, 243, 204, 86),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 90,
                                child: ClipRRect(
                                  // borderRadius: BorderRadius.circular(200),
                                  child: Image(
                                    image: AssetImage(
                                        'assets/images/guide_tour.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Text(
                                "Tutorial",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      key: profileKey,
                      splashColor: Colors.amber,
                      onTap: () async {
                        if (widget.user.email == "guest@ttw.com") {
                          _loadOptions();
                        } else {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (content) => ProfileScreen(
                                        user: widget.user,
                                      )));
                        }
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shadowColor: Colors.amber,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 247, 242, 199),
                                Color.fromARGB(255, 243, 204, 86),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 90,
                                child: ClipRRect(
                                  // borderRadius: BorderRadius.circular(200),
                                  child: Image(
                                    image: AssetImage(
                                        'assets/images/user_icon.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Text(
                                "Profile",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
            )),
          ],
        ),
      ]),
    );
  }

  _loadOptions() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Please login first to access.",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: _onLogin,
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      minimumSize: const Size(100, 40),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    )),
                ElevatedButton(
                    onPressed: _onRegister,
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      minimumSize: const Size(100, 40),
                    ),
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    )),
              ],
            ),
          );
        });
  }

  void _onLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => LoginScreen()));
  }

  void _onRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const RegistrationScreen()));
  }
}
