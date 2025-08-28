import 'dart:io';
import '../entities/user.dart';
import '../repositories/face_recognition_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';

class RegisterUserUseCase {
  final FaceRecognitionRepository repository;

  RegisterUserUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String name,
    required String email,
    required String phone,
    required File image,
  }) async {
    return await repository.registerUser(
      name: name,
      email: email,
      phone: phone,
      image: image,
    );
  }
}
