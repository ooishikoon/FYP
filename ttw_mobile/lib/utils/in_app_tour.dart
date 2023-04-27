import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

List<TargetFocus> mainTargetsPage({
  required GlobalKey textKey,
  required GlobalKey uploadKey,
  required GlobalKey bookrackKey,
  required GlobalKey dictionaryKey,
  required GlobalKey tourKey,
  required GlobalKey profileKey,
}) {
  List<TargetFocus> targets = [];

  //Text
  targets.add(TargetFocus(
      keyTarget: textKey,
      alignSkip: Alignment.bottomRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              FlutterTts flutterTts = FlutterTts();
              flutterTts.speak(
                  "Button at the upper left is to convert the text to speech.");
              return Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      "This is the button to convert the text to speech.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            })
      ]));

  //Upload
  targets.add(TargetFocus(
      keyTarget: uploadKey,
      alignSkip: Alignment.bottomRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              FlutterTts flutterTts = FlutterTts();
              flutterTts.speak("Button at the upper right is to upload file.");
              return Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      "This is the button to upload files.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            })
      ]));

  //Book Rack
  targets.add(TargetFocus(
      keyTarget: bookrackKey,
      alignSkip: Alignment.bottomRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              FlutterTts flutterTts = FlutterTts();
              flutterTts.speak(
                  "Button at the middle left is to view your uploaded file.");
              return Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      "This is the button to view your uploaded files.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            })
      ]));

  //Dictionary
  targets.add(TargetFocus(
      keyTarget: dictionaryKey,
      alignSkip: Alignment.bottomRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              FlutterTts flutterTts = FlutterTts();
              flutterTts.speak("Button at the middle right is dictionary.");
              return Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      "This is the button to view dictionary.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            })
      ]));

  //Guide Tour
  targets.add(TargetFocus(
      keyTarget: tourKey,
      alignSkip: Alignment.bottomRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              FlutterTts flutterTts = FlutterTts();
              flutterTts.speak("Button at the bottom left is guide tour.");
              return Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      "This is the button to view the guide tour.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            })
      ]));

  //Profile
  targets.add(TargetFocus(
      keyTarget: profileKey,
      alignSkip: Alignment.bottomRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              FlutterTts flutterTts = FlutterTts();
              flutterTts.speak("Button at the bottom right is your profile.");
              return Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      "This is the button to view your profile.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            })
      ]));

  //Return targets content
  return targets;
}
