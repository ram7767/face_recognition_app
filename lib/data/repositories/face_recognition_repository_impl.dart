import 'dart:io';
import '../../domain/entities/user.dart';
import '../../domain/entities/verification_result.dart';
import '../../domain/repositories/face_recognition_repository.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../core/utils/either.dart';
import '../datasources/face_recognition_remote_datasource.dart';

class FaceRecognitionRepositoryImpl implements FaceRecognitionRepository {
  final FaceRecognitionRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  FaceRecognitionRepositoryImpl(this.remoteDataSource, this.networkInfo);

  @override
  Future<Either<Failure, User>> registerUser({
    required String name,
    required String email,
    required String phone,
    required File image,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.registerUser(
          name: name,
          email: email,
          phone: phone,
          image: image,
        );
        return Either.right(user);
      } on ServerException catch (e) {
        return Either.left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Either.left(NetworkFailure(e.message));
      }
    } else {
      return Either.left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, VerificationResult>> verifyUser(File image) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.verifyUser(image);
        return Either.right(result);
      } on ServerException catch (e) {
        return Either.left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Either.left(NetworkFailure(e.message));
      }
    } else {
      return Either.left(NetworkFailure('No internet connection'));
    }
  }
}
