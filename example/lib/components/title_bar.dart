import 'package:copyapp_example/components/check_box.dart';
import 'package:copyapp_example/core.dart';
import 'package:copyapp_example/tooler/event_tooler.dart';
import 'package:flutter/material.dart';

class TitleBar extends StatefulWidget {

  var title;
  
  // var togglerSelect;
  // var togglerEdit;
  var tip;
  var canEdit;

  TitleBar({
    Key key,
    this.title,
    // this.togglerSelect,
    // this.togglerEdit,
    this.tip,
    this.canEdit
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
    print("== titleBar initState");
    super.initState();
    print("--1 Core.instance.eventTooler.eventBus--");
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
    ];

    if(widget.canEdit){
      list.add(Positioned(
        right: 20,
        top: 0,
        bottom: 0,
        child: GestureDetector(
            onTap: _togglerEdit,
            child: Center(
              child: Text(_isEdit ? "完成" : "编辑", style: TextStyle(color: Colors.white),),
            )
        ),
      ));

      if(_isEdit){
        // list.insert(0, Text("全选", style: TextStyle(color: Colors.white),));
        list.add(Positioned(
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
    print("== titleBar buid");
    return Container(
      child:  _getAppBar(),
      decoration: BoxDecoration(
        color: Colors.black
      ),
    );
  }
}