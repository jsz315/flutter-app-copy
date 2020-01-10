import 'package:copyapp_example/components/edit_frame.dart';
import 'package:copyapp_example/tooler/alert_tooler.dart';
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

class _ConfigPageState extends State<ConfigPage> {

  bool _running = false;
  
  Future<void> _update() async{

  }

  void _setRunning(c) async{
    await Core.instance.channelTooler.setRunning(c);
    setState(() {
      _running = c;
    });
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return EditFrame(
      title: "系统",
      tip: "edit",
      canEdit: false,
      onRefresh: _update,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
              child: Row(children: <Widget>[
                Expanded(
                  child: Text("开启服务"),
                  flex: 1,
                ),
                CupertinoSwitch(
                  value: _running,
                  onChanged: _setRunning,
                )
              ],),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black12, width: ScreenUtil().setWidth(1)))
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
              child: Row(children: <Widget>[
                Expanded(
                  child: Text("自动下载"),
                  flex: 1,
                ),
                CupertinoSwitch(
                  value: _running,
                  onChanged: _setRunning,
                )
              ],),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black12, width: ScreenUtil().setWidth(1)))
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
              child: Row(children: <Widget>[
                Expanded(
                  child: Text("调用系统方法"),
                  flex: 1,
                ),
                FlatButton.icon(onPressed: (){_checkRunning();}, icon: Icon(Icons.add_to_home_screen), label: Text("运行"))
              ],),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black12, width: ScreenUtil().setWidth(1)))
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
              child: Row(children: <Widget>[
                Expanded(
                  child: Text("数据重置"),
                  flex: 1,
                ),
                FlatButton.icon(onPressed: (){_resetSystem();}, icon: Icon(Icons.add_to_home_screen), label: Text("运行"))
              ],),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black12, width: ScreenUtil().setWidth(1)))
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
              child: Row(children: <Widget>[
                Expanded(
                  child: Text("添加数据"),
                  flex: 1,
                ),
                FlatButton.icon(onPressed: (){_addData();}, icon: Icon(Icons.add_to_home_screen), label: Text("运行"))
              ],),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black12, width: ScreenUtil().setWidth(1)))
              ),
            )
          ]
        )
      ),
    );
  }
}