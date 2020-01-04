import 'dart:convert';
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
  String _title = "";
  var _movie;

  void initState(){
    super.initState();
    _movie = widget.movie;
    print("initState current movie");
    print(_movie);

    var permission =  PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    print("permission status is " + permission.toString());
    PermissionHandler().requestPermissions(<PermissionGroup>[
      PermissionGroup.storage, // 在这里添加需要的权限
    ]);
  }

  void _callJavascript(){
    // var js = 'document.querySelector("#logo").style.backgroundColor="#440099";';
    var js = [
      'var video = document.querySelector("video");',
      'var src = video.getAttribute("src");',
      'var poster = video.getAttribute("poster");',
      'JSON.stringify({src, poster})'
      // 'src + "," + poster'
    ].join("");
    _webViewController.evaluateJavascript(js).then((res)async{
      print(res);
      String str1 = res.toString();
      var aim = str1.replaceAll(new RegExp(r'\\'), "");
      aim = aim.substring(1, aim.length -1 );
      dynamic item = json.decode(aim);
      // DownloadTooler.start(item["poster"], item["src"]);
      await Core.instance.downloadTooler.start(_movie["id"], item["poster"], item["src"]);
      ToastTooler.toast(context, msg: "下载成功", position: ToastPostion.bottom);
    });
    
  }

  void _setTitle(){
    _webViewController.evaluateJavascript("document.title").then((res){
      setState(() {
        _title = res;
      });
      // _movie["title"] = res;
      Core.instance.sqlTooler.updateTitle(_movie["id"], res);
    });
  }

  @override
  Widget build(BuildContext context) {
    // var movieModel = Provider.of<MovieModel>(context);
    // _movie = movieModel.movies[movieModel.index];
    print("build current movie");
    print(_movie);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: WebView(
        initialUrl: _movie["link"],
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController){
          _webViewController = webViewController;
        },
        onPageFinished: (url){
          _setTitle();
        },
        navigationDelegate: (NavigationRequest navigationRequest){
          // if(navigationRequest.url.startsWith("http://")){
          //   return NavigationDecision.prevent;
          // }
          print(navigationRequest.url);
          return NavigationDecision.navigate;
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.archive),
        onPressed: (){
          _callJavascript();
        },
      ),
    );
  }
}

// class Movie {
//   final String src;
//   final String poster;

//   Movie(this.src, this.poster);

//   Movie.fromJson(Map<dynamic, dynamic> json)
//       : src = json['src'],
//         poster = json['poster'];

//   Map<dynamic, dynamic> toJson() =>
//     {
//       'src': src,
//       'poster': poster,
//     };
// }