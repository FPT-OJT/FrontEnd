import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln('Usage: dart pre_built.dart env');
    exit(1);
  }
  final env = args[0];
  var filePath = 'env/prod.json';
  if (env == 'dev') {
    filePath = 'env/dev.json';
  }
  final input = File(filePath);

  final dynamic json = jsonDecode(input.readAsStringSync());

  final result = <String, dynamic>{};

  for (final entry in (json as Map<String, dynamic>).entries) {
    result[entry.key] = Platform.environment[entry.key] ?? entry.value;
  }

  input.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(result));
}
