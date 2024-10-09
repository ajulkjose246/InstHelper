import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:AjceTrips/provider/vehicle_provider.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class AddDriver extends StatefulWidget {
  const AddDriver({super.key});

  @override
  State<AddDriver> createState() => _AddDriverState();
}

class _AddDriverState extends State<AddDriver> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _licenseController = TextEditingController();
  File? _licenseImage;
  final TextRecognizer _textRecognizer = TextRecognizer();

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
          fontSize: MediaQuery.of(context).size.width < 360 ? 14 : 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      filled: true,
      fillColor: Colors.grey[200],
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _licenseImage = File(image.path);
      });

      // Perform text recognition on the selected image
      await _recognizeText(_licenseImage!);
    }
  }

  Future<void> _recognizeText(File image) async {
    final InputImage inputImage = InputImage.fromFile(image);
    final RecognizedText recognizedText =
        await _textRecognizer.processImage(inputImage);

    String name = '';
    String licenseNumber = '';

    // Extract name and license number from the recognized text
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        if (line.text.contains('Name')) {
          name = line.text.split(':').last.trim();
        } else if (line.text.contains('No.:')) {
          licenseNumber = line.text.split('No.:').last.trim().split(' ').first;
        }
      }
    }

    setState(() {
      _nameController.text = name;
      _licenseController.text = licenseNumber;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_licenseImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload a license image')),
        );
        return;
      }

      try {
        // Add driver to the database
        await Provider.of<VehicleProvider>(context, listen: false).addDriver(
          name: _nameController.text,
          phoneNumber: _phoneController.text,
          email: _emailController.text,
          licenseNumber: _licenseController.text,
          licenseImage: _licenseImage!,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Driver added successfully')),
        );

        // Clear form fields
        _nameController.clear();
        _phoneController.clear();
        _emailController.clear();
        _licenseController.clear();
        setState(() {
          _licenseImage = null;
        });
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding driver: $e')),
        );
      }
    }
  }

  String _generateRandomPassword() {
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()';
    return List.generate(12, (index) => chars[Random().nextInt(chars.length)])
        .join();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Driver', style: textTheme.titleMedium),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.04),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(_nameController, 'Name'),
                SizedBox(height: size.height * 0.02),
                _buildTextField(_phoneController, 'Phone Number',
                    keyboardType: TextInputType.phone),
                SizedBox(height: size.height * 0.02),
                _buildTextField(_emailController, 'Email',
                    keyboardType: TextInputType.emailAddress),
                SizedBox(height: size.height * 0.02),
                _buildTextField(_licenseController, 'License Number'),
                SizedBox(height: size.height * 0.02),
                ElevatedButton(
                  onPressed: _pickImage,
                  child:
                      Text('Upload License Image', style: textTheme.bodySmall),
                ),
                SizedBox(height: size.height * 0.01),
                _buildLicenseImagePreview(size),
                SizedBox(height: size.height * 0.03),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: size.height * 0.015),
                    child: Text(
                      'Submit',
                      style: textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      style: TextStyle(fontSize: 14),
      keyboardType: keyboardType,
      validator: (value) => value?.isEmpty ?? true
          ? 'Please enter the ${label.toLowerCase()}'
          : null,
    );
  }

  Widget _buildLicenseImagePreview(Size size) {
    return _licenseImage != null
        ? Image.file(
            _licenseImage!,
            height: size.height * 0.12,
            width: double.infinity,
            fit: BoxFit.cover,
          )
        : Container(
            height: size.height * 0.12,
            color: Colors.grey[300],
            child: Center(
              child: Text('No image selected', style: TextStyle(fontSize: 12)),
            ),
          );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _licenseController.dispose();
    _textRecognizer.close();
    super.dispose();
  }
}
