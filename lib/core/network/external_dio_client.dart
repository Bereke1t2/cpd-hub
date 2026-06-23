import 'package:dio/dio.dart';

/// Creates a bare [Dio] instance for calling external APIs (Codeforces,
/// LeetCode, AtCoder, etc.) — no auth interceptor, no backend error mapping.
Dio createExternalDio() {
  return Dio(BaseOptions(
    connectTimeout: const Duration(milliseconds: 10000),
    receiveTimeout: const Duration(milliseconds: 15000),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));
}
