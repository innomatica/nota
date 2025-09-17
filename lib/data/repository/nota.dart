import '../../models/notaitem.dart' show NotaItem;
import '../../models/notatag.dart' show NotaTag;
import '../../shared/settings.dart' show sampleItems, sampleTags;
import '../service/db/sqflite.dart';

class NotaRepository {
  final SqliteService _db;

  NotaRepository({required SqliteService db}) : _db = db;

  // nota item
  Future<int> createItem(NotaItem item) async {
    final data = item.toDbMap();
    final keys = data.keys.join(',');
    final vals = data.values.toList();
    final args = List.filled(vals.length, "?").join(',');
    return await _db.insert("""INSERT INTO items ($keys)
      VALUES ($args)""", vals);
  }

  Future<List<NotaItem>> getItems() async {
    // return sampleItems;
    final rows = await _db.queryAll("SELECT * FROM items");
    return rows.map((e) => NotaItem.fromDbMap(e)).toList();
  }

  Future<NotaItem?> getItem(int itemId) async {
    final row = await _db.query("SELECT * FROM items WHERE id = ?", [itemId]);
    return row != null ? NotaItem.fromDbMap(row) : null;
  }

  Future<bool> updateItem(NotaItem item) async {
    final data = item.toDbMap();
    final id = data.remove('id');
    final args = data.keys.map((e) => "$e = ?").join(",");
    final vals = data.values.toList();
    final count = await _db.update("UPDATE items SET $args WHERE id = ?", [
      ...vals,
      id,
    ]);
    return count == 1;
  }

  Future<bool> deleteItem(int itemId) async {
    final count = await _db.delete("DELETE FROM items WHERE id = ?", [itemId]);
    return count == 1;
  }

  Future<bool> setCompleted(int itemId) async {
    final count = await _db.update(
      "UPDATE items SET completed = 1 WHERE id=?",
      [itemId],
    );
    return count == 1;
  }

  Future<bool> clearCompleted(int itemId) async {
    final count = await _db.update(
      "UPDATE items SET completed = 0 WHERE id=?",
      [itemId],
    );
    return count == 1;
  }

  // nota tag

  Future<int> createTag(NotaTag tag) async {
    final map = tag.toDbMap();
    final keys = map.keys.join(',');
    final vals = map.values.toList();
    final args = List.filled(vals.length, "?").join(',');
    return await _db.insert("""INSERT INTO tags ($keys)
      VALUES ($args)""", vals);
  }

  Future<List<NotaTag>> getTags() async {
    // return sampleTags;
    final rows = await _db.queryAll("SELECT * FROM tags");
    return rows.map((e) => NotaTag.fromDbMap(e)).toList();
  }

  Future purgeTags() async {
    await _db.execute("DELETE FROM tags");
  }

  // sample data

  Future createSampleItems() async {
    for (final item in sampleItems) {
      await createItem(item);
    }

    for (final tag in sampleTags) {
      await createTag(tag);
    }
  }

  /*
  NotaLogic() {
    initialSetup();
  }

  final _items = <NotaItem>[];
  final _tags = <NotaTag>[];
  final _db = SqliteService();
  final _notification = NotificationService();
  late final SharedPreferences _prefs;
  int? _currentTagId;

  List<NotaItem> get items => _items;
  List<NotaTag> get tags => _tags;
  int? get currentTagId => _currentTagId;
  NotaItem get newItem => NotaItem.fromNew();
  NotaTag get newTag => NotaTag.fromNew();

  Future initialSetup() async {
    _prefs = await SharedPreferences.getInstance();
    _currentTagId = _prefs.getInt('currentTagId');
    if (_currentTagId == -1) {
      _currentTagId = null;
    }
    await refreshTags();
    await refreshItems();
  }

  //
  // NotaItems
  //
  Future refreshItems() async {
    debugPrint('notalogic:refreshItems');
    _items.clear();
    // get items
    final items = await _db.getNotaItems(query: {'orderBy': '"title" ASC'});

    // collect active items first
    for (final item in items) {
      if ((_currentTagId == null || item.tagIds.contains(_currentTagId)) &&
          !item.completed) {
        _items.add(item);
      }
    }

    // then collect completed items
    for (final item in items) {
      if ((_currentTagId == null || item.tagIds.contains(_currentTagId)) &&
          item.completed) {
        _items.add(item);
      }
    }

    // handle expired or completed alarm
    for (final item in _items) {
      // debugPrint('refreshItem: $item');
      clearExpiredAlarm(item);
    }
    notifyListeners();
  }

  // add
  Future addNotaItem(NotaItem item) async {
    await _db.addNotaItem(item);
    await _updateNotification(item);
    refreshItems();
  }

  // update
  Future updateNotaItem(NotaItem item) async {
    // debugPrint('updateNotaItem: $item');
    await _db.updateNotaItem(item);
    if (item.alarm.isUpdated == true) {
      await _updateNotification(item);
      item.alarm.isEnabled = false;
    }
    refreshItems();
  }

  // delete
  Future deleteNotaItem(NotaItem item) async {
    // debugPrint('deleteNotaItem: $item');
    await _db.deleteNotaItem(item);
    await _cancelNotification(item);
    refreshItems();
  }

  // complete
  Future completeNotaItem(NotaItem item) async {
    if (item.completed) {
      item.completed = false;
    } else {
      item.completed = true;
      // set alarm to false
      item.alarm.isEnabled = false;
      item.alarm.isUpdated = true;
      // cancel notification
      // await _notification.cancelNotification(item.alarm.alarmId);
    }
    await updateNotaItem(item);
  }

  // tag id for the current view
  Future setCurrentTagId(int? id) async {
    _currentTagId = id;
    await _prefs.setInt('currentTagId', _currentTagId ?? -1);
    await refreshItems();
  }

  //
  // NotaTags
  //
  Future refreshTags() async {
    _tags.clear();
    _tags.addAll(await _db.getNotaTags(query: {'orderBy': '"title" ASC'}));

    for (final tag in tags) {
      // debugPrint('refreshTags.tag:$tag');
      clearExpiredAlarm(tag);
    }
    notifyListeners();
  }

  // add
  Future addNotaTag(NotaTag tag) async {
    await _db.addNotaTag(tag);
    await _updateNotification(tag);
    refreshTags();
  }

  // update
  Future updateNotaTag(NotaTag tag) async {
    // debugPrint('updateTag.tag:$tag');
    await _db.updateNotaTag(tag);
    if (tag.alarm.isUpdated == true) {
      tag.alarm.isUpdated = false;
      await _updateNotification(tag);
    }
    refreshTags();
  }

  // delete
  Future deleteNotaTag(NotaTag tag) async {
    await _db.deleteNotaTag(tag);
    await _cancelNotification(tag);
    // change current tag id if required
    if (_currentTagId == tag.id) {
      _currentTagId = null;
    }
    refreshTags();

    // remove the tag from the items
    final items = await _db.getNotaItems();
    for (final item in items) {
      item.tagIds.remove(tag.id);
      await _db.updateNotaItem(item);
    }
    refreshItems();
  }

  // sample tags
  Future createSampleTags() async {
    for (final tag in sampleTags) {
      tag.id = null;
      // need to set null if you want to call it again
      // debugPrint('tag:$tag');
      await _db.addNotaTag(tag);
    }
    refreshTags();
  }

  Future createSampleItems() async {
    for (final item in sampleItems) {
      item.id = null;
      await _db.addNotaItem(item);
    }
    refreshItems();
  }

  //
  // Alarm
  //
  String? validateAlarm(NotaObject object) {
    /*
    // if (object is NotaItem) {
    if (object.alarm.isEnabled) {
      if (object.alarm.when == null) {
        return 'alarm is not specified explicitely';
      } else if (object.alarm.when!
          .isBefore(DateTime.now().add(const Duration(minutes: 1)))) {
        return 'alarm should be in the future';
      }
    }
    // } else if (object is NotaTag) {
    // }
    */
    return null;
  }

  //
  // helpers
  //

  // clear expired alarm
  void clearExpiredAlarm(NotaObject object) async {
    // clear one-off then expired alarm
    if (object.alarm.isEnabled &&
        object.alarm.match == null &&
        object.alarm.when != null &&
        DateTime.now()
            .add(const Duration(minutes: 1))
            .isAfter(object.alarm.when!)) {
      object.alarm.isEnabled = false;
      debugPrint('clearExpiredAlarm: $object');
      // await _notification.cancelNotification(object.alarm.alarmId);
      // update object without calling refresh
      if (object is NotaItem) {
        await _db.updateNotaItem(object);
      } else if (object is NotaTag) {
        await _db.updateNotaTag(object);
      }
    }
  }

  // cancel notification
  Future _cancelNotification(NotaObject object) async {
    debugPrint('_cencelNotification: $object');
    _notification.cancelNotification(object.alarm.alarmId);
  }

  // update notifcation
  Future _updateNotification(NotaObject object) async {
    // cancel existing notification unconditionally
    _notification.cancelNotification(object.alarm.alarmId);
    // setup a new one if necessary
    if (object.alarm.isEnabled && object.alarm.when != null) {
      debugPrint('_updateNotification.schedule: $object');
      _notification.scheduleNotification(
        id: object.alarm.alarmId,
        when: object.alarm.when!,
        title: object.title,
        match: object.alarm.match,
      );
    }
  }
  */
}
