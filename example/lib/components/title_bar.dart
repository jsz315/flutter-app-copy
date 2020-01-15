import 'package:copyapp_example/components/check_box.dart';
import 'package:copyapp_example/config.dart';
import 'package:copyapp_example/core.dart';
import 'package:copyapp_example/model/capture_model.dart';
import 'package:copyapp_example/model/movie_model.dart';
import 'package:copyapp_example/tooler/event_tooler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TitleBar extends StatefulWidget {

  var title;
  var tip;
  var canEdit;

  TitleBar({
    Key key,
    this.title,
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
    
    Core.instance.eventTooler.eventBus.fire(new EditEvent(widget.tip, !!_isEdit));
    // Core.instance.eventTooler.eventBus.fire(MenuEvent(_isEdit));
  }

  @override
  void initState(){
    super.initState();
    Core.instance.eventTooler.eventBus.on<EditEvent>().listen((e) {
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

  int _getTotal(){
    if(widget.title == Config.home){
      var movies = Provider.of<MovieModel>(context).movies;
      return movies.length;
    }
    else if(widget.title == Config.capture){
      var captures = Provider.of<CaptureModel>(context).captures;
      return captures.length;
    }
    return 0;
  }

  Widget _getAppBar(){
    var counter;
    if(widget.title == Config.home){
      var movieModel = Provider.of<MovieModel>(context);
      counter = movieModel.selectedCounter();
    }
    else if(widget.title == Config.capture){
      var captureModel = Provider.of<CaptureModel>(context);
      counter = captureModel.selectedCounter();
    }

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
              Text("全选 $counter", style: TextStyle(color: Colors.white),)
            ],
          ),
        ));
      }
      else{
        var total = _getTotal();
        list.add(
          Positioned(
            left: 20,
            top: 0,
            bottom: 0,
            child: Center(child: Text("$total 项", style: TextStyle(color: Colors.white),),) ,
          )
        );
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
    
    return Container(
      child:  _getAppBar(),
      decoration: BoxDecoration(
        color: Colors.black
      ),
    );
  }
}