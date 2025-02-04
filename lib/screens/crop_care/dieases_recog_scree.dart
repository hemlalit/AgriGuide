import 'dart:io';
import 'package:AgriGuide/providers/theme_provider.dart';
import 'package:AgriGuide/screens/crop_care/img_picker_dialog.dart';
import 'package:AgriGuide/services/crop_api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DieasesRecogScreen extends StatefulWidget {
  const DieasesRecogScreen({super.key});

  @override
  State<DieasesRecogScreen> createState() => _DieasesRecogScreen();
}

class _DieasesRecogScreen extends State<DieasesRecogScreen> {
  File? _selectedImage;
  String? _result;

  void _showImagePicker() {
    showDialog(
      context: context,
      builder: (context) => ImagePickerDialog(
        onImagePicked: (image) {
          setState(() {
            _selectedImage = File(image.path);
          });
        },
      ),
    );
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;

    final response = await CropApiService.analyzeCropImage(_selectedImage!);
    setState(() {
      _result = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: const Text('Crop Disease Recognition'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [
                        const Color.fromARGB(255, 0, 100, 0),
                        const Color.fromARGB(255, 0, 20, 0)
                      ]
                    : [Colors.lightGreen, const Color.fromARGB(255, 1, 128, 5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (_selectedImage != null)
            Image.file(_selectedImage!, height: 300, fit: BoxFit.cover),
          if (_result != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_result!, style: const TextStyle(fontSize: 16)),
            ),
          ElevatedButton(
            onPressed: _showImagePicker,
            child: const Text('Pick Image'),
          ),
          ElevatedButton(
            onPressed: _analyzeImage,
            child: const Text('Analyze Image'),
          ),
        ],
      ),
    );
  }
}
