import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histora_admin/state/exceptions.dart';
import 'package:histora_admin/state/structure/models/structure.dart';
import 'package:histora_admin/state/structure/models/structure_meta.dart';
import 'package:histora_admin/state/structure/repository/upload_repository.dart';

part 'upload_event.dart';
part 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final UploadRepository repository;
  UploadBloc(this.repository) : super(UploadInitial()) {
    on<StartUpload>(uploadData);
  }

  uploadData(StartUpload event, Emitter emit) async {
    Structure structure = event.structure;
    emit(UploadingAsset());
    try {
      final downloadUrls = await repository.uploadAsset(
          images: structure.images, id: structure.id);
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
      final uploadedDetails = await repository.uploadStructure(revisedStructure);

      if(!uploadedDetails) {
        emit(const UploadFailed(message: 'Failed to upload structure details'));
        return;
      }

      emit(UploadSuccess());

    } on CustomException catch (e) {
      emit(UploadFailed(message: e.message));
    }
  }
}
