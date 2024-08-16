import 'dart:collection';
import 'package:histora_admin/state/structure/models/history.dart';
import 'package:histora_admin/state/structure/typedefs/coordinate.dart';

class Structure extends MapView<String, dynamic> {
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final History history;
  final Coordinate coordinate;

  Structure({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.history,
    required this.coordinate,
  }) : super({
          'id': id,
          'title': description,
          'images': images,
          'history': history.history,
          'lat': coordinate.$1,
          'lon': coordinate.$2,
        });

  Structure copyWith({
    String? title,
    String? description,
    List<String>? images,
    History? history,
    Coordinate? coordinate,
  }) {
    return Structure(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      images: images ?? this.images,
      history: history ?? this.history,
      coordinate: coordinate ?? this.coordinate,
    );
  }
}
