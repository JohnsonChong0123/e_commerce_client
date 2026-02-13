import '/core/errors/exception.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Returns the base server URL from environment.
/// 
/// Fails fast if SERVER_URL is not configured.
class ServerConstant {
  static String get serverURL {
    final url = dotenv.env['SERVER_URL'];
    if (url == null || url.isEmpty) {
      throw ServerException('SERVER_URL is not set in .env');
    }
    return url;
  }
}
