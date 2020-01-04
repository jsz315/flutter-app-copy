
import 'dart:io';
import 'dart:math';

import '../core.dart';

import './sql_tooler.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DownloadTooler{

  static String dir = "/storage/emulated/0/0123";

  var _id = 0;

  DownloadTooler();

  void init(){
    createDir("$dir/image");
    createDir("$dir/video");
  }

  void createDir(path){
    var directory = new Directory(path);
    if(!directory.existsSync()){
      directory.createSync();
      print(directory.absolute.path);
    }
  }

  Future<void> load(url, type) async{
    var list = url.split("/");
    var fname = list[list.length - 1];
    var dio = new Dio();
    var path = type == 1 ? "$dir/image/$fname" : "$dir/video/$fname";
    // deleteFile(path);
    print(path);
    Response response = await dio.download(url, path);
    if(response.statusCode == 200){
      print(type == 1 ? "下载图片成功" : "下载视频成功");
      if(type == 1){
        Core.instance.sqlTooler.updateImage(_id, path);
      }
      else{
        Core.instance.sqlTooler.updateVideo(_id, path);
      }
    }
    else{
      print(type == 1 ? "下载图片失败" : "下载视频失败");
    }
  }

  void deleteFile(path) async{
    var file = new File(path);
    if(file.existsSync()){
      await file.delete();
      print("【删除成功】" + path);
    }
    else{
      print("【文件不存在】" + path);
    }
  }

  // static Future<void> start(url) async{
  //   print("下载图片");
  //   print(url);
  //   var dio = new Dio();
  //   var dir = await getApplicationDocumentsDirectory();
  //   print("${dir.path}/1234.jpg");
  //   await dio.download(url, "${dir.path}/777.jpg", onReceiveProgress: (rec, total){
  //     var progress = ((rec / total) * 100).toStringAsFixed(0) + "%";
  //     print(progress);
  //   });
  // }
  Future<void> start(id, poster, src) async{
    _id = id;
    await load(poster, 1);
    await load(src, 2);

    // var sql = new SqlTooler();r
    // await sql.init();
    // await sql.test();
  }

  Future<void> writeData(url) async{
    print("下载图片");
    print(url);
    var list = url.split("/");
    print(list[list.length - 1]);
    // var dir = await getApplicationDocumentsDirectory();
    var dir = await getTemporaryDirectory();
    var file = new File("${dir.path}/www123oop.txt");
    print(dir);
    print(dir.path);
    if(file.existsSync()){
      var str = file.readAsStringSync();
      print(str);
    }
    file.writeAsStringSync(url + "+++" + Random().nextDouble().toString());
    // var str = file.readAsStringSync();
    print("写入文件成功");
    print(file.readAsStringSync());
  }

  void test(){
    print("downloadTest");
  }
}
