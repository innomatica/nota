import 'dart:math';

import 'package:flutter/material.dart';

import 'notaalarm.dart';
import 'notaobject.dart';

class NotaTag extends NotaObject {
  int? id;
  int color;
  // NotaAlarm alarm;

  NotaTag({
    this.id,
    required super.title,
    required this.color,
    required super.alarm,
  });

  factory NotaTag.fromDbMap(Map<String, Object?> map) {
    // debugPrint('tag.fromDbMap: $map');
    return NotaTag(
      id: map['id'] as int,
      title: map['title'] as String,
      color: map['color'] as int,
      alarm: NotaAlarm.fromDbObject(map['alarm']),
    );
  }

  factory NotaTag.fromNew() {
    return NotaTag(
      title: '',
      color: _getRandomColor(),
      alarm: NotaAlarm.fromNew(),
    );
  }

  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'title': title,
      'color': color,
      'alarm': alarm.toDbObject(),
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

  static get tagColors => _tagColors;

  static final _tagColors = [
    Colors.yellow.value, // 0
    Colors.blue.value, // 1
    Colors.brown.value, // 2
    Colors.cyan.value, // 3
    Colors.grey.value, // 4
    Colors.green.value, // 5
    Colors.indigo.value, // 6
    Colors.lime.value, // 7
    Colors.orange.value, // 8
    Colors.pink.value, // 9
    Colors.purple.value, // 10
    Colors.red.value, // 11
    Colors.teal.value, // 12
  ];
}
