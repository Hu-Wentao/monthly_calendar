// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/3/10
// Time  : 15:45

import 'package:equatable/equatable.dart';

/// 1. 实体类: 本feature中的一切代码都围绕这里的实体类进行

///
/// 用户类
/// 1.1 Equatable是用于辅助覆写 "=="和"equals"方法的类
/// 继承自 Equatable的子类,其字段都必须是final类型的,
/// (因为 Equatable类被添加了@immutable注解)
/// 这里用户类只有用户名和密码两个属性
class User extends Equatable{

  final String name;
  final String password;

  User(this.name, this.password);

  @override
  // 1.1.2 使用Equatable的方式很简单, 只需要实现 props方法即可
  // 将本类中的所有字段都使用 [] 包裹,即表示 get props方法返回一个本类字段构成的数组
  // (显然, 这个数组是 dynamic类型的)
  List<Object> get props => [name, password];
}