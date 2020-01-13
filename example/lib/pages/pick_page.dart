import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import '../components/check_box.dart';
import '../components/edit_frame.dart';
import '../pages/viewer_page.dart';
import '../tooler/event_tooler.dart';
import 'package:extended_image/extended_image.dart';

import '../core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../tooler/toast_tooler.dart';

class PickPage extends StatefulWidget {
  @override
  _PickPageState createState() => _PickPageState();
}

class _PickPageState extends State<PickPage> {

  List<Map> _datas = [];

  @override
  void didChangeDependencies(){
    print("pick page didChangeDependencies --------");
    super.didChangeDependencies();

    _update();
  }

  Future<void> _update() async{
    List<Map> captures = await Core.instance.sqlTooler.captures();
    setState(() {
      _datas = captures;
    });
  }

  void _selectImage(id){
    print(_datas[id]);
    Navigator.of(context).pop(
      {
        "type": "file",
        "url": Core.instance.downloadTooler.getCapturePath(_datas[id])
      }
    );
  }
  
  Widget getItemContainer(id) {
    var item = _datas[id];

    var list = <Widget>[
            Container(
              child: Image.file(
                File(Core.instance.downloadTooler.getCapturePath(item)),
                fit: BoxFit.cover,
              ),
              decoration: BoxDecoration(
                color: Colors.black
              ),
            ),
          ];

    return Container(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: (){_selectImage(id);},
        child: Stack(
          children: list
        )
        
      ),
      color: Colors.black12,
    );
  }

  @override
  Widget build(BuildContext context) {
    print("pick page build --------");
    return Scaffold(
      appBar: AppBar(
        title: Text("选择图片"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: GridView.builder(
        itemCount: _datas.length,
        itemBuilder: (BuildContext context, int index) {
          return getItemContainer(index);
        },
        padding: EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.56,
            //水平单个子Widget之间间距
            mainAxisSpacing: 20.0,
            //垂直单个子Widget之间间距
            crossAxisSpacing: 20.0
        ),

      ),
    );
  }
}