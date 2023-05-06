import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class ScreenShotScreen extends StatefulWidget {
  const ScreenShotScreen({Key? key}) : super(key: key);

  @override
  _ScreenShotScreenState createState() => _ScreenShotScreenState();
}

class _ScreenShotScreenState extends State<ScreenShotScreen> {
  ///Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Capture the screen"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final image = await screenshotController.capture();
          if (image == null) return;
          await saveImage(image);
        },
        tooltip: "Captured image share",
        child: const Icon(Icons.share),
      ),
      body: Screenshot(
        controller: screenshotController,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  color: Colors.grey.withOpacity(0.8), child: buildImage()),
              const SizedBox(
                height: 25,
              ),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                child: const Text(
                  "Capture Widget",
                ),
                onPressed: () async {
                  final image = await screenshotController
                      .captureFromWidget(buildImage());
                  if (image.isNotEmpty) {
                    await saveAndShare(image);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///For build ui
  Widget buildImage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_F-i1OEsJ7QuuRc2K5xX5srlPQHGyjDpzkw&usqp=CAU",
                fit: BoxFit.cover,
              )),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              color: Colors.black,
              child: const Text(
                "Flutter",
                style: TextStyle(color: Colors.white, fontSize: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///Save into gallery and share
  Future saveAndShare(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File("${directory.path}/flutter.png");
    image.writeAsBytes(bytes);
    await Share.shareFiles([image.path]);
  }

  ///Save into gallery
  Future<String> saveImage(Uint8List bytes) async {
    await [
      Permission.storage,
    ].request();

    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '_')
        .replaceAll(':', "_");
    final name = "screenshot_$time";
    final result = await ImageGallerySaver.saveImage(bytes, name: name);
    final directory = await getApplicationDocumentsDirectory();
    final image = File("${directory.path}/flutter.png");
    image.writeAsBytes(bytes);
    await Share.shareFiles([image.path]);
    return result['filePath'];
  }
}
