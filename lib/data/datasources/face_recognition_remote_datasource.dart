import 'dart:io';
import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../models/verification_result_model.dart';
import '../../core/errors/exceptions.dart';
import '../../core/constants/api_constants.dart';

abstract class FaceRecognitionRemoteDataSource {
  Future<UserModel> registerUser({
    required String name,
    required String email,
    required String phone,
    required File image,
  });

  Future<VerificationResultModel> verifyUser(File image);
}

class FaceRecognitionRemoteDataSourceImpl
    implements FaceRecognitionRemoteDataSource {
  final Dio dio;

  FaceRecognitionRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> registerUser({
    required String name,
    required String email,
    required String phone,
    required File image,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'email': email,
        'phone': phone,
        'image': await MultipartFile.fromFile(image.path),
      });

      final response = await dio.post(
        ApiConstants.registerEndpoint,
        data: formData,
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to register user');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else {
        throw ServerException(e.message ?? 'Server error');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<VerificationResultModel> verifyUser(File image) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(image.path),
      });

      final response = await dio.post(
        ApiConstants.verifyEndpoint,
        data: formData,
      );

      if (response.statusCode == 200) {
        return VerificationResultModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to verify user');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else {
        throw ServerException(e.message ?? 'Server error');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
