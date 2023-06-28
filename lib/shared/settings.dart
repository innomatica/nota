// urls for app
import '../model/notatag.dart';
import '../model/notaalarm.dart';

const urlPrivacyPolicy = 'https://innomatica.github.io/nota/privacy/';
const urlDisclaimer = 'https://innomatica.github.io/nota/disclaimer/';
const urlInstruction = 'https://innomatica.github.io/nota/manual/';
// icon
const attAppIconSource = 'Notes icons created by Freepik - Flaticon';
const urlAppIconSource = 'https://www.flaticon.com/free-icon/notes_752326';
// store image
const attStoreImageSource = 'Glenn Carstens-Peters on Unsplash';
const urlStoreImageSource = 'https://unsplash.com/@glenncarstenspeters';

// default tolerances for the region matching
// one degree is roughly 111,139 meters? (111km)
const defaultTolLng = 0.001;
const defaultTolLat = 0.001;

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
      title: 'Farm Boy',
      color: NotaTag.tagColors[5],
      alarm: NotaAlarm.fromNew()),
  NotaTag(
      title: 'Food Basics',
      color: NotaTag.tagColors[5],
      alarm: NotaAlarm.fromNew()),
  NotaTag(
      title: 'Saturday CleanUp',
      color: NotaTag.tagColors[3],
      alarm: NotaAlarm.fromNew()),
  NotaTag(
      title: 'Moonshot Ideas',
      color: NotaTag.tagColors[8],
      alarm: NotaAlarm.fromNew()),
  NotaTag(
      title: 'Weekly Workout',
      color: NotaTag.tagColors[1],
      alarm: NotaAlarm.fromNew()),
  NotaTag(
      title: 'Meeting Deadlines',
      color: NotaTag.tagColors[11],
      alarm: NotaAlarm.fromNew()),
];
