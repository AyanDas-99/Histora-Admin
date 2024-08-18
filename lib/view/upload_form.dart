import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histora_admin/state/structure/bloc/upload_bloc.dart';
import 'package:histora_admin/state/structure/models/history.dart';
import 'package:histora_admin/state/structure/models/structure.dart';
import 'package:histora_admin/state/utils/pick_images.dart';
import 'package:image_picker/image_picker.dart';

class UploadForm extends StatefulWidget {
  const UploadForm({super.key});

  @override
  State<UploadForm> createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final historyController = TextEditingController();
  final latController = TextEditingController();
  final lonController = TextEditingController();

  List<XFile>? images;

  Structure getStructure() {
    return Structure(
      id: '',
      title: titleController.text,
      description: descController.text,
      images: [],
      history: History(history: historyController.text),
      coordinate: (2, 2),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    historyController.dispose();
    latController.dispose();
    lonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 5,
            child: Container(
              color: Colors.grey.shade200,
              child: ListView(
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
                      setState(() {
                        images = files;
                      });
                    },
                    child: Text('Get images'),
                  ),
                  if (images != null)
                    ...images!.map((image) {
                      return Image.network(image.path);
                    }),
                ],
              ),
            )),
        const SizedBox(height: 10),
        Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey.shade200,
              child: Center(
                child: BlocConsumer<UploadBloc, UploadState>(
                  builder: (context, state) {
                    return switch (state) {
                      UploadInitial() => TextButton(
                          child: const Text('Upload'),
                          onPressed: () {
                            context.read<UploadBloc>().add(StartUpload(
                                structure: getStructure(), files: images!));
                          },
                        ),
                      UploadingAsset() => const Loader('Uploding assets...'),
                      UploadingMeta() => const Loader('Uploading meta data...'),
                      UploadingDetails() =>
                        const Loader('Uploading final details'),
                      UploadSuccess() => TextButton(
                          child: const Text('Upload'),
                          onPressed: () {
                            context.read<UploadBloc>().add(StartUpload(
                                structure: getStructure(), files: images!));
                          },
                        ),
                      UploadFailed() => TextButton(
                          child: const Text('Upload'),
                          onPressed: () {
                            context.read<UploadBloc>().add(StartUpload(
                                structure: getStructure(), files: images!));
                          },
                        ),
                    };
                  },
                  listener: (BuildContext context, UploadState state) {
                    switch (state) {
                      case UploadSuccess():
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text((('Upload successfull')))));
                      case UploadFailed():
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(((state).message))));
                      default:
                        break;
                    }
                  },
                ),
              ),
            )),
      ],
    );
  }
}

class Loader extends StatelessWidget {
  final String msg;
  const Loader(
    this.msg, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircularProgressIndicator(),
        Text(msg),
      ],
    );
  }
}
