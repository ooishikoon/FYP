import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../main.dart';
import '../model/user.dart';
import 'mainscreen.dart';
import 'registrationscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late double screenHeight, screenWidth, ctrwidth;
  bool remember = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 800) {
      ctrwidth = screenWidth / 1.5;
    }
    if (screenWidth < 800) {
      ctrwidth = screenWidth;
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/login_page.png'),
                  fit: BoxFit.fill),
            ),
            child: SizedBox(
              width: ctrwidth,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
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
                                          builder: (content) => const SplashScreen(
                                                title: '',
                                              )));
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
                      ],
                    ),
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
                            height: 15,
                          ),
                          Card(
                            clipBehavior: Clip.antiAlias,
                            shadowColor: Colors.amber,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 20, 10, 20),
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
                                                BorderRadius.circular(50.0))),
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
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        hintText: 'Password',
                                        icon: const Icon(Icons.lock),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0))),
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
                                        onPressed: _loginUser,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 90,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text("No account? ",
                                  style: TextStyle(fontSize: 18.0)),
                              GestureDetector(
                                onTap: () => {
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
          ),
        ),
      ),
    );
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
        http.post(
            Uri.parse(CONSTANTS.server + "/fyp_ttw/php/login_user.php"),
            body: {"email": _email, "password": _password}).then((response) {
          var data = jsonDecode(response.body);
          if (response.statusCode == 200 && data['status'] == 'success') {
            User user = User.fromJson(data['data']);
            Fluttertoast.showToast(
                msg: "Success",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                fontSize: 16.0);
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
                fontSize: 16.0);
          }
        });
      }
    }
  }
}