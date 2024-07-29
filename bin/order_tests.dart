import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:http/http.dart';
import 'package:path/path.dart' as p;

const String version = '0.0.4';

final Uri repository = Uri.parse(
  'https://api.github.com/repos/edufolly/order_tests/releases/latest',
);

///
///
///
void main(List<String> arguments) async {
  final ArgParser argParser = ArgParser()
    ..addSeparator('Options:')
    ..addFlag(
      'recursive',
      defaultsTo: true,
      help: 'Recursive search for files.',
    )
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
    ..addSeparator('Administration options:')
    ..addFlag(
      'check-updates',
      defaultsTo: true,
      help: 'Check for updates.',
    )
    ..addFlag(
      'version',
      abbr: 'V',
      negatable: false,
      help: 'Version.',
    )
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Help.',
    );

  final ArgResults results = argParser.parse(arguments);

  if (results.wasParsed('help')) {
    printUsage(argParser);
  }

  if (results.wasParsed('version')) {
    print('Version: $version');
    exit(0);
  }

  final bool recursive = results['recursive'];

  final bool dryRun = results['dry-run'];

  final bool debug = results['debug'];

  if (results['check-updates']) {
    try {
      final Response response = await get(repository).timeout(
        const Duration(seconds: 2),
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
    } on Exception catch (e) {
      if (debug) {
        print('[warn] Unable to check for updates.\n $e');
      }
    }
  }

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
      directory.listSync(recursive: recursive)
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
void printUsage(ArgParser argParser, {String? error, int? code}) {
  if (error != null) {
    print('\n$error\n');
  }
  print('\nUsage: order-tests [options] <path_0> [path_1] ... [path_n]\n');
  print(argParser.usage);
  exit(error == null ? 0 : code ?? 1);
}
