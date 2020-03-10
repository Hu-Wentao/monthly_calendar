// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/1/17
// Time  : 0:08

import 'package:equatable/equatable.dart';

import 'exceptions.dart';

abstract class Failure extends Equatable {
  final String msg;

  Failure(this.msg);

  @override
  List<Object> get props => [this.msg];

  @override
  String toString() => 'Failure{msg: $msg}';
}

///
/// 需要向后台报告的问题 -说明代码逻辑出错\表示层不合理\用户作弊
/// todo 考虑自动向服务器发送错误报告, (包括用户操作状态等日志)
abstract class NeedFeedbackFailure extends Failure {
  NeedFeedbackFailure(String msg) : super('$msg 请向我们反馈问题!');
// 反馈问题, 添加一个 记录日志的仓库, 然后feedback方法提供一个该仓储的参数,添加错误日志,然后反馈
//  void feedback(){}
}

///
/// 服务器返回值异常(服务端程序导致的异常)
class ServerFailure extends NeedFeedbackFailure {
  ServerFailure(ServerException se)
      : super('服务器返回:${se.rsp.toString()}');
}

///
/// 网络错误,连不上服务器(可能是用户没联网)
class NetworkFailures extends Failure {
  NetworkFailures({String msg}) : super('NetworkFailures: $msg');
}

///
/// 本地缓存出错(HIVE出错)
class CacheFailures extends Failure {
  CacheFailures({String msg}) : super('CacheFailures: $msg');
}

///======= 用户Feature错误
// todo 需要根据状态码 400， 401 等进行完善
class UserOperateFailure extends Failure{
  UserOperateFailure(String msg) : super(msg);

}
///
/// 用户没登陆
class NoLoginFailures extends Failure {
  NoLoginFailures() : super('您还没有登陆');
}

///======= 游戏内错误, 考虑放到 features/game/failures中
///
/// 游戏流程错误, 一般是因为表示层调用了不应该调用的操作
/// 也可能是需要用户重输参数
/// todo 考虑自动向服务器发送错误报告, (包括用户操作状态等日志)
/// todo 考虑参数全部改为 Exception e, 而不是当前的 String msg
class GameFlowFailure extends NeedFeedbackFailure {
  GameFlowFailure({String msg}) : super('[游戏流程出错!]: $msg');
}

// 可能是非法输入\逻辑层出错\表示层出错
class InvalidInputFailure extends NeedFeedbackFailure {
  InvalidInputFailure(String msg) : super('[输入非法参数!]:$msg');
}

// 用户合法的输入, 只是参数无效
class InvalidInputWithoutFeedbackFailure extends Failure {
  InvalidInputWithoutFeedbackFailure(String msg) : super('[请重输参数]:$msg');
}

// 该功能尚未完成错误
class FeatDevelopingFailure extends NeedFeedbackFailure {
  FeatDevelopingFailure(String className) : super('[$className]功能正在开发中!');
}

// 未知错误
class UnknownFailure extends NeedFeedbackFailure {
  UnknownFailure(String msg) : super('未知错误[$msg]');
}
