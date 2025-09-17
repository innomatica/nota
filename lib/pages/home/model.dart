import 'package:flutter/material.dart';
import 'package:logging/logging.dart' show Logger;
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repository/nota.dart' show NotaRepository;
import '../../models/notaitem.dart' show NotaItem;
import '../../models/notatag.dart' show NotaTag, ItemLayout;

class HomeViewModel extends ChangeNotifier {
  final NotaRepository repo;
  HomeViewModel({required this.repo}) {
    _init();
  }

  SharedPreferences? _prefs;
  final _items = <NotaItem>[];
  final _tags = <NotaTag>[];
  int? _currentTagId;
  // ignore: unused_field
  final _logger = Logger("HomeViewModel");

  List<NotaItem> get items => _currentTagId == null || _currentTagId == 0
      ? _items
      : _items.where((e) => e.tagIds.contains(_currentTagId)).toList();
  List<NotaTag> get tags => _tags;
  int? get currentTagId => _currentTagId;

  Future _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future load() async {
    _items.clear();
    _items.addAll(await repo.getItems());
    _items.sort((a, b) => a.title.compareTo(b.title));
    _tags.clear();
    _tags.addAll(await repo.getTags());
    // if no data whatsoever, fill it with samples
    if (_items.isEmpty && _tags.isEmpty) {
      await repo.createSampleItems();
      _items.addAll(await repo.getItems());
      _items.sort((a, b) => a.title.compareTo(b.title));
      _tags.addAll(await repo.getTags());
    }
    _currentTagId = _prefs?.getInt('currentTagId') ?? 0;
    // validate currentTagId
    if (_currentTagId! > _tags.length || _currentTagId! < 0) {
      _currentTagId = 0;
    }
    _logger.fine('tags:$_tags');

    notifyListeners();
  }

  Future setCurrentTagId(int? value) async {
    if (value != null) {
      _currentTagId = value;
      await _prefs?.setInt('currentTagId', value);
      notifyListeners();
    }
  }

  Future createNewItem(String? title) async {
    if (title != null && title.isNotEmpty) {
      await repo.createItem(
        NotaItem(
          title: title,
          completed: false,
          tagIds: _currentTagId == null ? [] : [_currentTagId!],
          createdAt: DateTime.now(),
        ),
      );
      load();
    }
  }

  Future deleteItem(int? itemId) async {
    if (itemId != null) {
      await repo.deleteItem(itemId);
      load();
    }
  }

  Future toggleCompleted(NotaItem item) async {
    if (item.id != null) {
      item.completed
          ? await repo.clearCompleted(item.id!)
          : await repo.setCompleted(item.id!);
      load();
    }
  }
}
