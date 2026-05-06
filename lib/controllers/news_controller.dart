import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:news_app/models/news_article.dart';
import 'package:news_app/service/news_service.dart';
import 'package:news_app/utils/constant.dart';

//jadi news controller ini dibuat untuk ngatur state atau data yang berkaitan dengan berita
class NewsController extends GetxController {
  final NewsService _newsService = NewsService();

  //default kategori
  //.obs itu buat bikin variabel reaktif, jadi setiap kali nilainya berubah,
  //UI yang terkait akan otomatis update
  final _selectedCategory = 'general'.obs;
  final _isLoading = false.obs;
  final _articles = <Article>[].obs;
  final _error = ''.obs;

  //getter buat ngambil nilai kategori yang dipilih
  String get selectedCategory => _selectedCategory.value;
  //ini diambil dari Constant.categories
  List<String> get categories => Constants.categories;
  bool get isLoading=> _isLoading.value;
  String get error => _error.value;
  List<Article> get articles => _articles;

  @override
  void onInit(){
    super.onInit();
    fetchTopHeadLines();
  }

  //fungsi buat ngubah kategori yang dipilih
  void selectCategory(String category) {
    if (_selectedCategory.value != category) {
      _selectedCategory.value = category;
      fetchTopHeadLines(category: category);
    }
  }

  //buat ngambil berita berdasarkan kategori yang dipilih
  Future<void> fetchTopHeadLines({String? category}) async {
    try {
      // setting loading dan error yang, yang awalnya false jadi true, dan errornya dikosongin
      _isLoading.value = true;
      _error.value = '';

     // kalo udah loading , nanti bakalan ngambil response dari news service bagian function getTopHeadlines
    //  dan artikelnya bakalan muncul sesuai dengan  kategori yang dipilih
      final response = await _newsService.getTopHeadlines(
        category: category ?? selectedCategory,
      );
      _articles.value = response.articles;
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Erorr',
        'Failed to Load news: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      // kalo udah ngambil data , loadingnya di set ke false lagi
      _isLoading.value = false;
    }
  }

  //buat refresh berita, misalnya pas user pull to refresh
  Future<void> refreshNews() async {
    await fetchTopHeadLines();
  }

  Future<void> searchNews (String query) async{
    if (query.isEmpty) return;
    try{
       _isLoading.value = true;
      _error.value = '';

      final response = await _newsService.searchNews(
         query: query);
      _articles.value = response.articles;
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Erorr',
        'Failed to search news: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      // kalo udah ngambil data , loadingnya di set ke false lagi
      _isLoading.value = false;
    }
  } 

}