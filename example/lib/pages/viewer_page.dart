import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:copyapp_example/tooler/image_tooler.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../tooler/toast_tooler.dart';

class ViewerPage extends StatefulWidget {
  final id;
  final items;
  ViewerPage({this.id, this.items});

  @override
  _ViewerPageState createState() => _ViewerPageState();
}

class _ViewerPageState extends State<ViewerPage> {

  int _id = 0;

  void initState(){
    super.initState();
    _id = widget.id;
  }


  void _onChange(n){
    setState(() {
      _id = n;
    });
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    var item = widget.items[index];
    var path = Core.instance.downloadTooler.getCapturePath(item);
    return Center(
          child: Container(
            width: w,
            height: h,
            child: ExtendedImage.file(
              File(path),
              fit:BoxFit.contain,
              mode: ExtendedImageMode.gesture,
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    var cur = _id + 1;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
            Swiper(
              itemBuilder: _swiperBuilder,
              itemCount: widget.items.length,
              // pagination: new SwiperPagination(
              //   builder: DotSwiperPaginationBuilder(
              //     color: Colors.black54,
              //     activeColor: Colors.white,
              //   )
              // ),
              // control: new SwiperControl(),
              scrollDirection: Axis.horizontal,
              autoplay: false,
              index: _id,
              onIndexChanged: (n){_onChange(n);},
            ),
            Positioned(
              left: ScreenUtil().setWidth(300),
              bottom: 10,
              width: ScreenUtil().setWidth(150),
              height: ScreenUtil().setWidth(40),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Color.fromARGB(90, 0, 0, 0)
                ),
                child: Center(
                  child: Text("$cur/${widget.items.length}", style: TextStyle(color: Colors.amber),),
                ) 
              ),
            )
        ],
      ) 
      
    );
  }
}