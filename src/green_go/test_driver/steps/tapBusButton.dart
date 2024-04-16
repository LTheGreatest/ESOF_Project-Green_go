/*
import 'package:flutter_driver/flutter_driver.dart';

import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:green_go/view/pages/main_page.dart';
import 'package:green_go/view/widgets/menu_bar.dart';

StepDefinitionGeneric tappedBusButton() {
  return when1<String,FlutterWorld>(
      'I tapped the {string} Button', (key,context) async {
        final locator = find.byValueKey(key);
        await FlutterDriverUtils.tap(context.world.driver, locator);
  }
  );
}
*/