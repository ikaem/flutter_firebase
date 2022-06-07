import "package:flutter/material.dart";
import "dart:io";
import "package:path/path.dart";
import "package:image_picker/image_picker.dart";
import "package:firebase_storage/firebase_storage.dart";

class UploadFileScreen extends StatefulWidget {
  const UploadFileScreen({Key? key}) : super(key: key);

  @override
  State<UploadFileScreen> createState() => _UploadFileScreenState();
}

class _UploadFileScreenState extends State<UploadFileScreen> {
  File? _image;
  String _message = "";
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload to Firestore")),
      body: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    getImage();
                  },
                  child: Text("Choose image")),
              // this is pretty cool
              (_image == null)
                  ? Container(
                      height: 200,
                    )
                  : Container(
                      height: 200,
                      child: Image.file(_image!),
                    ),
              ElevatedButton(
                  onPressed: () {
                    uploadImage();
                  },
                  child: Text("Upload image")),
              // this seems to be technique for errors shwoing
              Text(_message)
            ],
          )),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No image selected");
      }
    });
  }

  Future uploadImage() async {
    if (_image != null) {
      String filename = basename(_image!.path);
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref(filename);

      setState(() {
        _message = "Uloading file. Please wait...";
      });

// taskSnapshot seems to be some generic thing - result of an ongoing process
      ref.putFile(_image!).then((TaskSnapshot result) {
        if (result.state == TaskState.success) {
          setState(() {
            _message = "File uploaded successfully";
          });
        } else {
          setState(() {
            _message = "File failed to uplaod";
          });
        }
      });
    } else {
      setState(() {
        _message = "Error uploading file";
      });
    }
  }
}
