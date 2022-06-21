import 'dart:io';
import 'package:path/path.dart' as p;

///
///
///
void main(List<String> arguments) {
  List<String> newArgs = List<String>.from(arguments);

  bool dryRun = false;

  if (newArgs.contains('--dry-run')) {
    dryRun = newArgs.remove('--dry-run');
  }

  bool debug = false;

  if (newArgs.contains('--debug')) {
    debug = newArgs.remove('--debug');
  }

  if (newArgs.isEmpty) {
    exitError('Path is required.');
  }

  for (String path in newArgs) {
    Directory directory = Directory(path);

    if (!directory.existsSync()) {
      print('[warn] Path not found: ${directory.path}');
      continue;
    }

    if (debug) {
      print('Working: ${directory.path}');
    }

    List<File> files = List.castFrom(
      directory.listSync(recursive: true)
        ..retainWhere((FileSystemEntity e) => e is File),
    );

    for (File file in files) {
      if (debug) {
        print('File: ${file.path}');
      }

      String filename = p.basename(file.path);

      String content = file.readAsStringSync();
      if (content.contains('MethodOrderer.OrderAnnotation.class')) {
        if (debug) {
          print('Working: $filename');
        }

        List<String> parts = content.split(RegExp(r'@Order\(.*\)'));

        print('Ordering ${parts.length - 1} tests.');

        StringBuffer sb = StringBuffer(parts.first);

        for (int i = 1; i < parts.length; i++) {
          sb
            ..write('@Order($i)')
            ..write(parts[i]);
        }

        if (!dryRun) {
          file.writeAsStringSync(sb.toString(), flush: true);
        }
      } else {
        if (debug) {
          print('Ignored: $filename');
        }
      }
    }
  }
}

///
///
///
void exitError(String error, {int code = 1}) {
  print(error);
  exit(code);
}
