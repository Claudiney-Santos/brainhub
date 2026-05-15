// test/router_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:brainhub/router/app_router.dart';
import 'package:brainhub/features/login/login_screen.dart';

void main() {
  testWidgets('app starts on login screen', (tester) async {
    final router = AppRouter.routes;

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}

