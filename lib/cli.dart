// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:args/args.dart';

class CLI {
  late final List<String> _argumentsRaw;
  late final ArgParser _parse;
  late final ArgResults _results;

  static const String path = "path";
  static const String recursive = "recursive";
  static const String hash = "hash";
  static const String exclude = "exclude";
  static const String output = "output";

  CLI({required List<String> argumentsRaw}) {
    _argumentsRaw = argumentsRaw;
    _build();
    _results = _parse.parse(_argumentsRaw);
  }

  static final OUTPUT_CSV = "csv";
  static final OUTPUT_STDOUT = "stdout";
  static final OUTPUT_JSON = "json";

  /// Return string "sha256"
  static final SHA256 = "sha256";

  /// Return string "md5"
  static final MD5 = "md5";

  void _build() {
    _parse = ArgParser()
      ..addFlag("help", negatable: false, help: "Provide help")
      ..addOption(path,
          defaultsTo: ".",
          abbr: "p",
          help: "path to search",
          valueHelp: "/home/")
      ..addFlag(recursive,
          abbr: "r",
          defaultsTo: false,
          negatable: false,
          help: "Search into directory")
      ..addOption(hash, abbr: "h", defaultsTo: "sha256", allowed: [
        "md5",
        "sha256",
      ], allowedHelp: {
        MD5: "Hash ${MD5.toUpperCase()}",
        SHA256: "Hash ${SHA256.toUpperCase()}",
      })
      ..addMultiOption(
        exclude,
        abbr: "x",
        help:
            "List of folders or files to exclude in search\nExample\n -x \"node_module,.gitignore,*.txt\"",
        valueHelp: "node_module,.gitignore",
      )
      ..addOption(output,
          defaultsTo: "stdout",
          abbr: "o",
          help: "Type of file to save the information",
          valueHelp: "csv",
          allowed: [
            "json",
            "csv"
          ],
          allowedHelp: {
            "json": "Save file array json",
            "csv": "Save file csv",
            "stdout": "Throw to terminal"
          });
  }

  String _getPath(String? mPath) {
    if (_results.rest.isNotEmpty) {
      if (mPath == ".") {
        return Directory.current.absolute.path;
      } else {
        return mPath!;
      }
    }
    return Directory.current.absolute.path;
  }

  Map<String, dynamic> getParameter() {
    return <String, dynamic>{
      path: _getPath(_results.rest.firstOrNull),
      recursive: _results[recursive],
      hash: _results[hash],
      exclude: _results[exclude],
      output: _results[output],
      "help": _results["help"] as bool
    };
  }

  String usage() => _parse.usage;
}
