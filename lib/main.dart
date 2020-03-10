import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'injection_container.dart';
import 'routes.gr.dart';

/// 配置当前开发环境
const curEnv = Environment.dev;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjection(env: curEnv);
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BotToastInit(
        child: MaterialApp(
          title: '月历',
          theme: ThemeData(primarySwatch: Colors.green),
          navigatorObservers: [BotToastNavigatorObserver()],
          onGenerateRoute: Router.onGenerateRoute,
          navigatorKey: Router.navigator.key,
        ),
      );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
      child: Text('hello world'),
    );
}
