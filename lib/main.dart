import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:logging/logging.dart' show Logger, Level;
import 'package:provider/provider.dart' show MultiProvider;

import 'shared/constants.dart' show appName;
import 'shared/dependencies.dart' show providers;
import 'shared/routes.dart' show router;

void main() {
  Logger.root.level = kDebugMode ? Level.FINE : Level.WARNING;
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print(
      '\u001b[1;33m${record.loggerName}.${record.level.name}: ${record.time}: ${record.message}\u001b[0m',
    );
  });

  runApp(MultiProvider(providers: providers, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: appName,
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
