// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/1/17
// Time  : 19:26
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:monthlycalendar/core/error/failures.dart';
import 'package:monthlycalendar/core/error/exceptions.dart';

///
/// 抽象用例类
/// [Type] 用例(正确的)返回值类型
/// [Params] 用例的参数类型
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

///
/// 网络请求用例
/// 用途: 所有需要访问网络的操作都经过这里,这样可以统一处理网络Error
/// 注意: 继承类 logic()方法内只允许 try..on XXException catch(),
/// 没有 on catch到的异常将交给 NetUseCase处理
mixin NetUseCase<T, P> on UseCase<T, P> {
  @override
  Future<Either<Failure, T>> call(P params) async {
    try {
      // 注意, 这里一定要 await,否则异常无法 catch
      return await logic(params);
    } on UserOperateException catch (e) {
      return Left(UserOperateFailure(e.msg));
    } on DioError catch (e) {
      return Left(NetworkFailures(msg: e.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, T>> logic(P params);
}

///
/// 显然, 有时候用例并不需要参数
/// 因此它的泛型为 NoneParams
class NoneParams {
  @override
  // ignore: hash_and_equals
  bool operator ==(other) => true;
}
