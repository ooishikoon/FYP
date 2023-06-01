import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constants.dart';
import '../verify_otp/verifyregistrationscreen.dart';
import 'loginscreen.dart';
import 'package:ndialog/ndialog.dart';
import 'package:http/http.dart' as http;

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  FlutterTts flutterTts = FlutterTts();

  String text =
      "Registration screen. Create Account. Email text field. Password text field. Re-enter password text field. Register button.";
      
  bool _passwordVisible = true;

  late double screenHeight, screenWidth, resWidth;

  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }

    return SafeArea(
        child: Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/register_page.png'),
                fit: BoxFit.fill),
          )),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 35, 20, 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.keyboard_arrow_left,
                        size: 35,
                      ),
                      onPressed: () {
                        stop();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (content) => const LoginScreen()));
                      },
                    ),
                    const Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                        onPressed: () => speakIntro(text),
                        icon: const Icon(
                          Icons.headphones,
                          size: 35,
                          color: Colors.black,
                        )),
                  ],
                ),
              ),
            ],
          ),
          Form(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 30,
                              ),
                              Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 235, 231, 231)),
                                    color: const Color.fromARGB(
                                        255, 235, 231, 231),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                        textInputAction: TextInputAction.next,
                                        validator: (val) => val!.isEmpty ||
                                                !val.contains("@") ||
                                                !val.contains(".")
                                            ? "Please enter a valid email"
                                            : null,
                                        focusNode: focus,
                                        onFieldSubmitted: (v) {
                                          FocusScope.of(context)
                                              .requestFocus(focus1);
                                        },
                                        controller: _emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: const InputDecoration(
                                            labelText: 'Email',
                                            labelStyle: TextStyle(),
                                            icon: Icon(Icons.local_phone),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(width: 0.5),
                                            )),
                                      ),
                                      TextFormField(
                                        textInputAction: TextInputAction.done,
                                        validator: (val) =>
                                            validatePassword(val.toString()),
                                        focusNode: focus1,
                                        onFieldSubmitted: (v) {
                                          FocusScope.of(context)
                                              .requestFocus(focus2);
                                        },
                                        controller: _passwordController,
                                        obscureText: _passwordVisible,
                                        decoration: InputDecoration(
                                            labelStyle: const TextStyle(),
                                            labelText: 'Password',
                                            icon: const Icon(Icons.lock),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _passwordVisible
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _passwordVisible =
                                                      !_passwordVisible;
                                                });
                                              },
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(width: 0.5),
                                            )),
                                      ),
                                      TextFormField(
                                        style: const TextStyle(),
                                        textInputAction: TextInputAction.done,
                                        validator: (val) {
                                          validatePassword(val.toString());
                                          if (val != _passwordController.text) {
                                            return "Password do not match";
                                          }
                                          if (val!.isEmpty) {
                                            return "Please enter the password";
                                          } else {
                                            return null;
                                          }
                                        },
                                        focusNode: focus2,
                                        onFieldSubmitted: (v) {
                                          FocusScope.of(context)
                                              .requestFocus(focus3);
                                        },
                                        controller: _password2Controller,
                                        obscureText: _passwordVisible,
                                        decoration: InputDecoration(
                                            labelText: 'Re-enter Password',
                                            labelStyle: const TextStyle(),
                                            icon: const Icon(Icons.lock),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _passwordVisible
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _passwordVisible =
                                                      !_passwordVisible;
                                                });
                                              },
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(width: 0.5),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    icon: const Icon(
                                      Icons.app_registration,
                                      size: 20.0,
                                    ),
                                    label: const Text('Register'),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                      minimumSize: const Size(100, 40),
                                    ),
                                    onPressed: () {
                                      stop();
                                      _registerAccountDialog();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  
    speakIntro(String intro) async {
    if (intro != null && intro.isNotEmpty) {
      await flutterTts.setLanguage('en-US');
      await flutterTts.setPitch(1); // 0.5 to 1.5
      await flutterTts.speak(intro);
    }
  }

  stop() async {
    await flutterTts.stop();
  }

  String? validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter the password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Password must have 6 characters that contain A-Z, a-z and numbers.';
      } else {
        return null;
      }
    }
  }

  void _registerAccountDialog() {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please fill in all the fields.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Register new account?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _verifyUserEmail();
              },
            ),
            TextButton(
              child: const Text(
                "No",
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

  void _verifyUserEmail() {
    FocusScope.of(context).requestFocus(FocusNode());
    String _email = _emailController.text;
    String _password = _passwordController.text;
    FocusScope.of(context).unfocus();
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Verify in progress..."),
        title: const Text("Verifying"));
    progressDialog.show();

    http.post(
        Uri.parse(
            CONSTANTS.server + "/fyp_ttw/php/verify_register_user_email.php"),
        body: {
          "email": _email,
          "password": _password,
        }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'failed') {
        Fluttertoast.showToast(
            msg: "The email had registered before",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 20.0,
            textColor: Colors.white,
            backgroundColor: Colors.amber);
        progressDialog.dismiss();
        return;
      } else if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "The email registered successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 20.0,
            textColor: Colors.white,
            backgroundColor: Colors.amber);
        progressDialog.dismiss();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => VerifyUserEmailScreen(
                      emailController: _emailController.text,
                      passwordController: _passwordController.text,
                    )));
        return;
      }
    });
  }
}
