import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../constants.dart';
import '../model/file.dart';
import '../model/user.dart';
import 'mainscreen.dart';
import 'package:http/http.dart' as http;

User user = User();

class FileScreen extends StatefulWidget {
  final User user;

  const FileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<FileScreen> createState() => _FileScreenState();
}

class _FileScreenState extends State<FileScreen> {
  late double screenHeight, screenWidth, resWidth;

  List<File> fileList = <File>[];
  String titlecenter = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadFile();
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
                    image: AssetImage('assets/images/file_page.png'),
                    fit: BoxFit.cover))),
      );

  Widget buildTitle() => const Text(
        "Book Rak",
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

  Widget buildContext() => Container(
            child: fileList.isEmpty
                ? Center(
                    child: Text(titlecenter,
                        style: const TextStyle(
                          fontSize: 22,
                        )))
                : Column(children: [
                    Expanded(
                        child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: (1 / 1),
                            children: List.generate(fileList.length, (index) {
                              return InkWell(
                                splashColor: Colors.amber,
                                onTap: () => {null},
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  shadowColor: Colors.amber,
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 0),
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 247, 242, 199),
                                            Color.fromARGB(255, 243, 204, 86),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Flexible(
                                            flex: 4,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  fileList[index]
                                                      .file_name
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              );
                            }))),
                  ])
      );

  void _loadFile() {
    http.post(Uri.parse(CONSTANTS.server + "/fyp_ttw/php/loadFile.php"), body: {
      "email": widget.user.email.toString(),
    }).then((response) {
      var jsondata = jsonDecode(response.body);
      print(jsondata);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        if (extractdata['files'] != null) {
          fileList = <File>[];
          extractdata['files'].forEach((v) {
            fileList.add(File.fromJson(v));
          });
          setState(() {});
        } else {
          titlecenter = "No Files Available";
          setState(() {});
        }
      }
    });
  }
}
