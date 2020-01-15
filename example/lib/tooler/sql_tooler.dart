// Get a location using getDatabasesPath
import 'package:sqflite/sqflite.dart';


class SqlTooler{
  
  String databaseName = "movie";
  String videoTableName = "video";
  String captureTableName = "capture";
  // Database database;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await _initDatabase();
 
    return _db;
  }

  _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + '/$databaseName.db'; 
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async{
    await db.execute(
      "CREATE TABLE $videoTableName (id INTEGER PRIMARY KEY, word TEXT, link TEXT, title TEXT, image TEXT, video TEXT, tag TEXT, time TIMESTAMP default (datetime('now', 'localtime')))"
    );

    await db.execute(
      "CREATE TABLE $captureTableName (id INTEGER PRIMARY KEY, image TEXT, tag TEXT, time TIMESTAMP default (datetime('now', 'localtime')))"
    );
  }
  
  Future<void> reset()async{
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + '/$databaseName.db';
    await deleteDatabase(path);
    _db = null;
    _initDatabase();
  }

  Future<void> init() async{
    
  }

  Future<void> update(id, title) async {
    var database = await db;
     int count = await database.rawUpdate(
        'UPDATE $videoTableName SET title = ? WHERE id = ?',
        [title, id]
      );
      
  }

  Future<void> updateVideoTitle(id, title) async {
    var database = await db;
     int count = await database.rawUpdate(
        'UPDATE $videoTableName SET title = ? WHERE id = ?',
        [title, id]
      );
      
  }

  Future<void> updatePoster(id, image) async {
    var database = await db;
     int count = await database.rawUpdate(
        'UPDATE $videoTableName SET image = ? WHERE id = ?',
        [image, id]
      );
      
  }

  Future<void> updateVideo(id, video) async {
    var database = await db;
     int count = await database.rawUpdate(
        'UPDATE $videoTableName SET video = ? WHERE id = ?',
        [video, id]
      );
      
  }

  Future<void> updateTag(id, tag) async {
    var database = await db;
     int count = await database.rawUpdate(
        'UPDATE $videoTableName SET tag = ? WHERE id = ?',
        [tag, id]
      );
      
  }

  Future<void> test() async {
    // var res;
    // await add("驾培🏅戴教练发了一个快手作品，一起来看！ http://kphshanghai.m.chenzhongtech.com/s/xNbMeYmE 复制此链接，打开【快手】直接观看！");
    // await add("驾培🏅戴教练");
    // await add("戴教练");
    // await updateTitle(2, "哈哈");
    // await delete(1);
    // res = await movies();
  }

  Future<bool> find(word)async{
     var database = await db;
    var list = await database.rawQuery('SELECT 1 FROM $videoTableName WHERE word="$word"');
    if(list.length > 0){
      return true;
    }
    return false;
  }
  

  Future<void> add(word, link) async{
    var has = await find(word);
    if(has){
      
    }
    else{
      var database = await db;
      await database.transaction((txn) async {
        var sql = 'INSERT INTO $videoTableName(word, link) VALUES("$word", "$link")';
        int id = await txn.rawInsert(sql);
        
      });
    }
  }

  Future<void> addFile(tag, name) async{
    var database = await db;
    await database.transaction((txn) async {
      var sql = 'INSERT INTO $videoTableName(video, image, tag) VALUES("$name.mp4", "$name.jpg", "$tag")';
      if(tag == null){
        sql = 'INSERT INTO $videoTableName(video, image) VALUES("$name.mp4", "$name.jpg")';
      }
      int id = await txn.rawInsert(sql);
      
    });
  }

  Future<void> deleteVideo(id) async{
    var database = await db;
    var count = await database.rawDelete('DELETE FROM $videoTableName WHERE id = ?', [id]);
  }

  Future<void> deleteCapture(id) async{
    var database = await db;
    var count = await database.rawDelete('DELETE FROM $captureTableName WHERE id = ?', [id]);
  }

  Future<List<Map>> movies() async{
    var database = await db;
    List<Map> list = await database.rawQuery('SELECT * FROM $videoTableName ORDER BY tag, time DESC');
    
    return list;
  }

  Future<List<Map>> moviesNoVideo() async{
    var database = await db;
    List<Map> list = await database.rawQuery('SELECT * FROM $videoTableName where video is NULL ORDER BY tag, time DESC');
    
    return list;
  }

  Future<void> saveCapture(image) async{
    var database = await db;
    await database.transaction((txn) async {
      // var sql = 'INSERT INTO $videoTableName(word) VALUES("驾培🏅戴教练发了一个快手作品，一起来看！ http://kphshanghai.m.chenzhongtech.com/s/xNbMeYmE 复制此链接，打开【快手】直接观看！")';
      var sql = 'INSERT INTO $captureTableName(image) VALUES("$image")';
      int id = await txn.rawInsert(sql);
      
    });
  }

  Future<List<Map>> captures() async{
    var database = await db;
    List<Map> list = await database.rawQuery('SELECT * FROM $captureTableName');
    
    return list;
  }

  Future<void> deleteVideos(list) async{
    var database = await db;
    for(var i = 0; i < list.length; i++){
      await database.rawDelete('DELETE FROM $videoTableName WHERE id = ?', [list[i]]);
    }
  }

  // Future<void> moveVideo(id, path) async{
  //   var database = await db;
  //   await database.rawUpdate(
  //       'UPDATE $videoTableName SET video = ? WHERE id = ?',
  //       [path, id]
  //   );
  // }

  Future<void> moveCapture(id, tag) async{
    var database = await db;
    await database.rawUpdate(
        'UPDATE $captureTableName SET tag = ? WHERE id = ?',
        [tag, id]
    );
    
  }

}