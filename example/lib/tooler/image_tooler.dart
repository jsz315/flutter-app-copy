import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';

class ImageTooler{
  static Future<ui.Image> loadImage(File file) async{
    final data = await file.readAsBytes();
    return await decodeImageFromList(data);
  }
}