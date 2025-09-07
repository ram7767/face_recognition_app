import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../domain/entities/user.dart';
import '../../domain/entities/verification_result.dart';
import '../../domain/usecases/register_user_usecase.dart';
import '../../domain/usecases/verify_user_usecase.dart';

class FaceRecognitionProvider extends ChangeNotifier {
  final RegisterUserUseCase registerUserUseCase;
  final VerifyUserUseCase verifyUserUseCase;

  FaceRecognitionProvider(
    this.registerUserUseCase,
    this.verifyUserUseCase,
  );

  bool _isLoading = false;
  String? _errorMessage;
  User? _registeredUser;
  VerificationResult? _verificationResult;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get registeredUser => _registeredUser;
  VerificationResult? get verificationResult => _verificationResult;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> registerUser({
    required String name,
    required String email,
    required String phone,
    required File image,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await registerUserUseCase(
        name: name,
        email: email,
        phone: phone,
        image: image,
      );

      result.fold(
        (failure) {
          _setError(failure.message);
          _registeredUser = null;
        },
        (user) {
          _registeredUser = user;
          _setError(null);
        },
      );
    } catch (e) {
      _setError('An unexpected error occurred: ${e.toString()}');
      _registeredUser = null;
    }

    _setLoading(false);
  }

  Future<void> verifyUser(File image) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await verifyUserUseCase(image);

      result.fold(
        (failure) {
          _setError(failure.message);
          _verificationResult = null;
        },
        (verificationResult) {
          // Debug print to check the image data
          debugPrint(
            'Verification result received: ${verificationResult.toString()}',
          );
          debugPrint('Raw image data: ${verificationResult.imageWithBoxes}');

          // Process the image data if needed
          final processedImageData = _processImageData(
            verificationResult.imageWithBoxes,
          );
          debugPrint('Processed image data: $processedImageData');

          // Create a new VerificationResult with the processed image data
          _verificationResult = VerificationResult(
            verified: verificationResult.verified,
            user: verificationResult.user,
            message: verificationResult.message,
            imageWithBoxes: processedImageData,
          );


          _setError(null);
        },
      );
    } catch (e) {
      _setError('An unexpected error occurred: ${e.toString()}');
      _verificationResult = null;
    }

    _setLoading(false);
  }

  // Helper method to process image data
  String? _processImageData(String? imageData) {
    if (imageData == null) return null;

    // If the image data is a base64 string without the prefix
    if (!imageData.startsWith('data:image') && !imageData.startsWith('http')) {
      try {
        // Check if it's valid base64
        base64.decode(imageData);
        // Add the data URI prefix
        return 'data:image/jpeg;base64,$imageData';
      } catch (e) {
        debugPrint('Invalid base64 image data: $e');
        return null;
      }
    }

    return imageData;
  }
}
