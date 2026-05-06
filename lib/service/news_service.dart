import 'dart:convert';
import 'package:news_app/models/news_response.dart';
import 'package:news_app/utils/constant.dart';
import 'package:http/http.dart' as http;

// Service ini buat ngambil data dari API
// nanti bakal dipanggil ke cnews controller buat diolah terus ditampilin ke UI
class NewsService {
  static const String _baseUrl = Constants.baseUrl;
  static final String _apiKey = Constants.apiKey;

  //  buat ngamil berita terbaru
  Future<NewsResponse> getTopHeadlines({
    String country = Constants.defaultCountry, //default negara
    String? category, // kategori optional
    int page = 1, //halaman pertama
    int pageSize = 20, // batas jumlah artikel per halaman
  }) async {
    try {
      final Map<String, String> queryParams = {
        'apiKey': _apiKey,
        'country': country,
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };

      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }

      // ini buat bikin URLrequest ke API dengan parameter yang udah disiapin
      final uri = Uri.parse(
        '$_baseUrl${Constants.topHeadlines}',
      ).replace(queryParameters: queryParams);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return NewsResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }


// function buat search 
Future<NewsResponse> searchNews({
  required String query,
  int page = 1,
  int pageSize = 20,
  String? sortBy
}) async{
  try {
    final Map<String, String> queryParams = {
        'apiKey': _apiKey,
        'q': query,
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };

       if (sortBy != null && sortBy.isNotEmpty) {
        queryParams['sortBy'] = sortBy;
      }

      final uri = Uri.parse(
        '$_baseUrl${Constants.everything}',
      ).replace(queryParameters: queryParams);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return NewsResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to search news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching news: $e');
    }
}
}