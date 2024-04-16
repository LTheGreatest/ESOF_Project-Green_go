/*
import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';
import 'package:flutter_test/flutter_test.dart';
import 'steps/tapBusButton.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [Glob(r"test/features/tapBusIconFeature.feature")]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: './report.json')
    ]
    ..stepDefinitions = [tappedBusButton()]
    ..customStepParameterDefinitions = []
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/app.dart";
  return GherkinRunner().execute(config);
}
*/