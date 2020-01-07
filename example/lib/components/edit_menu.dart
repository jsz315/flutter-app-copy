import 'package:copyapp_example/core.dart';
import 'package:copyapp_example/tooler/event_tooler.dart';
import 'package:flutter/material.dart';


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

class _EditMenuState extends State<EditMenu> {

  var _isEdit = false;

  TextEditingController _textEditingController = new TextEditingController();

  _deleteItems(){
    // widget.onDelete();
    Core.instance.eventTooler.eventBus.fire(DeleteEvent(widget.tip));
  }

  _moveItems(tag){
    Core.instance.eventTooler.eventBus.fire(MoveEvent(widget.tip, tag));
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    Core.instance.eventTooler.eventBus.on<EditEvent>().listen((e){
      setState(() {
        _isEdit = e.edit;
      });
    });
  }

  @override
  void dispose(){
    super.dispose();
  }

  _popInput(){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          content: Column(children: <Widget>[
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
          ],),
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
    return Positioned(
      left: 80,
      bottom: _isEdit ? 16 : -60,
      child: Center(
        child: Container(
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
        ),
      )
    );
  }
}
