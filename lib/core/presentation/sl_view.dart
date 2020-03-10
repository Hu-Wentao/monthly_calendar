// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/3/2
// Time  : 18:09
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

/// sl_view 2.3.0
/// _AbsView | _AbsViewState
/// ViewModel | View | _ViewState

final sl = GetIt.instance;
/// 构造方法类型
typedef WidgetBuilder<VM> = Widget Function(BuildContext ctx, VM m);
typedef WidgetReadyBuilder<VM> = Widget Function(BuildContext ctx, VM m);

///-----------------------------------------------------------------------------
///
/// TODO: 后期可能需要使用 HOOK 插件来完成 在SlView中使用 TextField等功能
/// 抽象SlView
abstract class _AbsSlView<VM extends BaseViewModel> extends StatefulWidget {
  _AbsSlView({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SlViewState<VM, SlView<VM>>();
}

/// 抽象SlViewSate
/// [VM] View所绑定的ViewModel
/// [V] ViewState所绑定的View
abstract class _ABsSlViewState<VM extends BaseViewModel,
V extends _AbsSlView<VM>> extends State<V> {
  /// ViewState初始化时
  @mustCallSuper
  void onStateInit() {
    sl<VM>().addListener(update);
  }

  /// ViewState释放时
  @mustCallSuper
  void onStateDispose() {
    sl<VM>().removeListener(update);
  }

  /// 刷新内部状态
  update() => setState(() => {});

  @override
  void initState() {
    onStateInit();
    super.initState();
  }

  @override
  void dispose() {
    onStateDispose();
    super.dispose();
  }
}

///-----------------------------------------------------------------------------
/// VM 的状态
/// [unknown] 只有需要 异步init()的VM才需要这个状态
/// [idle]    非异步VM的初始状态, 或者异步init的VM 初始化完成后的状态
/// [blocking] VM正在执行某个方法, 并且尚未执行完毕, 此时VM已阻塞,将忽略任何方法调用
enum VmState {
  unknown,
  idle,
  blocking,
}

///
/// 基础Model
abstract class BaseViewModel extends ChangeNotifier {
  VmState _vmState = VmState.unknown;

  /// 检查是否处于阻塞状态,如果是,则返回true,
  /// 如果否,则同时设置VM状态为Running
  ///
  /// ```dart
  ///   void incrementCounter() {
  ///     // check里面同时执行了 setVMRunning;
  ///     if (checkAndSetBlocking) return;
  ///
  ///     ... method body ...
  ///
  ///     notifyAndSetIdle;
  ///   }
  /// ```
  bool get checkAndSetBlocking {
    final isBlocking = _vmState != VmState.idle;
    if (!isBlocking) setVMBlocking;
    return isBlocking;
  }

  /// <组合> 通知监听者的同时,将VM设为Idle
  get notifyAndSetIdle {
    setVMIdle;
    notifyListeners();
  }

  /// <原子> 设置VM状态为 Running
  get setVMBlocking => _vmState = VmState.blocking;

  /// <原子> 设置VM状态为 Idle
  get setVMIdle => _vmState = VmState.idle;

  /// 默认的 onError函数, 直接通过Toast展示
  onError(String msg, {Duration durationSec: const Duration(seconds: 4)}) {
    BotToast.showText(text: '出错啦!\n $msg', duration: durationSec);
  }
}

///
/// 配合Get_it使用的view基类
/// 参数:
///   [VM]表示Model
class SlView<VM extends BaseViewModel> extends _AbsSlView<VM> {
  final WidgetBuilder builder;
  final WidgetBuilder error;

  SlView({
    Key key,
    this.builder,
    this.error,
  }) : super(key: key);
}

class _SlViewState<VM extends BaseViewModel, V extends SlView<VM>>
    extends _ABsSlViewState<VM, V> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(context, sl<VM>());
  }
}

///-----------------------------------------------------------------------------
///
/// 带有 "signalsReady: true" 的基础Model
abstract class ReadyViewModel extends BaseViewModel implements WillSignalReady {
  // 继承类在执行构造的时候, 会自动执行本类构造,即执行 init()方法
  ReadyViewModel() {
    init();
  }

  /// 是否阻止方法执行
  ///
  /// 详细介绍请见 super类中的[checkAndSetBlocking]
  @override
  bool get checkAndSetBlocking {
    // 是否已经准备完成(未完成则阻止,返回true)
    final isNotReady = !sl.isReadySync(instance: this);
    final isVMBlocking = super.checkAndSetBlocking;
    return (isNotReady || isVMBlocking);
  }

  /// init() 方法表示注册完成,因此继承类必须在初始化完成之后才能调用super.init()
  /// 如果想在View被展示之前就预先初始化,则可以在外部同步或异步方式调用本方法
  /// 例如:
  /// ```dart
  /// @singleton // 务必使用单例模式注解 <不建议使用@lazySingleton>
  /// class TestModel extends BaseReadyModel {
  ///   @override
  ///   init() {
  ///     return Future.delayed(Duration(seconds: 2)).then((value) => super.init());
  ///   }
  /// }
  /// ```
  @mustCallSuper
  Future<bool> init() async {
    // 先设为 idle,然后再标记 ready
    setVMIdle;
    sl.signalReady(this);
    return true;
  }
}

///
/// 配合Get_it使用的, <带有Ready的view基类>
/// 参数:
///   [VM]表示Model,需要继承[ReadyViewModel]
///
/// 条件:
class ReadySlView<VM extends ReadyViewModel> extends _AbsSlView<VM> {
  final Widget Function(BuildContext ctx) loading;
  final WidgetReadyBuilder<VM> builder;
  final Widget Function(BuildContext ctx, dynamic error) error;

  ReadySlView({
    @required this.loading,
    @required this.builder,
    @required this.error,
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _ReadySlViewState<VM, ReadySlView<VM>>();
}

class _ReadySlViewState<VM extends ReadyViewModel, V extends ReadySlView<VM>>
    extends _ABsSlViewState<VM, V> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<VM>(
      future: sl.isReady<VM>().then((_) => sl<VM>()),
      builder: (ctx, snap) {
        if (snap.hasData) {
          return widget.builder(context, snap.data);
        } else if (snap.hasError) {
          return widget.error(context, snap.error);
        } else {
          return widget.loading(context);
        }
      },
    );
  }

  ///
  /// 本类只覆写 onInit的"addListener"步骤,本类的继承类仍需call super
  /// 因为[_AbsSlView]的 onInit()没有等待[VM]初始化完成
  @override
  // ignore: must_call_super
  void onStateInit() {
    sl.isReady<VM>().then((_) => sl<VM>().addListener(update));
  }
}
