import 'package:flutter/material.dart' show Colors;

import '../models/notaalarm.dart' show NotaAlarm;
import '../models/notaitem.dart' show NotaItem;
import '../models/notatag.dart' show NotaTag, TagType;

const laterTimes = {
  // '5 min': Duration(minutes: 5),
  '10 min': Duration(minutes: 10),
  '30 min': Duration(minutes: 30),
  '1 hour': Duration(hours: 1),
  '2 hours': Duration(hours: 2),
  '3 hours': Duration(hours: 3),
  '6 hours': Duration(hours: 6),
  '12 hours': Duration(hours: 12),
};

final sampleTags = <NotaTag>[
  NotaTag(
    title: 'Grocery Shopping',
    color: NotaTag.tagColors[5],
    alarm: NotaAlarm.fromNew(),
    type: TagType.permanent,
  ),
  NotaTag(
    title: 'Moonshot Ideas',
    color: NotaTag.tagColors[8],
    alarm: NotaAlarm.fromNew(),
    type: TagType.temporary,
  ),
  NotaTag(
    title: 'Weekly Workout',
    color: NotaTag.tagColors[1],
    alarm: NotaAlarm.fromNew(),
    type: TagType.sequencial,
  ),
];

final defaultTag = NotaTag(
  id: 0,
  title: "All Items",
  color: Colors.white.toARGB32(),
  type: TagType.none,
);

final sampleItems = <NotaItem>[
  NotaItem(
    title: '1. Simple item with no content',
    completed: false,
    alarm: NotaAlarm.fromNew(),
    tagIds: [],
    createdAt: DateTime.now(),
  ),
  NotaItem(
    title: '2. Tap me to see details',
    content: 'Here you can edit contents, set up an alarm, and attach tags. ',
    completed: false,
    alarm: NotaAlarm.fromNew(),
    tagIds: [],
    createdAt: DateTime.now(),
  ),
  NotaItem(
    title: '3. Tap check button to toggle state',
    content:
        'Completed items are not deleted but are greyed out so that '
        'you can reuse it. To actually delete the item, tab and hold the '
        'item title.',
    completed: false,
    alarm: NotaAlarm.fromNew(),
    tagIds: [],
    createdAt: DateTime.now(),
  ),
  NotaItem(
    title: '4. Tap and hold to delete me',
    content:
        'Completed items are not deleted but are greyed out so that '
        'you can reuse it. To actually delete the item, tab and hold the '
        'item title.',
    completed: false,
    alarm: NotaAlarm.fromNew(),
    tagIds: [],
    createdAt: DateTime.now(),
  ),
  NotaItem(
    title: '5. How to attach tags',
    content:
        'Go to Tags page and create some tags. Then come back here. '
        'You should be able to see those tag below. '
        'You can display items per each tag or all at once. ',
    completed: false,
    alarm: NotaAlarm.fromNew(),
    tagIds: [],
    createdAt: DateTime.now(),
  ),
  NotaItem(
    title: '6. How to set up an alarm',
    content:
        'Tab on the Alarm to active alarm settings. You can set date and '
        'time individually or you can pick one of the predefined intervals',
    completed: false,
    alarm: NotaAlarm.fromNew(),
    tagIds: [],
    createdAt: DateTime.now(),
  ),
  NotaItem(
    title: '7. Create items via Share',
    content:
        'Nota understands "Share" feature of the Android. '
        'You can create items from Youtube, Chrome, or any other apps '
        'that can export data using "Share".',
    completed: false,
    alarm: NotaAlarm.fromNew(),
    tagIds: [],
    createdAt: DateTime.now(),
  ),
];
