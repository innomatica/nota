import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotaAlarm {
  int alarmId;
  bool isEnabled;
  bool? isUpdated; // ephemeral flag not to be saved to or retrieved from db
  DateTime? when;
  DateTimeComponents? match;

  NotaAlarm({
    required this.alarmId,
    required this.isEnabled,
    this.isUpdated,
    this.when,
    this.match,
  });

  NotaAlarm copyWith({
    int? alarmId,
    bool? isEnabled,
    bool? isUpdated,
    DateTime? when,
    DateTimeComponents? match,
  }) {
    return NotaAlarm(
      alarmId: alarmId ?? this.alarmId,
      isEnabled: isEnabled ?? this.isEnabled,
      isUpdated: isUpdated ?? this.isUpdated,
      when: when ?? this.when,
      match: match ?? this.match,
    );
  }

  bool notEqual(NotaAlarm other) =>
      (isEnabled != other.isEnabled || when != when || match != match);

  String toDbObject() {
    return jsonEncode({
      'alarmId': alarmId,
      'isEnabled': isEnabled ? 1 : 0,
      'when': when?.toIso8601String(),
      'match': match?.name,
    });
  }

  factory NotaAlarm.fromDbObject(Object? object) {
    if (object is String) {
      final map = jsonDecode(object);
      return NotaAlarm(
        alarmId: map?['alarmId'] ?? _getAlarmId(),
        isEnabled: map?['isEnabled'] == 1 ? true : false,
        isUpdated: false, // initial value
        when: map?['when'] is String ? DateTime.parse(map['when']) : null,
        match: map?['match'] is String
            ? DateTimeComponents.values
                .firstWhere((e) => e.name == map['match'])
            : null,
      );
    } else {
      return NotaAlarm(
        alarmId: _getAlarmId(),
        isEnabled: false,
      );
    }
  }

  factory NotaAlarm.fromNew() {
    return NotaAlarm(
      alarmId: _getAlarmId(),
      isEnabled: false,
    );
  }

  static int _getAlarmId() {
    return (DateTime.now().millisecondsSinceEpoch) % (0x80000000);
  }

  @override
  String toString() {
    return {
      'alarmId': alarmId,
      'isEnabled': isEnabled,
      'isUpdated': isUpdated,
      'when': when?.toIso8601String(),
      'match': match?.name,
    }.toString();
  }
}
