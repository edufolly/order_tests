import 'dart:io';
import 'package:path/path.dart' as p;

///
///
///
void main(List<String> arguments) {
  final List<String> newArgs = List<String>.from(arguments);

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

  for (final String path in newArgs) {
    final Directory directory = Directory(path);

    if (!directory.existsSync()) {
      print('[warn] Path not found: ${directory.path}');
      continue;
    }

    if (debug) {
      print('Working: ${directory.path}');
    }

    final List<File> files = List.castFrom(
      directory.listSync(recursive: true)
        ..retainWhere(
          (FileSystemEntity e) =>
              e is File && RegExp(r'\.(java|kt)$').hasMatch(e.path),
        ),
    );

    for (final File file in files) {
      if (debug) {
        print('File: ${file.path}');
      }

      final String filename = p.basename(file.path);

      final String content = file.readAsStringSync();

      if (content.contains('MethodOrderer.OrderAnnotation')) {
        if (debug) {
          print('Working: $filename');
        }

        final List<String> parts = content.split(RegExp(r'@Order\(.*\)'));

        print('$filename => Ordering ${parts.length - 1} tests!');

        final StringBuffer sb = StringBuffer(parts.first);

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
