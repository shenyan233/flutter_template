# Flutter_template

This project is a starting point for a Flutter application.
Compared to the official default template created,
this project implements functions such as state management,
Navigator 2.0 routing for Url, localization, etc.

中文介绍: https://www.worthpen.top/blog?id=656617506aa58e39d9301940

## Getting Started

The entry path for the project is 'lib/main.dart'

## Feature

### Responsive Layout

### State management

By provider.

### Navigator 2.0
In 'lib/routes.dart'. Just need to modify The function _createPage().

### main.dart.js Chunking of Web
On Web, it is not necessary to retrieve all the content from the server before it can be displayed.
By deferred loading in 'lib/routes.dart'.

### Localization

By Flutter Intl plugin and flutter_localizations lib.
Reference：https://blog.csdn.net/qq_39424143/article/details/105496999

### Persistent storage for simple data

By SharedPreferences.

### Local database

By sqflite.

### Feedback

Display alert dialog and tips toast.

### SEO for Web

By dependencies: seo:.

## Note
### dev
delete meta description in web/index.html
for single lang webpage, add lang attribute in web/index.html (from W3C check)
delete valid ’-‘ and ’/‘ in web/index.html (from W3C check)
### deploy
add ads.txt
add robots.txt
add sitemap.xml