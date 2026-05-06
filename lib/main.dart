import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/route_manager.dart';
import 'package:news_app/bindings/app_binding.dart';
import 'package:news_app/routes/app_pages.dart';

// buat daftar API key nya dari file .env
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'News App',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      initialRoute: AppPages.INITIAL, // halaman awal yang ditampilkan saat app dijalankan
      getPages: AppPages.routes,// daftar halaman yang ada di app, setiap halaman punya nama,
      initialBinding: AppBinding(),// binding yang dijalankan saat app dijalankan
      debugShowCheckedModeBanner: false,
    );
  }
}

