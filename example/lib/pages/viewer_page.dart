import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../tooler/toast_tooler.dart';

class ViewerPage extends StatefulWidget {
  final path;
  ViewerPage({this.path});

  @override
  _ViewerPageState createState() => _ViewerPageState();
}

class _ViewerPageState extends State<ViewerPage> {

  GlobalKey _imgKey = GlobalKey();
  double _imgWidth = 0;
  double _imgHeight = 0;
  var _path;

   @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _init();
  }

  void _init(){
    setState(() {
      _path = widget.path;
      _imgWidth = MediaQuery.of(context).size.width;
      _imgHeight = MediaQuery.of(context).size.height;
    });
  }

  void _capture() async{
    try {
      RenderRepaintBoundary boundary = _imgKey.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 2.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      await Core.instance.downloadTooler.saveImage(pngBytes);
      ToastTooler.toast(context, msg: "保存图片成功");
      
    } catch (e) {
      print(e);
      ToastTooler.toast(context, msg: "保存图片失败");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepaintBoundary(
        key: _imgKey,
        child: Center(
          child: Container(
            width: ScreenUtil().setWidth(720),
            height: ScreenUtil().setWidth(1080),
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: ExtendedImage.file(
              File(_path),
              fit:BoxFit.cover,
              mode: ExtendedImageMode.gesture,
              initGestureConfigHandler: (state){
                return GestureConfig(
                    minScale: 0.9,
                    animationMinScale: 0.7,
                    maxScale: 3.0,
                    animationMaxScale: 3.5,
                    speed: 1.0,
                    inertialSpeed: 100.0,
                    initialScale: 1.0,
                    inPageView: true
                );
              },
            ),
        ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "viewer",
        child: Icon(Icons.android),
        onPressed: (){_capture();},
      ),
    );
  }
}