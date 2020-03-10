// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/1/17
// Time  : 22:59
import 'package:dio/dio.dart';

///
/// 服务器出错
class ServerException implements Exception {
  final Response rsp;

  ServerException(this.rsp);

  @override
  String toString() => 'ServerException:\n$rsp';
}

///
/// 本地缓存,数据库等出错
class CacheException implements Exception {}

///
/// UserFeature内部异常
/// todo 待完善
class UserOperateException implements Exception{
  final String msg;

  UserOperateException(String msg):this.msg = "用户相关操作异常：$msg";
}

/// GameFeature内部异常
// 设置状态时发生错误, 例如仓库存储数量小于0
// 或者在用例中的前提条件错误, 例如某用例只有在生产线为idle时才能调用
class InvalidStateException implements Exception {
  final String msg;

  InvalidStateException(String msg) : this.msg = '状态异常: $msg';
}

// 找不到指定实例, 例如通过id找不到对应的车间
class InstanceNotFoundException implements Exception {
  final String msg;

  InstanceNotFoundException(String msg) : this.msg = '找不到实例: $msg';
}
