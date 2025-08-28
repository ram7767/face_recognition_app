import 'dart:io';
import '../entities/verification_result.dart';
import '../repositories/face_recognition_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';

class VerifyUserUseCase {
  final FaceRecognitionRepository repository;

  VerifyUserUseCase(this.repository);

  Future<Either<Failure, VerificationResult>> call(File image) async {
    return await repository.verifyUser(image);
  }
}
