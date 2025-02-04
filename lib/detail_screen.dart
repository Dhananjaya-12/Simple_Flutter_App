import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class DetailScreen extends StatefulWidget {
  final String itemName;
  final String itemDescription;
  final int itemIndex;

  DetailScreen({
    required this.itemName,
    required this.itemDescription,
    required this.itemIndex,
  });

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  File? _image; // Variable to store the captured image

  Future<void> _checkAndRequestPermissions() async {
    PermissionStatus cameraStatus = await Permission.camera.request();
    PermissionStatus storageStatus = await Permission.photos.request();

    if (cameraStatus.isGranted && storageStatus.isGranted) {
      _pickImage();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please grant camera and storage permissions to continue.'),
      ));
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.itemName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.itemDescription,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            if (widget.itemIndex == 0) ...[
              // Camera item (Task 2)
              _image != null
                  ? Image.file(_image!)
                  : Text('No image captured yet'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkAndRequestPermissions,
                child: Text('Capture Image'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
