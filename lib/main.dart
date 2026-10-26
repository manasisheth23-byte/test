import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:usb_camera/usb_camera.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MaterialApp(home: UsbCameraPhotoPage()));

class UsbCameraPhotoPage extends StatefulWidget {
  @override
  _UsbCameraPhotoPageState createState() => _UsbCameraPhotoPageState();
}

class _UsbCameraPhotoPageState extends State<UsbCameraPhotoPage> {
  final UsbCamera _camera = UsbCamera.instance;
  List<Map<String, dynamic>> _cams = [];
  String? selectedId;
  bool _isOpen = false;
  bool _photoTaken = false;

  @override
  void dispose() {
    if (_isOpen) _closeCamera();
    super.dispose();
  }

  Future<void> _takePhoto(Uint8List imageData) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CapturedImageView(imageData: imageData),
      ),
    );
  }

  Future<void> _closeCamera() async {
    await _camera.stopCapture();
    await _camera.close();
    setState(() {
      _isOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('USB Camera Photo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_isOpen)
              SizedBox(
                width: 320,
                height: 240,
                child: StreamBuilder<Uint8List?>(
                  stream: _camera.imageStream,
                  builder: (_, snap) {
                    if (!snap.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final imageData = snap.data!;
                    return Stack(
                      children: [
                        Image.memory(imageData, fit: BoxFit.cover),
                      ],
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),

            // Open Camera Button
            ElevatedButton(
              onPressed: () async {
                await [Permission.camera, Permission.storage].request();
                _cams = await _camera.list();

                if (_cams.isNotEmpty) {
                  selectedId = _cams.first['id'];
                  await _camera.open(selectedId!);
                  //await _camera.startCapture(); // Start capturing stream
                  setState(() {
                    _isOpen = true;
                    _photoTaken = false; // Reset capture flag
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No USB camera detected')),
                  );
                }
              },
              child: Text('Open Camera'),
            ),

            // Capture Button (only once)
            ElevatedButton(
              onPressed:  () async {
                await [Permission.camera, Permission.storage].request();
                _cams = await _camera.list();

                if (_cams.isNotEmpty) {
                  selectedId = _cams.first['id'];
                  await _camera.open(selectedId!);
                  //await _camera.startCapture(); // Start capturing stream
                  setState(() {
                    _isOpen = true;
                    _photoTaken = false; // Reset capture flag
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No USB camera detected')),
                  );
                }
                await _camera.startCapture();
                final image = await _camera.imageStream.firstWhere((data) => data != null);
               // await _camera.stopCapture(); // Stop streaming immediately after one frame
                setState(() => _photoTaken = true);
                _takePhoto(image!);
                _closeCamera();
              }, child: Text("Capture"),
            ),
            

            // Close Camera Button
            ElevatedButton(
              onPressed: () {
                _closeCamera();
              },
              child: Text('Close Camera'),
            ),
          ],
        ),
      ),
    );
  }
}



class CapturedImageView extends StatelessWidget {
  final Uint8List imageData;

  const CapturedImageView({Key? key, required this.imageData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Captured Image')),
      body: Center(
        child: Image.memory(imageData, fit: BoxFit.contain),
      ),
    );
  }
}