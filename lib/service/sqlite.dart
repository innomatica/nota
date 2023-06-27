import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../model/notaitem.dart';
import '../model/notatag.dart';

const databaseName = 'nota.db';
const databaseVersion = 1;

const tableNotaItems = 'items';
const tableNotaTags = 'tags';
const sqlCreateNotaItems = 'CREATE TABLE $tableNotaItems ('
    'id INTEGER PRIMARY KEY,'
    'title TEXT NOT NULL,'
    'content TEXT,'
    'completed INTEGER NOT NULL,'
    'alarm TEXT NOT NULL,'
    'tagIds TEXT)';
const sqlCreateNotaTags = 'CREATE TABLE $tableNotaTags ('
    'id INTEGER PRIMARY KEY,'
    'title TEXT NOT NULL,'
    'color INTEGER,'
    'alarm TEXT NOT NULL)';

const sqlCreateTables = [sqlCreateNotaItems, sqlCreateNotaTags];

class SqliteService {
  SqliteService._private();
  static final SqliteService _instance = SqliteService._private();
  factory SqliteService() {
    return _instance;
  }

  Database? _db;

  Future open() async {
    _db = await openDatabase(
      databaseName,
      version: databaseVersion,
      onCreate: (db, version) async {
        debugPrint('create tables');
        for (final sql in sqlCreateTables) {
          await db.execute(sql);
        }
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        debugPrint('upgrade database from $oldVersion to $newVersion');
      },
    );
  }

  Future close() async {
    await _db?.close();
  }

  Future<Database> getDatabase() async {
    if (_db == null) {
      await open();
    }
    return _db!;
  }

  //
  // NotaItem
  //
  Future<List<NotaItem>> getNotaItems({Map<String, Object?>? query}) async {
    final db = await getDatabase();
    final records = await db.query(
      tableNotaItems,
      distinct: query?['distinct'] as bool?,
      columns: query?['columns'] as List<String>?,
      where: query?['where'] as String?,
      whereArgs: query?['whereArgs'] as List<Object>?,
      groupBy: query?['groupBy'] as String?,
      having: query?['having'] as String?,
      orderBy: query?['orderBy'] as String?,
      limit: query?['limit'] as int?,
      offset: query?['offset'] as int?,
    );
    return records.map<NotaItem>((e) => NotaItem.fromDbMap(e)).toList();
  }

  Future<NotaItem?> getNotaItemById(int id) async {
    final db = await getDatabase();
    final records =
        await db.query(tableNotaItems, where: 'id = ?', whereArgs: [id]);
    return records.isNotEmpty ? NotaItem.fromDbMap(records.first) : null;
  }

  Future addNotaItem(NotaItem item) async {
    await updateNotaItem(item);
  }

  Future updateNotaItem(NotaItem item) async {
    final db = await getDatabase();

    if (item.id == null) {
      final id = await db.insert(
        tableNotaItems,
        item.toDbMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      item.id = id;
    } else {
      await db.update(
        tableNotaItems,
        item.toDbMap(),
        where: 'id = ?',
        whereArgs: [item.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future deleteNotaItem(NotaItem item) async {
    final db = await getDatabase();
    if (item.id != null) {
      await db.delete(
        tableNotaItems,
        where: 'id = ?',
        whereArgs: [item.id],
      );
    }
  }

  //
  // NoteTag
  //
  Future<List<NotaTag>> getNotaTags({Map<String, Object?>? query}) async {
    final db = await getDatabase();
    final records = await db.query(
      tableNotaTags,
      distinct: query?['distinct'] as bool?,
      columns: query?['columns'] as List<String>?,
      where: query?['where'] as String?,
      whereArgs: query?['whereArgs'] as List<Object>?,
      groupBy: query?['groupBy'] as String?,
      having: query?['having'] as String?,
      orderBy: query?['orderBy'] as String?,
      limit: query?['limit'] as int?,
      offset: query?['offset'] as int?,
    );
    return records.map<NotaTag>((e) => NotaTag.fromDbMap(e)).toList();
  }

  Future<NotaTag?> getNotaTagById(int id) async {
    final db = await getDatabase();
    final records =
        await db.query(tableNotaTags, where: 'id = ?', whereArgs: [id]);
    return records.isNotEmpty ? NotaTag.fromDbMap(records.first) : null;
  }

  Future addNotaTag(NotaTag tag) async {
    await updateNotaTag(tag);
  }

  Future updateNotaTag(NotaTag tag) async {
    final db = await getDatabase();
    if (tag.id == null) {
      final id = await db.insert(
        tableNotaTags,
        tag.toDbMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      tag.id = id;
    } else {
      await db.update(
        tableNotaTags,
        tag.toDbMap(),
        where: 'id = ?',
        whereArgs: [tag.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future deleteNotaTag(NotaTag tag) async {
    final db = await getDatabase();
    db.delete(
      tableNotaTags,
      where: 'id = ?',
      whereArgs: [tag.id],
    );
  }
}
