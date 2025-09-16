import 'package:fast_location/src/shared/storage/app_storage.dart';
import 'package:flutter/material.dart';
import 'src/routes/app_routes.dart';
import 'src/modules/initial/page/initial_page.dart';
import 'src/modules/home/page/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStorage.init();
  runApp(const FastLocationApp());
}

class FastLocationApp extends StatelessWidget {
  const FastLocationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FastLocation',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
