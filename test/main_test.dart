import 'package:fiado_facil/app.dart';
import 'package:fiado_facil/main.dart' as entry_point;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('main locks portrait before mounting FiadoFacilApp', (
    tester,
  ) async {
    final orientationCalls = <MethodCall>[];
    var appMountedAtOrientationCall = true;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'SystemChrome.setPreferredOrientations') {
          orientationCalls.add(call);
          appMountedAtOrientationCall = find
              .byType(FiadoFacilApp)
              .evaluate()
              .isNotEmpty;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    await entry_point.main();
    await tester.pump();

    expect(orientationCalls, hasLength(1));
    expect(orientationCalls.single.arguments, <String>[
      'DeviceOrientation.portraitUp',
    ]);
    expect(appMountedAtOrientationCall, isFalse);
    expect(find.byType(FiadoFacilApp), findsOneWidget);
    expect(find.text('A caderneta do fiado'), findsOneWidget);
  });
}
