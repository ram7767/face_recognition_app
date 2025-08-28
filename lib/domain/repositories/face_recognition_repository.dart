import 'dart:io';
import '../entities/user.dart';
import '../entities/verification_result.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';

abstract class FaceRecognitionRepository {
  Future<Either<Failure, User>> registerUser({
    required String name,
    required String email,
    required String phone,
    required File image,
  });

  Future<Either<Failure, VerificationResult>> verifyUser(File image);
}
