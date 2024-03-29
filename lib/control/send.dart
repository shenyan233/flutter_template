import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../generated/l10n.dart';
import '../model/entity.dart';

sendControl(BuildContext context, Entity entity,
    {String? nullTips,
      String? successTips,
      String? failTips,
      bool willPop = true}) {
  nullTips ??= S.current.inputInfo;
  successTips ??= S.current.success;
  failTips ??= S.current.fail;
  // 发送信息到服务器
  entity.toJson();
  entity.serverSave().then((sent) {
    if (willPop) {
      Navigator.of(context).pop();
    }
    Fluttertoast.showToast(
      msg: successTips!,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
    );
  }).catchError((e) {
    Fluttertoast.showToast(
      msg: failTips!,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
    );
  });
}
