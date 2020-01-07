import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:copyapp_example/components/check_box.dart';
import 'package:copyapp_example/components/edit_frame.dart';
import 'package:copyapp_example/pages/viewer_page.dart';
import 'package:copyapp_example/tooler/event_tooler.dart';
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

  var _isEdit = false;
  var _selectedList = [];
  var _tip = "image";

  @override
  bool get wantKeepAlive => true;

  List<Map> _datas = [];

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();

    _update();

    Core.instance.eventTooler.eventBus.on<EditEvent>().listen((e){
      print("--EditEvent--000000");
      if(e.tip == _tip){
        setState(() {
          _isEdit = e.edit;
        });
      }
    });

    Core.instance.eventTooler.eventBus.on<SelectEvent>().listen((e){
      print("--SelectEvent--");
      if(e.tip == _tip){
        _chooseAll(e.select);
      }
    });

    Core.instance.eventTooler.eventBus.on<DeleteEvent>().listen((e){
      print("--DeleteEvent--");
      if(e.tip == _tip){
        _deleteItems();
      }
    });

    Core.instance.eventTooler.eventBus.on<MoveEvent>().listen((e){
      print("--MoveEvent--");
      if(e.tip == _tip){
        _moveItems(e.tag);
      }
    });

  }

  Future<void> _update() async{
    List<Map> captures = await Core.instance.sqlTooler.captures();
    var slist = [];
    captures.forEach((val){
      slist.add(false);
    });

    setState(() {
      _datas = captures;
      _selectedList = slist;
      _isEdit = false;
    });
  }

  void _chooseOne(c, id){
    setState(() {
      _selectedList[id] = c;
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

  Widget getItemContainer(id) {
    var item = _datas[id];

    var list = <Widget>[
            Container(
              child: Image.file(
                File(Core.instance.downloadTooler.getCapturePath(item)),
                fit: BoxFit.cover,
              ),
            ),
          ];
    if(_isEdit){
      list.add(
        Positioned(
              right: 0,
              bottom: 0,
              child: CheckBox(
                value: _selectedList[id],
                onChanged: (c){_chooseOne(c, id);},
              ),
        )
      );
    }

    return Container(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: (){_showImage(Core.instance.downloadTooler.getCapturePath(item));},
        child: Stack(
          children: list
        )
        
      ),
      color: Colors.black12,
    );
  }

  Future<void> _deleteItems() async{
    for(var i = 0; i < _selectedList.length; i++){
      if(_selectedList[i]){
        await Core.instance.downloadTooler.deleteCapture(_datas[i]);
      }
    }
    await _update();
  }

  Future<void> _moveItems(tag) async{
    print("创建目录 $tag");
     Core.instance.downloadTooler.createCaptureTagDir(tag);
     for(var i = 0; i < _selectedList.length; i++){
       if(_selectedList[i]){
         await Core.instance.downloadTooler.moveCapture(_datas[i], tag);
       }
     }
     await _update();
  }


  void _chooseAll(c){
    setState(() {
      for(var i = 0; i < _selectedList.length; i++){
        _selectedList[i] = c;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new EditFrame(
      // onDelete: _deleteItems,
      // onMove: _moveItems,
      // togglerEdit: _togglerEdit,
      // togglerSelect: _chooseAll,
      title: "截图列表",
      tip: _tip,
      onRefresh: _update,
      child: GridView.builder(
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
            crossAxisSpacing: 20.0,
        ),

      ),
    );
  }
}