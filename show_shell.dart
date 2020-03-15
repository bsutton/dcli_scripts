#! /home/bsutton/.pub-cache/bin/dshell

//##! /usr/bin/env dshell

import 'dart:io';
import 'package:dshell/dshell.dart';

/// dshell script generated by:
/// dshell create show_shell.dart
/// 
/// See 
/// https://pub.dev/packages/dshell#-installing-tab-
/// 
/// For details on installing dshell.
///

void main() {
	print('PWD: $pwd');
	//'ps -p 0 '.run;
	var shell = ShellDetection().identifyShell();

	print('shell: ${ShellDetection().getShellPID()} : ${ShellDetection().getShellName()}');
	print('shell path: ${shell.startScriptPath}');

	int cpid =pid ;
	while(cpid != 0)
	{
		cpid = ProcessHelper().getParentPID(cpid);
		if (cpid == 0)
		{
			break;
		}	
		print('cpid: $cpid ${ProcessHelper().getPIDName(cpid)}');
	}


}
