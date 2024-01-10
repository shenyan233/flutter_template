import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seo/seo.dart';

import 'components/responsive.dart';

class Subpage extends StatefulWidget {
  const Subpage({Key? key}) : super(key: key);

  @override
  State<Subpage> createState() => _SubpageState();
}

class _SubpageState extends State<Subpage> {
  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.isWeb){
      SystemChrome.setApplicationSwitcherDescription(
          const ApplicationSwitcherDescription(
            label: 'subpage',
          ));
    }
    return Seo.head(
      tags: const [
        MetaTag(name: 'description', content: 'Flutter SEO Example'),
        LinkTag(rel: 'canonical', href: 'http://www.example.com'),
      ],
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Seo.text(
                text: 'Some SEO text',
                child: Text('SEO'),
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
            ],
          ),
        ),
      ),
    );
  }
}
