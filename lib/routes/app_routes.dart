part of 'app_pages.dart';

abstract class AppRoutes {
  static const notFound = '/not-found';
  static const splash = '/splash';
  static const login = '/login';
  static const home = '/home';
  static const main = '/main';
}

extension RoutesExtension on String {
  String toRoute() => '/${toLowerCase()}';
}
