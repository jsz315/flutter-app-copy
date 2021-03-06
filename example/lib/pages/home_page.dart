import 'dart:io';

import 'package:copyapp_example/components/check_box.dart';
import 'package:copyapp_example/components/edit_frame.dart';
import 'package:copyapp_example/config.dart';
import 'package:copyapp_example/model/movie_model.dart';
import 'package:copyapp_example/tooler/event_tooler.dart';
import 'package:copyapp_example/tooler/toast_tooler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import './player_page.dart';

import '../core.dart';

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
  var _tags = [];

  @override
  bool get wantKeepAlive => true;

  void _itemClick(id) {
    // var movieModel = Provider.of<MovieModel>(context);
    // movieModel.choose(id);
    var movie = _movies[id];
    if(movie['link'] == null){
      ToastTooler.toast(context, msg: "链接不存在");
      return;
    }
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
    var fname = Core.instance.downloadTooler.getPosterPath(item);
    var hasImage = true;
    if(path == null){
      hasImage = false;
    }
    else{
      var file = new File(fname);
      if(file.existsSync() == false){
        hasImage = false;
      }
    }

    if(hasImage == false){
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
    Core.instance.eventTooler.eventBus.on<EditEvent>().listen((e){
      
      if(e.tip == _tip){
        setState(() {
          _isEdit = e.edit;
        });
        _chooseAll(false);
      }
    });

    Core.instance.eventTooler.eventBus.on<SelectEvent>().listen((e){
      if(e.tip == _tip){
        _chooseAll(e.select);
      }
    });

    Core.instance.eventTooler.eventBus.on<DeleteEvent>().listen((e){
      if(e.tip == _tip){
        _deleteItems();
      }
    });

    Core.instance.eventTooler.eventBus.on<MoveEvent>().listen((e){
      if(e.tip == _tip){
        _moveItems(e.tag);
      }
    });
    
  }

  Future<void> _update() async{
    List<Map> movies = await Core.instance.sqlTooler.movies();
    var movieModel = Provider.of<MovieModel>(context);
    movieModel.update(movies);

    // var slist = [];
    // movies.forEach((val){
    //   slist.add(false);
    // });
    setState(() {
      _movies = movies;
      _selectedList = movieModel.selects;
      _isEdit = false;
      _tags =_getTags();
    });
  }

  void _chooseAll(c){
    var movieModel = Provider.of<MovieModel>(context);
    setState(() {
      movieModel.selectAll(c);
      _selectedList = movieModel.selects;
      // for(var i = 0; i < _selectedList.length; i++){
      //   _selectedList[i] = c;
      // }
    });

  }

  void _chooseOne(c, id){
    var movieModel = Provider.of<MovieModel>(context);
    setState(() {
      movieModel.selectOne(id, c);
      _selectedList = movieModel.selects;
      // _selectedList[id] = c;
    });
  }

  Future<void> _deleteItems() async{
    var selects = _selectedList.sublist(0);

    for(var i = 0; i < selects.length; i++){
      if(selects[i]){
        await Core.instance.downloadTooler.deleteVideoItem(_movies[i]);
      }
    }
    
    await _update();

    ToastTooler.toast(context, msg: "操作成功");
    // Scaffold.of(context).showSnackBar(SnackBar(content: Center(child: Text("操作成功")), duration: Duration(seconds: 2),));
  }

  Future<void> _deleteItem(id) async{
    await Core.instance.downloadTooler.deleteVideoItem(_movies[id]);
    await _update();
    ToastTooler.toast(context, msg: "操作成功");
  }

  Future<void> _moveItems(tag) async{
     Core.instance.downloadTooler.createVideoTagDir(tag);
     Core.instance.downloadTooler.createPosterTagDir(tag);

     var selects = _selectedList.sublist(0);
 
     for(var i = 0; i < selects.length; i++){
       if(selects[i]){
         await Core.instance.downloadTooler.moveVideoItem(_movies[i], tag);
       }
     }
     
     await _update();
     ToastTooler.toast(context, msg: "操作成功");
  }

  List _getTags(){
    var tags = [];
    for(var i = 0; i < _movies.length; i++){
      var tag = _movies[i]["tag"];
      if(tag != null && tags.indexOf(tag) == -1){
        tags.add(tag);
      }
    }
    return tags;
  }

  Widget _getItem(id){
    var list = <Widget>[
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: (){_itemClick(id);},
              child: Text(
                _movies[id]["word"] == null ? "来源扫描恢复的数据，链接不可访问，视频可正常播放" : _movies[id]["word"],
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.left,
                style:
                TextStyle(color: Color.fromARGB(255, 90, 90, 90)),
                strutStyle: StrutStyle(height: 1.6),
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(child: Text(_movies[id]["time"], style: TextStyle(color: Colors.black12),),),
                  Container(
                    child: Text(
                      _movies[id]["tag"] == null ? "默认" : _movies[id]["tag"],
                      style: TextStyle(fontSize: 10, color: Colors.white),),
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.amber
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

    return Dismissible(
      key: Key("item_${_movies[id]['id']}"),
      movementDuration: Duration(milliseconds: 600),
      onDismissed: (_){_deleteItem(id);},
      child: Container(
        padding: EdgeInsets.only(
            left: _isEdit ? 0 : 20.0, top: 10.0, right: 20.0, bottom: 10.0),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                  color: Color.fromARGB(255, 240, 240, 240),
                  width: ScreenUtil().setWidth(1),
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

    ListView _listView = ListView.separated(
        itemCount: _movies.length,
        itemBuilder: (BuildContext context, int id) {
          return _getItem(id);
        },
        separatorBuilder: (BuildContext context, int id){
          return Container(height: ScreenUtil().setWidth(1), color: Colors.black12,);
        },
      );

    return new EditFrame(
        title: Config.home,
        tip: _tip,
        onRefresh: _update,
        child: _listView
      );
    
  }
}
