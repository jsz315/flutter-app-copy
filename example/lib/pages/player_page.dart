import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/rendering.dart';
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
  GlobalKey _picKey = GlobalKey();
  String _path = '';

  var _movie;

  @override
  void initState() {
    super.initState();
    _movie = widget.movie;
    print(_movie);
    _path = _movie["video"];
    print("initState");
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
//      RenderRepaintBoundary boundary = _picKey.currentContext.findRenderObject();
//      var image = await boundary.toImage(pixelRatio: 2.0);
//      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
//      Uint8List pngBytes = byteData.buffer.asUint8List();

      Uint8List pngBytes = await VideoThumbnail.thumbnailData(
        video: _path, // Path of that video
        imageFormat: ImageFormat.PNG,
        quality: 100,
        timeMs: _controller.value.position.inMilliseconds,
      );
      await Core.instance.downloadTooler.saveImage(pngBytes);
      ToastTooler.toast(context, msg: "保存图片成功");

    } catch (e) {
      print(e);
      ToastTooler.toast(context, msg: "保存图片失败");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return MaterialApp(
      title: '视频播放',
      theme: ThemeData.dark(),
      home: Stack(
        children: <Widget>[
          Scaffold(
            body: RepaintBoundary(
              key: _picKey,
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
              bottom: 40,
              child: FlatButton.icon(onPressed: (){_capture();}, icon: Icon(Icons.movie), label: Text("截图"))
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