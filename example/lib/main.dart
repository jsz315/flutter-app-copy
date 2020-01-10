import './core.dart';
import 'package:provider/provider.dart';

import './movie_model.dart';
import 'package:flutter/material.dart';

import './app.dart';

void main(){
  
  // var movieModel = new MovieModel();
  test();
  runApp(MyApp());
}

void test(){
  
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Core.instance.init();
    print("Core instance init ==========");
    
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      home: App(),
      // home: MultiProvider(
      //   providers: [
      //     Provider<MovieModel>.value(value: new MovieModel(),)
      //   ],
      //   child: App(),
      // )
    );
  }
}


/*
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  WebViewController _controller;

  final MethodChannel _methodChannel = const MethodChannel('jsz_plugin_method');
  static const EventChannel _eventChannel = EventChannel('jsz_plugin_event');

   @override
  void initState() {
    super.initState();
    _eventChannel.receiveBroadcastStream().listen(_onEnvent, onError: _onError);
  }

  void _onEnvent(Object obj){
    // setState(() {
    //   _info = obj;
    // });
    print("----------");
    print(obj);
  }

  void _onError(Object obj){

  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
    Future<String> future = _methodChannel.invokeMethod("info");
    future.then((message) {
      print("----------");
      print(message);
    });
    // showAlert();
    // _controller.evaluateJavascript('document.querySelector(".app-bar-text").style.color="#ff0000";');
  }

  void showAlert(){
    print("reg test");
    // RegExp reg = new RegExp(r"(\d+)");
    RegExp reg = new RegExp(r"一起来看！ (http\S+) 复制此链接");
    String data = "姗姗💗＠¥发了一个快手作品，一起来看！ http://kphshanghai.m.chenzhongtech.com/s/9ctVsLxo 复制此链接，打开【快手】直接观看！";
    Iterable<RegExpMatch> matches = reg.allMatches(data);
    
    for(Match m in matches){
      print(m.group(0));
      print(m.group(1));
    }
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("tip"),
          content: Text("well done!"),
          actions: <Widget>[
            FlatButton(
              child: Text("sure"),
              onPressed: (){
                Navigator.pop(context);
              },
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    var url = "https://fanyi.baidu.com/";
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: WebView(        
        // initialUrl: url,        
        javascriptMode: JavascriptMode.unrestricted,  
        onWebViewCreated: (WebViewController webViewController){
          _controller = webViewController;
          print("webview page: load finished...url=$url");
          _controller.loadUrl(url);
        },
        onPageFinished: (url) {
          print("webview page: load finished...url=$url");
        },   
      ),  
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Browser extends StatelessWidget {  
  const Browser({Key key, this.url, this.title}) : super(key: key);
  final String url;  final String title;
  @override  Widget build(BuildContext context) {    
    return Scaffold(      
      appBar: AppBar(        
        title: Text(title),      
      ),      
      body: WebView(        
        initialUrl: url,        
        javascriptMode: JavascriptMode.unrestricted,      
      ),    
    );  
  }
}
*/