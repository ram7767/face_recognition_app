import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../network/network_info.dart';
import '../constants/api_constants.dart';
import '../../data/datasources/face_recognition_remote_datasource.dart';
import '../../data/repositories/face_recognition_repository_impl.dart';
import '../../domain/repositories/face_recognition_repository.dart';
import '../../domain/usecases/register_user_usecase.dart';
import '../../domain/usecases/verify_user_usecase.dart';
import '../../presentation/providers/face_recognition_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => Logger());
  sl.registerLazySingleton(
    () => Dio()
      ..options = BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: Duration(milliseconds: ApiConstants.connectTimeout),
        receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
      ),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // Data sources
  sl.registerLazySingleton<FaceRecognitionRemoteDataSource>(
    () => FaceRecognitionRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<FaceRecognitionRepository>(
    () => FaceRecognitionRepositoryImpl(sl(), sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => RegisterUserUseCase(sl()));
  sl.registerLazySingleton(() => VerifyUserUseCase(sl()));

  // Providers
  sl.registerFactory(() => FaceRecognitionProvider(sl(), sl()));
}
