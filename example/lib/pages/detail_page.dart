import 'package:copyapp_example/components/check_box.dart';
import 'package:copyapp_example/components/title_bar.dart';
import 'package:copyapp_example/components/edit_frame.dart';
import 'package:copyapp_example/components/edit_menu.dart';

import './player_page.dart';
import 'package:flutter/cupertino.dart';

import '../core.dart';
import '../tooler/channel_tooler.dart';

import '../core.dart';
import '../tooler/string_tooler.dart';
import '../tooler/toast_tooler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../movie_model.dart';

class DetailPage extends StatefulWidget {
  DetailPage(){
    print("DetailPage");
  }
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with AutomaticKeepAliveClientMixin implements SystemListener {

  bool _running = false;
  var _copyData = "暂无";
  var _isCheck = false;

  TextEditingController textEditingController = new TextEditingController();
  
  @override
  bool get wantKeepAlive => true;

  void initState(){
    super.initState();
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

  void _checkRunning() async{
    var res = await Core.instance.channelTooler.checkRunning();
    ToastTooler.toast(context, msg: res);

//    var today = DateTime.now();
//    print('当前时间是：$today');
//    var date1 = today.millisecondsSinceEpoch;
//    print('当前时间戳：$date1');
//    var date2 = DateTime.fromMillisecondsSinceEpoch(date1);
//    print('时间戳转日期：$date2');
//    //拼接成date
//    var dentistAppointment = new DateTime(2019, 6, 20, 17, 30,20);
//    print(dentistAppointment);
  }

  void _setRunning(c) async{
    await Core.instance.channelTooler.setRunning(c);
    setState(() {
      _running = c;
    });
    // ToastTooler.toast(context, msg: "check", position: ToastPostion.bottom);
  }

  void _addWord() async{
    // await Core.instance.sqlTooler.add("驾培🏅戴教练发了一个快手作品，一起来看！ http://kphshanghai.m.chenzhongtech.com/s/xNbMeYmE 复制此链接，打开【快手】直接观看！");
    
    // RegExp reg = new RegExp(r"一起来看！ (http\S+) 复制此链接");
    String data = "姗姗💗＠¥发了一个快手作品，一起来看！ http://kphshanghai.m.chenzhongtech.com/s/9ctVsLxo 复制此链接，打开【快手】直接观看！";
    var list = StringTooler.getData(data);
    if(list.length == 2){
      await Core.instance.sqlTooler.add(list[0], list[1]);
      _update();
    }
    
  }

  void _update() async{
    List<Map> movies = await Core.instance.sqlTooler.movies();
    var movieModel = Provider.of<MovieModel>(context);
    movieModel.update(movies);
  }

  void _playVideo(){
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => PlayerPage(
                movie: {}
            )
        )
    );
  }

  void _togglerSelect(s){
    print(s);
  }

  void _togglerEdit(s){
    print(s);
  }

  void _resetSystem(){
    Core.instance.reset();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("build call");
    // var TitleBar = TitleBar(togglerEdit: _togglerEdit, togglerSelect: _togglerSelect, title: "测试",);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("调试配置"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                child: Text("开启服务"),
              ),
              CupertinoSwitch(
                value: _running,
                onChanged: _setRunning,
              )
            ],),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                children: <Widget>[
                  MaterialButton(
                    color: Colors.amber,
                    child: new Text('添加数据'),
                    onPressed: (){_addWord();},
                  ),
                  MaterialButton(
                    color: Colors.amber,
                    child: new Text('刷新数据'),
                    onPressed: (){_update();},
                  ),
                  MaterialButton(
                    color: Colors.amber,
                    child: new Text('系统方法'),
                    onPressed: (){_checkRunning();},
                  ),

                ],
              ),
            ),
            MaterialButton(
              color: Colors.amber,
              child: new Text('播放视频'),
              onPressed: (){_playVideo();},
            ),
            CheckBox(
              value: _isCheck,
              onChanged: (c){
                print(c);
                setState(() {
                  _isCheck = c;
                });
              },
            ),
            MaterialButton(
              color: Colors.amber,
              child: new Text('重置系统'),
              onPressed: (){_resetSystem();},
            ),
            TextField(
              controller: textEditingController,
                decoration: InputDecoration(
                  prefixIcon:Icon(Icons.folder),
                  labelText: "目录名称",
                  hintText: "请输入视频目录名称",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Text("复制的文字", style: TextStyle(color: Colors.black26),),
            ),
            Container(
              child: Text(_copyData, style: TextStyle(color: Colors.blue),),
            ),
            // new EditMenu(onDelete: _onDelete, onMove: _onMove,)
          ],
        )
      ),
    );
  }
}