#! /usr/bin/env dcli

import 'dart:io';
import 'package:dcli/dcli.dart';

/// dcli script generated by:
/// dcli create ecliplse_launcher.dart
///
/// See
/// https://pub.dev/packages/dcli#-installing-tab-
///
/// For details on installing dcli.
///

/// eclipse_launcher.dart - create a desktop launcher for eclipse.
void main(List<String> args) {
  var installs = find('*',
      recursive: false,
      workingDirectory: join(HOME, 'apps', 'eclipse'),
      types: [FileSystemEntityType.directory]).toList();

  var i = 0;
  for (var install in installs) {
    print('${++i} $install');
  }

  var install =
      menu(prompt: 'Select eclipse version to use: ', options: installs);

  var path = join(HOME, '.local', 'share', 'applications', 'eclipse.desktop');
  // create desktop.ini
  if (exists(path)) {
    delete(path);
  }

  path.write('''[Desktop Entry]
Version=1.0
Type=Application
Name=Eclipse
Comment=Jave IDE
Categories=Development;IDE;
Terminal=false''');

  path.append('Icon=${join(install, "eclipse", "icon.xpm")}');
  path.append('Exec=${join(install, "eclipse", "eclipse")}');

  print('Created:');
  cat(path);
}
