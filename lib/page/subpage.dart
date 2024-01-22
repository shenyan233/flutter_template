import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seo/seo.dart';
import 'package:intl/intl.dart';
import '../widget/feedback_dialog.dart';
import '../generated/l10n.dart';
import '../main.dart';
import 'components/responsive.dart';

class Subpage extends StatefulWidget {
  const Subpage({Key? key}) : super(key: key);

  @override
  State<Subpage> createState() => _SubpageState();
}

class _SubpageState extends State<Subpage> {
  @override
  void didChangeDependencies() {
    print('didChangeDependencies in Subpage');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('build Subpage');
    if (PlatformUtils.isWeb) {
      SystemChrome.setApplicationSwitcherDescription(
          ApplicationSwitcherDescription(
        label: 'subpage - ${S.current.appName}',
      ));
    }
    return Seo.head(
      tags: const [
        MetaTag(name: 'description', content: 'Flutter SEO Example'),
        LinkTag(rel: 'canonical', href: 'https://www.example.com'),
        LinkTag(
            rel: 'alternate',
            hreflang: "zh",
            href: 'https://www.example.com'),
      ],
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Seo.text(
                text: 'Some SEO text',
                child: Text('${S.current.appName} - SEO'),
              ),
              ElevatedButton(
                onPressed: () {
                  Router.of(context).routerDelegate.popRoute();
                },
                child: const Text('routerDelegate.popRoute'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Navigator.of(context).pop'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (Intl.defaultLocale == 'en') {
                    MyAppState.setting.changeLocale!(
                        const Locale.fromSubtags(languageCode: 'zh'));
                  } else {
                    MyAppState.setting.changeLocale!(
                        const Locale.fromSubtags(languageCode: 'en'));
                  }
                  Future.delayed(const Duration(milliseconds: 100)).then((value) {
                    setState(() {});
                  });
                },
                child: const Text('中英文转换'),
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
            ],
          ),
        ),
      ),
    );
  }
}
