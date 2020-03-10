// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/2/27
// Time  : 20:54


import 'package:dio/dio.dart';

///
/// 网络请求
abstract class INetworkRepo {

  Dio get dio;

  // 如 "http://www.shuttlecloud.cn"
  String get baseUrl;

  // 如 "/v1"
  String get apiVersion;

//  Map<String, dynamic> get headers =>{ContentType("application", "json")};

  /// 注册
  String get registerUrl;

  /// 登陆
  String get loginUrl;
}
