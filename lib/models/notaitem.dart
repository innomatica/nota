import 'notaalarm.dart';
import 'notaobject.dart';

class NotaItem extends NotaObject {
  int? id;
  String? content;
  bool completed;
  List<int> tagIds;
  DateTime createdAt;

  NotaItem({
    required super.title,
    super.alarm,
    this.id,
    this.content,
    required this.completed,
    required this.tagIds,
    required this.createdAt,
  });

  factory NotaItem.fromDbMap(Map<String, Object?> map) {
    return NotaItem(
      id: map['id'] as int, // primary key not null
      title: map['title'] as String,
      content: map['content'] as String?,
      completed: (map['completed'] as int) == 1,
      alarm: NotaAlarm.fromDbObject(map['alarm']),
      tagIds: (map['tag_ids'] as String).isNotEmpty
          ? (map['tag_ids'] as String)
                .split(',')
                .map((e) => int.parse(e))
                .toList()
          : [],
      createdAt:
          DateTime.tryParse(map['created_at'] as String) ?? DateTime.now(),
    );
  }

  factory NotaItem.fromNew() {
    return NotaItem(
      title: '',
      completed: false,
      alarm: NotaAlarm.fromNew(),
      tagIds: [],
      createdAt: DateTime.now(),
    );
  }

  NotaItem copyWith(String newTitle) {
    return NotaItem(
      title: newTitle,
      content: content,
      completed: completed,
      alarm: alarm,
      tagIds: tagIds,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'completed': completed ? 1 : 0,
      'alarm': alarm?.toDbObject(),
      'tag_ids': tagIds.join(','),
      'created_at': createdAt.toIso8601String(),
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
      'createAt': createdAt.toIso8601String(),
    }.toString();
  }
}
