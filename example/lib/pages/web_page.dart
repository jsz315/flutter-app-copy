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

class WebPage extends StatefulWidget {
  final movie;
  WebPage({this.movie});

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {

  WebViewController _webViewController;
  List<String> _tips = [];
  String _title = "";
  var _movie;
  var _noVideos;
  var _nid = 0;
  Timer _timer;

  @override
  void initState(){
    super.initState();
    _movie = widget.movie;
//    _init();
  }

  void _init() async{
    var res = await Core.instance.sqlTooler.moviesNoVideo();
    _noVideos = res;
  }

  void _download([bool auto = false]){
    if(auto){
      if(_nid < _noVideos.length){
        setState(() {
          _movie = _noVideos[_nid];
        });
        
        _nid += 1;
      }
      else{
        
      }
    }
    _callJavascript();
  }

  void _callJavascript(){
    var js = StringTooler.getJs(_movie["word"]);
    _webViewController.evaluateJavascript(js).then((res)async{
      
      String str1 = res.toString();
      var aim = str1.replaceAll(new RegExp(r'\\'), "");
      aim = aim.substring(1, aim.length -1 );
      dynamic item = json.decode(aim);
      await Core.instance.downloadTooler.start(_movie["id"], item["poster"], item["src"]);
      ToastTooler.toast(context, msg: "下载成功", position: ToastPostion.bottom);
      setState(() {
        _tips.add("下载成功");
      });
    });
    
  }

  void _setTitle(){
    _webViewController.evaluateJavascript("document.title").then((res){
      setState(() {
        _title = res;
        _tips.add("获取标题成功");
      });
      Core.instance.sqlTooler.updateVideoTitle(_movie["id"], res);

      if(Core.instance.isAutoDownload){
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
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: <Widget>[
          WebView(
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
          ),
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
        backgroundColor: Colors.blue,
        child: Icon(Icons.archive, color: Colors.white,),
        onPressed: (){
          _callJavascript();
        },
      ),
    );
  }
}