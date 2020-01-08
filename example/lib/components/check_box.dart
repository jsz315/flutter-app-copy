import 'package:flutter/material.dart';

class CheckBox extends StatefulWidget {
  var value;
  var onChanged;

  CheckBox({
    Key key,
    this.value, 
    this.onChanged
  }):super(key: key);

  @override
  _CheckBoxState createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  
  void _changeValue(){
    setState(() {
      widget.value = !widget.value;
      widget.onChanged(widget.value);
    });
  }
  

  @override
  Widget build(BuildContext context) {
    var view;
    if(widget.value){
      view = Icon(
        Icons.check_box,
        color: Colors.amber,
        size: 24,
      );
    }
    else{
      view = Icon(
        Icons.check_box_outline_blank,
        color: Colors.amber,
        size: 24,
      );
    }

    return GestureDetector(
      onTap: _changeValue,
      child: Padding(
        padding: EdgeInsets.all(4),
        child: view
      ),
    );
  }
}