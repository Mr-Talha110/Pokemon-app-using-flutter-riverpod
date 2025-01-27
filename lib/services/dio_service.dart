import 'package:dio/dio.dart';

class DioService {
  DioService();
  final _dio = Dio();

  Future<Response?> get(String path) async {
    Response res = await _dio.get(path);
    return res;
  }
}
