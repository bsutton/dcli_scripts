#! /usr/bin/env dshell
import 'dart:io';

import 'package:dshell/dshell.dart';
import 'package:args/args.dart';
import 'package:dshell/src/pubspec/pubspec.dart';
import 'package:dshell/src/pubspec/pubspec_file.dart';

/// globally activates dshell from a local path rather than a public package.
///
/// defaults to activation from ~/git/dshell
///
/// You can change the path by passing in:
/// activate_local path=<your path>
///
void main(List<String> args) {
  var parser = ArgParser();

  parser.addCommand('help');

  var path = join(HOME, 'git', 'dshell');

  parser.addOption('path', defaultsTo: path);

  var result = parser.parse(args);

  if (result.command != null) {
    print(
        '''globally activates dshell from a local path rather than a public package.

defaults to activation from ~/git/dshell

You can change the path by passing in:
activate_local --path=<your path>

Options:
${parser.usage}
''');
    exit(0);
  }

  path = result['path'] as String;

  'pub global activate --source path $path'.run;

  // make certain the dependency injection points to $path
  var dependency = join(Settings().dshellPath, 'dependencies.yaml');

  if (exists(dependency)) {
    delete(dependency);
  }

  // make certain all script see the new settings.
  'dshell install -nc'.run;

  // var lines = read(join(Settings().dshellPath, 'dependency.yaml')).toList();
  // var pubspec = PubSpecFile.fromFile(dependancy);

  dependency.append('dependency_override:');
  dependency.append('  dshell:');
  dependency.append('    path: ~/git/dshell');

  print('dependency.yaml');
  cat(dependency);

  //'dshell install'.run;
}
