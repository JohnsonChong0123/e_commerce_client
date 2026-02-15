class ServerException implements Exception {
  final String message;
  const ServerException(this.message);

  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  final String message;
  const CacheException(this.message);

  @override
  String toString() => 'CacheException: $message';
}

class GoogleAuthException implements Exception {
  final String message;
  GoogleAuthException(this.message);
  
  @override
  String toString() => 'GoogleAuthException: $message';
}