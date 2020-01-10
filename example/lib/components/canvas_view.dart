import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;

class CanvasView extends CustomPainter{
  Paint mHelpPaint;
  ui.Image image;

  CanvasView(image);

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    mHelpPaint = new Paint();
    mHelpPaint.style = PaintingStyle.stroke;
    mHelpPaint.color = Color(0xffBBC3C5);
    mHelpPaint.isAntiAlias = true;

    print(size);

    //用Rect构建一个边长50,中心点坐标为100,100的矩形
    Rect rect = Rect.fromCircle(center: Offset(size.width, size.height), radius: 50.0);
    //根据上面的矩形,构建一个圆角矩形
    RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(20.0));
    canvas.drawRRect(rrect, mHelpPaint);
    draw(canvas, size, mHelpPaint);
  }

  void draw(Canvas canvas, Size size, Paint paint){
    canvas.drawImageRect(image, Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()), Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
  
}