import 'dart:convert';

import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constants.dart';
import '../main.dart';
import '../model/user.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:http/http.dart' as http;

import 'profilescreen.dart';

User user = User();

class DeleteAccountScreen extends StatefulWidget {
  final User user;

  const DeleteAccountScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
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
        userEmail: widget.user.email.toString(),
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
                builder: (content) => ProfileScreen(
                      user: widget.user,
                    )));
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
                      widget.user.email.toString(),
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
                  borderColor: Color(0xFF6A53A1),
                  focusedBorderColor: Color.fromARGB(255, 255, 191, 0),
                  textStyle: TextStyle(fontSize: 30),
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
                        content: Text("OTP is verified"),
                      ));
                      deleteAccountDialog();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Invalid OTP"),
                      ));
                      print("Invalid OTP");
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

  void deleteAccountDialog() {
    http.post(Uri.parse(CONSTANTS.server + "/fyp_ttw/php/delete_user.php"),
        body: {"email": widget.user.email}).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Delete Account",
            style: TextStyle(),
          ),
          content: const Text("Your account had deleted successfully."),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Confirm",
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (content) => const MyApp()));
              },
            ),
          ],
        );
      },
    );
  }
}
