import '../../domain/entities/verification_result.dart';
import 'user_model.dart';

class VerificationResultModel extends VerificationResult {
  VerificationResultModel({
    required super.verified,
    super.user,
    required super.message,
  });

  factory VerificationResultModel.fromJson(Map<String, dynamic> json) {
    return VerificationResultModel(
      verified: json['verified'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      message: json['message'],
    );
  }
}
