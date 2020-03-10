// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/3/10
// Time  : 13:22

import 'package:flutter_test/flutter_test.dart';

main() {
  test('这里写测试的名称',(){
    print('main: 这里写测试代码');

    // 通过调用被测试的方法, 得到返回值 r
    var r = 'get result';

    // 下面这个是检查代码得到的结果与期望的结果是否一致
    // 这是与结果与期望值一致的情况, 右边的'get result'就是期望的返回值
    expect(r, 'get result');

    expect(r, '这里是与期望结果不一致的情况');
  });
}