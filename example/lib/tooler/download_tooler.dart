
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import '../core.dart';

import './sql_tooler.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DownloadTooler{

  static String dir = "/storage/emulated/0/0772";

  var _id = 0;

  DownloadTooler();

  void init(){
    createDir(dir);
    createDir("$dir/poster");
    createDir("$dir/video");
    createDir("$dir/capture");
  }

  void createDir(fname){
    var directory = new Directory(fname);
    if(!directory.existsSync()){
      directory.createSync();
      
    }
  }

  createVideoTagDir(tag){
    createDir("$dir/video/$tag");
  }

  createPosterTagDir(tag){
    createDir("$dir/poster/$tag");
  }

  createCaptureTagDir(tag){
    createDir("$dir/capture/$tag");
  }

  void scanFiles(){
    var path = new Directory("$dir/video");
    var entityList = path.listSync(recursive: true);
    for(FileSystemEntity entity in entityList) {
      if(entity is File){
        var tag = getTag(entity.path);
        var name = getName(entity.path);
        Core.instance.sqlTooler.addFile(tag, name);
      }
    }
  }

  String getTag(path){
    var str = path.split("$dir/video/")[1];
    var list = str.split("/");
    if(list.length == 2){
      return list[0];
    }
    return null;
  }

  String getName(path){
    List list = path.split("/");
    return list.last.split(".")[0];
  }

  Future<void> load(url, type, fname) async{
    var dio = new Dio();
    var path = type == 1 ? "$dir/poster/$fname.jpg" : "$dir/video/$fname.mp4";
    Response response = await dio.download(url, path);
    if(response.statusCode == 200){
      if(type == 1){
        Core.instance.sqlTooler.updatePoster(_id, path.split("/").last);
      }
      else{
        Core.instance.sqlTooler.updateVideo(_id, path.split("/").last);
      }
    }
    else{
      
    }
  }

  Future<void> _deleteFile(path) async{
    if(path != null){
      try{
        var file = new File(path);
        if(file.existsSync()){
          await file.delete();
        }
        else{
          
        }
      }
      catch (e){
        
      }

    }
    else{
      
    }
    
  }

  Future<void> deleteVideoItem(item) async{
    var videoPath = getVideoPath(item);
    var posterPath = getPosterPath(item);
    await _deleteFile(videoPath);
    await _deleteFile(posterPath);

    await Core.instance.sqlTooler.deleteVideo(item["id"]);
  }

  Future<void> deleteCapture(item) async{
    var path = getCapturePath(item);
    await _deleteFile(path);

    await Core.instance.sqlTooler.deleteCapture(item["id"]);
  }

  Future<void> moveVideoItem(item, tag) async{
    var videoPath = getVideoPath(item);
    var posterPath = getPosterPath(item);
    await _moveFile(videoPath, "$dir/video/$tag/${item['video']}");
    await _moveFile(posterPath, "$dir/poster/$tag/${item['image']}");

    await Core.instance.sqlTooler.updateTag(item["id"], tag);
  }

  Future<void> moveCapture(item, tag) async{
    var path = getCapturePath(item);
    await _moveFile(path, "$dir/capture/$tag/${item['image']}");
    await Core.instance.sqlTooler.moveCapture(item["id"], tag);
  }

  Future<void> _moveFile(path, newPath) async{
    // var path = item["video"];
    if(path != null){
      var file = new File(path);
      // var newPath = path.toString().replaceFirst("/video", "/$folder");
      if(file.existsSync()){
        await file.rename(newPath);
      }
      else{
        
      }
      // await Core.instance.sqlTooler.moveVideo(item["id"], newPath);
    }
    else{
      
    }
  }

  Future<void> start(id, poster, src) async{
    _id = id;
    var fname = getTimer();
    await load(poster, 1, fname);
    await load(src, 2, fname);

    // var sql = new SqlTooler();r
    // await sql.init();
    // await sql.test();
  }

  int getTimer(){
    var today = DateTime.now();
    var timer = today.millisecondsSinceEpoch;
    return timer;
  }

  Future<void> saveImage(Uint8List bytes) async{
    var timer = getTimer();
    var path = "$dir/capture/$timer.png";
    var file = new File(path);
    file.writeAsBytesSync(bytes);
    Core.instance.sqlTooler.saveCapture(path.split("/").last);
  }

  Future<void> savePoster(Uint8List bytes, String fname) async{
    var file = new File(fname);
    file.writeAsBytesSync(bytes);
  }

  Future<void> writeData(url) async{
    var list = url.split("/");
    // var dir = await getApplicationDocumentsDirectory();
    var dir = await getTemporaryDirectory();
    var file = new File("${dir.path}/www123oop.txt");
   
    if(file.existsSync()){
      var str = file.readAsStringSync();
    }
    file.writeAsStringSync(url + "+++" + Random().nextDouble().toString());
    // var str = file.readAsStringSync();
  }

  void test(){
    
  }

  String getPosterPath(item){
    if(item['tag'] != null){
      return "$dir/poster/${item['tag']}/${item['image']}";
    }
    return "$dir/poster/${item['image']}";
  }

  String getVideoPath(item){
    if(item['tag'] != null){
      return "$dir/video/${item['tag']}/${item['video']}";
    }
    return "$dir/video/${item['video']}";
  }

  String getCapturePath(item){
    if(item['tag'] != null){
      return "$dir/capture/${item['tag']}/${item['image']}";
    }
    return "$dir/capture/${item['image']}";
  }
}
