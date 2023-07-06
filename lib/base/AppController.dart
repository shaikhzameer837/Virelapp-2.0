class AppController {
  static final AppController _instance = AppController._internal();

  factory AppController() {
    return _instance;
  }

  AppController._internal();

  Map<String, dynamic> homeUrl = {};
}
