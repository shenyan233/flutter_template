import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../model/entity.dart';

sendControl(BuildContext context, Entity entity,
    {String nullTips = "请输入信息",
      String successTips = "发送成功",
      String failTips = "发送失败",
      bool willPop = true}) {
  // 发送信息到服务器
  entity.toJson();
  entity.serverSave().then((sent) {
    if (willPop) {
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
