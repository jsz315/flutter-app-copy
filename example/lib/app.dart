import 'package:copyapp_example/config.dart';
import 'package:copyapp_example/pages/capture_page.dart';
import 'package:copyapp_example/pages/cover_page.dart';
import 'package:copyapp_example/pages/system_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import './pages/home_page.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
//  TabController _controller;
  var _index = 0;
  var _list = [
    new HomePage(),
    new CoverPage(),
    new CapturePage(),
    new SystemPage()
  ];

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
//    setState(() {
//      _list = [
//        new HomePage(),
//        new DetailPage(),
//        new ImagePage()
//      ];
//    });
  }

  @override
  void initState() {
    super.initState();

    var permission =  PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    PermissionHandler().requestPermissions(<PermissionGroup>[
      PermissionGroup.storage, // 在这里添加需要的权限
    ]);
    
  }

  void _changeIndex(n){
    setState(() {
      _index = n;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    
    return Scaffold(      
      body: SafeArea(
        child: IndexedStack(
          index: _index,
          children: _list,
        )
//        child: _list[_index],
      ) ,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        fixedColor: Colors.white,
        onTap: (n){_changeIndex(n);},
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.home),
            title: Text(Config.home)
          ),
          BottomNavigationBarItem(
              backgroundColor: Colors.black,
            icon: Icon(Icons.color_lens),
            title: Text(Config.cover)
          ),
          BottomNavigationBarItem(
              backgroundColor: Colors.black,
            icon: Icon(Icons.panorama),
            title: Text(Config.capture)
          ),
          BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(Icons.camera),
              title: Text(Config.system)
          ),
        ],
      )
      
    );
  }
}