import 'package:image_picker/image_picker.dart';
import 'dart:math';

class PickImages {
  static Future<List<XFile>> pickImages() async {
    try {
      final files = await ImagePicker()
          .pickMultiImage(maxHeight: 600, maxWidth: 600, imageQuality: 30);

      for (var file in files) {
        print(await _getFileSize(file, 2));
      }
      return files;
    } catch (e) {
      return [];
    }
  }

  static _getFileSize(XFile file, int decimals) async {
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}
