sealed class CustomException implements Exception {
  final String _message;

  String get message => _message;

  CustomException({required String message}) : _message = message;
}

class AssetUploadExcecption extends CustomException {
  AssetUploadExcecption({required super.message});
}

class MetaDataUploadException extends CustomException {
  MetaDataUploadException({required super.message});
}

class StructureUploadException extends CustomException {
  StructureUploadException({required super.message});
}
