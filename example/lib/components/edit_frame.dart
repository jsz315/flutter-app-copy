import 'package:copyapp_example/components/title_bar.dart';
import 'package:copyapp_example/components/edit_menu.dart';
import 'package:flutter/material.dart';

class EditFrame extends StatefulWidget {

  var child;
  var onRefresh;
  // var onDelete;
  // var onMove;
  // var togglerSelect;
  // var togglerEdit;
  var tip;
  var title;
  var canEdit;

  EditFrame({
    Key key,
    this.child,
    this.onRefresh,
    // this.onDelete,
    // this.onMove,
    // this.togglerSelect,
    // this.togglerEdit,
    this.title,
    this.tip,
    this.canEdit = true,
  }) : super(key: key);

  @override
  _EditFrameState createState() => _EditFrameState();
}

class _EditFrameState extends State<EditFrame> {
  
  var _tags;

  @override
  void initState(){
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          body: Container(
            child: Column(
              children: <Widget>[
                TitleBar(tip: widget.tip, title: widget.title, canEdit: widget.canEdit,),
                Expanded(
                  flex: 1,
                  child: RefreshIndicator(child: widget.child, onRefresh: widget.onRefresh)
                ),
              ],
            ),
          ),
        ),
        new EditMenu(tip: widget.tip)
      ],
    );
  }
}