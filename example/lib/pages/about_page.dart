import 'dart:io';

import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("关于我们"),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.file(
          File("/storage/emulated/0/0123/image/BMjAyMDAxMDExNTQ2MjZfNzQ3MzA0Nzg0XzIxMTkzODU4MjQ5XzFfMw==_Bb1238fafd9feedaf963ffd0945ce649e.jpg"),
          fit: BoxFit.cover,
        ),
      )
    );
  }
}