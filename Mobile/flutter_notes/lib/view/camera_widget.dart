import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CameraWidget extends StatefulWidget {
  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  CameraController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String imagePath;

  @override
  void initState() {
    super.initState();

    availableCameras().then((cameras) {
      controller = new CameraController(cameras[0], ResolutionPreset.medium);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: new Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          new Positioned.fill(
              child: new AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: new CameraPreview(controller),
          )),
          new PositionedDirectional(
              bottom: 16.0,
              child: new FloatingActionButton(
                onPressed: _takePicture,
                child: new Icon(Icons.camera),
              ))
        ],
      ),
    );
  }

  _takePicture() {


    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
        });
        if (filePath != null){
          showInSnackBar('Picture saved to $filePath');
          Navigator.pop(context, filePath);
        }
      }
    });

  }

  String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();

  Future<String> takePicture() async {
    if (controller != null && controller.value != null && !controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await new Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');

  void showInSnackBar(String message) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }
}
