import 'package:flutter/material.dart';
import '../constants.dart';
import '../model/user.dart';
import 'mainscreen.dart';

User user = User();

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late double screenHeight, screenWidth, resWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  // Widget build(BuildContext context) {
  //   screenHeight = MediaQuery.of(context).size.height;
  //   screenWidth = MediaQuery.of(context).size.width;
  //   if (screenWidth <= 600) {
  //     resWidth = screenWidth;
  //   } else {
  //     resWidth = screenWidth * 0.75;
  //   }

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
                    child: buildProfile(),
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
                    image: AssetImage('assets/images/profile_page.png'),
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
                      user: widget.user,
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

  Widget buildProfile() => Column(
        children: [
          SizedBox(
            // child: Card(
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GestureDetector(
                      onTap: () => {},
                      child: SizedBox(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: Image.asset('assets/images/profile.jpg')),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user.email.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 245, 240, 192),
                      Color.fromARGB(255, 245, 243, 240)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        child: SizedBox.fromSize(
                      size: const Size(45, 45),
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(Icons.emoji_people_outlined),
                            Text("Following"),
                          ],
                        ),
                      ),
                    )),
                    Expanded(
                        child: SizedBox.fromSize(
                      size: const Size(45, 45),
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(Icons.people_alt_outlined),
                            Text("Follower"),
                          ],
                        ),
                      ),
                    )),
                    Expanded(
                        child: SizedBox.fromSize(
                      size: const Size(45, 45),
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(Icons.message_outlined),
                            Text("Message"),
                          ],
                        ),
                      ),
                    )),
                    Expanded(
                        child: SizedBox.fromSize(
                      size: const Size(45, 45),
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(Icons.notification_important_outlined),
                            Text("Notifications"),
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            flex: 5,
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 245, 240, 192),
                      Color.fromARGB(255, 245, 243, 240)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Column(
                    children: [
                      Expanded(
                          child: GridView.count(
                        // 12 items
                        crossAxisCount: 4,
                        childAspectRatio: 1,
                        // 9 items
                        // crossAxisCount: 3,
                        // childAspectRatio: 1.5,
                        children: <Widget>[
                          SizedBox.fromSize(
                            size: const Size(45, 45),
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Icon(
                                    Icons.file_copy,
                                  ),
                                  Text("Files"),
                                ],
                              ),
                            ),
                          ),
                          SizedBox.fromSize(
                            size: const Size(45, 45),
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Icon(
                                    Icons.book,
                                  ),
                                  Text("Dictionary"),
                                ],
                              ),
                            ),
                          ),
                          SizedBox.fromSize(
                            size: const Size(45, 45),
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Icon(Icons.bookmark_outline),
                                  Text("Bookmark"),
                                ],
                              ),
                            ),
                          ),
                          SizedBox.fromSize(
                            size: const Size(45, 45),
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Icon(Icons.history_outlined),
                                  Text("History"),
                                ],
                              ),
                            ),
                          ),
                          SizedBox.fromSize(
                            size: const Size(45, 45),
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Icon(
                                    Icons.settings,
                                  ),
                                  Text("Setting"),
                                ],
                              ),
                            ),
                          ),
                          SizedBox.fromSize(
                            size: const Size(45, 45),
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Icon(Icons.task_outlined),
                                  Text("Task"),
                                ],
                              ),
                            ),
                          ),
                          SizedBox.fromSize(
                            size: const Size(45, 45),
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Icon(Icons.mode),
                                  Text("Theme"),
                                ],
                              ),
                            ),
                          ),
                          SizedBox.fromSize(
                            size: const Size(45, 45),
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Icon(Icons.person),
                                  Text("Update Info"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      );
}
