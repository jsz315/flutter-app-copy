import 'dart:io';

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
  var _allSelected = false;
  var _isEdit = false;
  var _selectedList = [];
  TextEditingController _textEditingController = new TextEditingController();

  @override
  bool get wantKeepAlive => true;

  _itemClick(id) {
    var movieModel = Provider.of<MovieModel>(context);
//    movieModel.changeTitle();
    movieModel.choose(id);
    var movie = _movies[id];
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

  Image _getImage(path){
    if(path == null){
      return Image.network(
        "https://oimagec4.ydstatic.com/image?id=-5397300958976572132&product=adpublish&w=520&h=347",
        fit: BoxFit.cover
      );
    }
    return Image.file(
      File(path),
      fit: BoxFit.cover,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    _textEditingController.addListener(listener)
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _update();
  }

  Future<void> _update() async{
    List<Map> movies = await Core.instance.sqlTooler.movies();
    var movieModel = Provider.of<MovieModel>(context);
    movieModel.update(movies);
    // var movieModel = Provider.of<MovieModel>(context);
    // var movies = movieModel.movies;
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
      _allSelected = c;
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

  void _togglerEdit(){
    setState(() {
      _isEdit = !_isEdit;
    });
  }

  Future<void> _deleteItems() async{
    var list = [];
    for(var i = 0; i < _selectedList.length; i++){
      if(_selectedList[i]){
//        var id = _movies[i]["id"];
//        list.add(id);
        await Core.instance.downloadTooler.deleteFile(_movies[i]);
      }
    }
    await _update();
  }

  Future<void> _moveItems(fname) async{
     Core.instance.downloadTooler.createDir(fname);
     for(var i = 0; i < _selectedList.length; i++){
       if(_selectedList[i]){
         await Core.instance.downloadTooler.moveFile(_movies[i], fname);
       }
     }
     await _update();
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

  Widget _getAppBar(){
    var list = <Widget>[
      Expanded(
          child: Center(
            child: Text("视频列表", style: TextStyle(color: Colors.white, fontSize: 18),),
          )
      ),
      GestureDetector(
          onTap: (){_togglerEdit();},
          child: Container(
            margin: EdgeInsets.only(right: 30),
            child:Text(_isEdit ? "完成" : "编辑", style: TextStyle(color: Colors.white),),
          )
      )
    ];

    if(_isEdit){
      list.insert(0, Text("全选", style: TextStyle(color: Colors.white),));
      list.insert(0, Checkbox(
        value: _allSelected,
        onChanged: (c){_chooseAll(c);},
      ));
    }

    return Container(
      height: 40,
      child: Row(
          children: list
      )
    );
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
                  Expanded(child: Text("01/06 12:24", style: TextStyle(color: Colors.black12),),),
                  Container(
                    child: Text("默认", style: TextStyle(fontSize: 10),),
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
        width: 50,
        height: 64,
        margin: EdgeInsets.only(left: 20),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: GestureDetector(
              onTap: (){_play(_movies[id]);},
              child: _getImage(_movies[id]["image"]),
            )
        ),
      )
    ];

    if(_isEdit){
      list.insert(0, Checkbox(
        value: _selectedList[id],
        onChanged: (c){_chooseOne(c, id);},
      ));
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
    ListView _listView = ListView.builder(
        itemCount: _movies.length,
        itemBuilder: (BuildContext context, int id) {
          return _getItem(id);
        });

    return Stack(
      children: <Widget>[
        Scaffold(
          floatingActionButton: FloatingActionButton(
            heroTag: "home",
            onPressed: (){_update();},
            child: Icon(Icons.autorenew),
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Container(
                  child:  _getAppBar(),
                  decoration: BoxDecoration(
                    color: Colors.black26
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: RefreshIndicator(child: _listView, onRefresh: _update) ,
                ),
              ],
            ),
          ),
        ),
        Positioned(
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
        )
      ],
    );

  }
}
