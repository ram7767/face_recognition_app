import 'user.dart';

class VerificationResult {
  final bool verified;
  final User? user;
  final String message;
  final String? imageWithBoxes; // New field for verification image

  VerificationResult({
    required this.verified,
    this.user,
    required this.message,
    this.imageWithBoxes, // Added to constructor
  });

  // Factory constructor to create from JSON
  factory VerificationResult.fromJson(Map<String, dynamic> json) {
    return VerificationResult(
      verified: json['verified'] ?? false,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      message: json['message'] ?? '',
      imageWithBoxes: json['imageWithBoxes'], // Map JSON field to property
    );
  }
}
