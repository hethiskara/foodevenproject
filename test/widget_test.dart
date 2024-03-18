import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodevenproject/features/user_auth/presentation/service/shared_pref.dart';
import 'package:foodevenproject/main.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Create a mock Razorpay object
    final razorpay = MockRazorpay();
    String? userId = await SharedPreferenceHelper().getUserId();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(userId: userId, razorpay: razorpay));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

class MockRazorpay extends Razorpay {
  @override
  void open(Map<String, dynamic> options) {
    // Mock implementation
  }
}
