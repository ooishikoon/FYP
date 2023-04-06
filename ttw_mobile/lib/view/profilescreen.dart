import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../main.dart';
import '../model/user.dart';
import 'mainscreen.dart';
import 'package:http/http.dart' as http;

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
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 20, 0),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildReturnButton(),
                    buildTitle(),
                    buildSpeech(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 40, 0, 40),
                  child: buildProfile(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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

  Widget buildTitle() => const Text(
        "Profile",
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      );

  Widget buildSpeech() => const IconButton(
        icon: Icon(
          Icons.headphones,
          size: 32,
          color: Colors.black,
        ),
        onPressed: null,
      );

  Widget buildProfile() => Column(
        children: [
          SizedBox(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
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
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.email.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          Expanded(
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
                child: ListView(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    shrinkWrap: true,
                    children: [
                      MaterialButton(
                        onPressed: () => {_updatePasswordDialog()},
                        child: const Text(
                          "Change Password",
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ),
                      const Divider(
                        height: 25,
                      ),
                      MaterialButton(
                        onPressed: () => {null},
                        child: const Text(
                          "Delete Account",
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ),
                      const Divider(
                        height: 15,
                      ),
                      MaterialButton(
                        onPressed: () => {null},
                        child: const Text(
                          "Setting",
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ),
                      const Divider(
                        height: 15,
                      ),
                      MaterialButton(
                        onPressed: () => {_logoutDialog()},
                        child: const Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ),
                      const Divider(
                        height: 15,
                      ),
                    ])),
          ))
        ],
      );

  void _updatePasswordDialog() {
    TextEditingController _pass1editingController = TextEditingController();
    TextEditingController _pass2editingController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Update Password",
            style: TextStyle(),
          ),
          content: SizedBox(
            height: screenHeight / 5,
            child: Column(
              children: [
                TextField(
                    controller: _pass1editingController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: 'New password',
                        labelStyle: TextStyle(),
                        icon: Icon(
                          Icons.password,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                        ))),
                TextField(
                    controller: _pass2editingController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: 'Renter password',
                        labelStyle: TextStyle(),
                        icon: Icon(
                          Icons.password,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                        ))),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Confirm",
                style: TextStyle(),
              ),
              onPressed: () {
                if (_pass1editingController.text !=
                    _pass2editingController.text) {
                  Fluttertoast.showToast(
                      msg: "Passwords are not the same",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.red,
                      fontSize: 14.0);
                  return;
                }
                if (_pass1editingController.text.isEmpty ||
                    _pass2editingController.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Please fill in passwords",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.red,
                      fontSize: 14.0);
                  return;
                }
                Navigator.of(context).pop();
                http.post(
                    Uri.parse(
                        CONSTANTS.server + "/fyp_ttw/php/update_profile.php"),
                    body: {
                      "password": _pass1editingController.text,
                      "email": widget.user.email
                    }).then((response) {
                  var data = jsonDecode(response.body);
                  if (response.statusCode == 200 &&
                      data['status'] == 'success') {
                    Fluttertoast.showToast(
                        msg: "Success",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.green,
                        fontSize: 14.0);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Failed",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.red,
                        fontSize: 14.0);
                  }
                });
              },
            ),
            TextButton(
              child: const Text(
                "Cancel",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _logoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Logout",
            style: TextStyle(),
          ),
          content: const Text("Are your sure?"),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(fontSize: 17,),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => const MyApp(
                            )));
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(fontSize: 17,),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
