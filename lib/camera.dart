import 'dart:ui';

import 'package:flutter/material.dart';
import "package:camera/camera.dart";
import 'package:flutter_firebase/shared/picture_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<CameraDescription>? cameras;
  List<Widget>? cameraButtons;
  CameraDescription? activeCamera;
  CameraController? cameraController;
  CameraPreview? preview;

  @override
  void initState() {
    listCameras().then((result) {
      print("result: $result");
      setState(() {
        cameraButtons = result;
        setCameraController();
      });
    });
  }

  @override
  void dispose() {
    if (cameraController != null) {
      cameraController?.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera View"),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: cameraButtons ??
                  <Widget>[Container(child: Text("No cameras available"))],
            ),
            // TODO here need size as a prop i guess
            // i dont understand why whould first container not be truthy
            // Container(height: size.height / 2, child: preview) ?? Container(),
            Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: preview) ??
                Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      if (cameraController != null) {
                        // why do we navigate here, if take picture is already navigating
                        // takePicture().then((dynamic picture) {
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) =>
                        //               PictureScreen(picture)));
                        // });

                        takePicture();
                      }
                    },
                    child: Text("Take picture"))
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<List<Widget>?> listCameras() async {
    List<Widget> buttons = [];
    cameras = await availableCameras();

    print("available cameras: $cameras");

    if (cameras == null) return null;

// i guess it could be that cameras will be a list of zero
    if (activeCamera == null) activeCamera = cameras!.first;

    if (cameras!.length == 0) return [];

    for (CameraDescription camera in cameras!) {
      buttons.add(ElevatedButton(
          onPressed: () {
            setState(() {
              activeCamera = camera;
              setCameraController();
            });
          },
          child: Row(
            children: <Widget>[
              Icon(Icons.camera_alt),
              // it is cool that a cmera has a name
              Text(camera == null ? "" : camera.name)
            ],
          )));

      return buttons;
    }
  }

  Future setCameraController() async {
    if (activeCamera == null) return;

    cameraController = CameraController(activeCamera!, ResolutionPreset.high);

    if (cameraController == null) return;
    await cameraController?.initialize();

    setState(() {
      preview = CameraPreview(cameraController!);
    });
  }

  Future takePicture() async {
    if (cameraController == null) return;
    if (!cameraController!.value.isInitialized) {
      return null;
    }
    if (cameraController!.value.isTakingPicture) {
      return null;
    }

    try {
      await cameraController?.setFlashMode(FlashMode.off);
      XFile picture = await cameraController!.takePicture();

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PictureScreen(picture)));
    } catch (e) {
      print(e.toString());
    }
  }
}
