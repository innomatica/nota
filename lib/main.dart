import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'logic/notalogic.dart';
import 'screen/home/home.dart';
import 'service/notification.dart';
import 'service/apptheme.dart';
import 'shared/constants.dart';

void main() async {
  // futter
  WidgetsFlutterBinding.ensureInitialized();

  // notification
  NotificationService().initialize();

  // app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotaLogic>(create: (_) => NotaLogic())
      ],
      child: DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          title: appName,
          theme: AppTheme.lightTheme(lightDynamic),
          darkTheme: AppTheme.darkTheme(darkDynamic),
          home: const HomePage(),
          debugShowCheckedModeBanner: false,
        );
      }),
    );
  }
}
