// lib/presentation/screens/verification_result_screen.dart

import 'package:flutter/material.dart';
import 'dart:convert';
import '../../domain/entities/verification_result.dart';

class VerificationResultScreen extends StatelessWidget {
  final VerificationResult result;

  const VerificationResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          result.verified ? 'Verification Successful' : 'Verification Failed',
        ),
        backgroundColor: result.verified ? Colors.green : Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(result.message, style: const TextStyle(fontSize: 16)),
            if (result.verified && result.user != null) ...[
              const SizedBox(height: 24),
              const Text(
                'User Details:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${result.user!.name}'),
                      const SizedBox(height: 8),
                      Text('Email: ${result.user!.email}'),
                      const SizedBox(height: 8),
                      Text('Phone: ${result.user!.phone}'),
                    ],
                  ),
                ),
              ),
            ],
            if (result.imageWithBoxes != null) ...[
              const SizedBox(height: 24),
              const Text(
                'Verification Image:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildImage(result.imageWithBoxes!),
            ],
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imageData) {
    try {
      // Handle base64 encoded images
      if (imageData.startsWith('data:image')) {
        final base64String = imageData.split(',').last;
        final bytes = base64.decode(base64String);
        return Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.memory(bytes, fit: BoxFit.contain),
        );
      }
      // Handle network images
      else if (imageData.startsWith('http')) {
        return Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.network(
            imageData,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Text('Failed to load image'));
            },
          ),
        );
      }
      // Handle raw base64 without prefix
      else {
        final bytes = base64.decode(imageData);
        return Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.memory(bytes, fit: BoxFit.contain),
        );
      }
    } catch (e) {
      return const Text('Invalid image data');
    }
  }
}
