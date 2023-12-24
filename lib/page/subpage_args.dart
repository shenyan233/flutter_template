import 'package:flutter/material.dart';
import '../routes.dart';
import 'components/check_args.dart';
import 'components/error_page.dart';

class SubpageArgs extends StatefulWidget with CheckArgs{
  late final String messageRequired;
  late final String message;

  SubpageArgs({Key? key, Map? args}) : super(key: key) {
    // TODO: implement args transfer
    args = checkArgs(args);
    messageRequired = args['urlRequest'].containsKey('messageRequired')
        ? args['urlRequest']['messageRequired']
        : '';
    message = args.containsKey('message') ? args['message'] : '';
  }

  @override
  State<SubpageArgs> createState() => _SubpageArgsState();
}

class _SubpageArgsState extends State<SubpageArgs> {
  late bool isErrorPage;
  late String message;

  @override
  void initState() {
    // TODO: implement required args check
    // 必须参数的检查，若缺少则进入错误页面
    passRequiredCheck(widget.messageRequired);
    if (!isErrorPage){
      // 传递参数
      message = widget.message;
      // 当满足必须参数时，检查冗余参数是否满足，当不满足冗余时，异步获取冗余参数
      // 当存在urlRequest参数时，urlRequest参数均为必须参数；
      // 当不存在urlRequest参数时，非urlRequest参数中既有非冗余参数，也有冗余参数。
      if (message.isEmpty){
        Future.delayed(const Duration(seconds: 1)).then((value){
          setState(() {
            message = '延迟获取';
          });
        });
      }
    }
    super.initState();
  }

  void passRequiredCheck(requiredArgs) {
    // TODO: implement required check
    if (requiredArgs.isEmpty) {
      isErrorPage = true;
    }else{
      isErrorPage = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return isErrorPage
        ? const ErrorPage()
        : Scaffold(
            body: Center(
              child: Column(
                children: [
                  SelectableText(message.isEmpty?'尚未获取':message),
                  SelectableText(widget.messageRequired),
                  ElevatedButton(
                    onPressed: () {
                      delegate.pushRoute(name: '/subpage');
                    },
                    child: const Text('进入subpage'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Router.of(context).routerDelegate.popRoute();
                    },
                    child: const Text('返回'),
                  ),
                ],
              ),
            ),
          );
  }
}
