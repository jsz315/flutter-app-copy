import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:copyapp_example/pages/viewer_page.dart';
import 'package:extended_image/extended_image.dart';

import '../core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../tooler/toast_tooler.dart';

class ImagePage extends StatefulWidget {
  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  List<Map> _datas = [];

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _update();
  }

  void _update() async{
    List<Map> captures = await Core.instance.sqlTooler.captures();
    setState(() {
      _datas = captures;
    });
  }

  void _showImage(path){
    print(path);
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => ViewerPage(
                path: path
            )
        )
    );
  }

  Widget getItemContainer(item) {
    return Container(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: (){_showImage(item["image"]);},
        child: Container(
          child: Image.file(
            File(item["image"]),
            fit: BoxFit.cover,
          ),
        ),
      ),
      color: Colors.black12,
    );
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("截图"),
        centerTitle: true,
      ),
      body: Center(
        child: GridView.builder(
          itemCount: _datas.length,
          itemBuilder: (BuildContext context, int index) {
            return getItemContainer(_datas[index]);
          },
          padding: EdgeInsets.all(20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.56,
              //水平单个子Widget之间间距
              mainAxisSpacing: 20.0,
              //垂直单个子Widget之间间距
              crossAxisSpacing: 20.0,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "image",
        onPressed: (){_update();},
        child: Icon(Icons.autorenew),
      ),
    );
  }
}