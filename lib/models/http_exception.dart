class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return 'When the http request was sent this was the error message:\n$message';
  }
}
