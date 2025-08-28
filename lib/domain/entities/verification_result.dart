import 'user.dart';

class VerificationResult {
  final bool verified;
  final User? user;
  final String message;

  VerificationResult({
    required this.verified,
    this.user,
    required this.message,
  });
}
