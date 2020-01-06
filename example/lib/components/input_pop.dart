import 'package:flutter/material.dart';

class InputPop extends StatefulWidget {
  @override
  _InputPopState createState() => _InputPopState();
}

class _InputPopState extends State<InputPop> {

  TextEditingController textEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(children: <Widget>[
        TextField(
              controller: textEditingController,
                decoration: InputDecoration(
                  prefixIcon:Icon(Icons.folder),
                  labelText: "目录名称",
                  hintText: "请输入视频目录名称",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
            ),
      ],),
      title: Center(
        child: Text(
        '标题',
        style: TextStyle(
          color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
      )),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('确定')),
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('取消')),
      ],
    );
  }
}
