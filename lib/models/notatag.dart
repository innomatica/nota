import 'dart:math';

import 'package:flutter/material.dart';

import 'notaalarm.dart';
import 'notaobject.dart';

enum TagType { temporary, permanent, sequencial, none }

class NotaTag extends NotaObject {
  int? id;
  int color;
  TagType type;

  NotaTag({
    required super.title,
    super.alarm,
    this.id,
    required this.color,
    required this.type,
  });

  factory NotaTag.fromDbMap(Map<String, Object?> map) {
    return NotaTag(
      id: map['id'] as int, // primary key
      title: map['title'] as String,
      color: map['color'] as int,
      alarm: NotaAlarm.fromDbObject(map['alarm']),
      type: TagType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TagType.temporary,
      ),
    );
  }

  factory NotaTag.fromNew({
    int? id,
    String title = "New Tag",
    TagType type = TagType.temporary,
  }) {
    return NotaTag(
      id: id,
      title: title,
      color: _getRandomColor(),
      alarm: NotaAlarm.fromNew(),
      type: type,
    );
  }

  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'title': title,
      'color': color,
      'alarm': alarm?.toDbObject(),
      'type': type.name,
    };
  }

  @override
  String toString() {
    return {
      'id': id,
      'title': title,
      'color': color,
      'alarm': alarm,
      'type': type.name,
    }.toString();
  }

  static int _getRandomColor() {
    return _tagColors.elementAt(Random().nextInt(_tagColors.length));
  }

  static List<int> get tagColors => _tagColors;

  static final _tagColors = [
    Colors.yellow.toARGB32(), // 0
    Colors.blue.toARGB32(), // 1
    Colors.brown.toARGB32(), // 2
    Colors.cyan.toARGB32(), // 3
    Colors.grey.toARGB32(), // 4
    Colors.green.toARGB32(), // 5
    Colors.indigo.toARGB32(), // 6
    Colors.lime.toARGB32(), // 7
    Colors.orange.toARGB32(), // 8
    Colors.pink.toARGB32(), // 9
    Colors.purple.toARGB32(), // 10
    Colors.red.toARGB32(), // 11
    Colors.teal.toARGB32(), // 12
  ];
}
