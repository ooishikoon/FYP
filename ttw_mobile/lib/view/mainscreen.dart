import 'package:flutter/material.dart';
import '../model/user.dart';
import 'loginscreen.dart';
import 'profilescreen.dart';

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
              padding: const EdgeInsets.fromLTRB(10, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.keyboard_arrow_left,
                      size: 35,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (content) => const LoginScreen()));
                    },
                  ),
                  const IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.headphones,
                        size: 35,
                        color: Colors.black,
                      )),
                ],
              ),
            ),
            // Column(
            //   children: [
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: const [
            //         Text(
            //           "Tell the World",
            //           style:
            //               TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
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
                      splashColor: Colors.amber,
                      onTap: () => {},
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Icon(
                                Icons.text_format,
                                size: 50,
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
                      splashColor: Colors.amber,
                      onTap: () => {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const LoginScreen()))
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Icon(
                                Icons.file_copy,
                                size: 50,
                              ),
                              Text(
                                "Files",
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
                      splashColor: Colors.amber,
                      onTap: () => {},
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Icon(
                                Icons.library_books,
                                size: 50,
                              ),
                              Text(
                                "Book Rak",
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
                      splashColor: Colors.amber,
                      onTap: () => {},
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Icon(
                                Icons.book,
                                size: 50,
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
                      splashColor: Colors.amber,
                      onTap: () => {},
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Icon(
                                Icons.settings,
                                size: 50,
                              ),
                              Text(
                                "Setting",
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
                      splashColor: Colors.amber,
                      onTap: () => {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ProfileScreen(
                                      user: user,
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Icon(
                                Icons.person,
                                size: 50,
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
}
