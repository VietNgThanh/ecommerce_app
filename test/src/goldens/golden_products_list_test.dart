import 'dart:ui';

import 'package:ecommerce_app/src/app.dart';
import 'package:flutter_test/flutter_test.dart';

import '../robot.dart';

void main() {
  final sizeVariant = ValueVariant<Size>({
    const Size(300, 600),
    const Size(600, 800),
    const Size(1000, 1000),
  });
  testWidgets(
    'Golden - products list',
    (tester) async {
      final r = Robot(tester: tester);
      final currentSize = sizeVariant.currentValue!;
      await r.goldenRobot.setSurfaceSize(currentSize);
      await r.goldenRobot.loadRobotoFont();
      await r.goldenRobot.loadMaterialIconFont();
      await r.pumpMyApp();
      await r.goldenRobot.precacheImages();
      await expectLater(
          find.byType(MyApp),
          matchesGoldenFile(
              'products_list_${currentSize.width.toInt()}x${currentSize.height.toInt()}.png'));
    },
    variant: sizeVariant,
    tags: ['golden'],
    // Skip this test until we can run it successfully on CI without this error:
    skip: true,
  );
}
