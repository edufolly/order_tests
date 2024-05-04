import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:http/http.dart';
import 'package:path/path.dart' as p;

const String version = '0.0.3';

final Uri repository = Uri.parse(
  'https://api.github.com/repos/edufolly/order_tests/releases/latest',
);

///
///
///
void main(List<String> arguments) async {
  final Response response = await get(repository).timeout(
    const Duration(seconds: 1),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> map = json.decode(response.body);

    final String latest = map['tag_name'].toString();

    if (latest != 'v$version') {
      final String line = '* New version available: $latest *';
      print('');
      print('*' * line.length);
      print(line);
      print('*' * line.length);
      print('');
    }
  }

  final ArgParser argParser = ArgParser()
    ..addFlag(
      'dry-run',
      abbr: 'd',
      negatable: false,
      help: 'Dry run, do not write to files.',
    )
    ..addFlag(
      'debug',
      abbr: 'v',
      negatable: false,
      help: 'Debug mode.',
    )
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Help.',
    )
    ..addFlag(
      'version',
      abbr: 'V',
      negatable: false,
      help: 'Version.',
    );

  final ArgResults results = argParser.parse(arguments);

  if (results.wasParsed('help')) {
    printUsage(argParser);
  }

  if (results.wasParsed('version')) {
    print('Version: $version');
    exit(0);
  }

  final bool dryRun = results.wasParsed('dry-run');

  final bool debug = results.wasParsed('debug');

  if (results.rest.isEmpty) {
    printUsage(argParser, error: 'Path is required.');
  }

  for (final String path in results.rest) {
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

void printUsage(ArgParser argParser, {String? error, int? code}) {
  if (error != null) {
    print('\n$error\n');
  }
  print('\nUsage: order-tests [options] <path_0> [path_1] ... [path_n]\n');
  print(argParser.usage);
  exit(error == null ? 0 : code ?? 1);
}
