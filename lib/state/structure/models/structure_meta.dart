import 'dart:collection';
import 'package:histora_admin/state/structure/models/structure.dart';
import 'package:histora_admin/state/structure/typedefs/coordinate.dart';

class StructureMeta extends MapView<String, dynamic> {
  final String id;
  final Coordinate coordinate;

  StructureMeta({
    required this.id,
    required this.coordinate,
  }) : super({
          'id': id,
          'lat': coordinate.$1,
          'lon': coordinate.$2,
        });

  factory StructureMeta.fromStructure(Structure structure) {
    return StructureMeta(id: structure.id, coordinate: structure.coordinate);
  }
}
