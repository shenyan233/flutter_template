import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../control/send.dart';
import '../generated/l10n.dart';
import '../model/datum/feedback.dart';

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog({Key? key}) : super(key: key);

  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  String feedbackStr='';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).feedback),
      content: TextField(
        maxLines: 3,
        decoration: InputDecoration(
            hintText: S.of(context).thanksFeedback,
            border: const OutlineInputBorder()),
        onChanged: (s) {
          feedbackStr = s;
        },
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(S.of(context).cancel)),
        ElevatedButton(
            onPressed: () {
              if (feedbackStr.isNotEmpty) {
                UserFeedback feedback = UserFeedback(feedbackStr);
                sendControl(
                    context,
                    feedback,
                    nullTips: S.of(context).inputFeedback,
                    successTips: S.of(context).success,
                    failTips: S.of(context).fail);
              }else{
                Fluttertoast.showToast(
                  msg: S.current.inputFeedback,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                );
              }
            },
            child: Text(S.of(context).ok)),
      ],
    );
  }
}
