import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:leaf_lense/design_system/design_system.dart';

void main() {
  Future<Duration> resolveWith(
    WidgetTester tester, {
    required bool disableAnimations,
  }) async {
    late Duration resolved;
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(disableAnimations: disableAnimations),
        child: Builder(
          builder: (context) {
            resolved = LeafMotion.resolve(context, LeafMotion.base);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    return resolved;
  }

  testWidgets('keeps the duration by default', (tester) async {
    expect(
      await resolveWith(tester, disableAnimations: false),
      LeafMotion.base,
    );
  });

  testWidgets('drops to zero when reduced motion is on', (tester) async {
    expect(await resolveWith(tester, disableAnimations: true), Duration.zero);
  });
}
