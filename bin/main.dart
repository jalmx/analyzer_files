// ignore_for_file: library_prefixes

import 'dart:io';

import 'package:analyzer_file/cli.dart';
import 'package:analyzer_file/info.dart';
import 'package:analyzer_file/element.dart';
import 'package:analyzer_file/save_file.dart';
import 'package:analyzer_file/search.dart';
import 'package:analyzer_file/comparator.dart';
import 'package:analyzer_file/hasher.dart';
import 'package:analyzer_file/version.dart';
import 'package:path/path.dart' as Path;

void main(List<String> arguments) async {
  try {
    CLI cli = CLI(argumentsRaw: arguments);

    if (cli.getParameter()["help"]) {
      print(cli.usage());
      printInformation();
      exit(0);
    }

    var data = cli.getParameter();
    // print("Parameters: $data");
    // exit(0);

    var search = SearchFile();

    var files = await search.getFiles(
        path: data[CLI.path],
        recursive: data[CLI.recursive],
        filesToExclude: data[CLI.exclude]);
    int count = 1;
    Map<String, Element> rows = {};

    for (final fileMain in files) {
      for (final fileSecond in files) {
        if (!(fileMain.path == fileSecond.path)) {
          List<String> elements = [fileMain.path, fileSecond.path];
          elements.sort();

          bool equal = await Comparator.isEqual(
              pathFileOne: elements[0], pathFileTwo: elements[1]);

          final idHash = getMD5("${elements[0]}${elements[1]}");

          if (equal && data[CLI.output] == CLI.OUTPUT_STDOUT) {
            stdout.write(getMD5("hash: ${elements[0]}${elements[1]} -"));
            print(" are the same files: ${elements[0]} <-> ${elements[1]}");
          }

          if (!(data[CLI.output] == CLI.OUTPUT_STDOUT)) {
            stdout.write("\rElements to analyzed :${count++}");
            rows[idHash] = Element(
                idHash: idHash,
                firstElementPath: elements[0],
                firstElementName: elements[0].split(Path.separator).last,
                secondElementPath: elements[1],
                secondElementName: elements[1].split(Path.separator).last,
                equal: equal);
          }
        }
      }
    }

    if (data[CLI.output] == CLI.OUTPUT_CSV) {
      final String pathSaved = await saveCSV(null, rowsMap: rows);
      print("\nsave on ${Path.absolute(pathSaved)}");
      print("Rows total: ${rows.length}");
    } else if (data[CLI.output] == CLI.OUTPUT_JSON) {
      print("yet without implement :(");
    } else if (data[CLI.output] == CLI.OUTPUT_DB) {
      print("yet without implement :(");
    }

    exit(0);
  } catch (e) {
    exit(1);
  }
}

void printInformation() {
  print("");
  print(VERSION);
  print(REPOSITORY);
  print(INFO);
}
