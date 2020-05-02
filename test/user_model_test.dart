// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vlop/models/user.dart';

void main() {
  // Build our app and trigger a frame.
  group('User', () {
    test('Test User declaration', () {
      var posts = [
        'these',
        'are',
        'postIds',
      ];
      var newUser = UserData(
          userName: 'testUser', email: 'testUser@email.com', postIds: posts);

      expect(newUser.postIds, ['these', 'are', 'postIds']);
      expect(newUser.userName, 'testUser');
      expect(newUser.email, 'testUser@email.com');
    });
    test('fromMap', () async {
      var user = UserData.fromMap(await userData());
      expect(user.email, 'testuser@email.com');
      expect(user.userName, 'testUser');
      expect(user.postIds, ['id1', 'id2', 'id3']);
    });
  });
}

dynamic userData() async {
  final dynamic data = await File('assets/user_data.json').readAsString();
  return json.decode(data).first;
}
