import 'package:flutter/cupertino.dart';

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

  bool _runing = false;
  var _copyData = "暂无";

  @override
  bool get wantKeepAlive => true;

  void initState(){
    super.initState();
    // _runing = false;
    print("initState");
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Core.instance.channelTooler.listen(this);
  }

  @override
  onReceive(obj) {
    print(obj);
    setState(() {
      _copyData = obj;
    });
  }

  void _callOs() async{
    var res = await Core.instance.channelTooler.info();
    print(res);
    ToastTooler.toast(context, msg: res);
  }

  void _changeRuning(c){
    setState(() {
      _runing = c;
    });
    ToastTooler.toast(context, msg: "check", position: ToastPostion.bottom);
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("build call");
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
                value: _runing,
                onChanged: _changeRuning,
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
                    child: new Text('调用系统方法'),
                    onPressed: (){_callOs();},
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Text("复制的文字", style: TextStyle(color: Colors.black26),),
            ),
            Container(
              child: Text(_copyData, style: TextStyle(color: Colors.blue),),
            )
          ],
        )
      ),
    );
  }
}