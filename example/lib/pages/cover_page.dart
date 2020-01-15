import 'package:copyapp_example/components/edit_frame.dart';
import 'package:copyapp_example/components/edit_image.dart';
import 'package:copyapp_example/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CoverPage extends StatefulWidget {
  CoverPage({Key key}) : super(key: key);

  @override
  _CoverPageState createState() => _CoverPageState();
}

class _CoverPageState extends State<CoverPage> with AutomaticKeepAliveClientMixin {

  Future<void> _update() async{

  }

  Widget _swiperBuilder(BuildContext context, int index) {
    return Container(
      child: Text("123"),
      decoration: BoxDecoration(
        color: Colors.amber,
        border: Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 240, 240, 240),
            width: 1,
          )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return EditFrame(
      title: Config.cover,
      tip: "edit",
      canEdit: false,
      onRefresh: _update,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Transform.scale(
              child: new EditImage(),
              scale: 0.9,
            ),
          ]
        )
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}