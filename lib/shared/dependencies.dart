import 'package:nota/data/service/db/sqflite.dart';
import 'package:provider/provider.dart';

import '../data/repository/nota.dart' show NotaRepository;
import '../pages/home/model.dart';
import '../pages/item/model.dart';

final providers = [
  Provider(create: (context) => SqliteService()),
  Provider(
    create: (context) => NotaRepository(db: context.read<SqliteService>()),
  ),
  ChangeNotifierProvider(
    create: (context) => HomeViewModel(repo: context.read<NotaRepository>()),
  ),
  ChangeNotifierProvider(
    create: (context) => ItemViewModel(repo: context.read<NotaRepository>()),
  ),
];
