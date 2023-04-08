import 'dart:convert';

import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:ttw_mobile/view/registrationscreen.dart';
import '../constants.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import 'loginscreen.dart';
import 'profilescreen.dart';

class VerifyUserEmailScreen extends StatefulWidget {
  final String emailController;
  final String passwordController;

  const VerifyUserEmailScreen({
    Key? key,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  @override
  State<VerifyUserEmailScreen> createState() => _VerifyUserEmailScreenState();
}

class _VerifyUserEmailScreenState extends State<VerifyUserEmailScreen> {
  late double screenHeight, screenWidth, resWidth;

  final TextEditingController verificationCode = TextEditingController();

  void clearText() {
    verificationCode.clear();
  }

  EmailOTP myauth = EmailOTP();

  void sendOtp() async {
    myauth.setConfig(
        appEmail: "ttw@moneymoney12345.com",
        appName: "Tell the World",
        userEmail: widget.emailController,
        otpLength: 6,
        otpType: OTPType.digitsOnly);
    if (await myauth.sendOTP() == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "OTP has been sent",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ));
      print("OTP sent successful!");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Oops, OTP send failed",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ));
      print("OTP sent unsuccessful!");
    }
  }

  @override
  void initState() {
    super.initState();

    sendOtp();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            buildBackground(),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
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

  Widget buildBackground() => ClipRRect(
        child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/deleteAccount_page.png'),
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
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (content) => const RegistrationScreen()));
      });

  Widget buildSpeechButton() => const IconButton(
        icon: Icon(
          Icons.headphones,
          size: 32,
          color: Colors.black,
        ),
        onPressed: null,
      );

  Widget buildContext() => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
            child: Column(
              children: [
                Text(
                  "Enter the verification code sent to \n" +
                      widget.emailController.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                OtpTextField(
                  numberOfFields: 6,
                  borderColor: const Color(0xFF6A53A1),
                  focusedBorderColor: Color.fromARGB(255, 255, 191, 0),
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
                      _registerUserAccount();
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
                      clearText();
                    }
                  },
                ),
                const SizedBox(
                  height: 35,
                ),
                TextButton(
                  onPressed: () {
                    sendOtp();
                  },
                  child: const Text(
                    "Didn't get the code?",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ],
      );

  void _registerUserAccount() {
    FocusScope.of(context).requestFocus(FocusNode());
    String _email = widget.emailController;
    String _password = widget.passwordController;
    FocusScope.of(context).unfocus();
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Registration in progress..."),
        title: const Text("Registering"));
    progressDialog.show();

    http.post(Uri.parse(CONSTANTS.server + "/fyp_ttw/php/register_user.php"),
        body: {
          "email": _email,
          "password": _password,
        }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Registration Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 18.0,
            textColor: Colors.white,
            backgroundColor: Colors.amber);
        progressDialog.dismiss();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Registration Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 18.0,
            textColor: Colors.white,
            backgroundColor: Colors.amber);
        progressDialog.dismiss();
        return;
      }
    });
  }
}
