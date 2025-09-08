import 'notaalarm.dart';
import 'notaobject.dart';

class NotaItem extends NotaObject {
  int? id;
  String? content;
  bool completed;
  List<int> tagIds;

  NotaItem({
    required super.title,
    super.alarm,
    this.id,
    this.content,
    required this.completed,
    required this.tagIds,
  });

  factory NotaItem.fromDbMap(Map<String, Object?> map) {
    return NotaItem(
      id: map['id'] as int,
      title: map['title'] as String,
      content: map['content'] != null ? map['content'] as String : null,
      completed: (map['completed'] as int) == 1,
      alarm: NotaAlarm.fromDbObject(map['alarm']),
      tagIds: map['tagIds'] != null && map['tagIds'] != ''
          ? (map['tagIds'] as String)
                .split(',')
                .map((e) => int.parse(e))
                .toList()
          : [],
    );
  }

  factory NotaItem.fromNew() {
    return NotaItem(
      title: '',
      completed: false,
      alarm: NotaAlarm.fromNew(),
      tagIds: [],
    );
  }

  NotaItem copyWith(String newTitle) {
    return NotaItem(
      title: newTitle,
      content: content,
      completed: completed,
      alarm: alarm,
      tagIds: tagIds,
    );
  }

  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'completed': completed ? 1 : 0,
      'alarm': alarm?.toDbObject(),
      'tagIds': tagIds.join(','),
    };
  }

  @override
  String toString() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'completed': completed,
      'tagIds': tagIds,
      'alarm': alarm,
    }.toString();
  }
}
