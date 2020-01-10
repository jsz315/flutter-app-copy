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

    print("======== size ------");
    print(size);

    //用Rect构建一个边长50,中心点坐标为100,100的矩形
    Rect rect = Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: 80.0);
    //根据上面的矩形,构建一个圆角矩形
    RRect rrect = RRect.fromRectAndRadius(Rect.fromLTWH(2, 2, size.width - 4, size.height - 4), Radius.circular(20.0));
    canvas.drawRRect(rrect, mHelpPaint);

    // ByteData data = image.toByteData();
    // canvas.scale(1.5);
    // canvas.translate(-image.width / 2, -image.height / 2);
//    canvas.translate(-80, -120);
    // canvas.drawImage(
    //   image, 
    //   Offset(0, 0),
    //   mHelpPaint
    // );

    canvas.drawRRect(rrect, mHelpPaint);
    draw(canvas, size, mHelpPaint);
  }

  void draw(Canvas canvas, Size size, Paint paint){
    var w = size.width / 3;
    for(var i = 0; i < 3; i++){
      var image = imageRectDatas[i].image;
      
      print("draw $i ==========");
      if(image != null){
        var srcRect = imageRectDatas[i].rect == null ? Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()) : imageRectDatas[i].rect;
        var dstRect = Rect.fromLTWH(i * w, 0, w, size.height);
        canvas.drawImageRect(image, srcRect, dstRect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }



  // Future<ui.Image> imageLoader() {
 
  //   ImageStream imageStream = NetworkImage(
 
  //           'https://avatars0.githubusercontent.com/u/45789654?s=460&v=4')
 
  //       .resolve(ImageConfiguration.empty);
 
  //   Completer<ui.Image> imageCompleter = Completer<ui.Image>();
 
  //   ImageStreamListener imageListener(ImageInfo info, bool synchronousCall) {
 
  //     ui.Image image = info.image;
 
  //     imageCompleter.complete(image);
 
  //     imageStream.removeListener(imageListener);
 
  //   }
 
  //   imageStream.addListener(imageListener);
 
  //   return imageCompleter.future;
 
  // }
  
}