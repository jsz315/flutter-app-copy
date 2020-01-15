import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:copyapp_example/tooler/toast_tooler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

import '../core.dart';

class ImageTooler{
  static Future<ui.Image> loadImage(File file) async{
    final data = await file.readAsBytes();
    return await decodeImageFromList(data);
  }

  static Future<void> capture(GlobalKey key, BuildContext context) async{
    try {
      RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 2.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      await Core.instance.downloadTooler.saveImage(pngBytes);
      ToastTooler.toast(context, msg: "保存图片成功");
    } catch (e) {
      
      ToastTooler.toast(context, msg: "保存图片失败");
    }
  }
}