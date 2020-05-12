// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

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
  });
}
