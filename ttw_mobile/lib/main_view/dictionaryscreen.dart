import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import '../model/user.dart';
import 'mainscreen.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';

User user = User();

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DictionaryScreen(
        user: user,
      ),
    );
  }
}

class DictionaryScreen extends StatefulWidget {
  final User user;
  const DictionaryScreen({super.key, required this.user});

  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  late double screenHeight, screenWidth, resWidth;

  final String _url = "https://owlbot.info/api/v4/dictionary/";
  final String _token = "78a5f282b05342e425dbd662e06500e2d760b06f";

  TextEditingController _controller = TextEditingController();

  late StreamController _streamController;
  late Stream _stream;

  late Timer _debounce;

  final border = const OutlineInputBorder(
      borderRadius: BorderRadius.horizontal(left: Radius.circular(24.0)));

  final FlutterTts flutterTts = FlutterTts();

  String intro =
      "Dictionary Screen. Search for a word text field. Clear text button. Enter word to search.";

  void clearText() {
    _controller.clear();
  }

  stop() async {
    await flutterTts.stop();
  }

  _search() async {
    if (_controller.text == null || _controller.text.length == 0) {
      _streamController.add(null);
      return;
    }

    _streamController.add("waiting");
    Response response = await get(Uri.parse(_url + _controller.text.trim()),
        headers: {"Authorization": "Token " + _token});
    if (response.statusCode == 200) {
      _streamController.add(json.decode(response.body));
    } else {
      _streamController.add({"statusCode": response.statusCode});
    }
  }

  //Speech to text
  late stt.SpeechToText _speech;
  bool _isListening = false;

  void onListen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
          onResult: (val) {
            setState(() {
              _controller.text = val.recognizedWords;
            });
            _search(); // Call _search() after updating the text
          },
        );
      }
    } else {
      setState(() {
        _isListening = false;
        _speech.stop();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
    _debounce = Timer(const Duration(milliseconds: 1000), () {});
    _speech = stt.SpeechToText();
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
      appBar: AppBar(
        title: const Text("Dictionary"),
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
                      builder: (content) => MainScreen(
                            user: widget.user,
                          )));
            }),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                icon: const Icon(
                  Icons.headphones,
                  size: 32,
                  color: Colors.black,
                ),
                onPressed: () => speakIntro(intro),
              )),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 12.0, bottom: 8.0, right: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: TextFormField(
                    onChanged: (String text) {
                      if (_debounce?.isActive ?? false) _debounce.cancel();
                      _debounce = Timer(const Duration(milliseconds: 1000), () {
                        _search();
                      });
                    },
                    controller: _controller,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
                      hintText: "Search for a word",
                      border: InputBorder.none,
                      prefixIcon: IconButton(
                        onPressed: () {
                          _search();
                          speak(_controller.text);
                        },
                        icon: const Icon(Icons.search),
                      ),
                      suffixIcon: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                clearText();
                                stop();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: _stream,
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: Text(
                  "Enter word to search",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              );
            }
            if (snapshot.data == "waiting") {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "No definitions found",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              );
            }
            if (snapshot.data["statusCode"] != null) {
              return const Center(
                child: Text(
                  "No definitions found",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              );
            }
            if (snapshot.data["definitions"] == null ||
                snapshot.data["definitions"].isEmpty) {
              return const Center(
                child: Text(
                  "No definitions found",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data["definitions"].length,
              itemBuilder: (BuildContext context, int index) {
                final definition = snapshot.data["definitions"][index];
                final imageUrl = definition["image_url"];
                final type = definition["type"];
                final def = definition["definition"];
                return ListBody(
                  children: <Widget>[
                    Container(
                      color: Colors.grey[300],
                      child: ListTile(
                        leading: imageUrl == null
                            ? null
                            : CircleAvatar(
                                backgroundImage: NetworkImage(imageUrl)),
                        title: Text("${_controller.text.trim()}($type)"),
                        trailing: IconButton(
                          onPressed: () {
                            speak("${_controller.text.trim()} $def");
                          },
                          icon: Icon(Icons.volume_up),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(def),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
          animate: _isListening,
          glowColor: Theme.of(context).primaryColor,
          duration: Duration(milliseconds: 2000),
          repeatPauseDuration: Duration(milliseconds: 100),
          repeat: true,
          endRadius: 60.0,
          child: FloatingActionButton(
            onPressed: () => onListen(),
            child: Icon(_isListening ? Icons.mic : Icons.mic_none),
          )),
    );
  }

  speakIntro(String intro) async {
    if (intro != null && intro.isNotEmpty) {
      await flutterTts.setLanguage('en-US');
      await flutterTts.setPitch(1); // 0.5 to 1.5
      await flutterTts.speak(intro);
    }
  }

  speak(String text) async {
    if (text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please enter the text.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      flutterTts.speak("Please enter the text");
      return;
    } else {
      await flutterTts.setLanguage('en-US');
      await flutterTts.setPitch(1); // 0.5 to 1.5
      await flutterTts.speak(text);
    }
  }
}
