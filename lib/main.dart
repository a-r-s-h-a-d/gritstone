import 'package:flutter/material.dart';
import 'package:gritstone/controller/home_controller.dart';
import 'package:gritstone/model/db/productmodel.dart';
import 'package:gritstone/view/screen_splash/screen_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProductModelAdapter());

  await Hive.openBox<ProductModel>('productBox');
  await Hive.openBox<ProductModel>('categoryBox');

  runApp(const MyApp());

  // Hive.close();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const ScreenSplash(),
      ),
    );
  }
}
