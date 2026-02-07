import 'package:flutter_dotenv/flutter_dotenv.dart';

class ServerConstant {
  static String get serverURL {
    final url = dotenv.env['SERVER_URL'];
    if (url == null || url.isEmpty) {
      throw Exception('SERVER_URL is not set in .env');
    }
    return url;
  }
}
