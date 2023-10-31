import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'base_entity.dart';
import 'error_handle.dart';

/// 默认dio配置
Duration _connectTimeout = const Duration(seconds: 15);
Duration _receiveTimeout = const Duration(seconds: 15);
Duration _sendTimeout = const Duration(seconds: 10);
String _baseUrl = 'https://news-at.zhihu.com/api/4/'; //基础url
List<Interceptor> _interceptors = [];

/// 初始化Dio配置
void configDio({
  Duration? connectTimeout,
  Duration? receiveTimeout,
  Duration? sendTimeout,
  String? baseUrl,
  List<Interceptor>? interceptors,
}) {
  _connectTimeout = connectTimeout ?? _connectTimeout;
  _receiveTimeout = receiveTimeout ?? _receiveTimeout;
  _sendTimeout = sendTimeout ?? _sendTimeout;
  _baseUrl = baseUrl ?? _baseUrl;
  _interceptors = interceptors ?? _interceptors;
}

////////////////////////////////////////////////////////////////////////////////

typedef NetSuccessCallback<T> = Function(T data);
typedef NetSuccessListCallback<T> = Function(List<T> data);
typedef NetErrorCallback = Function(int code, String msg);

class DioUtils {
  factory DioUtils() => _singleton;

  DioUtils._() {
    final BaseOptions options = BaseOptions(
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
      sendTimeout: _sendTimeout,

      /// dio默认json解析，指定返回UTF8字符串，自己处理解析。也可以 Transformer 自定义
      responseType: ResponseType.plain,
      // responseType: ResponseType.json,
      validateStatus: (_) {
        return true;
      },
      baseUrl: _baseUrl,
      // contentType: Headers.formUrlEncodedContentType, // 适用于post form表单提交
    );
    _dio = Dio(options);

    /// 添加拦截器
    void addInterceptor(Interceptor interceptor) {
      _dio.interceptors.add(interceptor);
    }

    _interceptors.forEach(addInterceptor);
  }

  static final DioUtils _singleton = DioUtils._();
  static DioUtils get instance => DioUtils();
  static late Dio _dio;
  Dio get dio => _dio;

  Future<BaseEntity<T>> _request<T>(
    String method,
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    final Response<String> response = await _dio.request<String>(
      url,
      data: data,
      queryParameters: queryParameters,
      options: _checkOptions(method, options),
      cancelToken: cancelToken,
    );
    try {
      final String data = response.data.toString();
      final bool isCompute = !false && data.length > 10 * 1024;
      debugPrint('isCompute:$isCompute');
      final Map<String, dynamic> map =
          isCompute ? await compute(parseData, data) : parseData(data);
      return BaseEntity<T>.fromJson(map);
    } catch (e) {
      debugPrint(e.toString());
      return BaseEntity<T>(ExceptionHandle.parse_error, '数据解析错误！', null);
    }
  }

  Options _checkOptions(String method, Options? options) {
    options ??= Options();
    options.method = method;
    return options;
  }

  // Future
  Future<dynamic> requestNetwork<T>(
    Method method,
    String url, {
    NetSuccessCallback<T?>? onSuccess,
    NetErrorCallback? onError,
    Object? params,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    return _request<T>(
      method.value,
      url,
      data: params,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    ).then<void>((BaseEntity<T> result) {
      if (result.code == 0) {
        onSuccess?.call(result.data);
      } else {
        _onError(result.code, result.message, onError);
      }
    }, onError: (dynamic e) {
      final NetError error = ExceptionHandle.handleException(e);
      _onError(error.code, error.msg, onError);
    });
  }

  /// 统一处理(onSuccess返回T对象，onSuccessList返回 List<T>)  Stream
  void asyncRequestNetwork<T>(
    Method method,
    String url, {
    NetSuccessCallback<T?>? onSuccess,
    NetErrorCallback? onError,
    Object? params,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
  }) {
    Stream.fromFuture(_request<T>(
      method.value,
      url,
      data: params,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    )).asBroadcastStream().listen((result) {
      if (result.code == 0) {
        if (onSuccess != null) {
          onSuccess(result.data);
        }
      } else {
        _onError(result.code, result.message, onError);
      }
    }, onError: (dynamic e) {
      final NetError error = ExceptionHandle.handleException(e);
      _onError(error.code, error.msg, onError);
    });
  }

  void _onError(int? code, String msg, NetErrorCallback? onError) {
    if (code == null) {
      code = ExceptionHandle.unknown_error;
      msg = '未知异常';
    }
    // Log.e('接口请求异常： code: $code, mag: $msg');
    onError?.call(code, msg);
  }
}

Map<String, dynamic> parseData(String data) {
  return json.decode(data) as Map<String, dynamic>;
}

enum Method { get, post, put, patch, delete, head }

/// 使用拓展枚举替代 switch判断取值
extension MethodExtension on Method {
  String get value => ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD'][index];
}
