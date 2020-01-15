import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../tooler/toast_tooler.dart';
import '../core.dart';

class PlayerPage extends StatefulWidget {
  final movie;
  PlayerPage({this.movie});

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  VideoPlayerController _controller;
//  final GlobalKey _picKey = GlobalKey();
  String _path = '';

  var _movie;

  @override
  void initState() {
    super.initState();
    _movie = widget.movie;
    _path = Core.instance.downloadTooler.getVideoPath(_movie);
    _controller = VideoPlayerController.file(
        File(_path),
      )
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  void _capture() async{
    try {
      Uint8List pngBytes = await VideoThumbnail.thumbnailData(
        video: _path, // Path of that video
        imageFormat: ImageFormat.PNG,
        quality: 100,
        timeMs: _controller.value.position.inMilliseconds,
      );
      await Core.instance.downloadTooler.saveImage(pngBytes);
      ToastTooler.toast(context, msg: "保存图片成功");

    } catch (e) {
      
      ToastTooler.toast(context, msg: "保存图片失败");
    }
  }

  void _setPoster() async{
    try {
      Uint8List pngBytes = await VideoThumbnail.thumbnailData(
        video: _path, // Path of that video
        imageFormat: ImageFormat.JPEG,
        quality: 100,
        timeMs: _controller.value.position.inMilliseconds,
      );
      var fname = Core.instance.downloadTooler.getPosterPath(_movie);
      await Core.instance.downloadTooler.savePoster(pngBytes, fname);
      ToastTooler.toast(context, msg: "保存图片成功");

    } catch (e) {
      
      ToastTooler.toast(context, msg: "保存图片失败");
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: '视频播放',
      theme: ThemeData.dark(),
      home: Stack(
        children: <Widget>[
          Scaffold(
            body: RepaintBoundary(
              child: Center(
                child: _controller.value.initialized
                    ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
                    : Container(),
              ),
            ),

            floatingActionButton: FloatingActionButton(
              heroTag: "player",
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
          ),
          Positioned(
              left: 20,
              bottom: 20,
              child: Container(
                width: ScreenUtil().setWidth(500),
                height: ScreenUtil().setWidth(96),
                decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Row(
                  children: <Widget>[
                    FlatButton.icon(onPressed: (){_setPoster();}, icon: Icon(Icons.photo_library), label: Text("设置封面")),
                    FlatButton.icon(onPressed: (){_capture();}, icon: Icon(Icons.movie), label: Text("截图")),
                  ],
                )
                
              )

          )
        ],
      )

    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}