import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

class PictureScreen extends StatefulWidget {
  final XFile picture;

  const PictureScreen(this.picture, {Key? key}) : super(key: key);

  @override
  State<PictureScreen> createState() => _PictureScreenState();
}

class _PictureScreenState extends State<PictureScreen> {
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text("Picture Screen")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(widget.picture.path),
          Container(
            height: deviceHeight / 1.5,
            // note how we do use file type here
            child: Image.file(File(widget.picture.path)),
          ),
          Row(
            children: <Widget>[
              ElevatedButton(onPressed: () {}, child: Text("Text Recognition"))
            ],
          )
        ],
      ),
    );
  }
}
