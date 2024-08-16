import 'dart:io';

import 'package:flutter/material.dart';
import 'package:histora_admin/state/utils/pick_images.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';

class UploadForm extends StatefulWidget {
  const UploadForm({super.key});

  @override
  State<UploadForm> createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final historyController = TextEditingController();

  List<File>? images;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextField(
          controller: titleController,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: 'Title'),
        ),
        TextField(
          controller: descController,
          maxLength: 200,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: 'Description'),
        ),
        TextField(
          controller: historyController,
          maxLength: 1000,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: 'History'),
        ),
        const SizedBox(height: 30),
        TextButton(
          onPressed: () async {
            final files = await PickImages.pickImages();
            print(files);
          },
          child: Text('Get images'),
        ),
        if (images != null) ...images!.map((image) => Image.file(image)),
      ],
    );
  }
}
