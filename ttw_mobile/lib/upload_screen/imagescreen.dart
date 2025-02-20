import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import '../constants.dart';
import '../login_register/loginscreen.dart';
import '../login_register/registrationscreen.dart';
import '../main_view/uploadscreen.dart';
import '../model/user.dart';

User user = User();

class RecognizePage extends StatefulWidget {
  final User user;
  final String? path;

  const RecognizePage({Key? key, this.path, required this.user})
      : super(key: key);

  @override
  State<RecognizePage> createState() => _RecognizePageState();
}

class _RecognizePageState extends State<RecognizePage> {
  FlutterTts flutterTts = FlutterTts();

  String intro = "Read Image Screen. Save button. Stop button. Speak button.";

  speakIntro(String intro) async {
    if (intro != null && intro.isNotEmpty) {
      await flutterTts.setLanguage('en-US');
      await flutterTts.setPitch(1); // 0.5 to 1.5
      await flutterTts.speak(intro);
    }
  }

  final TextEditingController fileName = TextEditingController();

  final TextEditingController imageText = TextEditingController();

  void stop() async {
    await flutterTts.stop();
  }

  void speak({String? text}) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setVolume(1.0);

    try {
      await flutterTts.speak(text!);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  bool _isBusy = false;

  @override
  void initState() {
    super.initState();

    final InputImage inputImage = InputImage.fromFilePath(widget.path!);

    processImage(inputImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              child: const Icon(
                Icons.keyboard_arrow_left,
                size: 35,
              ),
              onTap: () {
                stop();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => UploadScreen(
                              user: widget.user,
                            )));
              }),
          title: const Text("Read Image"),
          actions: [
            IconButton(
                onPressed: () {
                  stop();
                  if (widget.user.email == "guest@ttw.com") {
                    _loadOptions();
                  } else {
                    showSaveFileDialog();
                  }
                },
                icon: const Icon(
                  Icons.save,
                  size: 28,
                )),
            IconButton(
                onPressed: () {
                  stop();
                },
                icon: const Icon(
                  Icons.stop,
                  size: 28,
                )),
            IconButton(
                onPressed: () {
                  if (imageText.text.isNotEmpty) {
                    speak(text: imageText.text.trim());
                  }
                },
                icon: const Icon(
                  Icons.mic,
                  size: 28,
                )),
            IconButton(
                onPressed: () => speakIntro(intro),
                icon: const Icon(
                  Icons.headphones,
                  size: 28,
                )),
          ],
        ),
        body: _isBusy == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  maxLines: MediaQuery.of(context).size.height.toInt(),
                  controller: imageText,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    // label: Text("Text to read...")
                  ),
                ),
              ));
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

  void processImage(InputImage image) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    setState(() {
      _isBusy = true;
    });

    log(image.filePath!);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(image);

    imageText.text = recognizedText.text;

    ///End busy state
    setState(() {
      _isBusy = false;
    });
  }

  void showSaveFileDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save file'),
          content: TextField(
            controller: fileName,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: 'Enter file name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => saveImage(File(widget.path!)),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void saveImage(File imageFile) async {
    String filename = fileName.text;
    String filetext = imageText.text;

    // Read the image file as bytes
    List<int> imageBytes = await imageFile.readAsBytes();

    // Encode the bytes as base64
    String base64Image = base64Encode(imageBytes);

    if (fileName.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please fill in the file name",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 18.0);
      return;
    }
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Saving file in progress.."),
        title: const Text("Saving..."));
    progressDialog.show();
    Navigator.of(context).pop();

    // Send the HTTP request
    http.post(
      Uri.parse(CONSTANTS.server + "/fyp_ttw/php/save_image.php"),
      body: {
        "email": widget.user.email.toString(),
        "imagename": filename,
        "image": base64Image,
        "imagetext": filetext,
      },
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
          msg: "Image saved successfully.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0,
          textColor: Colors.white,
          backgroundColor: Colors.amber,
        );
        progressDialog.dismiss();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => UploadScreen(
                      user: widget.user,
                    )));
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Failed to save Image. Please try again later.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            backgroundColor: Colors.amber,
            fontSize: 16.0);
        progressDialog.dismiss();
        return;
      }
    });
  }
}
