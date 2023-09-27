import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../model/database.dart';

sendControl(BuildContext context, Datum? datum, {String nullTips="请输入信息",
    String successTips="发送成功", String failTips="发送失败", bool willPop=true}) {
  if (datum == null) {
    Fluttertoast.showToast(
      msg: nullTips,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
    );
  } else {
    // 发送信息到服务器
    datum.toJson(false);
    datum.cloudSave().then((sent) {
      if(willPop){
        Navigator.of(context).pop();
      }
      Fluttertoast.showToast(
        msg: successTips,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    }).catchError((e) {
      Fluttertoast.showToast(
        msg: failTips,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    });
  }
}
