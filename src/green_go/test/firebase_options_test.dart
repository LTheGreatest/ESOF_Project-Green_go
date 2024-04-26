import 'package:flutter/foundation.dart';
import 'package:green_go/firebase_options.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('DefaultFirebaseOptions', () {
    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });
    test('web', () {
      if (kIsWeb) expect(DefaultFirebaseOptions.currentPlatform, DefaultFirebaseOptions.web);
    });
    test('Android', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      expect(DefaultFirebaseOptions.currentPlatform, DefaultFirebaseOptions.android);
    });
    test('iOS', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      expect(DefaultFirebaseOptions.currentPlatform, DefaultFirebaseOptions.ios);
    });
    test('macOS', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      expect(DefaultFirebaseOptions.currentPlatform, DefaultFirebaseOptions.macos);
    });
    test('windows', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      expect(() => DefaultFirebaseOptions.currentPlatform, throwsA(isA<UnsupportedError>()));
    });
    test('linux', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      expect(() => DefaultFirebaseOptions.currentPlatform, throwsA(isA<UnsupportedError>()));
    });
    test('fuchsia', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
      expect(() => DefaultFirebaseOptions.currentPlatform, throwsA(isA<UnsupportedError>()));
    });
  });
}
