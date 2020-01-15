import 'dart:async';
import 'dart:io';

import 'package:copyapp_example/components/auto_view.dart';
import 'package:copyapp_example/components/edit_frame.dart';
import 'package:copyapp_example/config.dart';
import 'package:copyapp_example/pages/auto_page.dart';
import 'package:copyapp_example/tooler/alert_tooler.dart';
import 'package:copyapp_example/tooler/channel_tooler.dart';
import 'package:copyapp_example/tooler/string_tooler.dart';
import 'package:copyapp_example/tooler/toast_tooler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core.dart';

class SystemPage extends StatefulWidget {
  @override
  _SystemPageState createState() => _SystemPageState();
}

class _SystemPageState extends State<SystemPage> with AutomaticKeepAliveClientMixin implements SystemListener {
  GlobalKey _autoKey = GlobalKey();

  bool _running = false;
  bool _auto = Core.instance.isAutoDownload;
  var _movie;
  var _copyData = "暂无数据";

  int toastTimer = 0;
  Timer tid;
  
  Future<void> _update() async{

  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    
    _getRunning();
    Core.instance.channelTooler.listen(this);
  }

   @override
  onReceive(obj) {
    setState(() {
      _copyData = obj;
    });
//    ToastTooler.toast(context, msg: "数据已经复制", position: ToastPostion.bottom);

     if(tid != null){
       tid.cancel();
       toastTimer++;
     }
     tid = new Timer(Duration(seconds: 1), (){
       Core.instance.channelTooler.toast("数据已经复制($toastTimer)");
       toastTimer = 0;
     });
  }

  void _getRunning() async{
    var res = await Core.instance.channelTooler.getRunning();
    setState(() {
      _running = res;
    });
  }

  void _setRunning(c) async{
    await Core.instance.channelTooler.setRunning(c);
    setState(() {
      _running = c;
    });
  }

  void init() async{
    List<Map> movies = await Core.instance.sqlTooler.movies();
    for(var i = 0; i < movies.length; i++){
      if(movies[i]["video"] == null){
        setState(() {
          _movie = movies[i];
        });
        break;
      }
    }
    
  }
  

  void _autoDownload(){
    Core.instance.isAutoDownload = true;
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => AutoPage(
              key: _autoKey
            )
        )
    );
  }

  void _resetSystem(){
    AlertTooler.show(context, (n){
      if(n){
        Core.instance.reset();
      }
    }, "提示", "是否要删除全部数据？");
    
  }

   void _checkRunning() async{
    var res = await Core.instance.channelTooler.checkRunning();
    ToastTooler.toast(context, msg: res);
  }

  void _addData() async{
    // await Core.instance.sqlTooler.add("驾培🏅戴教练发了一个快手作品，一起来看！ http://kphshanghai.m.chenzhongtech.com/s/xNbMeYmE 复制此链接，打开【快手】直接观看！");
    
    // RegExp reg = new RegExp(r"一起来看！ (http\S+) 复制此链接");
    String data = "#在抖音，记录美好生活#你们理想中的女朋友体重是多少呢？￼ https://v.douyin.com/qncYPB/ 复制此链接，打开【抖音短视频】，直接观看视频！";
    var list = StringTooler.getData(data);
    if(list.length == 2){
      await Core.instance.sqlTooler.add(list[0], list[1]);
      // _update();
    }
  }

  void _scanFiles(){
    Core.instance.downloadTooler.scanFiles();
  }

  void _findNoVideo() async{
    var res = await Core.instance.sqlTooler.moviesNoVideo();
  }

  void _findSameVideo() async{
    var aim = "https://v.douyin.com/qncYPB/";
    var total = 0;
    List list = await Core.instance.sqlTooler.movies();
    for(var i = 0; i < list.length; i++){
      if(list[i]["link"] == aim){
        total++;
      }
    }
  }

  Widget _getSwitch(title, tip, value, onChanged){
    return Container(
              padding: EdgeInsets.only(left: 20, top: 15, right: 10, bottom: 15),
              child: Row(children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(title),
                      Container(
                        child: Text(tip, style: TextStyle(color: Colors.black26),),
                        margin: EdgeInsets.only(top: 5),
                      )
                    ],
                  ),
                  flex: 1,
                ),
                CupertinoSwitch(
                  value: value,
                  onChanged: onChanged,
                )
              ],),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black12, width: ScreenUtil().setWidth(1)))
              ),
            );
  }

  Widget _getItem(title, tip, onPressed){
    return Container(
              padding: EdgeInsets.only(left: 20, top: 10, right: 15, bottom: 10),
              child: Row(
                children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(title),
                      Container(
                        child: Text(tip, style: TextStyle(color: Colors.black26),),
                        margin: EdgeInsets.only(top: 5),
                      )
                    ],
                  ),
                  flex: 1,
                ),
                FlatButton.icon(
                    onPressed: (){onPressed();},
                    icon: Icon(Icons.add_to_home_screen, color: Colors.white, size: 16,),
                    label: Text("运行", style: TextStyle(color: Colors.white),),
                    color: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                ),
              ],),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black12, width: ScreenUtil().setWidth(1)))
              ),

            );
  }

  @override
  Widget build(BuildContext context) {

    super.build(context);
    
    // TODO: implement build
    return EditFrame(
      title: Config.system,
      tip: "edit",
      canEdit: false,
      onRefresh: _update,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _getSwitch("系统服务", "侦听系统剪贴板复制操作", _running, _setRunning),
            _getItem("自动下载", "自动下载视频", _autoDownload),
            _getItem("调用系统方法", "检测原生系统调用是否正常", _checkRunning),
            _getItem("数据重置", "清空数据库数据", _resetSystem),
            _getItem("添加数据", "添加一条测试数据", _addData),
            _getItem("扫描数据", "扫描文件系统下面的视频", _scanFiles),
            _getItem("查找空数据", "查看所有未下载的视频数据", _findNoVideo),
            _getItem("查找重复数据", "查看重复数据的数目", _findSameVideo),
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Text(_copyData)
            )
            
          ]
        )
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}