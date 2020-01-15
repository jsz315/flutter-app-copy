import 'package:copyapp_example/core.dart';
import 'package:copyapp_example/model/movie_model.dart';
import 'package:copyapp_example/tooler/event_tooler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class EditMenu extends StatefulWidget {

  // var onDelete;
  // var onMove;
  var tip;

  EditMenu({
    Key key,
    this.tip
  }):super(key: key);

  @override
  _EditMenuState createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> with SingleTickerProviderStateMixin {

  var _isEdit = false;
  var _tags = [];

  TextEditingController _textEditingController = new TextEditingController();
  Animation<double> animation;
  AnimationController controller;

  _deleteItems(){
    // widget.onDelete();
    Core.instance.eventTooler.eventBus.fire(new DeleteEvent(widget.tip));
    Core.instance.eventTooler.eventBus.fire(new EditEvent(widget.tip, false));
  }

  _moveItems(tag){
    Core.instance.eventTooler.eventBus.fire(new MoveEvent(widget.tip, tag));
    Core.instance.eventTooler.eventBus.fire(new EditEvent(widget.tip, false));
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
  }

  @override
  void initState(){
    super.initState();
    controller = new AnimationController(duration: const Duration(milliseconds: 240), vsync: this);
    final CurvedAnimation curve = CurvedAnimation(
          parent: controller,
          curve: Curves.easeIn
        );
    animation = new Tween(begin: -60.0, end: 10.0).animate(curve)
      ..addListener((){
        
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
      

    Core.instance.eventTooler.eventBus.on<EditEvent>().listen((e){
      
      setState(() {
        _isEdit = e.edit;
        if(!_isEdit){
          controller.reverse();
        }
        else{
          controller.forward();
        }
        
      });
      
    });
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }

  void _autoFolder(n){
    Navigator.of(context).pop();
    _moveItems(n);
  }

  List _getTags(){
    var movies = Provider.of<MovieModel>(context).movies;
    var tags = [];
    for(var i = 0; i < movies.length; i++){
      var tag = movies[i]["tag"];
      if(tag != null && tags.indexOf(tag) == -1){
        tags.add(tag);
        if(tags.length >= 6){
          break;
        }
      }
    }
    return tags;
  }

  _popInput(){
    var list = <Widget>[];
    
    _tags = _getTags();
    
    for(var i = 0; i < _tags.length; i++){
      var tag = _tags[i];
      list.add(
        SizedBox(
          height: 24,
          child: RaisedButton(
              padding: EdgeInsets.all(2),
              onPressed: (){_autoFolder(tag);},
              child: Text(tag, style: TextStyle(color: Colors.white,)),
              color: Colors.black38,
              shape: new RoundedRectangleBorder(
                // side: BorderSide(
                //   color: Colors.amber,
                //   width: 30
                // ),
                  borderRadius: BorderRadius.circular(16)
              )
          ),
        )

      );
    }
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    prefixIcon:Icon(Icons.folder),
                    labelText: "目录名称",
                    hintText: "请输入视频目录名称",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Text("最近使用的目录", style: TextStyle(color: Colors.black12, fontSize: 16),),
                  alignment: Alignment.centerLeft,
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: list,
                )
                ],
            ),
          ),
          title: Center(
            child: Text(
            '移动视频',
            style: TextStyle(
              color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
          )),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _moveItems(_textEditingController.text);
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
    );
  }


  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext ctx, Widget child){
        return Positioned(
          left: 0,
          bottom: animation.value,
          child: Container(
            width: ScreenUtil().setWidth(750),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton.icon(onPressed: (){_deleteItems();}, icon: Icon(Icons.delete_forever, color: Colors.white,), label: Text("删除", style: TextStyle(color: Colors.white),), color: Colors.black,),
                  FlatButton.icon(onPressed: (){_popInput();}, icon: Icon(Icons.move_to_inbox, color: Colors.white,), label: Text("移动", style: TextStyle(color: Colors.white),), color: Colors.black,)
                ],
              ),
            )
          )
        );
      }
    );
  }
}
