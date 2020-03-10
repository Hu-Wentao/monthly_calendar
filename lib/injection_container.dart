// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/3/10
// Time  : 16:09
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection_container.iconfig.dart';

///
/// 依赖注入容器
@injectableInit
Future<void> initInjection({@required String env}) async {
  return await $initGetIt(GetIt.instance, environment: env);
}