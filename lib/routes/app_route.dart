//  buat nyimpan nama routenya
part of 'app_pages.dart';

abstract class Routes {
  static const HOME = _Paths.HOME;
  static const NEWS_DETAIL = _Paths.NEWS_DETAIL;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const NEWS_DETAIL = '/news-detail';
}