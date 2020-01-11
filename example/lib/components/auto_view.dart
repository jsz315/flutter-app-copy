import 'dart:convert';

import 'package:copyapp_example/core.dart';
import 'package:copyapp_example/tooler/string_tooler.dart';
import 'package:copyapp_example/tooler/toast_tooler.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AutoView extends StatefulWidget {
  var movie;
  AutoView({Key key, this.movie}) : super(key: key);

  @override
  _AutoViewState createState() => _AutoViewState();
}

class _AutoViewState extends State<AutoView> {
  WebViewController _webViewController;
  var _movie;

   void initState(){
    super.initState();
    _movie = widget.movie;
  }

  void start() async{
    List<Map> movies = await Core.instance.sqlTooler.movies();
    for(var i = 0; i < movies.length; i++){
      if(movies[i]["video"] == null){
        _movie = movies[i];
        break;
      }
    }
    print("当前下载数据");
    print(_movie);
    // _callJavascript();
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
        // _tips.add("下载成功");
      });
    });
    
  }

  void _setTitle(){
    _webViewController.evaluateJavascript("document.title").then((res){
      setState(() {
        // _title = res;
        // _tips.add("获取标题成功");
      });
      Core.instance.sqlTooler.updateVideoTitle(_movie["id"], res);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
       child: Column(
         children: <Widget>[
           Row(
             children: <Widget>[
               Expanded(
                 child: Text("下载进度"),
                 flex: 1,
               ),
               Text("1/9")
             ],
           ),

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
         ],
       ),
    );
  }
}