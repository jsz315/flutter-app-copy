import 'package:copyapp_example/components/check_box.dart';
import 'package:copyapp_example/core.dart';
import 'package:copyapp_example/tooler/event_tooler.dart';
import 'package:flutter/material.dart';

class EditBar extends StatefulWidget {

  var title;
  
  // var togglerSelect;
  // var togglerEdit;
  var tip;

  EditBar({
    Key key,
    this.title,
    // this.togglerSelect,
    // this.togglerEdit,
    this.tip
  }) : super(key: key);

  @override
  _EditBarState createState() => _EditBarState();
}



class _EditBarState extends State<EditBar> {

  var _isEdit = false;
  var _isSelected = false;

  _togglerEdit(){
    setState(() {
      _isEdit = !_isEdit;
    });
    // widget.togglerEdit(_isEdit);
    print("togglerEdit");

    Core.instance.eventTooler.eventBus.fire(EditEvent(widget.tip, _isEdit));
    // Core.instance.eventTooler.eventBus.fire(MenuEvent(_isEdit));
  }

  _togglerSelect(s){
    setState(() {
      _isSelected = s;
    });
    // widget.togglerSelect(s);
    Core.instance.eventTooler.eventBus.fire(SelectEvent(widget.tip, s));
  }

  Widget _getAppBar(){
    var list = <Widget>[
      Expanded(
          child: Center(
            child: Text(widget.title, style: TextStyle(color: Colors.white, fontSize: 18),),
          )
      ),
      GestureDetector(
          onTap: _togglerEdit,
          child: Container(
            margin: EdgeInsets.only(right: 30),
            child:Text(_isEdit ? "完成" : "编辑", style: TextStyle(color: Colors.white),),
          )
      )
    ];

    if(_isEdit){
      // list.insert(0, Text("全选", style: TextStyle(color: Colors.white),));
      list.insert(0, Center(
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
      child: Row(
          children: list
      )
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