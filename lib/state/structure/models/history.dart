import 'dart:collection';

class History extends MapView<String, dynamic> {
  final String history;

  History({required this.history})
      : super({
          'history': history,
        });
}
