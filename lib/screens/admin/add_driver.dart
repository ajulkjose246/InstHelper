import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_ml_kit/google_ml_kit.dart';

class AddDriver extends StatefulWidget {
  const AddDriver({super.key});

  @override
  State<AddDriver> createState() => _AddDriverState();
}

class _AddDriverState extends State<AddDriver> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactNumberController = TextEditingController();
  File? _licenseImage;
  File? _liveImage;
  final _picker = ImagePicker();
  final _faceDetector = GoogleMlKit.vision.faceDetector();

  Future<void> _pickImage(ImageSource source,
      {bool isLiveImage = false}) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (isLiveImage) {
          _liveImage = File(pickedFile.path);
        } else {
          _licenseImage = File(pickedFile.path);
        }
      });
    }
  }

  Future<bool> _compareFaces() async {
    if (_licenseImage == null || _liveImage == null) {
      return false;
    }

    final licenseImageInput = InputImage.fromFile(_licenseImage!);
    final liveImageInput = InputImage.fromFile(_liveImage!);

    final licenseFaces = await _faceDetector.processImage(licenseImageInput);
    final liveFaces = await _faceDetector.processImage(liveImageInput);

    if (licenseFaces.isNotEmpty && liveFaces.isNotEmpty) {
      // For simplicity, assume the first detected face in each image
      final licenseFace = licenseFaces[0];
      final liveFace = liveFaces[0];

      // In real-world scenarios, you might use a more sophisticated method to compare face landmarks
      return licenseFace.boundingBox.overlaps(liveFace.boundingBox);
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Driver'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the driver\'s name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contactNumberController,
                decoration: const InputDecoration(labelText: 'Contact Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the driver\'s contact number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                child: const Text('Select License Image'),
              ),
              if (_licenseImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.file(_licenseImage!, height: 100),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    _pickImage(ImageSource.camera, isLiveImage: true),
                child: const Text('Capture Live Image'),
              ),
              if (_liveImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.file(_liveImage!, height: 100),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final facesMatch = await _compareFaces();
                    if (facesMatch) {
                      // TODO: Process the form data and image
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Faces match! Driver added.')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Faces do not match!')),
                      );
                    }
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactNumberController.dispose();
    _faceDetector.close();
    super.dispose();
  }
}
