import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isRegisteredImage = false;
  File? selectedImage;
  Uint8List? webImage;

  Uint8List? _imageBytes;
  String? _result = '';
  bool _isLoading = false;

  Future<void> _predictClass() async {
    if (_imageBytes == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final uri = Uri.parse('http://127.0.0.1:8000/predict_class/');
      final request = http.MultipartRequest('POST', uri);
      request.files.add(http.MultipartFile.fromBytes('file', _imageBytes!,
          filename: 'image.jpg'));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decodedResponse = jsonDecode(responseBody);
        final predictedClass = decodedResponse['class'];

        setState(() {
          _result = '클래스 : $predictedClass';
        });

        print('클래스: $predictedClass');
      } else {
        setState(() {
          _result = 'Prediction failed: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _predictConfidence() async {
    if (_imageBytes == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final uri = Uri.parse('http://127.0.0.1:8000/predict_confidence/');
      final request = http.MultipartRequest('POST', uri);
      request.files.add(http.MultipartFile.fromBytes('file', _imageBytes!,
          filename: 'image.jpg'));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decodedResponse = jsonDecode(responseBody);
        final confidence =
            (decodedResponse['confidence'] * 100).toStringAsFixed(2);

        setState(() {
          _result = '예측 확률 : $confidence%';
        });

        print('예측 확률 : $confidence%');
      } else {
        setState(() {
          _result = 'Prediction failed: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final boxSize = min(screenWidth * 0.9, 400.0);

    return Center(
        child: Column(
      children: [
        Container(
          color: Colors.white,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: boxSize,
                  height: boxSize,
                  decoration: isRegisteredImage
                      ? null
                      : BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                  child: Center(child: _buildImageWidget()),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                _result ?? '',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
            color: Colors.white,
            width: double.infinity,
            height: 250,
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: _predictClass,
                    child: const Icon(Icons.arrow_left)),
                const SizedBox(width: 100),
                ElevatedButton(
                    onPressed: _predictConfidence,
                    child: const Icon(Icons.arrow_right)),
              ],
            )))
      ],
    ));
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          webImage = bytes;
          _imageBytes = bytes;
          isRegisteredImage = true;
        });
      } else {
        final bytes = await File(pickedFile.path).readAsBytes();
        setState(() {
          selectedImage = File(pickedFile.path);
          _imageBytes = bytes;
          isRegisteredImage = true;
        });
      }
    }
  }

  Widget _buildImageWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        child: kIsWeb
            ? (webImage != null
                ? Image.memory(
                    webImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : const Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 50,
                    color: Colors.grey,
                  ))
            : (selectedImage != null
                ? Image.file(
                    selectedImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : const Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 50,
                    color: Colors.grey,
                  )),
      ),
    );
  }
}
