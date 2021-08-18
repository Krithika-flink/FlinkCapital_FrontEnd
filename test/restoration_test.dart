import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallery/data/demos.dart';
import 'package:gallery/deferred_widget.dart';
// ignore: unused_import
import 'package:gallery/demos/material/material_demos.dart'
    deferred as material_demos;
import 'package:gallery/main.dart';
import 'package:gallery/pages/demo.dart';
import 'package:gallery/pages/home.dart';
//import 'package:gallery/studies/reply/app.dart';
//import 'package:gallery/studies/reply/search_page.dart';

void main() {
  testWidgets(
    'State restoration test - Home Page',
    (tester) async {
      await tester.pumpWidget(const GalleryApp());
      // Let the splash page animations complete.
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(HomePage), findsOneWidget);

      // Test state restoration for carousel cards.
      // expect(find.byKey(const ValueKey('reply@study')), findsOneWidget);

      // Move two carousel cards over.

      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('rally@study')), findsOneWidget);

      await tester.restartAndRestore();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byKey(const ValueKey('rally@study')), findsOneWidget);

      // Test state restoration for category list.
      expect(find.byKey(const ValueKey('app-bar@material')), findsNothing);

      // Open material samples list view.
      await tester.tap(find.byKey(
        const PageStorageKey<GalleryDemoCategory>(GalleryDemoCategory.material),
      ));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('app-bar@material')), findsOneWidget);

      await tester.restartAndRestore();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byKey(const ValueKey('app-bar@material')), findsOneWidget);
    },
    variant: const TargetPlatformVariant(
      <TargetPlatform>{TargetPlatform.android},
    ),
  );

  testWidgets(
    'State restoration test -  Gallery Demo',
    (tester) async {
      // Preload deferred material demos widgets.
      await tester
          .runAsync(() => DeferredWidget.preload(material_demos.loadLibrary));

      await tester.pumpWidget(const GalleryApp());
      // Let the splash page animations complete.
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(HomePage), findsOneWidget);

      // Open material samples list view.
      await tester.tap(find.byKey(
        const PageStorageKey<GalleryDemoCategory>(GalleryDemoCategory.material),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('banner@material')));
      await tester.pumpAndSettle();

      // Should be on Material Banner demo page.
      expect(find.byType(GalleryDemoPage), findsOneWidget);
      await tester.restartAndRestore();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(GalleryDemoPage), findsOneWidget);

      const bannerDescriptionText = 'A banner displays an important, succinct '
          'message, and provides actions for users to address (or dismiss the '
          'banner). A user action is required for it to be dismissed.';

      expect(find.text(bannerDescriptionText), findsNothing);

      await tester.tap(find.byIcon(Icons.info));
      await tester.pumpAndSettle();
      expect(find.text(bannerDescriptionText), findsOneWidget);

      await tester.restartAndRestore();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text(bannerDescriptionText), findsOneWidget);
    },
    variant: const TargetPlatformVariant(
      <TargetPlatform>{TargetPlatform.android},
    ),
  );
}
