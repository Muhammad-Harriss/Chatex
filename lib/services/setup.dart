import 'package:get_it/get_it.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/services/cloud_storage_service.dart';
import 'package:chat_app/services/media_service.dart';
import 'package:chat_app/services/navigation_service.dart';

void setupServices() {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton<NavigationService>(() => NavigationService());
  getIt.registerLazySingleton<DatabaseService>(() => DatabaseService());
  getIt.registerLazySingleton<CloudStorageService>(() => CloudStorageService());
  getIt.registerLazySingleton<MediaService>(() => MediaService());
}
