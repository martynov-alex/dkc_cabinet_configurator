import 'dart:io';

import 'package:args/args.dart';

// ignore_for_file: avoid_print
const String releaseBuildType = 'release';

String flavor = 'dev';
String buildType = '';

/// Script for build application.
/// Need parameter: build type -release or -qa.
/// See also usage.
///
/// Exit codes:
/// 0 - success
/// 1 - error
void main(List<String> arguments) {
  exitCode = 0;
  final parser = ArgParser();

  final args = parser.parse(arguments).arguments;
  if (args.length != 1) {
    exitCode = 1;
    throw Exception('You should pass build type.');
  } else {
    buildType = args.first;

    try {
      build();
      // ignore:  avoid_catches_without_on_clauses
    } catch (_) {
      exitCode = 1;
      rethrow;
    }
  }
}

Future<void> build() async {
  resolveFlavor();
  await buildIpa();
}

void resolveFlavor() {
  if (buildType == releaseBuildType) {
    flavor = 'prod';
  }
}

Future<void> buildIpa() async {
  print('Build type $buildType');

  final result = await Process.run('fvm', [
    'flutter',
    'build',
    'ios',
    '-t',
    'lib/main_$buildType.dart',
    '--flavor',
    flavor,
    '--no-codesign',
    '--release',
  ]);
  stdout.write(result.stdout);
  stderr.write(result.stderr);
}
