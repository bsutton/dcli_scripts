#! /usr/bin/env dcli

import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';

/// dcli script generated by:
/// dcli create hog.dart
///
/// See
/// https://pub.dev/packages/dcli#-installing-tab-
///
/// For details on installing dcli.
///

void main(List<String> args) {
  args = ['disk'];
  var runner = CommandRunner<void>('hog', 'Find resource hogs')
    ..addCommand(DiskCommand())
    ..addCommand(MemoryCommand())
    ..addCommand(CPUCommand())
    ..run(args);
}

class CPUCommand extends Command<void> {
  @override
  String get description => 'Finds apps that are hogging CPU';

  @override
  String get name => 'cpu';
}

class MemoryCommand extends Command<void> {
  @override
  String get description => 'Finds apps that are hogging Memory';

  @override
  String get name => 'memory';
}

class DiskCommand extends Command<void> {
  @override
  String get description => 'Displays the top 50 largest directories below the current directory';

  @override
  String get name => 'disk';

  void run() {
    var directories = <String>[];
    print(green('Scanning...'));
    find('*', includeHidden: true, recursive: true, types: [Find.directory])
        .forEach((directory) => directories.add(directory));

    var directorySizes = <DirectorySize>[];

    print(orange('Found ${directories.length} directories'));

    print(green('Calculating sizes...'));
    for (var directory in directories) {
      var directorySize = DirectorySize(directory);
      directorySizes.add(directorySize);

      find('*', root: directory, includeHidden: true, recursive: false).forEach((file) {
        try {
          directorySize.size += stat(file).size;
        } on FileSystemException catch (e) {
          printerr(e.toString());
        }
      });
    }

    directorySizes.sort((a, b) => b.size - a.size);

    for (var i = 0; i < 50; i++) {
      print(Format.row(['${humanNumber(directorySizes[i].size)}', directorySizes[i].pathTo],
          widths: [10, -1], alignments: [TableAlignment.right, TableAlignment.left]));
    }
  }
}

class DirectorySize {
  String pathTo;
  int size = 0;

  DirectorySize(this.pathTo);
}

void showUsage(ArgParser parser) {
  print('Usage: hog.dart -v -prompt <a questions>');
  print(parser.usage);
  exit(1);
}

/// returns the the number [bytes] in a human readable
/// form. e.g. 10G, 100M, 20K, 10B
String humanNumber(int bytes) {
  String human;

  var svalue = '$bytes';
  if (bytes > 1000000000) {
    human = svalue.substring(0, svalue.length - 9);
    human += 'G';
  } else if (bytes > 1000000) {
    human = svalue.substring(0, svalue.length - 6);
    human += 'M';
  } else if (bytes > 1000) {
    human = svalue.substring(0, svalue.length - 3);
    human += 'K';
  } else {
    human = '${svalue}B';
  }
  return human;
}
