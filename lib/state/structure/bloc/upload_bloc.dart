import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histora_admin/state/exceptions.dart';
import 'package:histora_admin/state/structure/models/structure.dart';
import 'package:histora_admin/state/structure/models/structure_meta.dart';
import 'package:histora_admin/state/structure/repository/upload_repository.dart';
import 'package:uuid/uuid.dart';
import 'dart:developer' as dev;

import 'package:image_picker/image_picker.dart';

part 'upload_event.dart';
part 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final UploadRepository repository;
  UploadBloc(this.repository) : super(UploadInitial()) {
    on<StartUpload>(uploadData);
  }

  uploadData(StartUpload event, Emitter emit) async {
    Structure structure =
        event.structure.copyWith(id: event.structure.title + const Uuid().v4());
    emit(UploadingAsset());
    try {
      final downloadUrls =
          await repository.uploadAsset(images: event.files, id: structure.id);
      if (downloadUrls.isEmpty) {
        emit(const UploadFailed(message: 'Failed to upload assets'));
        return;
      }

      emit(UploadingMeta());
      final meta = StructureMeta.fromStructure(structure);
      final uploadedMeta = await repository.uploadMeta(meta);

      if (!uploadedMeta) {
        emit(const UploadFailed(message: 'Failed to upload meta'));
        return;
      }

      emit(UploadingDetails());
      final revisedStructure = structure.copyWith(images: downloadUrls);
      final uploadedDetails =
          await repository.uploadStructure(revisedStructure);

      if (!uploadedDetails) {
        emit(const UploadFailed(message: 'Failed to upload structure details'));
        return;
      }

      emit(UploadSuccess());
    } on CustomException catch (e) {
      emit(UploadFailed(message: e.message));
    }
  }

  @override
  void onTransition(Transition<UploadEvent, UploadState> transition) {
    super.onTransition(transition);
    dev.log(transition.toString());
  }
}
