import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:copyapp_example/tooler/image_tooler.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../tooler/toast_tooler.dart';

class ViewerPage extends StatefulWidget {
  final path;
  final eidt;
  ViewerPage({this.path, this.eidt = true});

  @override
  _ViewerPageState createState() => _ViewerPageState();
}

class _ViewerPageState extends State<ViewerPage> {

  final GlobalKey _imgKey = GlobalKey();
  final GlobalKey<ExtendedImageEditorState> editorKey  = GlobalKey<ExtendedImageEditorState>();

  void _capture() async{
    var rect = editorKey.currentState.getCropRect();
    Navigator.of(context).pop(rect);
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: RepaintBoundary(
        key: _imgKey,
        child: Center(
          child: Container(
            width: widget.eidt ? ScreenUtil().setWidth(720) : w,
            height: widget.eidt ? ScreenUtil().setWidth(1280) : h,
            child: ExtendedImage.file(
              File(widget.path),
              fit:BoxFit.contain,
              mode: widget.eidt ? ExtendedImageMode.editor : ExtendedImageMode.gesture,
              extendedImageEditorKey: editorKey,
              initEditorConfigHandler: (state){
                return EditorConfig(
                  cropAspectRatio: CropAspectRatios.ratio9_16,
                );
              },
            ),
        ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "viewer",
        child: Icon(Icons.camera_alt),
        onPressed: (){_capture();},
      ),
    );
  }
}