part of 'upload_bloc.dart';

sealed class UploadState extends Equatable {
  const UploadState();

  @override
  List<Object> get props => [];
}

final class UploadInitial extends UploadState {}

final class UploadingAsset extends UploadState {}

final class UploadingMeta extends UploadState {}

final class UploadingDetails extends UploadState {}

final class UploadSuccess extends UploadState {}

final class UploadFailed extends UploadState {
  final String message;

  const UploadFailed({required this.message});
}
