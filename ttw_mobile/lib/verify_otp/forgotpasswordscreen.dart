import 'dart:convert';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../login_register/loginscreen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late double screenHeight, screenWidth, resWidth;

  FlutterTts flutterTts = FlutterTts();

  String intro =
      "Verify Forgot Password Screen. Email Authentication. Email text field. Send OTP button. OTP text field.";

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController verificationCode = TextEditingController();

  final TextEditingController _pass1editingController = TextEditingController();
  final TextEditingController _pass2editingController = TextEditingController();

  bool passwordVisible = true;

  void clearTextPassword1() {
    _pass1editingController.clear();
  }

  void clearTextPassword2() {
    _pass2editingController.clear();
  }

  void clearText() {
    verificationCode.clear();
  }

  void clearTextEmail() {
    _emailController.clear();
  }

  EmailOTP myauth = EmailOTP();

  void sendOtp() async {
    myauth.setConfig(
        appEmail: "ttw@moneymoney12345.com",
        appName: "Tell the World",
        userEmail: _emailController.text,
        otpLength: 6,
        otpType: OTPType.digitsOnly);
    if (await myauth.sendOTP() == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("OTP has been sent"),
      ));
      print("OTP sent successful!");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Oops, OTP send failed"),
      ));
      print("OTP sent unsuccessful!");
    }
  }

  void verifyOtp() async {
    if (await myauth.verifyOTP(otp: verificationCode.toString()) == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "OTP is verified",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Invalid OTP",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ));
      print("Invalid OTP");
    }
  }

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
            padding: const EdgeInsets.fromLTRB(10, 35, 10, 0),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildReturnButton(),
                    buildTitle(),
                    buildSpeechButton(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 30, 0, 30),
                  child: buildContext(),
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
                    image: AssetImage('assets/images/forgotPassword_page.png'),
                    fit: BoxFit.cover))),
      );

  Widget buildTitle() => const Text(
        "Verification",
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      );

  Widget buildReturnButton() => IconButton(
      icon: const Icon(
        Icons.keyboard_arrow_left,
        size: 35,
      ),
      onPressed: () {
        stop();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (content) => LoginScreen()));
      });

  Widget buildSpeechButton() => IconButton(
        icon: Icon(
          Icons.headphones,
          size: 32,
          color: Colors.black,
        ),
        onPressed: () => speakIntro(intro),
      );

  Widget buildContext() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Email Authentication",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'Email',
              icon: const Icon(Icons.email),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
              suffixIcon: SizedBox(
                width: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          sendOtp();
                          stop();
                        },
                        child: const Text(
                          "Send OTP",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        )),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        clearTextEmail();
                      },
                    ),
                  ],
                ),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid email';
              }
              bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value);

              if (!emailValid) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              const Icon(
                Icons.lock,
                size: 25,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 30,
              ),
              OtpTextField(
                numberOfFields: 6,
                borderColor: const Color(0xFF6A53A1),
                focusedBorderColor: const Color.fromARGB(255, 255, 191, 0),
                textStyle: const TextStyle(fontSize: 30),
                showFieldAsBox: false,
                borderWidth: 4.0,
                clearText: true,
                //runs when a code is typed in
                onCodeChanged: (String code) {
                  //handle validation or checks here if necessary
                  if (code.length == 1) {
                    FocusScope.of(context).nextFocus();
                  }
                },
                //runs when every textfield is filled
                onSubmit: (String verificationCode) async {
                  if (await myauth.verifyOTP(
                          otp: verificationCode.toString()) ==
                      true) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        "OTP is verified",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ));
                    _updatePasswordDialog();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        "Invalid OTP",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ));
                    clearText();
                    print("Invalid OTP");
                  }
                },
              ),
            ],
          ),
        ],
      );

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
            width: screenWidth / 2,
            child: Column(
              children: [
                TextField(
                    controller: _pass1editingController,
                    keyboardType: TextInputType.text,
                    obscureText: passwordVisible,
                    decoration: InputDecoration(
                      labelText: 'New password',
                      labelStyle: const TextStyle(),
                      icon: const Icon(
                        Icons.password,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0),
                      ),
                      suffixIcon: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(passwordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(
                                  () {
                                    passwordVisible = !passwordVisible;
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                clearTextPassword1();
                              },
                            ),
                          ],
                        ),
                      ),
                    )),
                TextField(
                    controller: _pass2editingController,
                    keyboardType: TextInputType.text,
                    obscureText: passwordVisible,
                    decoration: InputDecoration(
                      labelText: 'Renter password',
                      labelStyle: const TextStyle(),
                      icon: const Icon(
                        Icons.password,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0),
                      ),
                      suffixIcon: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(passwordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(
                                  () {
                                    passwordVisible = !passwordVisible;
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                clearTextPassword2();
                              },
                            ),
                          ],
                        ),
                      ),
                    )),
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
                      fontSize: 18.0);
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
                      fontSize: 18.0);
                  return;
                }
                ProgressDialog progressDialog = ProgressDialog(context,
                    message: const Text("Update password in progress.."),
                    title: const Text("Updating..."));
                progressDialog.show();
                Navigator.of(context).pop();
                http.post(
                    Uri.parse(
                        CONSTANTS.server + "/fyp_ttw/php/update_profile.php"),
                    body: {
                      "password": _pass1editingController.text,
                      "email": _emailController.text
                    }).then((response) {
                  var data = jsonDecode(response.body);
                  if (response.statusCode == 200 &&
                      data['status'] == 'success') {
                    Fluttertoast.showToast(
                        msg: "Success",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.white,
                        backgroundColor: Colors.amber,
                        fontSize: 18.0);
                    progressDialog.dismiss();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => LoginScreen()));
                    return;
                  } else {
                    Fluttertoast.showToast(
                        msg: "Failed",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.white,
                        backgroundColor: Colors.amber,
                        fontSize: 18.0);
                    progressDialog.dismiss();
                    return;
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
}
