import 'package:get/get.dart';
import 'package:news_app/bindings/home_binding.dart';
import 'package:news_app/pages/detail_page.dart';
import 'package:news_app/pages/home_page.dart';

part 'app_route.dart';

class AppPages {
  AppPages._();
  //  halaman awal yang ditampilkan saat app dijalankan
  static const INITIAL = Routes.HOME;

  // daftar halaman yang ada di app, setiap halaman punya nama
  static final routes = [
    GetPage(name: _Paths.HOME, 
    page: () => HomePage(), 
    binding: HomeBinding(),
    ),

    GetPage(name: _Paths.NEWS_DETAIL, page: () => DetailPage()),
  ];
}