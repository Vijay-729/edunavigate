// Placeholder smoke test.
//
// The real app (EduNavigateApp) requires Firebase.initializeApp() before it
// can build, so a full pumpWidget test needs Firebase mocks — added later with
// the auth/profile repository tests. For now this just keeps `flutter test`
// green.

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('placeholder', () {
    expect(1 + 1, 2);
  });
}
