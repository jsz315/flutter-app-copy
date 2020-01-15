import 'dart:async';
import 'dart:typed_data';
import 'package:copyapp_example/model/image_rect_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;

class CanvasView extends CustomPainter{
  Paint mHelpPaint;
  List<ImageRectData> imageRectDatas;

  CanvasView(this.imageRectDatas);

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    mHelpPaint = new Paint();
    mHelpPaint.style = PaintingStyle.stroke;
    mHelpPaint.color = Color(0xffBBC3C5);
    mHelpPaint.isAntiAlias = true;

    //根据上面的矩形,构建一个圆角矩形
    RRect rrect = RRect.fromRectAndRadius(Rect.fromLTWH(2, 2, size.width - 4, size.height - 4), Radius.circular(20.0));
    canvas.drawRRect(rrect, mHelpPaint);

    canvas.drawRRect(rrect, mHelpPaint);
    draw(canvas, size, mHelpPaint);
  }

  void draw(Canvas canvas, Size size, Paint paint){
    if(imageRectDatas == null){
      
    }
    var w = size.width / 3;
    for(var i = 0; i < 3; i++){
      if(imageRectDatas[i] != null){
        var image = imageRectDatas[i].image;
        print(image);
        if(image != null){
          var srcRect = imageRectDatas[i].rect == null ? Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()) : imageRectDatas[i].rect;
          var dstRect = Rect.fromLTWH(i * w, 0, w, size.height);
          canvas.drawImageRect(image, srcRect, dstRect, paint);
        }
      }
      
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}