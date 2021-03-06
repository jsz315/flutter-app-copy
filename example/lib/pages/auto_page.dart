import 'dart:async';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../tooler/string_tooler.dart';
import '../tooler/toast_tooler.dart';

import '../core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../tooler/download_tooler.dart';

class AutoPage extends StatefulWidget {
 
  AutoPage({Key key}) : super(key: key);

  @override
  _AutoPageState createState() => _AutoPageState();
}

class _AutoPageState extends State<AutoPage> {
  WebViewController _webViewController;
  List<String> _tips = [];
  String _title = "";
  var _movie;
  var _noVideos;
  Timer _timer;
  var _running = true;

  @override
  void initState(){
    super.initState();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _init();
  }

  void _exit(){
    setState(() {
      _running = false;
    });
    if(_timer != null){
      _timer.cancel();
    }
  }

  @override
  void dispose(){
    if(_timer != null){
      _timer.cancel();
    }
    super.dispose();
  }

  void _init() async{
    var hasNext = await _hasNext();
    if(hasNext){
      setState(() {
        _movie = _noVideos[0];
        _tips.add("剩余下载个数：${_noVideos.length}");
      });
    }
    else{
      _tips.add("全部下载完成");
    }
  }

  Future<bool> _hasNext() async{
    var res = await Core.instance.sqlTooler.moviesNoVideo();
    
    _noVideos = res;
    if(_noVideos.length > 0){
      return true;
    }
    return false;
  }

  void _next() async{
    var hasNext = await _hasNext();
    if(hasNext){
      Navigator.pushReplacement(context,
          new MaterialPageRoute(
              builder: (context) => AutoPage()
          ));
    }
    else{
      _tips.add("全部下载完成");
    }
    
  }

  void _callJavascript(){
    var js = StringTooler.getJs(_movie["word"]);
    _webViewController.evaluateJavascript(js).then((res)async{
      if(res == "null"){
        
        await Core.instance.downloadTooler.deleteVideoItem(_movie);
      }
      else{

        String str1 = res.toString();
        
        var aim = str1.replaceAll(new RegExp(r'\\'), "");
        aim = aim.substring(1, aim.length -1 );
        dynamic item = json.decode(aim);
        await Core.instance.downloadTooler.start(_movie["id"], item["poster"], item["src"]);
        ToastTooler.toast(context, msg: "下载成功", position: ToastPostion.bottom);
        setState(() {
          _tips.add("下载成功");
        });
      }
      
     
      if(_running){
        _next();
      }
    });
    
  }

  void _setTitle(){
    if(_webViewController == null){
      
      return;
    }
    _webViewController.evaluateJavascript("document.title").then((res){

      Core.instance.sqlTooler.updateVideoTitle(_movie["id"], res);

      if(_running){
        if(_timer != null){
          _timer.cancel();
        }
        _timer = new Timer(Duration(seconds: 3), _callJavascript);
      }
    });
  }

  Widget _getTips(){
    return ListView.builder(
      itemCount: _tips.length,
      itemBuilder: (BuildContext context, int id){
        return Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Color.fromARGB(120, 0, 0, 0),
            border: Border(bottom: BorderSide(
              color: Color.fromARGB(80, 0, 0, 0),
              width: 1
            ))
          ),
          child:Text(_tips[id], style: TextStyle(color: Colors.amber),)
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    Widget listView = _getTips();

    Widget view;
    if(_movie != null){
      view = WebView(
        // key: UniqueKey(),
        initialUrl: _movie["link"],
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController){
          _webViewController = webViewController;
          
        },
        onPageFinished: (url){
          _setTitle();
        },
        navigationDelegate: (NavigationRequest navigationRequest){
          
          return NavigationDecision.navigate;
        },
      );
    }
    else{
      view = Container(
        child: Center(
          child: Text("loading", style: TextStyle(color: Colors.amber),),
        ),
        padding: EdgeInsets.all(20),
      ) ;
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: <Widget>[
          view,
          Positioned(
            left: 20,
            top: 20,
            width: ScreenUtil().setWidth(500),
            height: ScreenUtil().setWidth(300),
            child: Container(
              child: listView,
            ),
          )
        ],
      ), 
      
      floatingActionButton: FloatingActionButton(
        heroTag: "web",
        child: _running ? Icon(Icons.pause_circle_filled) : Icon(Icons.play_circle_filled),
        onPressed: (){
          _exit();
//          _callJavascript();
        },
      ),
    );
  }
}