import 'package:copyapp_example/pages/image_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditImage extends StatefulWidget {
  EditImage({Key key}) : super(key: key);

  @override
  _EditImageState createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {

  var _paths = [
    "assets/images/wgj.jpg",
    "assets/images/wgj.jpg",
    "assets/images/wgj.jpg"
  ];

  void _chooseImage(n){
    print(n);
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => ImagePage(

            )
        )
    );
  }

  Widget _getImages(){
    List<Widget> list = [];
    for(int i = 0; i < _paths.length; i++){
      list.add(
        SizedBox(
          width: ScreenUtil().setWidth(250),
          height: ScreenUtil().setWidth(360),
          child: Container(
            color: Colors.amber,
            child: Image.asset(
              _paths[i],
              fit: BoxFit.fill,
            ),
          ),
        ),
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