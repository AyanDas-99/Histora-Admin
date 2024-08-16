import 'dart:io';
import 'dart:developer' as dev;
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart' as image_picker;

class PickImages {
  static Future<List<File>> pickImages() async {
    try {
      final files =
          await image_picker.ImagePickerPlugin().getMultiImageWithOptions();
// TODO:Fix compression and image
      final compressedFiles =
          await Future.wait(files.map((file) => _getCompressed(file)));

      return compressedFiles.where((file) => file != null).toList()
          as List<File>;
    } catch (e) {
      return [];
    }
  }

  static Future<File?> _getCompressed(XFile file) async {
    ImageFile input =
        ImageFile(filePath: file.path, rawBytes: await file.readAsBytes());
    Configuration config = const Configuration(
      outputType: ImageOutputType.webpThenJpg,
      // can only be true for Android and iOS while using ImageOutputType.jpg or ImageOutputType.pngÏ
      useJpgPngNativeCompressor: false,
      // set quality between 0-100
      quality: 40,
    );

    final param = ImageFileConfiguration(input: input, config: config);
    final output = await compressor.compress(param);

    dev.log("Input size : ${input.sizeInBytes}");
    dev.log("Output size : ${output.sizeInBytes}");

    return File(output.filePath);
  }
}
