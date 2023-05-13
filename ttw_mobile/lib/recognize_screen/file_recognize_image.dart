import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../model/uploaded_image.dart';
import '../model/user.dart';
import 'extracted_image.dart';

class FileRecognizeImageScreen extends StatefulWidget {
  final User user;
  int index;
  final List<UploadedImage> imageList;

  FileRecognizeImageScreen({
    Key? key,
    required this.user, required this.index, required this.imageList,
  }) : super(key: key);

  @override
  _FileRecognizeImageScreenState createState() =>
      _FileRecognizeImageScreenState();
}

class _FileRecognizeImageScreenState extends State<FileRecognizeImageScreen> {
  late ImageProvider _imageProvider;
  List<UploadedImage> imageList = <UploadedImage>[];

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recognize Image'),
      ),
      body: Container(
        child: _imageProvider == null
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: Image(
                      image: _imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _loadText(widget.index);
                    },
                    child: const Text('Extract Text'),
                  ),
                ],
              ),
      ),
    );
  }

  void _loadImage() {
    setState(() {
      _imageProvider = NetworkImage(CONSTANTS.server +
        "/fyp_ttw/assets/image/" +
        widget.imageList[widget.index].image_id.toString() +
        '.jpg');
    });
  }

  void _loadText(int index){
    String imageText = widget.imageList[index].image_text.toString();
    String imageName = widget.imageList[index].image_name.toString();

    Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (_) => ExtractedImageTextScreen(
          imageText: imageText,
          imageName: imageName,
          user: widget.user,
        ),
      ),
    );
  }
}
