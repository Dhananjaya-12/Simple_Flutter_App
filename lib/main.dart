import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> task1Items = [
    {
      'name': 'Contact',
      'description': 'So here you will see the saved contacts from your phone. You can easily view and access names, phone numbers, and emails of people you’ve stored, making it quick to get in touch with anyone directly.',
      'icon': Icons.contacts
    },
    {
      'name': 'Files',
      'description': 'In this section, you can explore the files stored on your device. View, manage, and organize your documents, images, and other file types for easy access and management.',
      'icon': Icons.insert_drive_file
    },
    {
      'name': 'App Store',
      'description': 'Here you will find apps available for download and installation. Browse through different categories, check ratings, and install the apps you need directly from the App Store.',
      'icon': Icons.store
    },
  ];

  final List<Map<String, dynamic>> task2Items = [
    {
      'name': 'Camera',
      'description': 'Capture an image using your phone’s camera. With this feature, you can take photos and view them right in the app, giving you the ability to save memories instantly.',
      'icon': Icons.camera_alt
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: ListView(
        children: [
          // Task 1
          ExpansionTile(
            title: Text('Task 1'),
            leading: Icon(Icons.list),
            children: task1Items.map((item) {
              return ListTile(
                leading: Icon(item['icon'], size: 30),
                title: Text(item['name']),
                subtitle: Text(item['description']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        itemName: item['name'],
                        itemDescription: item['description'],
                        itemIndex: task1Items.indexOf(item),
                        showCameraFeature: false, // No camera in Task 1
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          // Task 2 (Camera)
          ExpansionTile(
            title: Text('Task 2'),
            leading: Icon(Icons.camera_alt),
            children: task2Items.map((item) {
              return ListTile(
                leading: Icon(item['icon'], size: 30),
                title: Text(item['name']),
                subtitle: Text(item['description']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        itemName: item['name'],
                        itemDescription: item['description'],
                        itemIndex: task2Items.indexOf(item),
                        showCameraFeature: true, // Camera enabled for Task 2
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatefulWidget {
  final String itemName;
  final String itemDescription;
  final int itemIndex;
  final bool showCameraFeature;

  DetailScreen({
    required this.itemName,
    required this.itemDescription,
    required this.itemIndex,
    required this.showCameraFeature,
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
            if (widget.showCameraFeature) ...[
              // Camera feature for Task 2
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
