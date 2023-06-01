import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ttw_mobile/verify_otp/forgotpasswordscreen.dart';
import '../constants.dart';
import '../main_view/mainscreen.dart';
import '../model/user.dart';
import 'registrationscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late double screenHeight, screenWidth, resWidth;

  User guest = User(email: 'guest@ttw.com');

  FlutterTts flutterTts = FlutterTts();

  String intro =
      "Login screen. Email text field. Password text field. Remember me checkbox. Login button. Forgot password? Reset here button. No account? Register here button.";

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool remember = false;
  bool passwordVisible = true;

  void clearTextEmail() {
    _emailController.clear();
  }

  void clearTextPassword() {
    _passwordController.clear();
  }

  @override
  void initState() {
    super.initState();
    loadPref();
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
    return SafeArea(
        child: Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          buildBackground(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildReturnButton(),
                    buildSpeechButton(),
                  ],
                ),
              ),
            ],
          ),
          Form(
              child: SingleChildScrollView(
            child: buildContext(),
          ))
        ],
      ),
    ));
  }

  Widget buildBackground() => ClipRRect(
        child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/login_page.png'),
                    fit: BoxFit.cover))),
      );

  Widget buildReturnButton() => IconButton(
      icon: const Icon(
        Icons.keyboard_arrow_left,
        size: 35,
      ),
      onPressed: () {
        stop();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (content) => MainScreen(
                      user: guest,
                    )));
      });

  Widget buildSpeechButton() => IconButton(
      onPressed: () => speakIntro(intro),
      icon: const Icon(
        Icons.headphones,
        size: 35,
        color: Colors.black,
      ));

  Widget buildContext() => Container(
        child: SizedBox(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                      const SizedBox(
                        height: 40,
                      ),
                      Card(
                        clipBehavior: Clip.antiAlias,
                        shadowColor: Colors.amber,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  icon: const Icon(Icons.email),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(50.0)),
                                  suffixIcon: SizedBox(
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
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
                                height: 20,
                              ),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: passwordVisible,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  icon: const Icon(Icons.lock),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(50.0)),
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
                                                passwordVisible =
                                                    !passwordVisible;
                                              },
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            clearTextPassword();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return "Password must be at least 6 characters";
                                  }
                                  return null;
                                },
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: remember,
                                    onChanged: (bool? value) {
                                      _onRememberMe(value!);
                                    },
                                  ),
                                  const Text("Remember Me")
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton.icon(
                                      icon: const Icon(
                                        Icons.login_sharp,
                                        size: 20.0,
                                      ),
                                      label: const Text('Login'),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                        minimumSize: const Size(100, 40),
                                      ),
                                      onPressed: () {
                                        stop();
                                        _loginUser();
                                      }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Forgot Password? ",
                              style: TextStyle(fontSize: 18.0)),
                          GestureDetector(
                            onTap: () => {
                              stop(),
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const ForgotPasswordScreen()))
                            },
                            child: const Text(
                              " Reset here",
                              style: TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(232, 232, 163, 23),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("No account? ",
                              style: TextStyle(fontSize: 18.0)),
                          GestureDetector(
                            onTap: () => {
                              stop(),
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const RegistrationScreen()))
                            },
                            child: const Text(
                              " Register here",
                              style: TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(232, 232, 163, 23),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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

  void saveRemovePref(bool value) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String email = _emailController.text;
      String password = _passwordController.text;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (value) {
        await prefs.setString('email', email);
        await prefs.setString('pass', password);
        await prefs.setBool('remember', true);
        Fluttertoast.showToast(
            msg: "Preference Stored",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      } else {
        await prefs.setString('email', '');
        await prefs.setString('pass', '');
        await prefs.setBool('remember', false);
        _emailController.text = "";
        _passwordController.text = "";
        Fluttertoast.showToast(
            msg: "Preference Removed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Preference Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      remember = false;
    }
  }

  void _onRememberMe(bool value) {
    remember = value;
    setState(() {
      if (remember) {
        saveRemovePref(true);
      } else {
        saveRemovePref(false);
      }
    });
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    remember = (prefs.getBool('remember')) ?? false;

    if (remember) {
      setState(() {
        _emailController.text = email;
        _passwordController.text = password;
        remember = true;
      });
    }
  }

  void _loginUser() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String _email = _emailController.text;
      String _password = _passwordController.text;
      if (_email.isNotEmpty && _password.isNotEmpty) {
        http.post(Uri.parse(CONSTANTS.server + "/fyp_ttw/php/login_user.php"),
            body: {"email": _email, "password": _password}).then((response) {
          var data = jsonDecode(response.body);
          if (response.statusCode == 200 && data['status'] == 'success') {
            User user = User.fromJson(data['data']);
            Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 18.0,
              textColor: Colors.white,
              backgroundColor: Colors.amber,
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (content) => MainScreen(
                          user: user,
                        )));
          } else {
            Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 18.0,
              textColor: Colors.white,
              backgroundColor: Colors.amber,
            );
          }
        });
      }
    }
  }
}
