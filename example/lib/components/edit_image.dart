import 'dart:io';
import 'package:copyapp_example/components/canvas_view.dart';
import 'package:copyapp_example/model/image_rect_data.dart';
import 'package:copyapp_example/pages/clip_page.dart';
import 'package:copyapp_example/pages/pick_page.dart';
import 'package:copyapp_example/pages/viewer_page.dart';
import 'package:copyapp_example/tooler/image_tooler.dart';
import 'package:copyapp_example/tooler/toast_tooler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditImage extends StatefulWidget {
  // var onChange;
  EditImage({Key key}) : super(key: key);

  @override
  _EditImageState createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {

  List<ImageRectData> _imageRectDatas = [];
  final GlobalKey _imgKey = GlobalKey();

  var _paths = [
    {
      "type": "assets",
      "url": "assets/images/wgj.jpg"
    },
    {
      "type": "assets",
      "url": "assets/images/wgj.jpg"
    },
    {
      "type": "assets",
      "url": "assets/images/wgj.jpg"
    },
  ];

  var _dragId = 0;

  void _dragStart(DragStartDetails e){
    _dragId = getHitIndex(e.globalPosition);
  }

  int getHitIndex(Offset offset){
    var p = offset.dx / ScreenUtil.screenWidthDp;
    if(p < 0.33){
      return 0;
    }
    else if(p < 0.66){
      return 1;
    }
    else{
      return 2;
    }
  }

  void _dragEnd(DragEndDetails e){
    if(e.velocity.pixelsPerSecond.dx > 600){
      if(_dragId < 2){
        setState(() {
          _imageRectDatas.insert(_dragId + 1, _imageRectDatas.removeAt(_dragId));
        });
      }
      else{
        
      }
    }
    else if(e.velocity.pixelsPerSecond.dx < -600){
      
      if(_dragId > 0) {
        setState(() {
          _imageRectDatas.insert(_dragId - 1, _imageRectDatas.removeAt(_dragId));
        });
      }
      else{
        
      }
    }
  }

  @override
  void initState(){
    super.initState();
    for(var i = 0; i < 3; i++){
      _imageRectDatas.add(null);
    }
  }

  void _chooseImage(n){
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => PickPage(

            )
        )
    ).then((data) async{
      
      if(data != null){
        setState(() {
          _paths[n] = data;
        });
        // widget.onChange(n, data);
        var img = await ImageTooler.loadImage(File(data["url"]));
        setState(() {
          _imageRectDatas[n] = new ImageRectData(img, null, data["url"]);
        });
      }
    });
  }

  void _editImage(LongPressEndDetails e){
    var n = getHitIndex(e.globalPosition);
   
     Navigator.push(
         context,
         new MaterialPageRoute(
             builder: (context) => ClipPage(
                 path: _imageRectDatas[n].path
             )
         )
     ).then((data){
       
       if(data != null){
         setState(() {
           _imageRectDatas[n].rect = data;
         });
       }
     });
  }

  Widget _getImages(){
    return FittedBox(
                child: SizedBox(
                  child: GestureDetector(
                    onLongPressEnd: _editImage,
                    onHorizontalDragStart: _dragStart,
                    onHorizontalDragEnd: _dragEnd,
                    child: RepaintBoundary(
                      key: _imgKey,
                      child:  CustomPaint(
                        size: Size(ScreenUtil().setWidth(1280), ScreenUtil().setWidth(720)),
                        painter: CanvasView(_imageRectDatas),
                      ),
                    ),
                  )
                )
              );
  }

  Widget _getBtns(){
    List<Widget> list = [];
    for(int i = 0; i < _paths.length; i++){
      list.add(
        SizedBox(
          width: ScreenUtil().setWidth(250),
          height: ScreenUtil().setWidth(90),
          child: Container(
            color: Colors.black12,
            child: MaterialButton(
              onPressed: (){_chooseImage(i);},
              child: Text("选取图片"),
            ),
          ),
        ),
      );
    }

    return Row(
      children: list
    );
  }

   void _capture() async{
    ImageTooler.capture(_imgKey, context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Column(
         children: <Widget>[
           GestureDetector(
             child: _getImages(),
           ),
           _getBtns(),
           Container(
            margin: EdgeInsets.only(top: 30),
            width: ScreenUtil().setWidth(640),
            height: ScreenUtil().setWidth(80),
            child: MaterialButton(
              color: Colors.amber,
              child: new Text('生成图片'),
              onPressed: (){_capture();}
            ),
          ),
         ],
       ),
    );
  }
}