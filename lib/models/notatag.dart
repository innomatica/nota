import 'dart:math';

import 'package:flutter/material.dart';

import 'notaalarm.dart';
import 'notaobject.dart';

class NotaTag extends NotaObject {
  int? id;
  int color;

  NotaTag({required super.title, super.alarm, this.id, required this.color});

  factory NotaTag.fromDbMap(Map<String, Object?> map) {
    return NotaTag(
      id: map['id'] as int,
      title: map['title'] as String,
      color: map['color'] as int,
      alarm: NotaAlarm.fromDbObject(map['alarm']),
    );
  }

  factory NotaTag.fromNew({int? id, String title = "New Tag"}) {
    return NotaTag(
      id: id,
      title: title,
      color: _getRandomColor(),
      alarm: NotaAlarm.fromNew(),
    );
  }

  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'title': title,
      'color': color,
      'alarm': alarm?.toDbObject(),
    };
  }

  @override
  String toString() {
    return {
      'id': id,
      'title': title,
      'color': color,
      'alarm': alarm,
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
