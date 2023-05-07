import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import 'package:pdf_text/pdf_text.dart';
import '../constants.dart';
import '../login_register/loginscreen.dart';
import '../login_register/registrationscreen.dart';
import '../main_view/uploadscreen.dart';
import '../model/user.dart';

User user = User();

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RecognizePdfScreen(
        user: user,
      ),
    );
  }
}

class RecognizePdfScreen extends StatefulWidget {
  final User user;
  const RecognizePdfScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<RecognizePdfScreen> createState() => _RecognizePdfScreenState();
}

class _RecognizePdfScreenState extends State<RecognizePdfScreen> {
  TextEditingController controller = TextEditingController();
  final TextEditingController fileName = TextEditingController();

  late final String? files;

  FlutterTts flutterTts = FlutterTts();

  String intro =
      "Read PDF Screen. Save button. Stop button. Speak button. Upload PDF button.";

  speakIntro(String intro) async {
    if (intro != null && intro.isNotEmpty) {
      await flutterTts.setLanguage('en-US');
      await flutterTts.setPitch(1); // 0.5 to 1.5
      await flutterTts.speak(intro);
    }
  }

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

  Future<String> pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowCompression: true);

    if (result != null) {
      files = result.files.single.path;
      return files!;
    } else {
      // User canceled the picker
      print("File Picked canceled");
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
          onPressed: () {
            stop();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (content) => UploadScreen(
                          user: widget.user,
                        )));
          },
        ),
        title: const Text("Read PDF"),
        actions: [
          IconButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  if (widget.user.email == "guest@ttw.com") {
                    _loadOptions();
                  } else {
                    showSaveFileDialog();
                  }
                } else {
                  Fluttertoast.showToast(
                    msg: "Please select a pdf file",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    fontSize: 16.0,
                  );
                  flutterTts.speak("Please select a pdf file");
                  return;
                }
                stop();
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
                if (controller.text.isNotEmpty) {
                  speak(text: controller.text.trim());
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
      body: Container(
        padding: const EdgeInsets.all(20),
        child: TextFormField(
          controller: controller,
          maxLines: MediaQuery.of(context).size.height.toInt(),
          decoration: const InputDecoration(
            border: InputBorder.none,
            // label: Text("Text to read...")
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          stop();
          pickDocument().then((value) async {
            debugPrint(value);
            if (value != '') {
              PDFDoc doc = await PDFDoc.fromPath(value);

              final text = await doc.text;

              controller.text = text;
            } else {
              controller.text = "No PDF selected.";
            }
          });
        },
        label: const Icon(Icons.attach_file),
      ),
    );
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
              // onPressed: () => savePdf(File(files!)),
              onPressed: () => savePdf(),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void savePdf() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Saving file in progress.."),
        title: const Text("Saving..."));
    progressDialog.show();
    Navigator.of(context).pop();

    final bytes = File(files!).readAsBytesSync();
    final base64Pdf = base64Encode(bytes);

    Map<String, String> headers = {
      "Content-type": "application/x-www-form-urlencoded"
    };

    var data = {
      'email': widget.user.email.toString(),
      'pdfname': fileName.text,
      'pdf_file': base64Pdf,
    };

    var response = await http.post(
        Uri.parse(CONSTANTS.server + "/fyp_ttw/php/save_pdf.php"),
        headers: headers,
        body: data);

    progressDialog.dismiss();

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "PDF saved successfully.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0,
      );
      Navigator.of(context).pop();
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
        msg: "Failed to save PDF. Please try again later.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0,
      );
      progressDialog.dismiss();
      return;
    }
  }
}
