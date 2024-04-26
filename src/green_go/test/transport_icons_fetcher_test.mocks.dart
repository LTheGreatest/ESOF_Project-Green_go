// Mocks generated by Mockito 5.4.4 from annotations
// in green_go/test/transport_icons_fetcher_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;
import 'dart:io' as _i4;

import 'package:firebase_storage/firebase_storage.dart' as _i2;
import 'package:green_go/controller/database/cloud_storage.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i6;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeReference_0 extends _i1.SmartFake implements _i2.Reference {
  _FakeReference_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUploadTask_1 extends _i1.SmartFake implements _i2.UploadTask {
  _FakeUploadTask_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [CloudStorage].
///
/// See the documentation for Mockito's code generation for more information.
class MockCloudStorage extends _i1.Mock implements _i3.CloudStorage {
  @override
  _i2.Reference get storageRef => (super.noSuchMethod(
        Invocation.getter(#storageRef),
        returnValue: _FakeReference_0(
          this,
          Invocation.getter(#storageRef),
        ),
        returnValueForMissingStub: _FakeReference_0(
          this,
          Invocation.getter(#storageRef),
        ),
      ) as _i2.Reference);

  @override
  _i2.UploadTask uploadFile(
    _i4.File? file,
    String? path,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #uploadFile,
          [
            file,
            path,
          ],
        ),
        returnValue: _FakeUploadTask_1(
          this,
          Invocation.method(
            #uploadFile,
            [
              file,
              path,
            ],
          ),
        ),
        returnValueForMissingStub: _FakeUploadTask_1(
          this,
          Invocation.method(
            #uploadFile,
            [
              file,
              path,
            ],
          ),
        ),
      ) as _i2.UploadTask);

  @override
  _i5.Future<String> downloadFileURL(String? path) => (super.noSuchMethod(
        Invocation.method(
          #downloadFileURL,
          [path],
        ),
        returnValue: _i5.Future<String>.value(_i6.dummyValue<String>(
          this,
          Invocation.method(
            #downloadFileURL,
            [path],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<String>.value(_i6.dummyValue<String>(
          this,
          Invocation.method(
            #downloadFileURL,
            [path],
          ),
        )),
      ) as _i5.Future<String>);

  @override
  _i5.Future<String> uploadImageToFirebaseStorage(String? imagePath) =>
      (super.noSuchMethod(
        Invocation.method(
          #uploadImageToFirebaseStorage,
          [imagePath],
        ),
        returnValue: _i5.Future<String>.value(_i6.dummyValue<String>(
          this,
          Invocation.method(
            #uploadImageToFirebaseStorage,
            [imagePath],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<String>.value(_i6.dummyValue<String>(
          this,
          Invocation.method(
            #uploadImageToFirebaseStorage,
            [imagePath],
          ),
        )),
      ) as _i5.Future<String>);
}
