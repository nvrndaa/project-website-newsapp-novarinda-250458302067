import 'package:get/get.dart';
import 'package:news_app/controllers/news_controller.dart';

// tempat untuk daftarin controller yang hanya di pake di home page, biar ga kepake di page lain
// binding punya fungsi wajib yaitu dependency
class HomeBinding implements Bindings{
  @override
  void dependencies(){
    // get.lazy put biar controller nya cuma dibuat saat dibutuhkan
    // jadi ngga langsung dibuat saat app jalan, tapi baru dibuat saat home page diakses
    Get.lazyPut<NewsController>(() => NewsController());
  }
} 