import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:copyapp_example/config.dart';
import 'package:copyapp_example/model/capture_model.dart';
import 'package:provider/provider.dart';

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

class CapturePage extends StatefulWidget {
  @override
  _CapturePageState createState() => _CapturePageState();
}

class _CapturePageState extends State<CapturePage> with AutomaticKeepAliveClientMixin {

  var _isEdit = false;
  List _selectedList = [];
  var _tip = "image";

  @override
  bool get wantKeepAlive => true;

  List<Map> _datas = [];

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();

    _update();
    Core.instance.eventTooler.eventBus.on<EditEvent>().listen((e){
      if(e.tip == _tip){
        setState(() {
          _isEdit = e.edit;
        });
        _chooseAll(false);
      }
    });

    Core.instance.eventTooler.eventBus.on<SelectEvent>().listen((e){
      if(e.tip == _tip){
        _chooseAll(e.select);
      }
    });

    Core.instance.eventTooler.eventBus.on<DeleteEvent>().listen((e){
      if(e.tip == _tip){
        _deleteItems();
      }
    });

    Core.instance.eventTooler.eventBus.on<MoveEvent>().listen((e){
      if(e.tip == _tip){
        _moveItems(e.tag);
      }
    });

  }

  Future<void> _update() async{
    List<Map> captures = await Core.instance.sqlTooler.captures();

    var captureModel = Provider.of<CaptureModel>(context);
    captureModel.update(captures);
    
    setState(() {
      _datas = captures;
      _selectedList = captureModel.selects;
      _isEdit = false;
    });
  }

  void _chooseOne(c, id){
    var captureModel = Provider.of<CaptureModel>(context);
    setState(() {
      // _selectedList[id] = c;
      captureModel.selectOne(id, c);
      _selectedList = captureModel.selects;
    });
  }

  void _showImage(id){
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => ViewerPage(
                id: id,
                items: _datas
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
              decoration: BoxDecoration(
                color: Colors.black
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
        onTap: (){_showImage(id);},
        child: Stack(
          children: list
        )
        
      ),
      color: Colors.black12,
    );
  }

  Future<void> _deleteItems() async{
    var selects = _selectedList.sublist(0);
    for(var i = 0; i < selects.length; i++){
      if(selects[i]){
        await Core.instance.downloadTooler.deleteCapture(_datas[i]);
      }
    }
    await _update();
    ToastTooler.toast(context, msg: "操作成功");
    // Scaffold.of(context).showSnackBar(SnackBar(content: Center(child: Text("操作成功")), duration: Duration(seconds: 2),));
  }

  Future<void> _moveItems(tag) async{
     Core.instance.downloadTooler.createCaptureTagDir(tag);
     var selects = _selectedList.sublist(0);
     for(var i = 0; i < selects.length; i++){
       if(selects[i] == true){
         await Core.instance.downloadTooler.moveCapture(_datas[i], tag);
       }
     }
     await _update();
     ToastTooler.toast(context, msg: "操作成功");
  }


  void _chooseAll(c){
    var captureModel = Provider.of<CaptureModel>(context);
    setState(() {
      // for(var i = 0; i < _selectedList.length; i++){
      //   _selectedList[i] = c;
      // }
      _selectedList = captureModel.selects;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new EditFrame(
      title: Config.capture,
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