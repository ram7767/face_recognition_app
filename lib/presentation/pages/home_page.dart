import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/image_utils.dart';
import '../providers/face_recognition_provider.dart';
import '../widgets/register_dialog.dart';
import '../widgets/result_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Recognition'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Consumer<FaceRecognitionProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.face, size: 100, color: Colors.deepPurple),
                const SizedBox(height: 32),
                const Text(
                  'Face Recognition App',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Register a new user or verify an existing user using face recognition',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 48),
                if (provider.isLoading)
                  const CircularProgressIndicator()
                else
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () => _showRegisterDialog(context),
                          icon: const Icon(Icons.person_add),
                          label: const Text('Register User'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () => _verifyUser(context),
                          icon: const Icon(Icons.verified_user),
                          label: const Text('Verify User'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (provider.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Card(
                      color: Colors.red.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.error, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                provider.errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                            IconButton(
                              onPressed: provider.clearError,
                              icon: const Icon(Icons.close, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showRegisterDialog(BuildContext context) {
    final provider = Provider.of<FaceRecognitionProvider>(
      context,
      listen: false,
    );
    showDialog(
      context: context,
      builder: (context) => ChangeNotifierProvider.value(
        value: provider,
        child: const RegisterDialog(),
      ),
    );
  }

  Future<void> _verifyUser(BuildContext context) async {
    final provider = Provider.of<FaceRecognitionProvider>(
      context,
      listen: false,
    );

    final File? image = await _showImageSourceDialog(context);
    if (image != null) {
      await provider.verifyUser(image);

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                VerificationResultScreen(result: provider.verificationResult!),
          ),
        );
      }
    }
  }

  Future<File?> _showImageSourceDialog(BuildContext context) async {
    return showDialog<File?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: const Text('Choose how you want to select the image'),
        actions: [
          TextButton(
            onPressed: () async {
              // don't pop the dialog before picking — pick first, then return the image
              final image = await ImageUtils.pickImageFromCamera();
              if (image != null) {
                Navigator.pop(context, image);
              } else {
                Navigator.pop(context);
              }
            },
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () async {
              final image = await ImageUtils.pickImageFromGallery();
              if (image != null) {
                Navigator.pop(context, image);
              } else {
                Navigator.pop(context);
              }
            },
            child: const Text('Gallery'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
