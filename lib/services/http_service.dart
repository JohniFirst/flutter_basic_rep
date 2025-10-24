import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// 网络请求服务类，提供统一的HTTP请求功能
class HttpService {
  /// 基础URL
  static const String baseUrl = 'http://192.168.11.94:3001';
  
  /// 请求超时时间（毫秒）
  static const int timeoutMs = 30000;
  
  /// 单例实例
  static final HttpService _instance = HttpService._internal();
  
  /// HTTP客户端
  final http.Client _client = http.Client();
  
  /// 私有构造函数
  HttpService._internal();
  
  /// 获取单例实例
  factory HttpService() {
    return _instance;
  }
  
  /// 获取默认请求头
  Map<String, String> _getDefaultHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // 可以在这里添加token等通用头信息
      // 'Authorization': 'Bearer ${AuthService.getToken()}',
    };
  }
  
  /// 构建完整的URL
  String _buildUrl(String endpoint) {
    // 如果endpoint已经是完整URL，则直接返回
    if (endpoint.startsWith('http://') || endpoint.startsWith('https://')) {
      return endpoint;
    }
    
    // 确保baseUrl末尾没有斜杠，endpoint开头没有斜杠
    final cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
    
    return '$cleanBaseUrl/$cleanEndpoint';
  }
  
  /// 通用请求方法
  Future<Map<String, dynamic>> _request(
    String method,
    String endpoint,
    dynamic data,
    Map<String, String>? customHeaders,
    Map<String, dynamic>? queryParameters,
  ) async {
    try {
      // 构建基础URL
      final baseUrl = _buildUrl(endpoint);
      
      // 合并默认头和自定义头
      final headers = {..._getDefaultHeaders()};
      if (customHeaders != null) {
        headers.addAll(customHeaders);
      }
      
      // 创建URI对象，处理查询参数
      Uri uri;
      if (queryParameters != null && queryParameters.isNotEmpty) {
        // 创建带查询参数的URI
        uri = Uri.parse(baseUrl).replace(
          queryParameters: queryParameters.map((key, value) => MapEntry(key, value.toString())),
        );
      } else {
        uri = Uri.parse(baseUrl);
      }
      
      // 创建请求
      http.Request request = http.Request(method, uri);
      request.headers.addAll(headers);
      
      // 添加请求体数据
      if (data != null) {
        request.body = json.encode(data);
      }
      
      // 发送请求并设置超时
      final response = await _client.send(request).timeout(
        Duration(milliseconds: timeoutMs),
        onTimeout: () {
          throw Exception('请求超时，请检查网络连接');
        },
      );
      
      // 读取响应体
      final responseBody = await response.stream.bytesToString();
      
      // 解析JSON响应
      Map<String, dynamic>? responseData;
      try {
        responseData = json.decode(responseBody);
      } catch (e) {
        // 如果响应不是有效JSON，返回原始字符串
        return {
          'success': false,
          'data': responseBody,
          'message': '响应格式无效',
          'statusCode': response.statusCode,
        };
      }
      
      // 根据状态码判断请求是否成功
      final success = response.statusCode >= 200 && response.statusCode < 300;
      
      return {
        'success': success,
        'data': responseData,
        'statusCode': response.statusCode,
        'message': responseData?['message'] ?? (success ? '请求成功' : '请求失败'),
      };
    } catch (e) {
      // 处理网络错误
      if (kDebugMode) {
        print('网络请求错误: $e');
      }
      
      String errorMessage = '请求失败';
      
      if (e is SocketException) {
        errorMessage = '网络连接失败，请检查网络设置';
      } else if (e is TimeoutException) {
        errorMessage = e.message ?? '请求超时';
      } else {
        errorMessage = '请求失败: $e';
      }
      
      return {
        'success': false,
        'data': null,
        'message': errorMessage,
        'statusCode': null,
      };
    }
  }
  
  /// GET请求
  Future<Map<String, dynamic>> get(
    String endpoint,
    {Map<String, dynamic>? queryParameters,
     Map<String, String>? headers,
    }) async {
    // 直接传递原始endpoint和参数，让_request方法正确处理
    return await _request('GET', endpoint, null, headers, queryParameters);
  }
  
  /// POST请求
  Future<Map<String, dynamic>> post(
    String endpoint,
    dynamic data,
    {Map<String, String>? headers,
     Map<String, dynamic>? queryParameters,
    }) async {
    return await _request('POST', endpoint, data, headers, queryParameters);
  }
  
  /// PUT请求
  Future<Map<String, dynamic>> put(
    String endpoint,
    dynamic data,
    {Map<String, String>? headers,
     Map<String, dynamic>? queryParameters,
    }) async {
    return await _request('PUT', endpoint, data, headers, queryParameters);
  }
  
  /// DELETE请求
  Future<Map<String, dynamic>> delete(
    String endpoint,
    {dynamic data,
     Map<String, String>? headers,
     Map<String, dynamic>? queryParameters,
    }) async {
    return await _request('DELETE', endpoint, data, headers, queryParameters);
  }
  
  /// PATCH请求
  Future<Map<String, dynamic>> patch(
    String endpoint,
    dynamic data,
    {Map<String, String>? headers,
     Map<String, dynamic>? queryParameters,
    }) async {
    return await _request('PATCH', endpoint, data, headers, queryParameters);
  }
  
  /// 上传文件
  Future<Map<String, dynamic>> uploadFile(
    String endpoint,
    String filePath,
    String fieldName,
    {Map<String, String>? headers,
     Map<String, String>? additionalFields,
    }) async {
    try {
      final url = _buildUrl(endpoint);
      
      // 创建multipart请求
      final request = http.MultipartRequest('POST', Uri.parse(url));
      
      // 添加文件
      final fileStream = http.ByteStream(File(filePath).openRead());
      final fileLength = await File(filePath).length();
      final multipartFile = http.MultipartFile(
        fieldName,
        fileStream,
        fileLength,
        filename: filePath.split('/').last,
      );
      request.files.add(multipartFile);
      
      // 添加额外字段
      if (additionalFields != null) {
        request.fields.addAll(additionalFields);
      }
      
      // 添加请求头（不包括Content-Type，会自动设置为multipart/form-data）
      final defaultHeaders = _getDefaultHeaders();
      defaultHeaders.remove('Content-Type');
      request.headers.addAll(defaultHeaders);
      
      if (headers != null) {
        request.headers.addAll(headers);
      }
      
      // 发送请求
      final streamedResponse = await _client.send(request).timeout(
        Duration(milliseconds: timeoutMs * 2), // 文件上传给更长的超时
      );
      
      // 读取响应
      final responseBody = await streamedResponse.stream.bytesToString();
      final responseData = json.decode(responseBody);
      
      return {
        'success': streamedResponse.statusCode >= 200 && streamedResponse.statusCode < 300,
        'data': responseData,
        'statusCode': streamedResponse.statusCode,
        'message': responseData?['message'] ?? '上传完成',
      };
    } catch (e) {
      if (kDebugMode) {
        print('文件上传错误: $e');
      }
      
      return {
        'success': false,
        'data': null,
        'message': '文件上传失败: $e',
        'statusCode': null,
      };
    }
  }
  
  /// 清理资源
  void dispose() {
    _client.close();
  }
}