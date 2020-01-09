import 'dart:io';

import 'package:copyapp_example/pages/image_page.dart';
import 'package:copyapp_example/pages/pick_page.dart';
import 'package:copyapp_example/pages/viewer_page.dart';
import 'package:copyapp_example/tooler/toast_tooler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditImage extends StatefulWidget {
  EditImage({Key key}) : super(key: key);

  @override
  _EditImageState createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {

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

  void _chooseImage(n){
    print(n);
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => PickPage(

            )
        )
    ).then((data){
      print("返回的数据");
      print(data);
      if(data != null){
        setState(() {
          _paths[n] = data;
        });
      }
    });
  }

  void _editImage(n){
    if(_paths[n]["type"] == "assets"){
      ToastTooler.toast(context, msg: "先选择图片");
      return;
    }
    print(n);
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => ViewerPage(
                path: _paths[n]["url"]
            )
        )
    ).then((data){
      print("返回的数据");
      print(data);
      if(data != null){
        setState(() {
          _paths[n] = data;
        });
      }
    });
  }

  Widget _getImages(){
    List<Widget> list = [];
    for(int i = 0; i < _paths.length; i++){
      var image;
      var type = _paths[i]["type"];
      var url = _paths[i]["url"];
      if(type == "assets"){
        image = Image.asset(
          url,
          fit: BoxFit.fill,
        );
      }
      else{
        image = Image.file(
          File(url),
          fit: BoxFit.fill,
        );
      }

      list.add(
        GestureDetector(
          onTap: (){_editImage(i);},
          child: SizedBox(
            width: ScreenUtil().setWidth(250),
            height: ScreenUtil().setWidth(540),
            child: Container(
              color: Colors.amber,
              child: image
            ),
          ),
        )
      );
    }

    return Row(
      children: list
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

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Column(
         children: <Widget>[
           _getImages(),
           _getBtns(),
         ],
       ),
    );
  }
}