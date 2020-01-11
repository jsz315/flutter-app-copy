import 'dart:io';

import 'package:copyapp_example/components/canvas_view.dart';
import 'package:copyapp_example/components/edit_image.dart';
import 'package:copyapp_example/pages/image_page.dart';
import 'package:copyapp_example/tooler/image_tooler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../components/check_box.dart';
import '../components/title_bar.dart';
import '../components/edit_frame.dart';
import '../components/edit_menu.dart';

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
import 'dart:ui' as ui;

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

  bool _isImageLoad = false;
  final GlobalKey _imgKey = GlobalKey();
  CanvasView _painter;
  List<ui.Image> _images = [];


  TextEditingController textEditingController = new TextEditingController();
  
  @override
  bool get wantKeepAlive => true;

  void initState(){
    super.initState();
    // _loadImage();
    _images.add(null);
    _images.add(null);
    _images.add(null);
  }

  void _loadImage(id, path)async{
    var img = await ImageTooler.loadImage(File(path));
    print("$id 加载图片完成 ${path}");
    print(img);
    setState(() {
      _isImageLoad = true;
      _images[id] = img;
    });
  }

  void _onPickImage(n, data){
    print("_onPickImage");
    print(n);
    print(data);
    _loadImage(n, data["url"]);
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
  }

  void _setRunning(c) async{
    await Core.instance.channelTooler.setRunning(c);
    setState(() {
      _running = c;
    });
    // ToastTooler.toast(context, msg: "check", position: ToastPostion.bottom);
  }

  void _update() async{
    // List<Map> movies = await Core.instance.sqlTooler.movies();
    // var movieModel = Provider.of<MovieModel>(context);
    // movieModel.update(movies);
  }
  

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("build call");
    // var TitleBar = TitleBar(togglerEdit: _togglerEdit, togglerSelect: _togglerSelect, title: "测试",);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("调试"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(30),
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
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
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
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Text("复制的文字", style: TextStyle(color: Colors.black26),),
            ),
            Container(
              child: Text(_copyData, style: TextStyle(color: Colors.blue),),
              padding: EdgeInsets.all(30),
            ),
            Transform.scale(
              child: new EditImage(),
              scale: 0.9,
            ),
            // new EditMenu(onDelete: _onDelete, onMove: _onMove,)
          ],
        )
      ),
    );
  }
}