import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class RepaintBoundarySsScreen extends StatefulWidget {
  const RepaintBoundarySsScreen({
    Key? key,
  }) : super(key: key);

  @override
  _RepaintBoundarySsScreenState createState() =>
      _RepaintBoundarySsScreenState();
}

class _RepaintBoundarySsScreenState extends State<RepaintBoundarySsScreen> {
  static GlobalKey previewContainer = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
        key: previewContainer,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Repaint Boundary "),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: takeScreenShot,
                  child: const Text('Take a Screenshot'),
                ),
                const SizedBox(
                  height: 150.0,
                  child: Icon(Icons.flutter_dash),
                ),
              ],
            ),
          ),
        ));
  }

  takeScreenShot() async {
    RenderRepaintBoundary? boundary = previewContainer.currentContext!
        .findRenderObject() as RenderRepaintBoundary?;
    ui.Image image = await boundary!.toImage();
    final directory = (await getExternalStorageDirectory())!.path;
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    File imgFile = File('$directory/abc-screenshot.png');
    imgFile.writeAsBytes(pngBytes);
  }
}
