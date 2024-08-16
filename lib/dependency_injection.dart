import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:histora_admin/state/structure/bloc/upload_bloc.dart';
import 'package:histora_admin/state/structure/repository/upload_repository.dart';

final sl = GetIt.instance;

void init() {
  sl.registerFactory(() => UploadBloc(sl()));

  sl.registerLazySingleton<UploadRepository>(
    () => UploadRepositoryImpl(
      storage: sl(),
      firestore: sl(),
    ),
  );

  sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
}
