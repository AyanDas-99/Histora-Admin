part of 'upload_bloc.dart';

sealed class UploadEvent extends Equatable {
  const UploadEvent();

  @override
  List<Object> get props => [];
}

class StartUpload extends UploadEvent {
  final Structure structure;
  final List<XFile> files;

  const StartUpload({required this.structure, required this.files});
}
