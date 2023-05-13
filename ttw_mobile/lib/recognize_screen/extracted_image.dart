import 'package:flutter/material.dart';
import '../model/uploaded_image.dart';
import '../model/user.dart';

class ExtractedImageTextScreen extends StatefulWidget {
  final User user;
  String imageText;

  ExtractedImageTextScreen({
    Key? key,
    required this.user,
    required this.imageText,
  }) : super(key: key);

  @override
  State<ExtractedImageTextScreen> createState() => _ExtractedImageTextScreenState();
}

class _ExtractedImageTextScreenState extends State<ExtractedImageTextScreen> {
  List<UploadedImage> imageList = <UploadedImage>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Extracted Text'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: (widget.imageText) != null
                    ? Text(
                        widget.imageText,
                        style: TextStyle(fontSize: 16),
                      )
                    : Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
