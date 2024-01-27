import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/page/components/responsive.dart';
import 'package:seo/seo.dart';
import '../widget/feedback_dialog.dart';
import '../generated/l10n.dart';
import '../routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedOption = '';

  @override
  void initState() {
    print('initState in HomePage');
    super.initState();
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    print('didUpdateWidget in HomePage');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void reassemble() {
    print('reassemble in HomePage');
    super.reassemble();
  }

  @override
  void didChangeDependencies() {
    print('didChangeDependencies in HomePage');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('build HomePage');
    if (PlatformUtils.isWeb) {
      SystemChrome.setApplicationSwitcherDescription(
          ApplicationSwitcherDescription(
        label: S.current.appName,
      ));
    }
    return Seo.head(
        tags: const [
          MetaTag(name: 'description', content: 'Flutter SEO Example'),
          LinkTag(rel: "canonical", href: 'https://www.example.com'),
          LinkTag(
              rel: 'alternate',
              hreflang: "zh",
              href: 'https://www.example.com'),
          LinkTag(
              rel: 'alternate',
              hreflang: "x-default",
              href: 'https://www.example.com'),
        ],
        child: Scaffold(
          body: Center(
            child: Column(
              children: [
                Text(
                  S.of(context).appName,
                  style: const TextStyle(fontSize: 50),
                ),
                if (Responsive.isMobile(context))
                  const Text(
                    '该设备是手机',
                    style: TextStyle(fontSize: 50),
                  ),
                if (Responsive.isTablet(context))
                  const Text(
                    '该设备是平板',
                    style: TextStyle(fontSize: 50),
                  )
                else if (Responsive.isDesktop(context))
                  const Text(
                    '该设备是电脑',
                    style: TextStyle(fontSize: 50),
                  ),
                ElevatedButton(
                  onPressed: () {
                    delegate.pushRoute(name: '/subpage').then((value) {
                      setState(() {});
                    });
                  },
                  child: const Text('进入无参数子页面'),
                ),
                ElevatedButton(
                  onPressed: () {
                    delegate.pushRoute(
                      name: '/subpage_args',
                    );
                  },
                  child: const Text('进入带参数子页面(no arguments)'),
                ),
                ElevatedButton(
                  onPressed: () {
                    delegate.pushRoute(name: '/subpage_args', arguments: {});
                  },
                  child: const Text('进入带参数子页面(empty arguments)'),
                ),
                ElevatedButton(
                  onPressed: () {
                    delegate.pushRoute(
                        name: '/subpage_args', arguments: {'message': '传递的信息'});
                  },
                  child: const Text('进入带参数子页面(message)'),
                ),
                ElevatedButton(
                  onPressed: () {
                    delegate.pushRoute(name: '/subpage_args', arguments: {
                      'urlRequest': {'messageRequired': '必须信息'},
                    });
                  },
                  child: const Text('进入带参数子页面(messageRequired)'),
                ),
                ElevatedButton(
                  onPressed: () {
                    delegate.pushRoute(name: '/subpage_args', arguments: {
                      'urlRequest': {'messageRequired': '必须信息'},
                      'message': '传递的信息'
                    });
                  },
                  child: const Text('进入带参数子页面(message, messageRequired)'),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const FeedbackDialog();
                        });
                  },
                  child: const Text('反馈'),
                ),
                RadioListTile<String>(
                  title: Text('选项 1'),
                  value: 'Option 1',
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text('选项 2'),
                  value: 'Option 2',
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text('选项 3'),
                  value: 'Option 3',
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
