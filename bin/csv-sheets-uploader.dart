import 'package:args/args.dart';
import 'package:csv/csv.dart';
import 'dart:io';

class Options {
  final _parser = ArgParser(allowTrailingOptions: false);
  ArgResults _results;
  String get separator =>
      _results['separator'] == '\\t' ? '\t' : _results['separator'];
  String get csvFile => _results['file'];
  String get credentials => _results['credentials'];
  String get spreadsheetKey => _results['spreadsheet-key'];
  int get exitCode => _results == null ? -1 : _results['help'] ? 0 : null;
  Options(List<String> args) {
    _parser
      ..addFlag('help',
          defaultsTo: false, abbr: 'h', negatable: false, help: 'get usage')
      ..addOption('separator', defaultsTo: ',', help: 'column separator')
      ..addOption('file', abbr: 'f', help: 'file to upload')
      ..addOption('credentials', abbr: 'c', help: 'Google Sheets credentials')
      ..addOption('spreadsheet-key',
          abbr: 's', help: 'Key of spreadsheet to upload to');
    try {
      _results = _parser.parse(args);
      if (_results['help']) _printUsage();
      if (separator == null ||
          csvFile == null ||
          credentials == null ||
          spreadsheetKey == null) {
        _printUsage();
        exit(-1);
      }
    } on ArgParserException catch (e) {
      print(e.message);
      _printUsage();
    }
  }

  void _printUsage() {
    print(
        "Usage: pub run csv-sheets-uploader.dart [-h] [--separator=','] --file=foo.csv --credentials=user credentials --spreadsheet-key=key");
    print(_parser.usage);
  }
}

void main(List<String> args) async {
  final opts = Options(args);
  print('separator ${opts.separator} length ${opts.separator.length}');
  print('file ${opts.csvFile}');
  print('credentials ${opts.credentials}');
  print('key ${opts.spreadsheetKey}');
}
