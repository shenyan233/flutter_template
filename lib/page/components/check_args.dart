mixin CheckArgs {
  Map checkArgs(Map? args) {
    args ??= {};
    args = Map<String, dynamic>.from(args);
    if (!args.containsKey('urlRequest')) {
      args['urlRequest'] = {};
    }
    return args;
  }
}
