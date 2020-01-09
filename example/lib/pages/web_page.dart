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
import '../movie_model.dart';
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

  @override
  void initState(){
    super.initState();
    _movie = widget.movie;
    print("initState current movie");
    print(_movie);

  }

  void _callJavascript(){
    var js = StringTooler.getJs(_movie["word"]);
    _webViewController.evaluateJavascript(js).then((res)async{
      print(res);
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
    print("build current movie");
    print(_movie);

    Widget listView = _getTips();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
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
              print("内部跳转：${navigationRequest.url}");
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
        child: Icon(Icons.archive),
        onPressed: (){
          _callJavascript();
        },
      ),
    );
  }
}