import 'dart:io';

import '../core.dart';
import '../movie_model.dart';
import 'package:provider/provider.dart';

import './web_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {

  var _movies = [];

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
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _update();
  }

  void _update() async{
    List<Map> movies = await Core.instance.sqlTooler.movies();
    var movieModel = Provider.of<MovieModel>(context);
    movieModel.update(movies);
    // var movieModel = Provider.of<MovieModel>(context);
    // var movies = movieModel.movies;
    setState(() {
      _movies = movies;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("===build movies===");

    ListView _listView = ListView.builder(
        itemCount: _movies.length,
        itemBuilder: (BuildContext context, int id) {
          return GestureDetector(
            onTap: () {
              _itemClick(id);
            },
            child: Container(
              padding: EdgeInsets.only(
                  left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color: Color.fromARGB(255, 240, 240, 240),
                width: 1,
              ))),
              child: Row(
                children: <Widget>[
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
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.only(left: 30),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: _getImage(_movies[id]["image"]),
                    ),
                  )
                ],
              ),
            ),
          );
        });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        // title: Text(Provider.of<String>(context)),
        // title: Consumer<String>(builder: (context, data, child){
        //   return Text(data + " -1");
        // }),
        title: Consumer<MovieModel>(builder: (context, data, child){
          return Text(data.title);
        }),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){_update();},
        child: Icon(Icons.autorenew),
      ),
      body: Container(
        child: _listView,
      ),
    );
  }
}
