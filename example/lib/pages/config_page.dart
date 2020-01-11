import 'dart:async';
import 'dart:io';

import 'package:copyapp_example/components/auto_view.dart';
import 'package:copyapp_example/components/edit_frame.dart';
import 'package:copyapp_example/pages/auto_page.dart';
import 'package:copyapp_example/tooler/alert_tooler.dart';
import 'package:copyapp_example/tooler/channel_tooler.dart';
import 'package:copyapp_example/tooler/string_tooler.dart';
import 'package:copyapp_example/tooler/toast_tooler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core.dart';

class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> with AutomaticKeepAliveClientMixin implements SystemListener {
  GlobalKey _autoKey = GlobalKey();

  bool _running = false;
  bool _auto = Core.instance.isAutoDownload;
  var _movie;
  var _copyData = "暂无数据";
  
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
    print(obj);
    setState(() {
      _copyData = obj;
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
    print("当前下载数据");
    print(_movie);
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
    String data = "姗姗💗＠¥发了一个快手作品，一起来看！ http://kphshanghai.m.chenzhongtech.com/s/9ctVsLxo 复制此链接，打开【快手】直接观看！";
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
    print(res);
  }

  void _testTimer(){
    new Timer(Duration(seconds: 1), (){
      print("定时执行====");
    });
  }

  Widget _getSwitch(title, value, onChanged){
    return Container(
              padding: EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
              child: Row(children: <Widget>[
                Expanded(
                  child: Text(title),
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

  Widget _getItem(title, onPressed){
    return Container(
              padding: EdgeInsets.only(left: 20, top: 10, right: 15, bottom: 10),
              child: Row(
                children: <Widget>[
                Expanded(
                  child: Text(title),
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
      title: "系统",
      tip: "edit",
      canEdit: false,
      onRefresh: _update,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _getSwitch("系统服务", _running, _setRunning),
            _getItem("自动下载", _autoDownload),
            _getItem("调用系统方法", _checkRunning),
            _getItem("数据重置", _resetSystem),
            _getItem("添加数据", _addData),
            _getItem("扫描数据", _scanFiles),
            _getItem("查找空数据", _findNoVideo),
            _getItem("测试定时数据", _testTimer),
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