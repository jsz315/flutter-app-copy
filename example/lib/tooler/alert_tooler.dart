import 'package:flutter/material.dart';

class AlertTooler{

  AlertTooler();

  static void show(context, onClose, title, tip){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            content: Text(tip),
            title: Center(
                child: Text(
                  title,
                  style: TextStyle(
                      color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                )),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onClose(true);
                  },
                  child: Text('确定')),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onClose(false);
                  },
                  child: Text('取消')),
            ],
          );
        }
    );
  }
}