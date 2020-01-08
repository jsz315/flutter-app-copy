import 'package:copyapp_example/components/check_box.dart';
import 'package:copyapp_example/core.dart';
import 'package:copyapp_example/tooler/event_tooler.dart';
import 'package:flutter/material.dart';

class TitleBar extends StatefulWidget {

  var title;
  
  // var togglerSelect;
  // var togglerEdit;
  var tip;

  TitleBar({
    Key key,
    this.title,
    // this.togglerSelect,
    // this.togglerEdit,
    this.tip
  }) : super(key: key);

  @override
  _TitleBarState createState() => _TitleBarState();
}



class _TitleBarState extends State<TitleBar> {

  var _isEdit = false;
  var _isSelected = false;

  _togglerEdit(){
    setState(() {
      _isEdit = !_isEdit;
      _isSelected = false;
    });
    // widget.togglerEdit(_isEdit);
    print("togglerEdit");

    Core.instance.eventTooler.eventBus.fire(new EditEvent(widget.tip, !!_isEdit));
    // Core.instance.eventTooler.eventBus.fire(MenuEvent(_isEdit));
  }

  @override
  void initState(){
    super.initState();
    Core.instance.eventTooler.eventBus.on<EditEvent>().listen((e) {
      print("--EditMenu EditEvent--");
      setState(() {
        _isEdit = e.edit;
      });
    });
  }

  _togglerSelect(s){
    setState(() {
      _isSelected = s;
    });
    // widget.togglerSelect(s);
    Core.instance.eventTooler.eventBus.fire(new SelectEvent(widget.tip, s));
  }

  Widget _getAppBar(){
    var list = <Widget>[
      Positioned(
        left: 0,
        right: 0,
        top: 0,
        bottom: 0,
        child: Center(
          child: Text(widget.title, style: TextStyle(color: Colors.white, fontSize: 18),),
        )
      ),
      Positioned(
        right: 20,
        top: 0,
        bottom: 0,
        child: GestureDetector(
            onTap: _togglerEdit,
            child: Center(
              child: Text(_isEdit ? "完成" : "编辑", style: TextStyle(color: Colors.white),),
            )
        ),
      )

    ];

    if(_isEdit){
      // list.insert(0, Text("全选", style: TextStyle(color: Colors.white),));
      list.insert(0, Positioned(
        left: 10,
        top: 0,
        bottom: 0,
        child: Row(
          children: <Widget>[
            CheckBox(
              value: _isSelected,
              onChanged: (c){_togglerSelect(c);},
            ),
            Text("全选", style: TextStyle(color: Colors.white),)
          ],
        ),
      ));
    }

    return Container(
      height: 40,
      child: Stack(
        children: list
      ),
//      child: Row(
//          children: list
//      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:  _getAppBar(),
      decoration: BoxDecoration(
        color: Colors.black
      ),
    );
  }
}