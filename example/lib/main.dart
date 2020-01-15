import 'package:copyapp_example/model/capture_model.dart';

import './core.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import './app.dart';
import 'model/movie_model.dart';

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
    
    
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      // home: App(),
      home: MultiProvider(
        providers: [
          Provider<MovieModel>.value(value: new MovieModel(),),
          Provider<CaptureModel>.value(value: new CaptureModel(),)
        ],
        child: App(),
      )
    );
  }
}