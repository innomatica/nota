import 'package:flutter/material.dart';
import 'package:logging/logging.dart' show Logger;

import '../../data/repository/nota.dart';
import '../../models/notaitem.dart';
import '../../models/notatag.dart';

class ItemViewModel extends ChangeNotifier {
  final NotaRepository repo;
  ItemViewModel({required this.repo});
  NotaItem? _item;
  final _tags = <NotaTag>[];
  final _logger = Logger("ItemViewModel");

  NotaItem? get item => _item;
  List<NotaTag> get tags => _tags;

  Future load(int? itemId) async {
    _logger.fine("load:$itemId");
    if (itemId != null) {
      _item = await repo.getItem(itemId);
      _tags.clear();
      _tags.addAll(await repo.getTags());
      notifyListeners();
    }
  }

  void addTagToItem(int tagId) {
    if (item != null && !item!.tagIds.contains(tagId)) {
      _item!.tagIds.add(tagId);
    }
  }

  void removeTagFromItem(int tagId) {
    if (item != null && item!.tagIds.contains(tagId)) {
      _item!.tagIds.remove(tagId);
    }
  }

  Future<bool> updateItem() async {
    return await repo.updateItem(_item!);
  }

  Future<bool> deleteItem() async {
    return await repo.deleteItem(_item!.id!);
  }

  void createTag() {
    _tags.add(NotaTag.fromNew());
  }

  void deleteTag(int tagId) {
    _tags.removeWhere((e) => e.id == tagId);
  }

  Future updateTags() async {
    await repo.purgeTags();
    for (final tag in _tags) {
      await repo.createTag(tag);
    }
  }
}
