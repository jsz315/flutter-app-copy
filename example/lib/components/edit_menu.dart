import 'package:copyapp_example/core.dart';
import 'package:copyapp_example/tooler/event_tooler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class EditMenu extends StatefulWidget {

  // var onDelete;
  // var onMove;
  var tip;

  EditMenu({
    Key key,
    // this.onDelete,
    // this.onMove,
    this.tip
  }):super(key: key);

  @override
  _EditMenuState createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> with SingleTickerProviderStateMixin {

  var _isEdit = false;

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
        print(animation.value);
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    // controller.forward();
    print("animation.value");
    print(animation.value);

    Core.instance.eventTooler.eventBus.on<EditEvent>().listen((e){
      print("--EditMenu EditEvent--");
      setState(() {
        _isEdit = e.edit;
        if(!_isEdit){
          controller.reverse();
        }
        else{
          controller.forward();
        }
        print("动画开始");
      });
      
    });
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }

  _popInput(){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          content: Container(
            child: TextField(
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
                  print("_textEditingController.text = ${_textEditingController.text}");
                  // widget.onMove(_textEditingController.text);
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
    print("build menu");
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext ctx, Widget child){
        return Positioned(
          left: ScreenUtil().setWidth(750 / 2 - 400 / 2),
          bottom: animation.value,
          child: Center(
            child: Container(
              width: ScreenUtil().setWidth(400),
              child: Row(
                children: <Widget>[
                  FlatButton.icon(onPressed: (){_deleteItems();}, icon: Icon(Icons.delete_forever), label: Text("删除")),
                  FlatButton.icon(onPressed: (){_popInput();}, icon: Icon(Icons.move_to_inbox), label: Text("移动"))
                ],
              ),
              decoration: BoxDecoration(
                  color: Color.fromARGB(180, 255, 240, 0),
                borderRadius: BorderRadius.circular(10)
              ),
            )
          )
        );
      }
    );
  }
}
