import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClipPage extends StatefulWidget {
  final path;
  ClipPage({this.path});

  @override
  _ClipPageState createState() => _ClipPageState();
}

class _ClipPageState extends State<ClipPage> {
  
  final GlobalKey<ExtendedImageEditorState> editorKey  = GlobalKey<ExtendedImageEditorState>();

  void _capture() async{
    var rect = editorKey.currentState.getCropRect();
    Navigator.of(context).pop(rect);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Container(
            width: ScreenUtil().setWidth(720),
            height: ScreenUtil().setWidth(1280),
            child: ExtendedImage.file(
              File(widget.path),
              fit:BoxFit.contain,
              mode: ExtendedImageMode.editor,
              extendedImageEditorKey: editorKey,
              initEditorConfigHandler: (state){
                return EditorConfig(
                  cropAspectRatio: CropAspectRatios.ratio9_16,
                );
              },
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