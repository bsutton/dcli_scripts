#! /usr/bin/env dcli
import 'dart:io';
import 'package:dcli/dcli.dart';

/// dwhich appname - searches for 'appname' on the path
void main(List<String> args) {
  var parser = ArgParser();
  parser.addFlag('verbose', abbr: 'v', defaultsTo: false, negatable: false);

  var results = parser.parse(args);

  var verbose = results['verbose'] as bool;

  if (results.rest.length != 1) {
    print(red('You must pass the name of the executable to search for.'));
    print(green('Usage:'));
    print(green('   which ${parser.usage}<exe>'));
    exit(1);
  }

  var command = results.rest[0];

  for (var path in PATH) {
    if (verbose) {
      print('Searching: ${truepath(path)}');
    }
    if (!exists(path))
    {
	printerr(red('The path $path does not exist.'));
 	continue;
    }
    if (exists(join(path, command))) {
      print(red('Found at: ${truepath(path, command)}'));
    }
  }
}
