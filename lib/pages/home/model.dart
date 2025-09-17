import 'package:flutter/material.dart';
import 'package:logging/logging.dart' show Logger;
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repository/nota.dart' show NotaRepository;
import '../../models/notaitem.dart' show NotaItem;
import '../../models/notatag.dart' show NotaTag;
import '../../shared/settings.dart' show defaultTag;

class HomeViewModel extends ChangeNotifier {
  final NotaRepository repo;
  HomeViewModel({required this.repo}) {
    _init();
  }

  SharedPreferences? _prefs;
  final _items = <NotaItem>[];
  final _tags = <NotaTag>[];
  NotaTag _currentTag = defaultTag;
  // ignore: unused_field
  final _logger = Logger("HomeViewModel");

  List<NotaItem> get items => _currentTag == defaultTag
      ? _items
      : _items.where((e) => e.tagIds.contains(_currentTag.id)).toList();
  List<NotaTag> get tags => _tags;
  NotaTag get currentTag => _currentTag;

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
    // add all items tag
    _tags.add(defaultTag);
    // retrieve tagId and layout
    try {
      final currentTagId = _prefs?.getInt('currentTagId');
      _currentTag = _tags.firstWhere((e) => e.id == currentTagId);
    } catch (e) {
      _currentTag = defaultTag;
    }

    _logger.fine('tags:$_tags');

    notifyListeners();
  }

  Future setCurrentTagId(int? value) async {
    if (value != null) {
      try {
        _currentTag = _tags.firstWhere((e) => e.id == value);
        await _prefs?.setInt('currentTagId', value);
        notifyListeners();
      } catch (e) {
        _currentTag = defaultTag;
      }
    }
  }

  Future createNewItem(String? title) async {
    if (title != null && title.isNotEmpty) {
      await repo.createItem(
        NotaItem(
          title: title,
          completed: false,
          tagIds: _currentTag == defaultTag ? [] : [_currentTag.id!],
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
