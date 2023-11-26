# Flutter_template

This project is a starting point for a Flutter application.
Compared to the official default template created,
this project implements functions such as state management,
Navigator 2.0 routing for Url, localization, etc.

中文介绍: http://worthpen.top/#/home/blog?blog=pot-blog37.md

## Getting Started

The entry path for the project is 'lib/init/init.dart'

## Feature

### State management

By provider.

### Navigator 2.0
In 'lib/init/routes.dart'. Just need to modify The function _createPage().

### main.dart.js Chunking of Web
On Web, it is not necessary to retrieve all the content from the server before it can be displayed. 
By deferred loading in 'lib/init/routes.dart'.

### Localization

By Flutter Intl plugin and flutter_localizations lib.
Reference：https://blog.csdn.net/qq_39424143/article/details/105496999

### Persistent storage for simple data

By SharedPreferences.

### Local database

By sqflite.

### Feedback

Display alert dialog and tips toast.
