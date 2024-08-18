import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:histora_admin/state/exceptions.dart';
import 'package:histora_admin/state/structure/models/structure.dart';
import 'package:histora_admin/state/structure/models/structure_meta.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

abstract class UploadRepository {
  /// Throws [AssetUploadException] on error
  Future<List<String>> uploadAsset(
      {required List<XFile> images, required String id});

  /// Throws [MetaDataUploadException] on error
  Future<bool> uploadMeta(StructureMeta meta);

  /// Throws [StructureUploadException] on error
  Future<bool> uploadStructure(Structure structure);
}

class UploadRepositoryImpl implements UploadRepository {
  final FirebaseStorage storage;
  final FirebaseFirestore firestore;

  UploadRepositoryImpl({
    required this.storage,
    required this.firestore,
  });
  @override
  Future<List<String>> uploadAsset({
    required List<XFile> images,
    required String id,
  }) async {
    final List<String> downloadUrls = [];

    if (images.isEmpty) {
      throw AssetUploadExcecption(
          message: 'Empty list of image received for upload');
    }

    for (var image in images) {
      final name = basename(image.path);
      final ref = storage.ref().child('assets/$id/$name');
      try {
        await ref.putData(await image.readAsBytes(),
            SettableMetadata(contentType: 'image/jpeg'));
        final downloadUrl = await ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      } on FirebaseException catch (e) {
        throw AssetUploadExcecption(
            message: e.message ?? 'Error uploading image to database');
      } catch (e) {
        throw AssetUploadExcecption(
            message: 'Error uplaoding image to database');
      }
    }

    return downloadUrls;
  }

  @override
  Future<bool> uploadMeta(StructureMeta meta) async {
    try {
      await firestore.collection('metadata').add(meta);
      return true;
    } on FirebaseException catch (e) {
      throw MetaDataUploadException(
          message: e.message ?? 'Error uploading meta data to database');
    } catch (e) {
      throw MetaDataUploadException(
        message: 'Error uploading meta data to database',
      );
    }
  }

  @override
  Future<bool> uploadStructure(Structure structure) async {
    try {
      await firestore.collection('details').add(structure);
      return true;
    } on FirebaseException catch (e) {
      throw StructureUploadException(
          message: e.message ?? 'Error uploading structure data to database');
    } catch (e) {
      throw MetaDataUploadException(
        message: 'Error uploading structure data to database',
      );
    }
  }
}
