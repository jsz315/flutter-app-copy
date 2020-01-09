import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import './pages/image_page.dart';

import './pages/detail_page.dart';
import 'package:flutter/material.dart';

import './pages/home_page.dart';
import './tooler/download_tooler.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
//  TabController _controller;
  var _index = 0;
  var _list = [
    new HomePage(),
    new DetailPage(),
    new ImagePage()
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
//    _controller = new TabController(
//      vsync: ScrollableState(),
//      length: 3
//    );
//    _controller.addListener((){
//      print(_controller.index);
//    });

    // DownloadTooler.init();

    var permission =  PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    print("permission status is " + permission.toString());
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

    print("app build *************");
    
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
        onTap: (n){_changeIndex(n);},
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("主页")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.color_lens),
            title: Text("调试")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.panorama),
            title: Text("截图")
          ),
        ],
      )
      
    );
  }
}