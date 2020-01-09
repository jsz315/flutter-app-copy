import 'dart:io';

import 'package:copyapp_example/components/check_box.dart';
import 'package:copyapp_example/components/edit_frame.dart';
import 'package:copyapp_example/tooler/event_tooler.dart';
import 'package:copyapp_example/tooler/toast_tooler.dart';
import 'package:provider/provider.dart';

import './player_page.dart';

import '../core.dart';
import '../movie_model.dart';

import './web_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {

  var _movies = [];
  var _isEdit = false;
  List _selectedList = [];
  var _tip = "home";

  @override
  bool get wantKeepAlive => true;

  _itemClick(id) {
    // var movieModel = Provider.of<MovieModel>(context);
    // movieModel.choose(id);
    var movie = _movies[id];
    print("goto web ${movie['link']}");
    Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => WebPage(
            movie: movie
          )
        )
    );
  }

  _play(movie){
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => PlayerPage(
                movie: movie
            )
        )
    );
  }

  Image _getImage(item){
    var path = item["image"];
    if(path == null){
      return Image.asset(
        "assets/images/wgj.jpg",
        fit: BoxFit.cover
      );
    }
    return Image.file(
      File(Core.instance.downloadTooler.getPosterPath(item)),
      fit: BoxFit.cover,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();

    _update();
    print("--2 Core.instance.eventTooler.eventBus--");
    Core.instance.eventTooler.eventBus.on<EditEvent>().listen((e){
      print("--HomePage EditEvent--");
      if(e.tip == _tip){
        setState(() {
          _isEdit = e.edit;
        });
        _chooseAll(false);
      }
    });

    Core.instance.eventTooler.eventBus.on<SelectEvent>().listen((e){
      print("--SelectEvent--");
      if(e.tip == _tip){
        _chooseAll(e.select);
      }
    });

    Core.instance.eventTooler.eventBus.on<DeleteEvent>().listen((e){
      print("--DeleteEvent--");
      if(e.tip == _tip){
        _deleteItems();
      }
    });

    Core.instance.eventTooler.eventBus.on<MoveEvent>().listen((e){
      print("--MoveEvent--");
      if(e.tip == _tip){
        _moveItems(e.tag);
      }
    });
    
  }

  Future<void> _update() async{
    List<Map> movies = await Core.instance.sqlTooler.movies();
    // var movieModel = Provider.of<MovieModel>(context);
    // movieModel.update(movies);
    var slist = [];
    movies.forEach((val){
      slist.add(false);
    });
    setState(() {
      _movies = movies;
      _selectedList = slist;
      _isEdit = false;
    });
  }

  void _chooseAll(c){
    setState(() {
      for(var i = 0; i < _selectedList.length; i++){
        _selectedList[i] = c;
      }
    });

  }

  void _chooseOne(c, id){
    setState(() {
      _selectedList[id] = c;
    });
  }

  // void _togglerEdit(c){
  //   setState(() {
  //     _isEdit = c;
  //   });
  // }

  Future<void> _deleteItems() async{
    var selects = _selectedList.sublist(0);
    print("selects before");
    print(selects);
    print(_selectedList);

    for(var i = 0; i < selects.length; i++){
      if(selects[i]){
        await Core.instance.downloadTooler.deleteVideoItem(_movies[i]);
      }
    }
    print("selects after");
    print(selects);
    print(_selectedList);
    await _update();

    ToastTooler.toast(context, msg: "操作成功");
    // Scaffold.of(context).showSnackBar(SnackBar(content: Center(child: Text("操作成功")), duration: Duration(seconds: 2),));
  }

  Future<void> _moveItems(tag) async{
    print("创建目录 $tag");
     Core.instance.downloadTooler.createVideoTagDir(tag);
     Core.instance.downloadTooler.createPosterTagDir(tag);

     var selects = _selectedList.sublist(0);
    print("selects before");
     print(selects);
    print(_selectedList);
     for(var i = 0; i < selects.length; i++){
       if(selects[i]){
         await Core.instance.downloadTooler.moveVideoItem(_movies[i], tag);
       }
     }
    print("selects after");
    print(selects);
    print(_selectedList);
     await _update();
     ToastTooler.toast(context, msg: "操作成功");
  }

  Widget _getItem(id){
    var list = <Widget>[
      Expanded(
        child: Column(
          children: <Widget>[
            Text(
              _movies[id]["word"],
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style:
              TextStyle(color: Color.fromARGB(255, 90, 90, 90)),
              strutStyle: StrutStyle(height: 1.6),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(child: Text(_movies[id]["time"], style: TextStyle(color: Colors.black12),),),
                  Container(
                    child: Text(
                      _movies[id]["tag"] == null ? "默认" : _movies[id]["tag"],
                      style: TextStyle(fontSize: 10),),
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.amberAccent
                    ),
                  )

                ],
              ),
              margin: EdgeInsets.only(top: 10),
            )
          ],
        ),
      ),
      Container(
        width: 60,
        height: 68,
        margin: EdgeInsets.only(left: 20),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: GestureDetector(
              onTap: (){_play(_movies[id]);},
              child: _getImage(_movies[id]),
            )
        ),
      )
    ];

    if(_isEdit){
      list.insert(0, Padding(
        padding: EdgeInsets.only(left: 10,right: 10),
        child: CheckBox(
          value: _selectedList[id],
          onChanged: (c){_chooseOne(c, id);},
        )),
      );
    }

    return GestureDetector(
      onTap: () {
        _itemClick(id);
      },
      child: Container(
        padding: EdgeInsets.only(
            left: _isEdit ? 0 : 20.0, top: 10.0, right: 20.0, bottom: 10.0),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                  color: Color.fromARGB(255, 240, 240, 240),
                  width: 1,
                ))),
        child: Row(
          children: list
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    print("home page build ************");

    ListView _listView = ListView.builder(
        itemCount: _movies.length,
        itemBuilder: (BuildContext context, int id) {
          return _getItem(id);
        });

    return new EditFrame(
      // onDelete: _deleteItems,
      // onMove: _moveItems,
      // togglerEdit: _togglerEdit,
      // togglerSelect: _chooseAll,
      title: "视频列表",
      tip: _tip,
      onRefresh: _update,
      child: _listView
    );
  }
}
