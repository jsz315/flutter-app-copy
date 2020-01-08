import 'package:copyapp_example/tooler/event_tooler.dart';

import './tooler/channel_tooler.dart';
import './tooler/download_tooler.dart';
import './tooler/sql_tooler.dart';

class Core {
  // 工厂模式 : 单例公开访问点
  factory Core() => _getInstance();

  static Core get instance => _getInstance();

  // 静态私有成员，没有初始化
  static Core _instance;

  SqlTooler sqlTooler;
  DownloadTooler downloadTooler;
  ChannelTooler channelTooler;
  EventTooler eventTooler;

  // 私有构造函数
  Core._internal() {
    
  }

  void init() async {
    channelTooler = new ChannelTooler();
    channelTooler.init();

    sqlTooler = new SqlTooler();
    await sqlTooler.init();

    downloadTooler = new DownloadTooler();
    downloadTooler.init();

    eventTooler = new EventTooler();
  }

  void reset(){
    sqlTooler.reset();
  }

  // 静态、同步、私有访问点
  static Core _getInstance() {
    if (_instance == null) {
      _instance = new Core._internal();
    }
    return _instance;
  }
}