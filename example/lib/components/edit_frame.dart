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

  EditFrame({
    Key key,
    this.child,
    this.onRefresh,
    // this.onDelete,
    // this.onMove,
    // this.togglerSelect,
    // this.togglerEdit,
    this.title,
    this.tip
  }) : super(key: key);

  @override
  _EditFrameState createState() => _EditFrameState();
}

class _EditFrameState extends State<EditFrame> {

  EditMenu _editMenu;
  TitleBar _titleBar;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _editMenu = new EditMenu(tip: widget.tip,);
    _titleBar = new TitleBar(tip: widget.tip, title: widget.title,);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          body: Container(
            child: Column(
              children: <Widget>[
                _titleBar,
                Expanded(
                  flex: 1,
                  child: RefreshIndicator(child: widget.child, onRefresh: widget.onRefresh)
                ),
              ],
            ),
          ),
        ),
        _editMenu
      ],
    );
  }
}