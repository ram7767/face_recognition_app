import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/verification_result.dart';
import '../../domain/usecases/register_user_usecase.dart';
import '../../domain/usecases/verify_user_usecase.dart';

class FaceRecognitionProvider extends ChangeNotifier {
  final RegisterUserUseCase registerUserUseCase;
  final VerifyUserUseCase verifyUserUseCase;

  FaceRecognitionProvider(this.registerUserUseCase, this.verifyUserUseCase);

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

    _setLoading(false);
  }

  Future<void> verifyUser(File image) async {
    _setLoading(true);
    _setError(null);

    final result = await verifyUserUseCase(image);

    result.fold(
      (failure) {
        _setError(failure.message);
        _verificationResult = null;
      },
      (verificationResult) {
        _verificationResult = verificationResult;
        _setError(null);
      },
    );

    _setLoading(false);
  }
}
