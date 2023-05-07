import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import '../model/user.dart';
import '../upload_screen/imagescreen.dart';
import '../upload_screen/pdfscreen.dart';
import '../utils/image_cropper_page.dart';
import '../utils/image_picker_class.dart';
import '../widgets/modal_dialog.dart';
import 'mainscreen.dart';

User user = User();

class UploadScreen extends StatefulWidget {
  final User user;

  const UploadScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  late double screenHeight, screenWidth, resWidth;

  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController textEditingController = TextEditingController();

  File file = File("");

  void clearText() {
    textEditingController.clear();
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
                    image: AssetImage('assets/images/upload_page.png'),
                    fit: BoxFit.cover))),
      );

  Widget buildTitle() => const Text(
        "Upload",
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
                builder: (content) => MainScreen(
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

  Widget buildContext() => ListView(
          padding: const EdgeInsets.fromLTRB(0, 40, 10, 0),
          shrinkWrap: true,
          children: <Widget>[
            GestureDetector(
              onTap: () => {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => RecognizePdfScreen(
                              user: widget.user,
                            )))
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      children: const [
                        SizedBox(
                          height: 38,
                          child: SizedBox(
                            child: ClipRRect(
                              child: Image(
                                image: AssetImage('assets/images/pdf_icon.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Upload PDF",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_right,
                    size: 35,
                  ),
                ],
              ),
            ),
            const Divider(
              height: 20,
              color: Colors.black,
            ),
            GestureDetector(
              onTap: () {
                imagePickerModal(context, onCameraTap: () {
                  print("Camera");
                  pickImage(source: ImageSource.camera).then((value) {
                    if (value != '') {
                      imageCropperView(value, context).then((value) {
                        if (value != '') {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => RecognizePage(
                                path: value,
                                user: widget.user,
                              ),
                            ),
                          );
                        }
                      });
                    }
                  });
                }, onGalleryTap: () {
                  print("Gallery");
                  pickImage(source: ImageSource.gallery).then((value) {
                    if (value != '') {
                      imageCropperView(value, context).then((value) {
                        if (value != '') {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => RecognizePage(
                                path: value,
                                user: widget.user,
                              ),
                            ),
                          );
                        }
                      });
                    }
                  });
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      children: const [
                        SizedBox(
                          height: 38,
                          child: SizedBox(
                            child: ClipRRect(
                              child: Image(
                                image:
                                    AssetImage('assets/images/image_icon.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Upload image",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_right,
                    size: 35,
                  ),
                ],
              ),
            ),
            const Divider(
              height: 20,
              color: Colors.black,
            ),
          ]);
}
